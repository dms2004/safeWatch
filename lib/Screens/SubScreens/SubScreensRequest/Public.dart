import 'package:flutter/material.dart';
import 'PublicRequestDatabase.dart';
import 'package:intl/intl.dart'; // Add this package to format the date and time

class Public extends StatefulWidget {
  const Public({super.key});

  @override
  State<Public> createState() => _MyPublicState();
}

class _MyPublicState extends State<Public> {
  final _titleController = TextEditingController();
  final _contactController = TextEditingController(); // Contact number controller
  final _detailsController = TextEditingController();

  @override
  void dispose() {
    // Dispose of the controllers when the widget is disposed
    _titleController.dispose();
    _contactController.dispose(); // Dispose contact controller
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    final String title = _titleController.text;
    final String contact = _contactController.text; // Get contact number
    final String details = _detailsController.text;
    final String date = DateFormat('dd-MM-yyyy').format(DateTime.now()); // Automatically get the current date
    final String time = DateFormat('hh:mm a').format(DateTime.now()); // Get the current time in 12-hour format with AM/PM

    if (title.isEmpty || contact.isEmpty || details.isEmpty) {
      // Show a simple error if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields')),
      );
      return;
    }

    // Prepare data to be inserted
    Map<String, dynamic> requestData = {
      'title': title,
      'contact': contact, // Add contact number to the request data
      'details': details,
      'date': date, // Add the current date
      'time': time, // Add the current time in 12-hour format with AM/PM
    };

    // Insert into the SQLite database
    await PublicDatabaseHelper.instance.insertRequest(requestData);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Request Submitted Successfully')),
    );

    // Clear the form fields
    _titleController.clear();
    _contactController.clear(); // Clear contact field
    _detailsController.clear();

    await PublicDatabaseHelper.instance.printAllRequests();
    PublicDatabaseHelper.instance.printDatabasePath();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, 
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('TITLE OF REQUEST', '', controller: _titleController),
              const SizedBox(height: 16),
              _buildTextField('CONTACT NUMBER', '', controller: _contactController), // New Contact Field
              const SizedBox(height: 16),
              _buildTextField('DETAILS OF REQUEST', '', controller: _detailsController, maxLines: 3),
              const SizedBox(height: 24),
              const Text(
                "*Please Note: The information provided herein is intended for public disclosure and may be shared within the public domain.",
                style: TextStyle(fontSize: 12, color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF7A00), // Submit button color
                  minimumSize: const Size(double.infinity, 64), // Button size
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'SUBMIT',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String hint, {
    int maxLines = 1,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
    TextEditingController? controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.black,
            fontSize: fontSize, // Customize font size here
            fontWeight: fontWeight, // Customize font weight here
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller, // Attach the controller
          maxLines: maxLines,
          keyboardType: label == 'CONTACT NUMBER' ? TextInputType.phone : TextInputType.text, // Phone input for contact
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
