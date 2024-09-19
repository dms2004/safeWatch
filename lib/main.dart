import 'package:flutter/material.dart';
//import 'Screens/MenuScreen.dart';
//import 'Screens/ProfileScreen.dart';
//import 'Screens/HomeScreen.dart';
import 'Screens/LogInScreen.dart';

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
      home: const Loginscreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // int _selectedIndex = 0;
  // // Dummy Screens
  // final List<Widget> _screens = [
  //   const HomeScreen(),
  //   const MenuScreen(),
  //   const NotificationScreen(),
  //   const ProfileScreen(),
  // ];

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  // void _showAlertDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Icon(
  //           Icons.warning_amber_rounded,
  //           size: 160,
  //           color: Color.fromARGB(255, 192, 38, 27),
  //         ),
  //         content: const Text(
  //           'Confirm Emergency!!',
  //           textAlign: TextAlign.center,
  //           style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
  //         ),
  //         actions: <Widget>[
  //           ElevatedButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //               child: const Text('Cancel')),
  //           ElevatedButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //               child: const Text('OK')),
  //         ],
  //       );
  //     },
  //   );
  // }

   @override
   Widget build(BuildContext context) {
     return const Placeholder();
  //     resizeToAvoidBottomInset: false,
  //     body: _screens[_selectedIndex],
  //     floatingActionButton: SizedBox(
  //       height: 90, // Set the desired height
  //       width: 90, // Set the desired width
  //       child: FloatingActionButton(
  //         backgroundColor: Colors.transparent,
  //         shape: const CircleBorder(),
  //         onPressed: _showAlertDialog, // Update to use the new function
  //         elevation: 0,
  //         child: Center(
  //           child: Image.asset('assets/logo.png',)
  //         ),
  //       ),
  //     ),
  //     floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
  //     bottomNavigationBar: BottomAppBar(
  //       // shape: const CircularNotchedRectangle(),
  //       notchMargin: 10,
  //       height: 65,
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         mainAxisSize: MainAxisSize.max,
  //         children: [
  //           IconButton(
  //             onPressed: () => _onItemTapped(0),
  //             icon: Icon(
  //               Icons.home_outlined,
  //               size: 30,
  //               color: _selectedIndex == 0
  //                   ? const Color.fromARGB(255, 202, 113, 19)
  //                   : Colors.grey,
  //             ),
  //           ),
  //           IconButton(
  //             onPressed: () => _onItemTapped(1),
  //             icon: Icon(
  //               Icons.menu,
  //               size: 30,
  //               color: _selectedIndex == 1
  //                   ? const Color.fromARGB(255, 202, 113, 19)
  //                   : Colors.grey,
  //             ),
  //           ),
  //           const SizedBox(width: 100), // Space for the FAB
  //           IconButton(
  //             onPressed: () => _onItemTapped(2),
  //             icon: Icon(
  //               Icons.notifications_outlined,
  //               size: 30,
  //               color: _selectedIndex == 2
  //                   ? const Color.fromARGB(255, 202, 113, 19)
  //                   : Colors.grey,
  //             ),
  //           ),
  //           IconButton(
  //             onPressed: () => _onItemTapped(3),
  //             icon: Icon(
  //               Icons.person_2_outlined,
  //               size: 30,
  //               color: _selectedIndex == 3
  //                   ? const Color.fromARGB(255, 202, 113, 19)
  //                   : Colors.grey,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
   }
}

// class NotificationScreen extends StatelessWidget {
//   const NotificationScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Text('Notification Screen', style: TextStyle(fontSize: 24)),
//     );
//   }
// }
