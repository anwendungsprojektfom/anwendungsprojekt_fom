import 'package:flutter/material.dart';
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

  // Widget creation
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Profile'),
      body: SingleChildScrollView(
        // Scrollable widget to scroll the content
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Center(
                child: CircleAvatar(
                  radius: 70,
                  backgroundColor: Color.fromARGB(255, 0, 0, 0),
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
                child: ElevatedButton(
                  // Button for editing the profile
                  onPressed: _nameError || _phoneError || _addressError || _emailError ? null : () {
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
              currentIndex: 2, // Navigation element displayed only when not in editing mode
            ),
    );
  }

  // Function to save profile data in SharedPreferences
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

// Widget for a single profile field
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
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: const Color.fromARGB(255, 218, 54, 5).withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(icon),
            title: Text(title),
            subtitle: isEditing
                ? TextFormField(
                    controller: controller,
                    onChanged: onChanged,
                  )
                : Text(subtitle),
          ),
          if (showError)
            Padding(
              padding: const EdgeInsets.only(left: 56),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(''),
                          content: Text(errorText),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.info, color: Color.fromARGB(255, 255, 0, 0)),
                        const SizedBox(width: 5),
                        Text(
                          'Invalid input. Please check.',
                          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
