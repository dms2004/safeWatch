import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // Import Geolocator package
import 'package:safe_watch/globals.dart';
import 'MenuScreen.dart';
import 'ProfileScreen.dart';
import 'EmergencyDatabase.dart'; // Import your EmergencyDatabaseHelper
import 'ProfileDatabase.dart'; // Import your ProfileDatabaseHelper

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const Center(child: Text('Home Screen', style: TextStyle(fontSize: 24))),
    const MenuScreen(),
    const NotificationScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Handle the case when the user denies the permission
        // You might want to show a message or a dialog here
        print('Location permission denied');
      } else if (permission == LocationPermission.deniedForever) {
        // Handle the case when the user denies the permission permanently
        // You might want to direct them to app settings
        print('Location permission denied forever');
      } else {
        // Permission granted
        print('Location permission granted');
      }
    } else {
      // Permission already granted
      print('Location permission already granted');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _showAlertDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Icon(
            Icons.warning_amber_rounded,
            size: 160,
            color: Color.fromARGB(255, 192, 38, 27),
          ),
          content: const Text(
            'Confirm Emergency!!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                    String currentLocation = "${position.latitude}, ${position.longitude}";

                    List<Map<String, dynamic>> profile = await ProfileDatabaseHelper.instance.queryProfileByEmail(globalEmail);

                    if (profile.isNotEmpty) {
                      Map<String, dynamic> userProfile = profile.first;

                      Map<String, dynamic> emergencyRequest = {
                        'name': userProfile['name'],
                        'phonenumber': userProfile['phonenumber'],
                        'address': userProfile['address'],
                        'currentlocation': currentLocation,
                        'date': DateTime.now().toLocal().toIso8601String().split("T")[0],
                        'time': TimeOfDay.now().format(context),
                        'details': 'I am at an emergency!! Please help me...',
                      };

                      await EmergencyDatabaseHelper.instance.insertRequest(emergencyRequest);
                      await EmergencyDatabaseHelper.instance.printAllRequests();
                      Navigator.of(context).pop(); // Close the dialog
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(100, 40),
                    backgroundColor: Colors.green,
                  ),
                  child: const Text(
                    'YES',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(100, 40),
                    backgroundColor: Colors.red,
                  ),
                  child: const Text(
                    'NO',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _screens[_selectedIndex],
      floatingActionButton: SizedBox(
        height: 90,
        width: 90,
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          shape: const CircleBorder(),
          onPressed: _showAlertDialog,
          elevation: 0,
          child: Center(
            child: Image.asset('assets/logo.png'),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        notchMargin: 10,
        height: 65,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => _onItemTapped(0),
              icon: Icon(
                Icons.home_outlined,
                size: 30,
                color: _selectedIndex == 0 ? const Color.fromARGB(255, 202, 113, 19) : Colors.grey,
              ),
            ),
            IconButton(
              onPressed: () => _onItemTapped(1),
              icon: Icon(
                Icons.menu,
                size: 30,
                color: _selectedIndex == 1 ? const Color.fromARGB(255, 202, 113, 19) : Colors.grey,
              ),
            ),
            const SizedBox(width: 100),
            IconButton(
              onPressed: () => _onItemTapped(2),
              icon: Icon(
                Icons.notifications_outlined,
                size: 30,
                color: _selectedIndex == 2 ? const Color.fromARGB(255, 202, 113, 19) : Colors.grey,
              ),
            ),
            IconButton(
              onPressed: () => _onItemTapped(3),
              icon: Icon(
                Icons.person_2_outlined,
                size: 30,
                color: _selectedIndex == 3 ? const Color.fromARGB(255, 202, 113, 19) : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Notification Screen', style: TextStyle(fontSize: 24)),
    );
  }
}
