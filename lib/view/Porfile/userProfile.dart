import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  final String useremail;

  const ProfileScreen({Key? key, required this.useremail}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String username;
  late String profileImageUrl;
  late String aboutMe;
  List<String> resumeData = [];
  List<String> appreciation = [];
  List<String> education = [];
  List<String> languages = [];
  List<String> skills = [];
  List<String> workExperience = [];
  bool aboutUser = true;

  @override
  void initState() {
    super.initState();
    username = '';
    profileImageUrl = '';
    aboutMe = '';
    resumeData = [];
    appreciation = [];
    education = [];
    languages = [];
    skills = [];
    workExperience = [];
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      // Fetch data from the "users" collection
      QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: widget.useremail)
          .get();

      // Fetch data from the "userProfile" collection using document ID (email)
      DocumentSnapshot userProfileSnapshot = await FirebaseFirestore.instance
          .collection('usersProfile')
          .doc(widget.useremail)
          .get();

      // Check if data is available
      if (usersSnapshot.docs.isNotEmpty) {
        // Assuming "username" and "profileImageUrl" are fields in the documents
        setState(() {
          username = usersSnapshot.docs[0]['name'];
          profileImageUrl = usersSnapshot.docs[0]['imageUrl'];
        });
      } else {
        // Handle case when no data is found in the "users" collection
        print(
            'No data found in the "users" collection for user with email: ${widget.useremail}');
      }

      setState(() {
        aboutMe = userProfileSnapshot['aboutMe'];
      });

      processField(userProfileSnapshot, 'Resume', (field) {
        setState(() {
          resumeData =
              List<String>.from((field as List).map((e) => e.toString()));
        });
      });

      processField(userProfileSnapshot, 'appreciation', (field) {
        setState(() {
          appreciation =
              List<String>.from((field as List).map((e) => e.toString()));
        });
      });

      processField(userProfileSnapshot, 'education', (field) {
        setState(() {
          education =
              List<String>.from((field as List).map((e) => e.toString()));
        });
      });

      processField(userProfileSnapshot, 'languages', (field) {
        setState(() {
          languages =
              List<String>.from((field as List).map((e) => e.toString()));
        });
      });

      processField(userProfileSnapshot, 'skills', (field) {
        setState(() {
          skills = List<String>.from((field as List).map((e) => e.toString()));
        });
      });

      processField(userProfileSnapshot, 'workExperience', (field) {
        setState(() {
          workExperience =
              List<String>.from((field as List).map((e) => e.toString()));
        });
      });
    } catch (e) {
      // Handle errors
      print('Error fetching user data: $e');
    }
  }

  void processField(DocumentSnapshot snapshot, String fieldName,
      Function(dynamic) processFunction) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

    if (snapshot.exists &&
        data != null &&
        data[fieldName] != null &&
        data[fieldName] is List) {
      processFunction(data[fieldName]);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(aboutMe);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 241, 241, 241),
      appBar: AppBar(
        title: Text('Profile'),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(profileImageUrl),
                radius: 50,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                username,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildButtonForAboutUser(
                    onPressed: () {
                      setState(() {
                        aboutUser = true;
                      });
                    },
                    isSelected: aboutUser,
                  ),
                  _buildButtonForPostsByUser(
                    onPressed: () {
                      setState(() {
                        aboutUser = false;
                      });
                    },
                    isSelected: !aboutUser,
                  ),
                  // Add similar buttons for other sections if needed
                ],
              ),
            ),
            if (aboutUser) ...[
              // Display About Me content
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16),
                    Text(
                      'About Me:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      aboutMe,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 16),
                    buildDataSection('Appreciation', appreciation),
                    buildDataSection('Education', education),
                    buildDataSection('Languages', languages),
                    buildDataSection('Skills', skills),
                    buildDataSection('Work Experience', workExperience),
                    buildDataSection('Resume Data', resumeData),
                  ],
                ),
              ),
            ],
            if (!aboutUser) ...[
              // Display Posts content
              // You can replace this with the actual content for Posts
              Text(
                'Posts Section',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget buildDataSection(String title, List<String> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Text(
          '$title:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        for (String item in data) Text('- $item'),
      ],
    );
  }

  Widget _buildButtonForPostsByUser({
    required VoidCallback onPressed,
    required bool isSelected,
  }) {
    return Container(
      width: 100,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        color: isSelected ? Color(0xFFFCA34D) : Colors.white,
      ),
      child: TextButton(
          onPressed: onPressed,
          child: Center(
              child: Text(
            'Posts',
            style: TextStyle(color: isSelected ? Colors.white : Colors.black),
          ))),
    );
  }

  Widget _buildButtonForAboutUser({
    required VoidCallback onPressed,
    required bool isSelected,
  }) {
    return Container(
      width: 100,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        color: isSelected ? Color(0xFFFCA34D) : Colors.white,
      ),
      child: TextButton(
          onPressed: onPressed,
          child: Center(
              child: Text(
            'About Me',
            style: TextStyle(color: isSelected ? Colors.white : Colors.black),
          ))),
    );
  }
}
