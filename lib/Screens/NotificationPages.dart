import 'package:flutter/material.dart';
//import 'HomeScreen.dart';

// Data model for notifications
class NotificationModel {
  final String title;
  final String subtitle;
  final String time;
  final String imagePath;

  NotificationModel({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.imagePath,
  });
}

// Data model for messages
class MessageModel {
  final String title;
  final String content;
  final String time;
  final String imagePath;

  MessageModel({
    required this.title,
    required this.content,
    required this.time,
    required this.imagePath,
  });
}

class NotificationPages extends StatefulWidget {
  final List<NotificationModel> notifications;
  final List<MessageModel> messages;

  const NotificationPages({
    Key? key,
    required this.notifications,
    required this.messages,
  }) : super(key: key);

  @override
  _NotificationPagesState createState() => _NotificationPagesState();
}

class _NotificationPagesState extends State<NotificationPages> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // Initialize the TabController
  }

  @override
  void dispose() {
    _tabController.dispose(); // Dispose of the TabController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // Remove shadow from AppBar
        leading: Container(
          margin: const EdgeInsets.all(8), // Spacing around the circle
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[300], // Grey background for the circle
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new, // "less than" icon
              color: Colors.black, // Icon color
            ),
            onPressed: () {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => const HomeScreen()),
            // );
            },
          ),
        ),
        title: const Text("Notifications"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Notifications'),
            Tab(text: 'Messages'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Notifications Tab
          ListView(
            children: widget.notifications.map((notification) => ListTile(
                  leading: Image.asset(notification.imagePath),
                  title: Text(notification.title),
                  subtitle: Text(notification.subtitle),
                  trailing: Text(notification.time),
                )).toList(),
          ),
          // Messages Tab
          ListView(
            children: widget.messages.map((message) => ListTile(
                  leading: Image.asset(message.imagePath),
                  title: Text(message.title),
                  subtitle: Text(message.content),
                  trailing: Text(message.time),
                )).toList(),
          ),
        ],
      ),
    );
  }
}
