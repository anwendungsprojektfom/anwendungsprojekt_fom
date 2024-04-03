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
  bool _isEditing = false; // State variable for the editing mode
  late SharedPreferences _prefs; // SharedPreferences instance for accessing local storage

  late String _name;
  late String _phone;
  late String _address;
  late String _email; 

  // Controllers for the input fields
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _emailController;

  // The initState method is called when the widget state is first created
  @override
  void initState() {
    super.initState();
    // Variable initialization
    _name = '';
    _phone = '';
    _address = '';
    _email = '';
    // Initialization of controllers for the input fields
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _emailController = TextEditingController();
    // Load profile data
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
              ),
              ProfileItem(
                title: 'Phone',
                subtitle: _phone,
                icon: Icons.phone,
                isEditing: _isEditing,
                controller: _phoneController,
              ),
              ProfileItem(
                title: 'Address',
                subtitle: _address,
                icon: Icons.location_on,
                isEditing: _isEditing,
                controller: _addressController,
              ),
              ProfileItem(
                title: 'Email',
                subtitle: _email,
                icon: Icons.email,
                isEditing: _isEditing,
                controller: _emailController,
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  // Button for editing the profile
                  onPressed: () {
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
              currentIndex: 2,
            ), // Navigation element displayed only when not in editing mode
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
  final String title; 
  final String subtitle;
  final IconData icon;
  final bool isEditing;
  final TextEditingController controller;

  // Constructor for ProfileItem
  const ProfileItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isEditing,
    required this.controller,
    Key? key,
  }) : super(key: key);

  // Widget design
  @override
  Widget build(BuildContext context) {
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
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: isEditing
            ? TextFormField(
                controller: controller,
              ) // Display input field in editing mode
            : Text(subtitle),
      ),
    );
  }
}
