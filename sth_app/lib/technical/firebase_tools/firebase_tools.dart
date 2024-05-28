import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

// Authentication
Future<void> signUpWithEmailAndPassword(String email, String password) async {
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  } catch (e) {
    rethrow;
  }
}

Future<Map<String, dynamic>> getCurrentUserData(String userId) async {
  DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
  // Document data is available in documentSnapshot.data()
  Map<String, dynamic> userData = documentSnapshot.data() as Map<String, dynamic>;
  return (userData);
}

Future<String> getCurrentUserName() async {
  Map<String, dynamic> userData = await getCurrentUserData('JN2dcl4RbBNSs7VGEbYZ');
  return userData['name'];
}

Future<String> getCurrentUserIdToken() async {
  Map<String, dynamic> userData = await getCurrentUserData('JN2dcl4RbBNSs7VGEbYZ');
  return userData['uid'];
}

Future<void> updateUsername(String newUsername) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String uid = user.uid;

      CollectionReference users = FirebaseFirestore.instance.collection('users');

      DocumentReference userDoc = users.doc(uid);

      await userDoc.update({'username': newUsername});
    }
  } catch (error) {
    print('Error updating username: $error');
  }
}

// Push profile details from accountprofilescreen to Cloud Firestore
Future<void> updateUserData({
  required String name,
  required String phone,
  required String address,
  required String email,
}) async {
  try {
    const String userId = 'JN2dcl4RbBNSs7VGEbYZ';
    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

    await userRef.set({
      'name': name,
      'phone': phone,
      'address': address,
      'email': email,
    }, SetOptions(merge: true));
  } catch (e) {
    rethrow;
  }
}

// Push avatarImage from accountprofilescreen to Firestore Storage
Future<bool> uploadAvatarImageToFirebase(File imageFile) async {
  try {
    const String userId = 'JN2dcl4RbBNSs7VGEbYZ';

    final storageRef = FirebaseStorage.instance.ref();
    final fileName = imageFile.path.split("/").last;
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final uploadRef = storageRef.child("$userId/uploads/avatarImages/$timestamp-$fileName");
    await uploadRef.putFile(imageFile);

    return true;
  } catch (e) {
    print('error uploading the avatar: $e');
    rethrow;
  }
}

// Push galeryImage from profilescreen to Firestore Storage
Future<bool> uploadGaleryImageToFirebase(File imageFile) async {
  try {
    const String userId = 'JN2dcl4RbBNSs7VGEbYZ';

    final storageRef = FirebaseStorage.instance.ref();
    final fileName = imageFile.path.split("/").last;
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final uploadRef = storageRef.child("$userId/uploads/galery/$timestamp-$fileName");
    await uploadRef.putFile(imageFile);

    return true;
  } catch (e) {
    print('error uploading the image: $e');
    rethrow;
  }
}

Future<List<String>> downloadImagesFromFirebase(String userId) async {
  try {
    final storageRef = FirebaseStorage.instance.ref().child("$userId/uploads/galery/");
    final listResult = await storageRef.listAll();
    List<String> base64Images = [];

    for (var item in listResult.items) {
      final data = await item.getData();
      Uint8List imageBytes = data!;

      // Convert imageBytes to base64 string
      String base64Image = base64Encode(imageBytes);
      base64Images.add(base64Image);
    }

    return base64Images;
  } catch (e) {
    print('Error fetching images: $e');
    rethrow; // Rethrow the error to be handled by the caller
  }
}

// Push videofile from profilescreen to Firestore Storage
Future<bool> uploadVideoFileToFirebase(File videofile) async {
  try {
    const String userId = 'JN2dcl4RbBNSs7VGEbYZ';

    final storageRef = FirebaseStorage.instance.ref();
    final fileName = videofile.path.split("/").last;
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final uploadRef = storageRef.child("$userId/uploads/videos/$timestamp-$fileName");
    await uploadRef.putFile(videofile);

    return true;
  } catch (e) {
    print('error uploading the video: $e');
    rethrow;
  }
}

// Push hashtags from profilescreen to Cloud Firestore
Future<void> pushHashtagsToFirebase(List<String> hashtags) async {
  try {
    const String userId = 'JN2dcl4RbBNSs7VGEbYZ';
    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

    if (hashtags.length > 3) {
      throw Exception('May allowed elements: 3');
    }

    await userRef.update({
      'selectedHashtags': hashtags,
    });
  } catch (e) {
    print('Error pushing hashtag to Firebase: $e');
    rethrow;
  }
}

//Delete hashtag from Cloud Firestore
Future<void> deleteHashtagFromFirebase(String hashtag) async {
  try {
    const String userId = 'JN2dcl4RbBNSs7VGEbYZ';
    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

    await userRef.update({
      'selectedHashtags': FieldValue.arrayRemove([hashtag]),
    });
  } catch (e) {
    print('Error deleting hashtag from Firebase: $e');
  }
}
