import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Color.fromARGB(255, 241, 241, 241),
      appBar: AppBar(
        title: Text('All Notifications',style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
              // Get the timestamp from the notification data
              Timestamp timestamp = notification['timestamp'];
              // Format the timestamp using timeago
              String timeAgoFormatted = timeago.format(timestamp.toDate());

              return Dismissible(
                key: Key(notification['notificationId']),
                direction: DismissDirection.startToEnd,
                onDismissed: (direction) {
                  _deleteNotification(notification['notificationId']);
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        'Delete',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
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
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(notification['message']),
                          SizedBox(height: 5),
                          Text(
                            timeAgoFormatted,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  void _deleteNotification(String notificationId) async {
    try {
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(notificationId)
          .delete();
    } catch (e) {
      print('Error deleting notification: $e');
      // Handle the error, if any
    }
  }
}
