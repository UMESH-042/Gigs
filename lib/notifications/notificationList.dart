import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: NotificationListView(),
    );
  }
}

class NotificationListView extends StatefulWidget {
  @override
  _NotificationListViewState createState() => _NotificationListViewState();
}

class _NotificationListViewState extends State<NotificationListView> {
  late Stream<List<Map<String, dynamic>>> _notificationsStream;

  @override
  void initState() {
    super.initState();
    _notificationsStream = _getNotifications();
  }

  Stream<List<Map<String, dynamic>>> _getNotifications() async* {
    // Get the current user's email
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String currentUserEmail = user.email ?? '';
      // Use the current user's email to filter notifications
      yield* FirebaseFirestore.instance
          .collection('notifications')
          .where('SendTo', isEqualTo: currentUserEmail)
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _notificationsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<Map<String, dynamic>> notifications = snapshot.data ?? [];

          if (notifications.isEmpty) {
            return Center(child: Text('No notifications available'));
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> notification = notifications[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Card(
                  elevation: 3,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(notification['imageUrl'] ?? ''),
                      radius: 24,
                    ),
                    title: Text(
                      notification['userName'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(notification['message']),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
