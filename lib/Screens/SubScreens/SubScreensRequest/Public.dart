import 'package:flutter/material.dart';

class Public extends StatefulWidget {
  const Public({super.key});

  @override
  State<Public> createState() => _MyPublicState();
}

class _MyPublicState extends State<Public> {
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
            _buildTextField('DETAILS OF REQUEST','',maxLines: 4,fontSize: 14, fontWeight: FontWeight.w400),
            const SizedBox(height: 24),
            const Text("*Please Note: The information provided herein is intended for public disclosure and may be shared within the public domain.",
            style: TextStyle(fontSize: 12,color: Colors.red,),),
            const Text(""),
            ElevatedButton(
              onPressed: () {
                // Handle submit action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF7A00), // Submit button color
                minimumSize: const Size(double.infinity, 64), // Button size
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('SUBMIT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 14)),
            ),
          ],
        ),
      ),
    ),
    );
  }
  Widget _buildTextField(String label, String hint, {int maxLines = 1, double fontSize = 16, FontWeight fontWeight = FontWeight.normal}) {
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
}