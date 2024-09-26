import 'package:flutter/material.dart';
import 'package:safe_watch/globals.dart';
import 'HomeScreen.dart';
import 'SignupDatabase.dart';
import 'ProfileDatabase.dart'; // Import the profile database helper

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<ProfileScreen> {
  String fullName = 'Loading...';
  String email = 'Loading...';
  String username = 'Loading...';
  String phoneNumber = '+91-01234-56789'; // Initial phone number
  String address = '123 Main St, City, Country'; // Initial address
  bool isLoading = true;
  bool isEditing = false;

  final _profileDBHelper = ProfileDatabaseHelper.instance; // Create an instance of ProfileDatabaseHelper

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

Future<void> _loadUserData() async {
  try {
    final dbHelper = SignupDatabaseHelper.instance;
    final List<Map<String, dynamic>> users = await dbHelper.queryUserByEmail(globalEmail);

    if (users.isNotEmpty) {
      setState(() {
        fullName = users.first['name'];
        email = users.first['email'];
        username = fullName.split(' ').first; // Extract first word as username
        isLoading = false;
      });

      // Load additional profile data (phone number and address)
      final List<Map<String, dynamic>> profile = await _profileDBHelper.queryProfileByEmail(globalEmail);
      if (profile.isNotEmpty) {
        setState(() {
          phoneNumber = profile.first['phonenumber'];
          address = profile.first['address'];
        });
      } 
    } else {
      setState(() {
        fullName = 'No user found';
        email = 'No user found';
        username = 'No user found';
        phoneNumber = 'No data'; // Set default or error value for phone number
        address = 'No data';     // Set default or error value for address
        isLoading = false;
      });
    }
  } catch (e) {
    setState(() {
      fullName = 'Error loading data';
      email = 'Error loading data';
      username = 'Error loading data';
      phoneNumber = 'Error loading data';
      address = 'Error loading data';
      isLoading = false;
    });
  }
}


  void _toggleEdit() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  Future<void> _saveChanges() async {
  // Create a map to store the profile data
  final profileData = {
    'name': fullName,
    'email': email,
    'phonenumber': phoneNumber,
    'address': address,
  };

  try {
    // Check if profile already exists in the database
    final List<Map<String, dynamic>> existingProfile = await _profileDBHelper.queryProfileByEmail(globalEmail);

    if (existingProfile.isNotEmpty) {
      // Update existing profile
      await _profileDBHelper.updateProfileData(profileData, globalEmail);
    } else {
      // Insert new profile data if it doesn't exist
      await _profileDBHelper.insertprofiledata(profileData);
    }

    setState(() {
      isEditing = false; // Exit edit mode after saving
    });

    // Display a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile saved successfully!')),
    );
    await ProfileDatabaseHelper.instance.printAllprofile();
  } 
  catch (e) {
    // Handle any errors during insertion or update
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error saving profile: $e')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[300],
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
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
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.cancel : Icons.edit, color: Colors.orange),
            onPressed: _toggleEdit,
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.orange, Colors.pink],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.all(4),
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
              Text(
                username,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ProfileDetail(
                      icon: Icons.person,
                      title: 'FULL NAME',
                      detail: fullName,
                    ),
                    const Divider(),
                    ProfileDetail(
                      icon: Icons.email,
                      title: 'EMAIL',
                      detail: email,
                    ),
                    const Divider(),
                    Row(
                      children: [
                        const Icon(Icons.phone, color: Colors.orange, size: 24),
                        const SizedBox(width: 16),
                        Expanded(
                          child: isEditing
                              ? TextField(
                                  onChanged: (value) {
                                    phoneNumber = value; // Update phone number
                                  },
                                  decoration: InputDecoration(
                                    hintText: phoneNumber,
                                    border: const OutlineInputBorder(),
                                  ),
                                )
                              : Text(
                                  phoneNumber,
                                  style: const TextStyle(fontSize: 16),
                                ),
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.orange, size: 24),
                        const SizedBox(width: 16),
                        Expanded(
                          child: isEditing
                              ? TextField(
                                  onChanged: (value) {
                                    address = value; // Update address
                                  },
                                  decoration: InputDecoration(
                                    hintText: address,
                                    border: const OutlineInputBorder(),
                                  ),
                                )
                              : Text(
                                  address,
                                  style: const TextStyle(fontSize: 16),
                                ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    if (isEditing)
                      ElevatedButton(
                        onPressed: _saveChanges,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF7A00),
                          minimumSize: const Size(180, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'SAVE',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
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
