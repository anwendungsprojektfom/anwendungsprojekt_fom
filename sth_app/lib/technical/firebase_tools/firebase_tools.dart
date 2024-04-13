import 'package:firebase_auth/firebase_auth.dart';
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

Future<Map<String, dynamic>> getCurrentUserData() async {
  User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic> userData = {
    'name': 'Your profile name',
    'uid': 'Your User ID Token',
  };

  if (user != null) {
    String uid = user.uid;

    CollectionReference users = FirebaseFirestore.instance.collection('users');

    DocumentSnapshot<Object?> userDoc = await users.doc(uid).get();

    if (userDoc.exists) {
      userData = {
        'name': userDoc.get('name'),
        'uid': uid,
      };
    }
  }

  return userData;
}

Future<String> getCurrentUserName() async {
  Map<String, dynamic> userData = await getCurrentUserData();
  return userData['name'];
}

Future<String> getCurrentUserIdToken() async {
  Map<String, dynamic> userData = await getCurrentUserData();
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

// Push values to Firestore
Future<void> addDataToFirestore(String data) async {
  try {
    await FirebaseFirestore.instance.collection('your_collection').add({
      'field_name': data,
    });
  } catch (e) {
    rethrow;
  }
}

// Get values from Firestore
Future<List<String>> getDataFromFirestore() async {
  try {
    final querySnapshot = await FirebaseFirestore.instance.collection('your_collection').get();
    final List<String> dataList = [];
    for (var doc in querySnapshot.docs) {
      dataList.add(doc['field_name']);
    }
    return dataList;
  } catch (e) {
    rethrow;
  }
}
