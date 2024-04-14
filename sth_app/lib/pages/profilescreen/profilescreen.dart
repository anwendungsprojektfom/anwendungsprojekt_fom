import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sth_app/pages/profilescreen/settings.dart';
import 'package:sth_app/technical/technical.dart';

// Enum for different display modes
enum DisplayMode { images, videos }

// ProfileScreen widget that is a StatefulWidget
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

// State class for ProfileScreen widget
class _ProfileScreenState extends State<ProfileScreen> {
  // Variable to store the current display mode
  DisplayMode _displayMode = DisplayMode.images;

  // List of image paths to display
  List<String> _imagePaths = [
    "assets/profilescreenImages/image0.png",
    "assets/profilescreenImages/image1.png",
    "assets/profilescreenImages/image2.png",
    "assets/profilescreenImages/image3.png",
    "assets/profilescreenImages/image4.png",
    "assets/profilescreenImages/image5.png",
    "assets/profilescreenImages/image6.png",
    "assets/profilescreenImages/image7.png",
  ];

  // Function to open the gallery
  void _openGallery(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Image'),
            leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SizedBox.expand(
            child: PhotoView(
              imageProvider: AssetImage(_imagePaths[index]),
              backgroundDecoration: BoxDecoration(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<String> itemsToDisplay =
        _displayMode == DisplayMode.images ? _imagePaths : [];
    return Scaffold(
      // Custom app bar with title and back button
      appBar: AppBar(
        title: const Text('Profile Page'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profile header with user details
              Container(
                height: size.height * 0.4,
                color: Colors.white, // White background color
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    const CircleAvatar(
                      radius: 48,
                      backgroundImage:
                          AssetImage("assets/profilescreenImages/profile1.png"),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Fit",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Flutter Developer",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: Material(
                  elevation: 3,
                  shadowColor: Colors.black26,
                  child: SizedBox(
                    height: 55,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.image, size: 30, color: Colors.black),
                          onPressed: () {
                            setState(() {
                              _displayMode = DisplayMode.images;
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.play_circle, size: 30, color: Colors.black),
                          onPressed: () {
                            setState(() {
                              _displayMode = DisplayMode.videos;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
                            image: AssetImage(itemsToDisplay[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          )
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        currentIndex: 3,
      ),
    );
  }
}
