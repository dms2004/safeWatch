import 'package:flutter/material.dart';
import 'AuthorityRequestDatabase.dart'; // Import the SQLite helper class
import 'package:intl/intl.dart'; // Import for date formatting

class Authority extends StatefulWidget {
  const Authority({super.key});

  @override
  State<Authority> createState() => _MyAuthorityState();
}

class _MyAuthorityState extends State<Authority> {
  final _incidentDateController = TextEditingController();
  final _detailsController = TextEditingController();
   String? _selectedAuthority; // To hold the selected authority

  // List of authorities for the dropdown
  final List<String> _authorities = ['Police Department', 'Fire Department', 'Health Department', 'Municipality'];

  @override
  void dispose() {
    // Dispose of the controllers when the widget is disposed
    _incidentDateController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    final String? authority = _selectedAuthority; // Get the selected authority
    final String incidentDate = _incidentDateController.text;
    final String details = _detailsController.text;

    if (authority == null || incidentDate.isEmpty || details.isEmpty) {
      // Show a simple error if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields')),
      );

      return;
    }

    // Prepare data to be inserted
    Map<String, dynamic> requestData = {
      'authority': authority,
      'incident_date': incidentDate,
      'details': details,
    };

    // Insert into the SQLite database
    await DatabaseHelper.instance.insertRequest(requestData);
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Request Submitted Successfully')),
    );

    // Clear the form fields
        setState(() {
      _selectedAuthority = null;
    });
    _incidentDateController.clear();
    _detailsController.clear();
    await DatabaseHelper.instance.printAllRequests();
    DatabaseHelper.instance.printDatabasePath();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        // Format the selected date to dd/mm/yyyy
        _incidentDateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
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
              const SizedBox(height: 16),
              _buildDropdownField(),
              const SizedBox(height: 16),
              _buildDateField('DATE OF INCIDENT', controller: _incidentDateController), // Use date picker field
              const SizedBox(height: 16),
              _buildTextField('DETAILS OF REQUEST', '', controller: _detailsController, maxLines: 3, fontSize: 14, fontWeight: FontWeight.w400),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF7A00), // Submit button color
                  minimumSize: const Size(double.infinity, 64), // Button size
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('SUBMIT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            ],
          ),
        ),
      ),
    );
  }

    Widget _buildDropdownField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'AUTHORITY',
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedAuthority,
          hint: const Text('Select Authority'),
          items: _authorities.map((String authority) {
            return DropdownMenuItem<String>(
              value: authority,
              child: Text(authority),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedAuthority = newValue;
            });
          },
          decoration: InputDecoration(
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

  Widget _buildTextField(String label, String hint, {int maxLines = 1, double fontSize = 16, FontWeight fontWeight = FontWeight.normal, TextEditingController? controller}) {
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
  Widget _buildDateField(String label, {required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: true, // Make the field read-only
          onTap: () => _selectDate(context), // Open the date picker when tapped
          decoration: InputDecoration(
            hintText: 'Select Date',
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
