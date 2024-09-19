import 'package:flutter/material.dart';
import 'package:safe_watch/Screens/HomeScreen.dart';
import 'SubScreens/Request.dart'; // Import the Request screen

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final Color _selectedColor = const Color(0xff1a73e8);
  final Color _unselectedColor = const Color(0xff5f6368);

  final List<Tab> _tabs = const [
    Tab(child: Text('All', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16))),
    Tab(child: Text('Requests', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16))),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this); // The length is now 2
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
          'My Requests',
          style: TextStyle(fontSize: 18),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs,
          labelColor: _selectedColor,
          indicatorColor: _selectedColor,
          unselectedLabelColor: _unselectedColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 0),
        child: TabBarView(
          controller: _tabController,
          children: const [
            Center(child: Text('All Requests')), // Content for the first tab ("All")
            Requests(), // Navigates to the Request screen for the second tab ("Requests")
          ],
        ),
      ),
    );
  }
}
