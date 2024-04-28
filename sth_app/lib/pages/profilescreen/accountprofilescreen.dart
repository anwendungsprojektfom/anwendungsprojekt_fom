import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sth_app/technical/technical.dart';

// Widget for the profile screen, displaying editable profile data
class AccountProfileScreen extends StatefulWidget {
  const AccountProfileScreen({Key? key}) : super(key: key);

  @override
  _AccountProfileScreenState createState() => _AccountProfileScreenState();
}

// State class for the profile screen
class _AccountProfileScreenState extends State<AccountProfileScreen> {
  bool _isEditing = false;
  late String? _name, _phone, _address, _email;
  late TextEditingController _nameController, _phoneController, _addressController, _emailController;
  late File? _avatarImage;
  final picker = ImagePicker();
  bool _nameError = false, _phoneError = false, _addressError = false, _emailError = false;
  bool _validateName(String name) => RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(name);
  bool _validatePhone(String phone) => RegExp(r'^(\+\d{1,3})?\s?\d+$').hasMatch(phone);
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

  // Function to load the current profileStatus of entities
  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _name = prefs.getString('name');
      _phone = prefs.getString('phone');
      _address = prefs.getString('address');
      _email = prefs.getString('email');
      _nameController.text = _name!;
      _phoneController.text = _phone!;
      _addressController.text = _address!;
      _emailController.text = _email!;
      _loadAvatarImage().then((File? image) {
        setState(() {
          _avatarImage = image;
        });
      });
    });
  }

  // Function to save the profile image in local storage
  Future<void> _saveAvatarImage(File imageFile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('avatar_image_path', imageFile.path);
  }

  // Function to load the profile image from local storage
  Future<File?> _loadAvatarImage() async {
    final prefs = await SharedPreferences.getInstance();
    final String? imagePath = prefs.getString('avatar_image_path');
    if (imagePath != null && imagePath.isNotEmpty) {
      return File(imagePath);
    }
    return null;
  }

  // Function to pick images & upload in firebasse
  Future<void> _pickImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final File imageFile = File(pickedFile.path);
        await _saveAvatarImage(imageFile);
        bool success = await uploadAvatarImageToFirebase(imageFile);
        if (success) {
          setState(() {
            _avatarImage = imageFile;
          });
        }
      }
    } catch (e) {
      print('Error accessing the gallery: $e');
    }
  }

// Widget creation
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
          title: Text('Account Profile'),
          onBack: true,
          showChatIcon: false,
          showSettings: false,
          route: '/profilescreen'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              // Container to display avatar image and handle image picking
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.grey[400],
                    backgroundImage: _avatarImage != null ? FileImage(_avatarImage!) : null,
                    child: _avatarImage == null ? const Icon(Icons.add_photo_alternate, size: 70) : null,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.11,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 20,
                      spreadRadius: 2,
                      color: Colors.black.withOpacity(0.1),
                    ),
                  ],
                  color: const Color.fromARGB(255, 114, 114, 114).withOpacity(0.3),
                ),
                // Text field for editing name
                child: ProfileItem(
                  title: 'Name',
                  subtitle: _name!,
                  icon: Icons.person,
                  isEditing: _isEditing,
                  controller: _nameController,
                  onChanged: (value) => setState(() => _nameError = !_validateName(value)),
                  showError: _nameError,
                  errorText: _nameError ? 'Invalid characters. Only letters, numbers, and spaces are allowed.' : null,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.11,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 20,
                      spreadRadius: 2,
                      color: Colors.black.withOpacity(0.1),
                    ),
                  ],
                  color: const Color.fromARGB(255, 114, 114, 114).withOpacity(0.3),
                ),
                // Text field for editing phone number
                child: ProfileItem(
                  title: 'Phone',
                  subtitle: _phone!,
                  icon: Icons.phone,
                  isEditing: _isEditing,
                  controller: _phoneController,
                  onChanged: (value) => setState(() => _phoneError = !_validatePhone(value)),
                  showError: _phoneError,
                  errorText: _phoneError ? 'Invalid input. Only numbers are allowed.' : null,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.11,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 20,
                      spreadRadius: 2,
                      color: Colors.black.withOpacity(0.1),
                    ),
                  ],
                  color: const Color.fromARGB(255, 114, 114, 114).withOpacity(0.3),
                ),
                // Text field for editing address
                child: ProfileItem(
                  title: 'Address',
                  subtitle: _address!,
                  icon: Icons.location_on,
                  isEditing: _isEditing,
                  controller: _addressController,
                  onChanged: (value) => setState(() => _addressError = !_validateAddress(value)),
                  showError: _addressError,
                  errorText: _addressError
                      ? 'Invalid characters. Only letters, numbers, commas, periods, spaces, and umlauts are allowed.'
                      : null,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.11,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 20,
                      spreadRadius: 2,
                      color: Colors.black.withOpacity(0.1),
                    ),
                  ],
                  color: const Color.fromARGB(255, 114, 114, 114).withOpacity(0.3),
                ),
                // Text field for editing email address
                child: ProfileItem(
                  title: 'Email',
                  subtitle: _email!,
                  icon: Icons.email,
                  isEditing: _isEditing,
                  controller: _emailController,
                  onChanged: (value) => setState(() => _emailError = !_validateEmail(value)),
                  showError: _emailError,
                  errorText: _emailError ? 'Invalid email format. Please enter a valid email address.' : null,
                ),
              ),
              const SizedBox(height: 10),
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
                              updateUserData(
                                name: _nameController.text,
                                phone: _phoneController.text,
                                address: _addressController.text,
                                email: _emailController.text,
                              );
                            }
                          });
                        },
                  child: Text(_isEditing ? 'Save' : 'Edit'), // Change button text based on editing mode
                ),
              ),
              const SizedBox(height: 10),
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _nameController.text);
    await prefs.setString('phone', _phoneController.text);
    await prefs.setString('address', _addressController.text);
    await prefs.setString('email', _emailController.text);
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
  final String? errorText;

  // Constructor for ProfileItem
  const ProfileItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isEditing,
    required this.controller,
    this.onChanged,
    required this.showError,
    this.errorText,
    Key? key,
  }) : super(key: key);

  // Widget design and ui with ui content
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color.fromARGB(255, 0, 0, 0)),
      title: Text(title, style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
      subtitle: isEditing
          ? TextFormField(
              controller: controller,
              onChanged: onChanged,
              style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
            )
          : Text(subtitle, style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
      trailing: showError && errorText != null
          ? Tooltip(
              message: errorText!,
              child: const Icon(Icons.error, color: Color.fromARGB(255, 0, 0, 0)),
            )
          : null,
    );
  }
}
