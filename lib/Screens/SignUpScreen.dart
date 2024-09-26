import 'package:flutter/material.dart';
import 'package:safe_watch/Screens/LogInScreen.dart';
import 'SignupDatabase.dart'; // Import the SQLite helper class
import 'package:crypto/crypto.dart'; // For hashing
import 'dart:convert'; // For utf8.encode and base64.encode

class Signupscreen extends StatefulWidget {
  const Signupscreen({super.key});

  @override
  State<Signupscreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Signupscreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _retypePasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isRetypePasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _retypePasswordController.dispose();
    super.dispose();
  }

  String hashPassword(String password) {
    var bytes = utf8.encode(password); // Encode the password as bytes
    var digest = sha256.convert(bytes); // Hash the password using SHA256
    return digest.toString(); // Convert the hash to a string
  }

  bool isPasswordValid(String password) {
    return password.length >= 8 && password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  }

  Future<void> _submitForm() async {
    final String name = _nameController.text;
    final String email = _emailController.text;
    final String password = _passwordController.text;
    final String retypePassword = _retypePasswordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty || retypePassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields')),
      );
      return;
    }
    if (!isPasswordValid(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 8 characters long and contain at least one special character')),
      );
      return;
    }

    if (password != retypePassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    String encryptedPassword = hashPassword(password);

    Map<String, dynamic> signupData = {
      'name': name,
      'email': email,
      'password': encryptedPassword,
    };

    await SignupDatabaseHelper.instance.insertSignup(signupData);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sign Up Successful!! Please Login with your credentials')),
    );

    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _retypePasswordController.clear();

    await SignupDatabaseHelper.instance.printAllSignups();
    SignupDatabaseHelper.instance.printDatabasePath();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Loginscreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF1B1D28),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const Center(
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Center(
                    child: Text(
                      'Please sign up to get started',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildTextField(
                    label: 'NAME',
                    hint: '',
                    obscureText: false,
                    controller: _nameController,
                    toggleVisibility: null, // No toggle needed for name
                    isVisible: true, // Always true for name
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    label: 'EMAIL',
                    hint: '',
                    obscureText: false,
                    controller: _emailController,
                    toggleVisibility: null, // No toggle needed for email
                    isVisible: true, // Always true for email
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    label: 'PASSWORD',
                    hint: '',
                    obscureText: !_isPasswordVisible,
                    controller: _passwordController,
                    toggleVisibility: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    isVisible: _isPasswordVisible,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    label: 'RE-TYPE PASSWORD',
                    hint: '',
                    obscureText: !_isRetypePasswordVisible,
                    controller: _retypePasswordController,
                    toggleVisibility: () {
                      setState(() {
                        _isRetypePasswordVisible = !_isRetypePasswordVisible;
                      });
                    },
                    isVisible: _isRetypePasswordVisible,
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF7A00),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'SIGN UP',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool obscureText = false,
    Function? toggleVisibility, // Optional for name and email
    required bool isVisible,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.black54),
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            suffixIcon: toggleVisibility != null ? IconButton(
              icon: Icon(
                isVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.black54,
              ),
              onPressed: () => toggleVisibility(),
            ) : null, // Only add the toggle if it's not null
          ),
        ),
      ],
    );
  }
}
