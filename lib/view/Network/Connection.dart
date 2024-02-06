import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gigs/view/Porfile/userProfile.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class ConnectionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 241, 241, 241),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          // Filter out the current user's card from the list
          List<DocumentSnapshot> users = snapshot.data!.docs
              .where(
                  (user) => user.id != FirebaseAuth.instance.currentUser?.uid)
              .toList();

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 16.0,
              ),
              itemCount: users.length,
              itemBuilder: (context, index) {
                DocumentSnapshot user = users[index];


                return GestureDetector(
                    onTap: () {
                      // Navigate to the user's profile page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProfileScreen(useremail: user['email']),
                        ),
                      );
                    },
                    child: ConnectionCard(user: user));
              },
            ),
          );
        },
      ),
    );
  }
}

class ConnectionCard extends StatefulWidget {
  final DocumentSnapshot user;

  const ConnectionCard({Key? key, required this.user}) : super(key: key);

  @override
  _ConnectionCardState createState() => _ConnectionCardState();
}

class _ConnectionCardState extends State<ConnectionCard> {
  bool isFollowing = false;
  int followersCount = 0;
  bool isButtonDisabled = false;

  @override
  void initState() {
    super.initState();
    checkIfFollowing();
  }

  void checkIfFollowing() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? currentUser = auth.currentUser;

    if (currentUser != null) {
      String currentUserId = currentUser.uid;
      String targetUserId = widget.user.id;

      // Check if the current user is following the target user
      DocumentSnapshot followingDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection('following')
          .doc(targetUserId)
          .get();

      setState(() {
        isFollowing = followingDoc.exists;
      });
    }

    // Set the initial follower count
    setState(() {
      followersCount = widget.user['followers'] ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.user['imageUrl']),
              radius: 27.0,
            ),
            SizedBox(height: 8),
            Text(
              widget.user['name'] ?? '',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              '$followersCount Followers',
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 0),
              child: buildFollowButton(widget.user.id),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFollowButton(String targetUserId) {
    return ElevatedButton(
      key: ValueKey<bool>(isFollowing),
      onPressed: isButtonDisabled
          ? null
          : () {
              // Implement follow or unfollow functionality here
              isFollowing
                  ? unfollowUser(targetUserId)
                  : followUser(targetUserId);
            },
      style: ElevatedButton.styleFrom(
        primary: Colors.transparent, // Transparent background color
        elevation: 0, // No shadow
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.grey, // Border color
            width: 2.0, // Border width
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      child: Text(
        isFollowing ? 'Following' : 'Follow',
        style: TextStyle(
          fontSize: 16,
          color: Colors.black, // Text color
        ),
      ),
    );
  }

  void followUser(String targetUserId) async {
    setState(() {
      isButtonDisabled = true;
    });

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? currentUser = auth.currentUser;

    if (currentUser != null) {
      String currentUserId = currentUser.uid;

      // Fetch the current user's document from Firestore
      DocumentSnapshot currentUserSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .get();

      // Get the 'following' field from the document
      int currentFollowing = currentUserSnapshot['following'] ?? 0;

      // Update the following count for the current user
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .update({'following': currentFollowing + 1});

      // Add targetUserId to the 'followers' collection of currentUserId
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection('following')
          .doc(targetUserId)
          .set({});

      // Fetch the target user's document from Firestore
      DocumentSnapshot targetUserSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(targetUserId)
          .get();

      // Get the 'followers' field from the document
      int targetFollowers = targetUserSnapshot['followers'] ?? 0;

      // Update the followers count for the target user
      await FirebaseFirestore.instance
          .collection('users')
          .doc(targetUserId)
          .update({'followers': targetFollowers + 1});

      // Add currentUserId to the 'followers' collection of targetUserId
      await FirebaseFirestore.instance
          .collection('users')
          .doc(targetUserId)
          .collection('followers')
          .doc(currentUserId)
          .set({});

           sendNotification(
 currentUserSnapshot['name'],
      'followed you', targetUserSnapshot['token'],
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("You are following ${widget.user['name']}"),
        ),
      );
    }

    // Update the state to reflect the changes
    setState(() {
      isFollowing = true;
      followersCount += 1;
      isButtonDisabled = false;
    });
  }

  void unfollowUser(String targetUserId) async {
    setState(() {
      isButtonDisabled = true;
    });

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? currentUser = auth.currentUser;

    if (currentUser != null) {
      String currentUserId = currentUser.uid;

      // Fetch the current user's document from Firestore
      DocumentSnapshot currentUserSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .get();

      // Get the 'following' field from the document
      int currentFollowing = currentUserSnapshot['following'] ?? 0;

      // Update the following count for the current user
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .update({'following': currentFollowing - 1});

      // Remove targetUserId from the 'following' collection of currentUserId
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection('following')
          .doc(targetUserId)
          .delete();

      // Fetch the target user's document from Firestore
      DocumentSnapshot targetUserSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(targetUserId)
          .get();

      // Get the 'followers' field from the document
      int targetFollowers = targetUserSnapshot['followers'] ?? 0;

      // Update the followers count for the target user
      await FirebaseFirestore.instance
          .collection('users')
          .doc(targetUserId)
          .update({'followers': targetFollowers - 1});

      // Remove currentUserId from the 'followers' collection of targetUserId
      await FirebaseFirestore.instance
          .collection('users')
          .doc(targetUserId)
          .collection('followers')
          .doc(currentUserId)
          .delete();
    }
    // Show Snackbar for unfollowing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("You are unfollowing ${widget.user['name']}"),
      ),
    );
    // Update the state to reflect the changes
    setState(() {
      isFollowing = false;
      followersCount -= 1;
      isButtonDisabled = false;
    });
  }


  sendNotification(String userName, String message, String token) async {
    final data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'userName': userName,
      'message': message,
    };

    try {
      http.Response response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAGNLlsWY:APA91bHic5VqqER8euXs_uxxqwar5VHmAxw_2rVMaTH6QYaD2MG3TTGh6W_xxMfqyHzbvPHrvkDqyFUvk6J8sNy0W7CaowxSGP23x-VZmAVFNAV59xZoF74SLpK4L6E8mM6bVETHKSTm'
        },
        body: jsonEncode(<String, dynamic>{
          'notification': <String, dynamic>{
            'title': '$userName',
            'body': '$message',
          },
          'priority': 'high',
          'data': data,
          'to': '$token',
        }),
      );
      String? imageUrl;
      try {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();

        imageUrl = userSnapshot.get('imageUrl');
      } catch (e) {
        print("Error fetching imageUrl: $e");
      }

      if (response.statusCode == 200) {
          String notificationId = Uuid().v4();
     await FirebaseFirestore.instance.collection('notifications').doc(notificationId).set({
        'notificationId': notificationId,
        'userName': userName,
        'message': message,
        'SendTo': widget.user['email'],
        'imageUrl': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print("Notification sent successfully");
    } else {
      print("Error sending notification");
    }
    } catch (e) {
      print("Error: $e");
    }
  }
}
