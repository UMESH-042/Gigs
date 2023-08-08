import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:gigs/view/Add_Jobs.dart';
import 'package:gigs/view/Chats.dart';
import 'package:gigs/view/Display_Jobs.dart';
import 'package:gigs/view/Network.dart';

import '../Screens/login_screen.dart';
import 'SavedJobs.dart';

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

  @override
  void initState() {
    super.initState();
    _screens = [
      DisplayJobs(),
      Network(),
      AddJobs(),
      Chats(),
      Saved(),
    ];
    _loadUserData();
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
          Icon(Icons.home, size: 30),
          Icon(Icons.people, size: 30),
          Icon(Icons.add_circle, size: 30),
          Icon(Icons.chat, size: 30),
          Icon(Icons.feedback, size: 30),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
