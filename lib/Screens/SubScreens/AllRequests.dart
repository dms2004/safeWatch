import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting
import 'package:safe_watch/Screens/EmergencyDatabase.dart';
import 'SubScreensRequest/PublicRequestDatabase.dart';

class AllRequests extends StatefulWidget {
  const AllRequests({super.key});

  @override
  State<AllRequests> createState() => _AllRequestsState();
}

class _AllRequestsState extends State<AllRequests> with SingleTickerProviderStateMixin {
  late Future<List<Map<String, dynamic>>> _publicRequests;
  late Future<List<Map<String, dynamic>>> _emergencyRequests;
  late TabController _tabController;
  final Color _selectedColor = const Color(0xff1a73e8); // Blue color for selected tab
  final Color _unselectedColor = Colors.black; // Text color for unselected tab

  @override
  void initState() {
    super.initState();
    _publicRequests = PublicDatabaseHelper.instance.getAllRequests();
    _emergencyRequests = EmergencyDatabaseHelper.instance.getAllRequests();
    _tabController = TabController(length: 2, vsync: this); // 2 tabs: public and emergency
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0, // Remove AppBar shadow
        title: Container(
          margin: const EdgeInsets.only(top: 8.0), // Add some margin for styling
          child: TabBar(
            controller: _tabController,
            tabs: const [
              // Emergency requests tab
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.warning, size: 18, color: Colors.red), // Emergency icon
                    SizedBox(width: 8), // Space between icon and text
                    Text('Emergency', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              // Public requests tab
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
            ],
            labelColor: Colors.white, // Text color when selected
            unselectedLabelColor: _unselectedColor, // Text color when unselected
            labelPadding: const EdgeInsets.symmetric(horizontal: 34.0), // Increase padding between tabs
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0), // Rounded corners for the indicator
              color: _selectedColor, // Background color when selected
            ),
            indicatorSize: TabBarIndicatorSize.tab, // Ensures the indicator matches the tab's width
            //indicatorPadding: const EdgeInsets.symmetric(horizontal: 0), // Adjust padding to control width
            indicatorWeight: 0, // Custom styling to remove default underline
            dividerColor: Colors.transparent, // Remove any divider between tabs
          ),
        ),
        centerTitle: true, // Center the TabBar title
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRequestList(_emergencyRequests, isEmergency: true), // Tab 1: Emergency Requests
          _buildRequestList(_publicRequests, isEmergency: false), // Tab 2: Public Requests
        ],
      ),
    );
  }

  // Function to build the request list for each tab
  // Function to build the request list for each tab
Widget _buildRequestList(Future<List<Map<String, dynamic>>> futureRequests, {required bool isEmergency}) {
  return FutureBuilder<List<Map<String, dynamic>>>(
    future: futureRequests,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return const Center(child: Text('Error loading requests'));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Center(child: Text('No requests available'));
      } else {
        // Reverse the list to show the newest request first
        var requests = snapshot.data!;
        requests = requests.reversed.toList(); // Reverse the list

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            var request = requests[index];
            return _buildRequestCard(request, isEmergency: isEmergency);
          },
        );
      }
    },
  );
}


  // Function to build the individual request card
  Widget _buildRequestCard(Map<String, dynamic> request, {required bool isEmergency}) {
    String title = isEmergency ? 'Emergency' : request['title'] ?? 'No Title';
    String date = request['date'] ?? 'No Date';
    date = _formatDate(date);  // Format the date into dd-mm-yyyy
    String time = request['time'] ?? 'No Time';
    String contact = isEmergency ? request['phonenumber'] ?? 'No Contact' : request['contact'] ?? 'No Contact';
    String currentLocation = isEmergency ? request['currentlocation'] ?? 'No Location' : '';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardHeader(title, date, isEmergency),
            const SizedBox(height: 8),
            Text(
              request['details'] ?? 'No details provided',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Contact: $contact',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            if (isEmergency) ...[
              const SizedBox(height: 8),
              Text(
                'Location: $currentLocation',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              'Time: $time',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to format the date into dd-mm-yyyy
  String _formatDate(String date) {
    try {
      DateTime parsedDate = DateTime.parse(date);
      return DateFormat('dd-MM-yyyy').format(parsedDate);
    } catch (e) {
      return date;  // Return the original date string if parsing fails
    }
  }

  // Header including a conditional emergency icon on the right side
  Widget _buildCardHeader(String title, String date, bool isEmergency) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isEmergency ? Colors.red : Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        if (isEmergency)
          const Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
            size: 30,
          ),
      ],
    );
  }
}
