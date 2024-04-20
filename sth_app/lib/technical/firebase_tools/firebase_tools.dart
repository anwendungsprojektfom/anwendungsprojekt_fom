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

Future<Map<String, dynamic>> getCurrentUserData(String userId) async {
  DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
  // Document data is available in documentSnapshot.data()
  Map<String, dynamic> userData = documentSnapshot.data() as Map<String, dynamic>;
  return (userData);
}

Future<String> getCurrentUserName() async {
  Map<String, dynamic> userData = await getCurrentUserData('MtPDCjiV4J3MRwO79mqY');
  return userData['name'];
}

Future<String> getCurrentUserIdToken() async {
  Map<String, dynamic> userData = await getCurrentUserData('MtPDCjiV4J3MRwO79mqY');
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
