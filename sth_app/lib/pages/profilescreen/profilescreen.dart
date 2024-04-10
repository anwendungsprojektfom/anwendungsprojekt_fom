import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sth_app/technical/technical.dart';

// Widget for the profile screen, displaying editable profile data
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

// State class for the profile screen
class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;
  late SharedPreferences _prefs;
  late String _name, _phone, _address, _email;
  late TextEditingController _nameController, _phoneController, _addressController, _emailController;
  late File? _avatarImage;
  final picker = ImagePicker();
  bool _nameError = false, _phoneError = false, _addressError = false, _emailError = false;
  bool _validateName(String name) => RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(name);
  bool _validatePhone(String phone) => RegExp(r'^[0-9]+$').hasMatch(phone);
  bool _validateAddress(String address) => RegExp(r'^[a-zA-Z0-9,.\säöüÄÖÜß]+$').hasMatch(address);
  bool _validateEmail(String email) => RegExp(r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,4}$').hasMatch(email);

  // The initState method is called when the widget state is first created
  @override
  void initState() {
    super.initState();
    _name = '';
    _phone = '';
    _address = '';
    _email = '';
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _emailController = TextEditingController();
    _avatarImage = null;
    _loadProfileData();
  }

  // Function to load profile data from SharedPreferences
  Future<void> _loadProfileData() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = _prefs.getString('name') ?? 'Tigers';
      _phone = _prefs.getString('phone') ?? '0123456789';
      _address = _prefs.getString('address') ?? 'TigersHausen 12, 80993 München';
      _email = _prefs.getString('email') ?? 'TigerDevTeam@gmail.de';
      _nameController.text = _name;
      _phoneController.text = _phone;
      _addressController.text = _address;
      _emailController.text = _email;
    });
  }

  //Functioon to load profile avatar
  Future<void> _pickImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _avatarImage = File(pickedFile.path);
        });
      } else {
        print('User cancelled the image selection process.');
      }
    } catch (e) {
      print('Error accessing the gallery: $e');
    }
  }

  // Widget creation
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Profilescreen', onBack: true,),
      body: SingleChildScrollView(
        // Scrollable widget to scroll the content
        child: Container(
          color: Colors.grey[300],
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _pickImage(),
                child: CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.grey[400],
                  backgroundImage: _avatarImage != null ? FileImage(_avatarImage!) : null,
                  child: _avatarImage == null ? const Icon(Icons.add_photo_alternate, size: 70) : null,
                ),
              ),
              const SizedBox(height: 20),
              // Profile fields
              ProfileItem(
                title: 'Name',
                subtitle: _name,
                icon: Icons.person,
                isEditing: _isEditing,
                controller: _nameController,
                onChanged: (value) => setState(() => _nameError = !_validateName(value)),
                showError: _nameError,
              ),
              ProfileItem(
                title: 'Phone',
                subtitle: _phone,
                icon: Icons.phone,
                isEditing: _isEditing,
                controller: _phoneController,
                onChanged: (value) => setState(() => _phoneError = !_validatePhone(value)),
                showError: _phoneError,
              ),
              ProfileItem(
                title: 'Address',
                subtitle: _address,
                icon: Icons.location_on,
                isEditing: _isEditing,
                controller: _addressController,
                onChanged: (value) => setState(() => _addressError = !_validateAddress(value)),
                showError: _addressError,
              ),
              ProfileItem(
                title: 'Email',
                subtitle: _email,
                icon: Icons.email,
                isEditing: _isEditing,
                controller: _emailController,
                onChanged: (value) => setState(() => _emailError = !_validateEmail(value)),
                showError: _emailError,
              ),
              const SizedBox(height: 20),
              Center(
                // Button for editing the profile
                child: ElevatedButton(
                  onPressed: _nameError || _phoneError || _addressError || _emailError
                      ? null
                      : () {
                          setState(() {
                            _isEditing = !_isEditing;
                            if (!_isEditing) {
                              _saveProfile();
                            }
                          });
                        },
                  child: Text(_isEditing ? 'Save' : 'Edit'), // Change button text based on editing mode
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _isEditing
          ? null
          : const CustomBottomNavigationBar(
              currentIndex: 2), // Navigation element displayed only when not in editing mode
    );
  }

  // Function to save profile data in SharedPreference
  Future<void> _saveProfile() async {
    await _prefs.setString('name', _nameController.text);
    await _prefs.setString('phone', _phoneController.text);
    await _prefs.setString('address', _addressController.text);
    await _prefs.setString('email', _emailController.text);
    setState(() {
      _name = _nameController.text;
      _phone = _phoneController.text;
      _address = _addressController.text;
      _email = _emailController.text;
      _isEditing = false;
    });
  }
}

// Initialize items
class ProfileItem extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;
  final bool isEditing;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final bool showError;

  // Constructor for ProfileItem
  const ProfileItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isEditing,
    required this.controller,
    this.onChanged,
    required this.showError,
    Key? key,
  }) : super(key: key);

  // Widget design and ui with ui content
  @override
  Widget build(BuildContext context) {
    String errorText = '';

    if (showError) {
      if (title == 'Name') {
        errorText = 'Invalid characters. Only letters, numbers, and spaces are allowed.';
      } else if (title == 'Phone') {
        errorText = 'Invalid input. Only numbers are allowed.';
      } else if (title == 'Address') {
        errorText = 'Invalid characters. Only letters, numbers, commas, periods, spaces, and umlauts are allowed.';
      } else if (title == 'Email') {
        errorText = 'Invalid email format. Please enter a valid email address.';
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(icon, color: Colors.black),
            title: Text(title, style: const TextStyle(color: Colors.black)),
            subtitle: isEditing
                ? TextFormField(
                    controller: controller,
                    onChanged: onChanged,
                    style: const TextStyle(color: Colors.black),
                  )
                : Text(subtitle, style: const TextStyle(color: Colors.black)),
          ),
          if (showError)
            Container(
              alignment: Alignment.topRight,
              padding: const EdgeInsets.all(8),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text(''),
                      content: Text(errorText, style: const TextStyle(color: Colors.black)),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK', style: TextStyle(color: Colors.black)),
                        ),
                      ],
                    ),
                  );
                },
                child: const Icon(Icons.info, color: Color.fromARGB(255, 207, 90, 83)),
              ),
            ),
        ],
      ),
    );
  }
}
