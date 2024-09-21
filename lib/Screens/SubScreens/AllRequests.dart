import 'package:flutter/material.dart';
import 'SubScreensRequest/PublicRequestDatabase.dart'; // Assuming your SQLite database helper is in this file

class AllRequests extends StatefulWidget {
  const AllRequests({super.key});

  @override
  State<AllRequests> createState() => _AllRequestsState();
}

class _AllRequestsState extends State<AllRequests> {
  late Future<List<Map<String, dynamic>>> _allRequests;

  @override
  void initState() {
    super.initState();
    _allRequests = PublicDatabaseHelper.instance.getAllRequests();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>( 
      future: _allRequests,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading requests'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                'Total 0 requests',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            body: const Center(child: Text('No public requests available')),
          );
        } else {
          int totalRequests = snapshot.data!.length;
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                'Total $totalRequests requests',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            body: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: totalRequests,
              itemBuilder: (context, index) {
                var request = snapshot.data![index];
                return _buildRequestCard(request);
              },
            ),
          );
        }
      },
    );
  }

  // Build each request card dynamically using the title, contact, and date from the database
  Widget _buildRequestCard(Map<String, dynamic> request) {
    // Extract title, contact, and date from the request map
    String title = request['title'] ?? 'No Title';
    String date = request['date'] ?? 'No Date';
    String contact = request['contact'] ?? 'No Contact';

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
            _buildCardHeader(title, date), // Use dynamic title and date
            const SizedBox(height: 8),
            Text(
              request['details'] ?? 'No details provided',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Contact: $contact',  // Use dynamic contact from the database
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  // Build the card header with dynamic title and date
  Widget _buildCardHeader(String title, String date) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,  // Dynamic title from the database
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              date,  // Dynamic date from the database
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );
  }
}
