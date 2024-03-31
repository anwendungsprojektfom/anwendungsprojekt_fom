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
