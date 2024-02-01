import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

      processField(userProfileSnapshot, 'aboutMe', (field) {
        setState(() {
          aboutMe = field.toString();
        });
      });

      processField(userProfileSnapshot, 'Resume', (field) {
        setState(() {
          resumeData = List<String>.from((field as List).map((e) => e.toString()));
        });
      });

      processField(userProfileSnapshot, 'appreciation', (field) {
        setState(() {
          appreciation = List<String>.from((field as List).map((e) => e.toString()));
        });
      });

      processField(userProfileSnapshot, 'education', (field) {
        setState(() {
          education = List<String>.from((field as List).map((e) => e.toString()));
        });
      });

      processField(userProfileSnapshot, 'languages', (field) {
        setState(() {
          languages = List<String>.from((field as List).map((e) => e.toString()));
        });
      });

      processField(userProfileSnapshot, 'skills', (field) {
        setState(() {
          skills = List<String>.from((field as List).map((e) => e.toString()));
        });
      });

      processField(userProfileSnapshot, 'workExperience', (field) {
        setState(() {
          workExperience = List<String>.from((field as List).map((e) => e.toString()));
        });
      });

    } catch (e) {
      // Handle errors
      print('Error fetching user data: $e');
    }
  }



void processField(DocumentSnapshot snapshot, String fieldName, Function(dynamic) processFunction) {
  Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

  if (snapshot.exists && data != null && data[fieldName] != null && data[fieldName] is List) {
    processFunction(data[fieldName]);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Username: $username'),
            SizedBox(height: 16),
            CachedNetworkImage(
              imageUrl: profileImageUrl,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            SizedBox(height: 16),
            Text('About Me: $aboutMe'),
            // Display additional data
            buildDataSection('Appreciation', appreciation),
            buildDataSection('Education', education),
            buildDataSection('Languages', languages),
            buildDataSection('Skills', skills),
            buildDataSection('Work Experience', workExperience),
            buildDataSection('Resume Data', resumeData),
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
        Text('$title:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        for (String item in data) Text('- $item'),
      ],
    );
  }
}
