import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import '../Screens/login_screen.dart';

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

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(child: Text('Umesh')),
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        items: [
          Icon(Icons.home, size: 30),
          Icon(Icons.people, size: 30),
          Icon(Icons.add_circle, size: 30),
          Icon(Icons.chat, size: 30),
          Icon(Icons.feedback, size: 30),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
