import 'package:flutter/material.dart';
import 'Screens/EmergencyDatabase.dart'; // Import the Emergency Database helper class

class EmergencyRequestList extends StatelessWidget {
  const EmergencyRequestList({super.key});

  Future<List<Map<String, dynamic>>> _fetchEmergencyRequests() async {
    final requests = await EmergencyDatabaseHelper.instance.getAllRequests();
    return requests;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchEmergencyRequests(),
        builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No emergency requests found.'));
          } else {
            final requests = snapshot.data!;

            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Phone Number')),
                    DataColumn(label: Text('Address')),
                    DataColumn(label: Text('Current Location')),
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('Time')),
                    DataColumn(label: Text('Details')),
                  ],
                  rows: requests.map((request) {
                    return DataRow(
                      cells: [
                        DataCell(Text(request['id'].toString())),
                        DataCell(Text(request['name'] ?? 'N/A')),
                        DataCell(Text(request['phonenumber'] ?? 'N/A')),
                        DataCell(Text(request['address'] ?? 'N/A')),
                        DataCell(Text(request['currentlocation'] ?? 'N/A')),
                        DataCell(Text(request['date'] ?? 'N/A')),
                        DataCell(Text(request['time'] ?? 'N/A')),
                        DataCell(Text(request['details'] ?? 'N/A')),
                      ],
                    );
                  }).toList(),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
