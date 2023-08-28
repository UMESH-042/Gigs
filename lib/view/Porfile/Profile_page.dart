import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  final String currentUserEmail;
  final String imageUrl;

  const ProfilePage(
      {Key? key, required this.currentUserEmail, required this.imageUrl})
      : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: PreferredSize(
        preferredSize: Size.fromHeight(235), // Set the desired height of the app bar
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          child: AppBar(
            flexibleSpace: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/app_bar_background.png', // Use the asset path
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 35, top: 50), // Adjust margins as needed
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(widget.imageUrl),
                        radius: 34,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .where('email', isEqualTo: widget.currentUserEmail)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }

                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            return Text(
                              "User's Name", // Default name
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            );
                          }

                          var userData = snapshot.data!.docs.first.data();
                          String displayName = userData['name'] ?? '';
                          print(displayName);

                          return Text(
                            displayName,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            automaticallyImplyLeading: false, // Remove back button
            actions: [IconButton(onPressed: () {}, icon: Icon(Icons.settings))],
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: widget.currentUserEmail)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading data'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available'));
          }

          var userData = snapshot.data!.docs.first.data();
          String displayName = userData['name'] ?? '';

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.imageUrl),
                  radius: 40,
                ),
                SizedBox(height: 8),
                Text(
                  displayName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(widget.currentUserEmail),
              ],
            ),
          );
        },
      ),
    );
  }
}
