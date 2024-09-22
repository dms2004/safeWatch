import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting
import 'package:safe_watch/Screens/EmergencyDatabase.dart';
import 'SubScreensRequest/PublicRequestDatabase.dart';

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
    _allRequests = _getAllRequests();
  }
Future<List<Map<String, dynamic>>> _getAllRequests() async {
  // Fetch both public and emergency requests
  final publicRequests = await PublicDatabaseHelper.instance.getAllRequests();
  final emergencyRequests = await EmergencyDatabaseHelper.instance.getAllRequests();

  // Combine both lists
  final combinedRequests = [...publicRequests, ...emergencyRequests];

  // Sort by date and time in descending order (newest first)
  combinedRequests.sort((a, b) {
    DateTime dateTimeA = _parseDateTime(a['date'], a['time']);
    DateTime dateTimeB = _parseDateTime(b['date'], b['time']);

    // Newest submissions should come first
    return dateTimeB.compareTo(dateTimeA);
  });

  return combinedRequests;
}

// Helper function to parse date and time into a DateTime object
DateTime _parseDateTime(String? date, String? time) {
  try {
    // If date is null, return a very old date to sort it to the bottom
    if (date == null) return DateTime(0);

    // Parse the date
    DateTime parsedDate = DateTime.parse(date);

    // If time is provided, combine date and time, otherwise default to start of the day (00:00:00)
    if (time != null && time.isNotEmpty) {
      final parsedTime = DateFormat.Hms().parse(time);  // Parse time in HH:mm:ss format
      return DateTime(parsedDate.year, parsedDate.month, parsedDate.day, parsedTime.hour, parsedTime.minute, parsedTime.second);
    }

    // If no time is provided, return the date with time set to 00:00:00
    return DateTime(parsedDate.year, parsedDate.month, parsedDate.day);
  } catch (e) {
    // Return a default date in case of parsing error
    return DateTime(0);
  }
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
            body: const Center(child: Text('No requests available')),
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

  Widget _buildRequestCard(Map<String, dynamic> request) {
    // Determine if the request is an emergency
    bool isEmergency = request['details'] != null && request['details'].contains('emergency');

    // Use 'Emergency' as the title for emergency requests, otherwise use the title from public requests
    String title = isEmergency ? 'Emergency' : request['title'] ?? 'No Title';

    // Date and time - time only for emergency requests
    String date = request['date'] ?? 'No Date';
    date = _formatDate(date);  // Format the date into dd-mm-yyyy
    String time = isEmergency ? (request['time'] ?? 'No Time') : ''; // Time only for emergency requests

    // Contact - for public requests use 'contact' field, for emergency use 'phonenumber'
    String contact = isEmergency ? request['phonenumber'] ?? 'No Contact' : request['contact'] ?? 'No Contact';

    // Location - only show for emergency requests
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
            // Display header with title, date, and emergency indicator if needed
            _buildCardHeader(title, date, isEmergency),
            const SizedBox(height: 8),

            // Display details of the request (whether emergency or public request)
            Text(
              request['details'] ?? 'No details provided',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),

            // Display contact info for both emergency and public requests
            Text(
              'Contact: $contact',  // Correctly showing public request or emergency contact
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),

            // Show location only if it's an emergency request
            if (isEmergency) ...[
              const SizedBox(height: 8),
              Text(
                'Location: $currentLocation', // Display location for emergencies
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],

            // Show time only if it's an emergency request
            if (isEmergency) ...[
              const SizedBox(height: 8),
              Text(
                'Time: $time', // Display time of emergency
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
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
                color: isEmergency ? Colors.red : Colors.black,  // Emergency title in red
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),

        // Show an emergency icon on the right if it's an emergency request
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
