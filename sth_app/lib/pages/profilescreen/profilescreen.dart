import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sth_app/technical/technical.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

enum DisplayMode { images, videos }

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

File? _avatarImage;
List<String> _imagePaths = [];
List<String> _videoPaths = [];
List<String> _selectedHashtags = [];


class _ProfileScreenState extends State<ProfileScreen> {

  DisplayMode _displayMode = DisplayMode.images;
  String _userName = "Fit";
  List<String> _hashtags = ["Soccer", "Ice Hockey", "Ju-Jitsu"];

  // Function to open the gallery
  void _openGallery(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Image'),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _deleteImage(index),
              ),
            ],
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SizedBox.expand(
            child: PhotoView(
              imageProvider: FileImage(File(_imagePaths[index])),
              backgroundDecoration: const BoxDecoration(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }

  // Function to open the videos
  void _openVideo(int index) {
    VideoPlayerController _controller = VideoPlayerController.file(File(_videoPaths[index]));
    _controller.initialize().then((_) {
      _controller.play();
    });
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Video'),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _deleteVideo(index),
              ),
            ],
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _controller.pause();
                _controller.dispose();
                Navigator.pop(context);
              },
            ),
          ),
          body: Center(
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          ),
        ),
      ),
    );
  }

// Function for Hashtags-popUP
void _showHashtagsModal(BuildContext context) async {
  final selectedHashtag = await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Icon(Icons.star_border, color: Colors.black),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Add Hashtag',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _hashtags.map((String hashtag) {
                return GestureDetector(
                  onTap: () {
                    if (!_selectedHashtags.contains(hashtag)) {
                      Navigator.pop(context, hashtag);
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Container(
                              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                              child: Text(
                                'The hashtag "$hashtag" has already been selected.',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      hashtag,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      );
    },
  );

  if (selectedHashtag != null) {
    setState(() {
      _selectedHashtags.add(selectedHashtag);
      _saveHashtagsToLocalStorage(_selectedHashtags);
      pushHashtagsToFirebase(_selectedHashtags);
    });
  }
}

  // Function to load the avatar image from local storage
  Future<void> _loadAvatarImage() async {
    final prefs = await SharedPreferences.getInstance();
    final String? imagePath = prefs.getString('avatar_image_path');
    if (imagePath != null && imagePath.isNotEmpty) {
      setState(() {
        _avatarImage = File(imagePath);
      });
    }
  }

  // Function to load the user name from local storage
  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userName = prefs.getString('name');
    if (userName != null && userName.isNotEmpty) {
      setState(() {
        _userName = userName;
      });
    }
  }

  // Function to save image paths to local storage
  Future<void> _saveImagePathsToLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('saved_image_paths', _imagePaths);
  }

  // Function to save the image to a permanent location
  Future<String> _saveImage(String imagePath) async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String fileName = imagePath.split('/').last;
    final String newPath = '${appDir.path}/$fileName';
    await File(imagePath).copy(newPath);
    return newPath;
  }

  // Function to load images from local storage
  Future<void> _loadImagesFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? savedImagePaths = prefs.getStringList('saved_image_paths');
    if (savedImagePaths != null && savedImagePaths.isNotEmpty) {
      setState(() {
        _imagePaths = savedImagePaths;
      });
    }
  }

  // Function to add images to galeryPage and upload to firebase
  Future<void> _uploadGalleryImages() async {
    final List<XFile> images = await ImagePicker().pickMultiImage();
    if (images.isNotEmpty) {
      for (XFile image in images) {
        final String newPath = await _saveImage(image.path);
        setState(() {
          _imagePaths.insert(0, newPath);
          _saveImagePathsToLocalStorage();
        });
        uploadGaleryImageToFirebase(File(newPath)).then((success) {
          //add firebase logic
        }).catchError((error) {});
      }
    }
  }

  // Function to delete the selected image from the gallery view
  void _deleteImage(int index) {
    setState(() {
      _imagePaths.removeAt(index);
      _saveImagePathsToLocalStorage();
    });
    Navigator.pop(context);
  }

  // Function to save video paths to local storage
  Future<void> _saveVideoPathsToLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('saved_video_paths', _videoPaths);
  }

  // Function to save the video to a permanent location
  Future<String> _saveVideo(String videoPath) async {
    // Funktion zum Speichern von Videos in lokalem Speicher
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String fileName = videoPath.split('/').last;
    final String newPath = '${appDir.path}/$fileName';
    await File(videoPath).copy(newPath);
    return newPath;
  }

  // Function to load videos from local storage
  Future<void> _loadVideosFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? savedVideoPaths = prefs.getStringList('saved_video_paths');
    if (savedVideoPaths != null && savedVideoPaths.isNotEmpty) {
      setState(() {
        _videoPaths = savedVideoPaths;
      });
    }
  }

  // Function to add videos to videoPage and upload to firebase
  Future<void> _uploadVideos() async {
    final XFile? video = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(minutes: 5),
    );
    if (video != null) {
      final String newPath = await _saveVideo(video.path);
      setState(() {
        _videoPaths.insert(0, newPath);
        _saveVideoPathsToLocalStorage();
      });
      uploadVideoFileToFirebase(File(newPath)).then((success) {
        //add firebase logic
      }).catchError((error) {});
    }
  }

  // Function to delete the selected video from the gallery view
  void _deleteVideo(int index) {
    setState(() {
      _videoPaths.removeAt(index);
      _saveVideoPathsToLocalStorage();
    });
    Navigator.pop(context);
  }

  // Function to show video thumbnail 
  Future<Uint8List?> _generateThumbnail(String videoPath) async {
    final thumbnail = await VideoThumbnail.thumbnailData(
      video: videoPath,
      imageFormat: ImageFormat.JPEG,
      maxHeight: 100,
      quality: 25,
    );
    return thumbnail;
  }

  // Function to save hashtags to local storage
  Future<void> _saveHashtagsToLocalStorage(List<String> hashtags) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('saved_hashtags', hashtags);
  }

  // Function to load hashtags from local storage
  Future<void> _loadHashtagsFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? savedHashtags = prefs.getStringList('saved_hashtags');
    if (savedHashtags != null && savedHashtags.isNotEmpty) {
      setState(() {
        _selectedHashtags = savedHashtags;
      });
    }
  }

  // Function to delete hashtags from local storage
  Future<void> _deleteHashtagFromLocalStorage(String hashtag) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? savedHashtags = prefs.getStringList('saved_hashtags');
    if (savedHashtags != null) {
      savedHashtags.remove(hashtag);
      await prefs.setStringList('saved_hashtags', savedHashtags);
    }
  }


  @override
  void initState() {
    super.initState();
    _loadAvatarImage();
    _loadImagesFromStorage();
    _loadVideosFromStorage();
    _loadUserName();
    _loadHashtagsFromStorage();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<String> itemsToDisplay = _imagePaths;
    return Scaffold(
      appBar: const CustomAppBar(title: Text('Profile Page'), onBack: false, showChatIcon: false, showSettings: true),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: size.height * 0.23,
                color: Colors.white,
                child: Column(
                  children: [
                    const SizedBox(height: 1),
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.black,
                      child: CircleAvatar(
                        radius: 46,
                        backgroundColor: Colors.white,
                        backgroundImage: _avatarImage != null ? FileImage(_avatarImage!) : null,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      _userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () {
                        _showHashtagsModal(context);
                      },
                      child: _selectedHashtags.isNotEmpty ? 
                        Container(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: _selectedHashtags
                                .map((String hashtag) => Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                  child: Material(
                                    borderRadius: BorderRadius.circular(16), 
                                    color: Colors.grey[300],
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min, 
                                        children: [
                                          Text(
                                            hashtag,
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          SizedBox(width: 4),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _selectedHashtags.remove(hashtag);
                                                _deleteHashtagFromLocalStorage(hashtag);
                                                deleteHashtagFromFirebase(hashtag);
                                              });
                                            },
                                            child: Icon(Icons.cancel, size: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ))
                                .toList(),
                            ),
                          ),
                        ) 
                        : Text(
                            'Add Hashtag',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black54,
                            ),
                          ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Material(
                  elevation: 3,
                  shadowColor: Colors.black26,
                  child: SizedBox(
                    height: 55,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.black, width: 2),
                              ),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                alignment: Alignment.center,
                                icon: const Icon(Icons.image, size: 30, color: Colors.black),
                                onPressed: () {
                                  setState(() {
                                    _displayMode = DisplayMode.images;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.black, width: 2),
                              ),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                alignment: Alignment.center,
                                icon: const Icon(Icons.play_circle, size: 30, color: Colors.black),
                                onPressed: () {
                                  setState(() {
                                    _displayMode = DisplayMode.videos;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                          child: IconButton(
                              padding: EdgeInsets.zero,
                              alignment: Alignment.center,
                              icon: const Icon(Icons.add, size: 30, color: Colors.black),
                              onPressed: () async {
                                if (_displayMode == DisplayMode.images) {
                                  _uploadGalleryImages();
                                } else if (_displayMode == DisplayMode.videos) {
                                  _uploadVideos();
                                }
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Display images
              if (_displayMode == DisplayMode.images)
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 9,
                      crossAxisSpacing: 9,
                    ),
                    itemCount: itemsToDisplay.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () => _openGallery(index),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: FileImage(File(itemsToDisplay[index])),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              // Display of videos
              if (_displayMode == DisplayMode.videos)
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 9,
                    crossAxisSpacing: 9,
                  ),
                  itemCount: _videoPaths.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () => _openVideo(index),
                      child: FutureBuilder<Uint8List?>(
                        future: _generateThumbnail(_videoPaths[index]),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Container(
                              color: Colors.grey,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          if (snapshot.hasError || snapshot.data == null) {
                            return Container(
                              color: Colors.grey,
                              child: Center(
                                child: Icon(
                                  Icons.error_outline,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: MemoryImage(snapshot.data!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                )
                ),
            ],
          )
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        currentIndex: 2,
      ),
    );
  }
}