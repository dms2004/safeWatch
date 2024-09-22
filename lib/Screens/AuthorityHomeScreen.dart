import 'package:flutter/material.dart';
import 'package:safe_watch/EmergencyRequestsList.dart';
import 'SubScreens/SubScreensRequest/AuthorityRequestList.dart';

class AuthorityHomeScreen extends StatefulWidget {
  const AuthorityHomeScreen({super.key});

  @override
  State<AuthorityHomeScreen> createState() => _AuthorityHomeScreenState();
}

class _AuthorityHomeScreenState extends State<AuthorityHomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final Color _selectedColor = const Color(0xff1a73e8);
  final Color _unselectedColor = const Color(0xff5f6368);
  final Color _emergencyColor = Colors.red; // Red color for Emergency tab

  final List<Tab> _tabs = []; // Initialize later

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // Length is 2 for Emergency and Requests
    _tabs.addAll([
      Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.warning_amber_rounded, color: _emergencyColor), // Emergency icon
            const SizedBox(width: 8), // Spacing between icon and text
            Text(
              'Emergency',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: _emergencyColor, // Use emergency color
              ),
            ),
          ],
        ),
      ),
      const Tab(
        child: Text(
          'Requests',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    ]);
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
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0, // Remove shadow from AppBar
        title: Row(
          children: [
            Icon(Icons.admin_panel_settings, color: _selectedColor), // Admin icon
            const SizedBox(width: 8), // Spacing between icon and text
            const Text(
              'Admin Home',
              style: TextStyle(
                fontSize: 20, // Increased font size
                fontWeight: FontWeight.bold, // Bold text
              ),
            ),
          ],
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
            EmergencyRequestList(),
            AuthorityRequestsScreen(),
          ],
        ),
      ),
    );
  }
}
