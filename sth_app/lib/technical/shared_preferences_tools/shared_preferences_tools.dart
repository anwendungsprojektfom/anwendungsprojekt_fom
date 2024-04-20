import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveUserDataToSharedPreferences(Map<String, dynamic> userData) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('name', userData['name']);
  await prefs.setString('phone', userData['phone']);
  await prefs.setString('email', userData['email']);
  await prefs.setString('address', userData['address']);
}
