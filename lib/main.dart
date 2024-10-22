import 'package:flutter/material.dart';
import 'package:safe_watch/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screens/LogInScreen.dart';
import 'Screens/HomeScreen.dart'; // Assuming you have a HomeScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // Check if the user is already logged in
  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? password = prefs.getString('password');

    if (email != null) {
      globalEmail = email;
    }

    // Delay for 5 seconds before navigating
    await Future.delayed(const Duration(seconds: 2));

    // Navigate to the home screen if the user is logged in
    if (email != null && password != null) {
      // Here, you can perform validation against the database if needed
      // For simplicity, we'll assume valid credentials if they are saved
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      // Otherwise, navigate to the login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Loginscreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black, // Set the background color to black
      body: Center(
        child: Text(
          'Welcome to SafeWatch',
          style: TextStyle(
            color: Colors.white, // Set the text color to white
            fontSize: 24, // Adjust the font size as needed
            fontWeight: FontWeight.bold, // Make the text bold
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
