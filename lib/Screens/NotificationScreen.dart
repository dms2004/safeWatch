import 'package:flutter/material.dart';
import 'NotificationPages.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<NotificationModel> notifications = [
      NotificationModel(
        title: "NDMA",
        subtitle: "Dispatched rescue team",
        time: "20 min ago",
        imagePath: "assets/ndma_logo.jpg",
      ),
      NotificationModel(
        title: "Kudumbashree",
        subtitle: "Food distribution is underway in your area",
        time: "1 hour ago",
        imagePath: "assets/kudumbashree_logo.jpg",
      ),
      NotificationModel(
        title: "Kerala Police",
        subtitle: "Has reviewed your request on theft",
        time: "2 days ago",
        imagePath: "assets/kerala_police_logo.jpg",
      ),
      NotificationModel(
        title: "KLC",
        subtitle: "The aid for relief camps is on the way",
        time: "3 min ago",
        imagePath: "assets/klc_logo.jpg",
      ),
    ];

    // List of messages data (from the image)
    final List<MessageModel> messages = [
      MessageModel(
          title: "KSDMA",
          content: "Red Alert issued for Kollam District",
          time: "07:42",
          imagePath: 'assets/ksdma_logo.jpg'),
      MessageModel(
          title: "District Collector",
          content: "Due to heavy rain, tomorrow (20-02-20)...",
          time: "17:54",
          imagePath: 'assets/district_logo.jpg'),
      MessageModel(
          title: "Kerala Fisheries Department",
          content: "Fishermen are advised not to go fishing...",
          time: "19:34",
          imagePath: 'assets/kerala_fisheries_logo.jpg'),
    ];

    return MaterialApp(
      initialRoute: '/', // Set the initial route
      routes: {
        '/': (context) => NotificationPages(
              notifications: notifications, // Pass the notifications list
              messages: messages, // Pass the messages list
            ),
        /*
        '/welcome_page': (context) => const WelcomeScreen(), // Welcome page route
        '/login_page': (context) => const LoginPage(), // Login page route
        '/logIn_done': (context) => const Hello(), // Additional "Hello Welcome" page
        '/home_page':(context)=> const HomePage(),
        '/register_page':(context)=>const RegisterPage(),
        '/set_password': (context)=> const SetPassword(),
        */
      },
    );
  }
}