import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DisplayJobs extends StatefulWidget {
  const DisplayJobs({super.key});

  @override
  State<DisplayJobs> createState() => _DisplayJobsState();
}

class _DisplayJobsState extends State<DisplayJobs> {
  String _userName = ""; // Initialize the user's name

  @override
  void initState() {
    super.initState();
    _loadUserData();
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
          String userName =
              userDoc['name'] ?? "User"; // Default to "User" if no name is set
          String userImageUrl = userDoc['imageUrl'] ??
              ""; // Default to empty if no image URL is set

          setState(() {
            _userName = userName;
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
        body: Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
            ),
            Text(
              _userName,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
