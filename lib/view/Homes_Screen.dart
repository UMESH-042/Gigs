import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:gigs/view/Add_Jobs.dart';
import 'package:gigs/view/Chats.dart';
import 'package:gigs/view/Display_Jobs.dart';
import 'package:gigs/view/Network.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Screens/login_screen.dart';
import 'SavedJobs.dart';
import 'bottomSheet.dart';

class HomePage extends StatefulWidget {
  final String currentUserEmail;
  final bool requiresProfileSetup;
  const HomePage({
    Key? key,
    required this.currentUserEmail,
    required this.requiresProfileSetup,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _userImageUrl = ""; // Initialize the user's profile image URL
  int _currentIndex = 0;
  List<Widget> _screens = [];

  Future<void> storeNotificationToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({'token': token}, SetOptions(merge: true));
  }

  Future<void> _requestNotificationPermissions() async {
    PermissionStatus status = await Permission.notification.request();
    if (status.isGranted) {
      print('Notification allowed');
    } else if (status.isDenied) {
      // Notification permissions denied
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  @override
  void initState() {
    super.initState();
    storeNotificationToken();
    _screens = [
      DisplayJobs(),
      Network(),
      AddJobs(),
      Chats(),
      Saved(),
    ];
    _loadUserData();
    _requestNotificationPermissions();
  }

  // Function to handle the logout action
  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      // After successful logout, navigate to the login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      print("Error occurred during logout: $e");
      // Handle any error that occurred during logout (if any).
    }
  }

  Future<void> _loadUserData() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        // Retrieve user's document from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists) {
          // Get name and imageUrl from the document
          String userImageUrl = userDoc['imageUrl'] ??
              ""; // Default to empty if no image URL is set

          setState(() {
            _userImageUrl = userImageUrl;
          });
        }
      }
    } catch (e) {
      print("Error occurred while loading user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex == 0
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 17),
                      child: IconButton(
                        padding: EdgeInsets.all(0),
                        icon: CircleAvatar(
                          // backgroundColor: Color.fromARGB(255, 76, 175, 142),
                          backgroundImage: NetworkImage(_userImageUrl),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ],
            )
          : null,
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: _screens[_currentIndex],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        items: [
          Image.asset(
            'assets/homes_icon.png',
            width: 28,
            height: 28,
          ),
          Image.asset(
            'assets/sharing_icon.png',
            width: 28,
            height: 28,
          ),
          Image.asset(
            'assets/add_icon.png',
            width: 40,
            height: 40,
          ),
          Image.asset(
            'assets/chat_icon.png',
            width: 28,
            height: 28,
          ),
          Image.asset(
            'assets/save_icon.png',
            width: 28,
            height: 28,
          ),
        ],
        onTap: (index) {
          if (index == 2) {
            // Check if "Add" button is tapped
            showModalBottomSheet(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
              context: context,
              isScrollControlled: true,
              builder: (context) => AddBottomSheet(),
              
            );
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
      ),
    );
  }
}
