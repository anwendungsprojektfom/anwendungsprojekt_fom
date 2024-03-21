import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Center(
              child: CircleAvatar(
                radius: 70,
                backgroundColor: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            SizedBox(height: 20),
            ProfileItem(title: 'Name', subtitle: 'Tigers', icon: Icons.person),
            ProfileItem(title: 'Phone', subtitle: '0123456789', icon: Icons.phone),
            ProfileItem(title: 'Address', subtitle: 'TigersHausen 12, 80993 München', icon: Icons.location_on),
            ProfileItem(title: 'Email', subtitle: 'TigerDevTeam@gmail.de', icon: Icons.email),
            SizedBox(height: 20),
            Center(
                //hier Button rein
                ),
          ],
        ),
      ),
    );
  }
}

class ProfileItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const ProfileItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    Key? key,
  }) : super(key: key);

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
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward, color: Color.fromARGB(255, 0, 0, 0)),
      ),
    );
  }
}
