import 'package:flutter/material.dart';

void main() {
  runApp(const ProfileScreen());
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;

  // The value is initialized later: namely before it is actually used
  late String _originalName;
  late String _originalPhone;
  late String _originalAddress;
  late String _originalEmail;

  // final: Value is passed only once (Edit Button) and initialized.
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _originalName = 'Tigers';
    _originalPhone = '0123456789';
    _originalAddress = 'TigersHausen 12, 80993 München';
    _originalEmail = 'TigerDevTeam@gmail.de';

    // Copy existing records of ProfileItems (so they can be updated later
    _nameController.text = _originalName;
    _phoneController.text = _originalPhone;
    _addressController.text = _originalAddress;
    _emailController.text = _originalEmail;
  }

  // Add Widg
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView( // Scroll widgetPage
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
              ProfileItem(
                title: 'Name',
                subtitle: _originalName,
                icon: Icons.person,
                isEditing: _isEditing,
                controller: _nameController,
              ),
              ProfileItem(
                title: 'Phone',
                subtitle: _originalPhone,
                icon: Icons.phone,
                isEditing: _isEditing,
                controller: _phoneController,
              ),
              ProfileItem(
                title: 'Address',
                subtitle: _originalAddress,
                icon: Icons.location_on,
                isEditing: _isEditing,
                controller: _addressController,
              ),
              ProfileItem(
                title: 'Email',
                subtitle: _originalEmail,
                icon: Icons.email,
                isEditing: _isEditing,
                controller: _emailController,
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton( // Edit button handler
                  onPressed: () {
                    setState(() {
                      _isEditing = !_isEditing;
                      if (!_isEditing) {
                        _saveProfile();
                      }
                    });
                  },
                  child: Text(_isEditing ? 'Save' : 'Edit'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _isEditing
          ? null // Once we are in Edit Mode: Hide BottomNavigationBarItems
          : BottomNavigationBar(
              currentIndex: 2,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Search',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
    );
  }

  // Save new records into ProfileItems, specifically within the main ProfileScreenWidget
  void _saveProfile() {
    _originalName = _nameController.text;
    _originalPhone = _phoneController.text;
    _originalAddress = _addressController.text;
    _originalEmail = _emailController.text;

    setState(() {
      _isEditing = false;
    });
  }
}

// Initialize items
class ProfileItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isEditing;
  final TextEditingController controller;

  const ProfileItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isEditing, 
    required this.controller,
    Key? key,
  }) : super(key: key);

  //Design
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
              )
            : Text(subtitle),
      ),
    );
  }
}
