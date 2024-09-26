import 'package:flutter/material.dart';
import 'AuthorityHomeScreen.dart';


class Authorityloginscreen extends StatefulWidget {
  const Authorityloginscreen({super.key});

  @override
  State<Authorityloginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Authorityloginscreen> {
  bool _isRememberMeChecked = false;
  bool _obscurePassword = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B1D28),
      ),
      backgroundColor: const Color(0xFF1B1D28),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  const Center(
                  child: Text(
                    'Admin Log In',
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
                      'Please sign in to your existing account',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  Center(
                    child: _buildTextField(
                      label: 'EMAIL',
                      hint: 'Enter your email',
                      controller: _emailController,
                      obscureText: false,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  Center(
                    child: _buildTextField(
                      label: 'PASSWORD',
                      hint: 'Enter your password',
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 10),
                  
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _isRememberMeChecked,
                              activeColor: const Color(0xFFFF7A00),
                              onChanged: (value) {
                                setState(() {
                                  _isRememberMeChecked = value!;
                                });
                              },
                            ),
                            const Text(
                              'Remember me',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            // Forgot password functionality here
                          },
                          child: const Text(
                            'Forgot Password',
                            style: TextStyle(
                              color: Color(0xFFFF7A00),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  Center(
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AuthorityHomeScreen()),
                    );
                    
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF7A00),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'LOG IN',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
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
    Widget? suffixIcon,
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
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}