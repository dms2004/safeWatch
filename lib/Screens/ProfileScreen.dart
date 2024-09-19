import 'package:flutter/material.dart';
import 'HomeScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // Remove shadow from AppBar
        leading: Container(
          margin: const EdgeInsets.all(8), // Spacing around the circle
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[300], // Grey background for the circle
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new, // "less than" icon
              color: Colors.black, // Icon color
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
            },
          ),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                "EDIT",
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture with gradient
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.orange, Colors.pink],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(4), // Padding around the avatar
              child: const CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // User Name
            const Text(
              'User Name',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Nickname
            const Text(
              'Nick Name',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            // Profile Details Section
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color:  Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                children: [
                  ProfileDetail(
                    icon: Icons.person,
                    title: 'FULL NAME',
                    detail: 'Username',
                  ),
                  Divider(),
                  ProfileDetail(
                    icon: Icons.email,
                    title: 'EMAIL',
                    detail: 'example@gmail.com',
                  ),
                  Divider(),
                  ProfileDetail(
                    icon: Icons.phone,
                    title: 'PHONE NUMBER',
                    detail: '+91-01234-56789',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable widget for profile detail row
class ProfileDetail extends StatelessWidget {
  final IconData icon;
  final String title;
  final String detail;

  const ProfileDetail({
    super.key,
    required this.icon,
    required this.title,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.orange, size: 24),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            Text(
              detail,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }
}
