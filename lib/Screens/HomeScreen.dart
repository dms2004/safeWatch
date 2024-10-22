import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:safe_watch/Screens/SubScreens/Request.dart';
//import 'package:safe_watch/Screens/SubScreens/SubScreensRequest/Authority.dart';
import 'package:safe_watch/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/weather.dart';
import 'MenuScreen.dart';
import 'ProfileScreen.dart';
import 'EmergencyDatabase.dart';
import 'ProfileDatabase.dart';
import 'LoginScreen.dart';
import 'NotificationScreen.dart';
import 'package:safe_watch/apikey.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  WeatherFactory wf = WeatherFactory(apikey);
  Weather? _weather;

  final List<Widget> _screens = [
    const HomeContent(),
    const MenuScreen(),
    const NotificationScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _fetchWeather();
  }

  Future<void> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permission denied');
      } else if (permission == LocationPermission.deniedForever) {
        print('Location permission denied forever');
      } else {
        print('Location permission granted');
      }
    } else {
      print('Location permission already granted');
    }
  }

  void _fetchWeather() async {
    try {
      Weather w = await wf.currentWeatherByLocation(8.8932, 76.6141);
      setState(() {
        _weather = w;
      });
    } catch (e) {
      print('Error fetching weather: $e');
      setState(() {
        _weather = null;
      });
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
                      Navigator.of(context).pop();
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

  Future<void> _signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('rememberMe');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Loginscreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0
    ? AppBar(
        automaticallyImplyLeading: false,
        title: Text('safeWatch', style: TextStyle(color: Colors.orange[800])),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      )
    : null,
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

class HomeContent extends StatelessWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate([
            const WeatherOverview(),
            const EmergencyActions(),
            const PublicRequestsSection(),
            const LatestUpdates(),
          ]),
        ),
      ],
    );
  }
}

class WeatherOverview extends StatelessWidget {
  const WeatherOverview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeScreenState = context.findAncestorStateOfType<_HomeScreenState>();
    final weather = homeScreenState?._weather;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Current Weather',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Icon(Icons.location_on, color: Colors.blue.shade700),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    weather?.weatherMain ?? 'Unavailable',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    weather?.temperature?.celsius != null
                        ? '${weather!.temperature!.celsius!.toStringAsFixed(1)}°C'
                        : 'Temperature unavailable',
                    style: TextStyle(color: Colors.blue.shade600, fontSize: 16),
                  ),
                ],
              ),
              Icon(
                _getWeatherIcon(weather?.weatherMain),
                color: Colors.blue.shade700,
                size: 48,
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getWeatherIcon(String? condition) {
    if (condition == null) return Icons.cloud;
    switch (condition.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'rain':
        return Icons.umbrella;
      case 'thunderstorm':
        return Icons.flash_on;
      case 'snow':
        return Icons.ac_unit;
      default:
        return Icons.cloud;
    }
  }
}

class EmergencyActions extends StatelessWidget {
  const EmergencyActions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Emergency Actions',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildEmergencyButton(
                  context,
                  'Request Help',
                  Icons.emergency,
                  Colors.red.shade400,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildEmergencyButton(
                  context,
                  'Public Help',
                  Icons.location_on,
                  Colors.orange.shade400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyButton(BuildContext context, String text, IconData icon, Color color) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Requests(),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(height: 8),
          Text(text, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

class PublicRequestsSection extends StatelessWidget {
  const PublicRequestsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Public Requests',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildRequestItem('Food needed at Mundakayi camp', 'High Priority', Colors.red.shade400),
          const SizedBox(height: 8),
          _buildRequestItem('Medicines required in Wayanad', 'Medium Priority', Colors.orange.shade400),
          TextButton(
            onPressed: () {},
            child: const Text('View All Requests'),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestItem(String title, String priority, Color priorityColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  priority,
                  style: TextStyle(color: priorityColor, fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }
}

class LatestUpdates extends StatelessWidget {
  const LatestUpdates({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Latest Updates',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildUpdateItem(
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT5IycQef64hQO3582IojxYjc4VLIPPd2nKyA&s',
            'Flood warning issued for coastal areas',
          ),
           _buildUpdateItem(
            'https://images.unsplash.com/photo-1469571486292-0ba58a3f068b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2340&q=80',
            'Relief camps set up in affected regions',
          ),
          TextButton(
            onPressed: () {},
            child: const Text('See All Updates'),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateItem(String imageUrl, String title) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            child: Image.network(imageUrl,
                height: 150, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
