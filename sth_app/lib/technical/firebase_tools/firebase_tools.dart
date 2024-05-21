import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  DocumentSnapshot documentSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();
  // Document data is available in documentSnapshot.data()
  Map<String, dynamic> userData =
      documentSnapshot.data() as Map<String, dynamic>;
  return (userData);
}

Future<String> getCurrentUserName() async {
  Map<String, dynamic> userData =
      await getCurrentUserData('MtPDCjiV4J3MRwO79mqY');
  return userData['name'];
}

Future<String> getCurrentUserIdToken() async {
  Map<String, dynamic> userData =
      await getCurrentUserData('MtPDCjiV4J3MRwO79mqY');
  return userData['uid'];
}

Future<void> updateUsername(String newUsername) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String uid = user.uid;

      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      DocumentReference userDoc = users.doc(uid);

      await userDoc.update({'username': newUsername});
    }
  } catch (error) {
    print('Error updating username: $error');
  }
}

// Push profile details from accountprofilescreen to Firestore Cloud
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
    final uploadRef =
        storageRef.child("$userId/uploads/avatarImages/$timestamp-$fileName");
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
    final uploadRef =
        storageRef.child("$userId/uploads/galery/$timestamp-$fileName");
    await uploadRef.putFile(imageFile);

    return true;
  } catch (e) {
    print('error uploading the image: $e');
    rethrow;
  }
}

// Push videofile from profilescreen to Firestore Storage
Future<bool> uploadVideoFileToFirebase(File videofile) async {
  try {
    const String userId = 'JN2dcl4RbBNSs7VGEbYZ';

    final storageRef = FirebaseStorage.instance.ref();
    final fileName = videofile.path.split("/").last;
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final uploadRef =
        storageRef.child("$userId/uploads/videos/$timestamp-$fileName");
    await uploadRef.putFile(videofile);

    return true;
  } catch (e) {
    print('error uploading the video: $e');
    rethrow;
  }
}

// Implement search method in Firestore

Future<List<Map<String, dynamic>>> searchUsersByHashtags(String hashtag) async {
  try {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('hashtags', arrayContains: hashtag)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return [];
    }

    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  } catch (e) {
    print('Error searching users: $e');
    return [];
  }
}
