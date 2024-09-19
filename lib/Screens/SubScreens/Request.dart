import 'package:flutter/material.dart';
import 'SubScreensRequest/Authority.dart';
import 'SubScreensRequest/Public.dart';

class Requests extends StatefulWidget {
  const Requests({super.key});

  @override
  State<Requests> createState() => _MyRequestsState();
}

class _MyRequestsState extends State<Requests> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final Color _selectedColor = const Color(0xff1a73e8); // Blue color for selection
  final Color _unselectedColor = Colors.black; // Default text color for unselected tabs

  final List<Tab> _tabs = const [
    // Adding icons alongside text using Row
    Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person, size: 18), // Public icon
          SizedBox(width: 8), // Space between icon and text
          Text('Public', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    ),
    Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.gavel, size: 18), // Authority icon
          SizedBox(width: 8), // Space between icon and text
          Text('Authority', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    ),
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
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0, // Remove AppBar shadow
        title: TabBar(
          controller: _tabController,
          tabs: _tabs,
          labelColor: Colors.white, // Text color when selected
          unselectedLabelColor: _unselectedColor, // Text color when unselected
          labelPadding: const EdgeInsets.symmetric(horizontal: 24.0), // Increase padding between tabs
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(50.0), // Rounded corners
            color: _selectedColor, // Background color when selected
          ),
          //indicatorWeight: 0.0,
          indicatorSize: TabBarIndicatorSize.tab, // Ensures the indicator matches the tab's width
          dividerColor: Colors.transparent,
          //indicatorColor: Colors.transparent,
        ),
        centerTitle: true,
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          Public(),
          Authority(),
        ],
      ),
    );
  }
}
