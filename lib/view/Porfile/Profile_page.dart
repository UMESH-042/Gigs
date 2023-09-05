import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gigs/profile_APIs/Add_about_me.dart';

import '../../profile_APIs/Add_work_experience.dart';

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
  String _aboutme = '';
  String _workexperience = '';

  void onJobDescriptionAdded(String description) {
    setState(() {
      _aboutme = description;
    });
  }

  void onWorkExperienceAdded(String work) {
    setState(() {
      _workexperience = work;
    });
  }

    @override
  void initState() {
    super.initState();
    // Fetch "About Me" content from Firestore when the widget is created
    fetchAboutMeContent();
  }

  // Fetch "About Me" content from Firestore
  void fetchAboutMeContent() async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.currentUserEmail)
          .get();

      if (docSnapshot.exists) {
        setState(() {
          _aboutme = docSnapshot.data()?['aboutMe'] ?? ''; // Get the "aboutMe" field
        });
      }
    } catch (e) {
      print('Error fetching About Me: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(220), // Set the desired height of the app bar
        child: Stack(
          children: [
            AppBar(
              backgroundColor: Color.fromARGB(255, 31, 11, 118),
              automaticallyImplyLeading: false, // Remove back button
              flexibleSpace: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        left: 35, top: 50), // Adjust margins as needed
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
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Text(
                            "User's Name", // Default name
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          );
                        }

                        var userData = snapshot.data!.docs.first.data();
                        String displayName = userData['name'] ?? '';
                        print(displayName);

                        return Text(
                          displayName,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        );
                      },
                    ),
                  ),
                ],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20), // Adjust the radius as needed
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    // Implement the action for the Settings button here
                  },
                  icon: Icon(Icons.settings),
                ),
              ],
            ),
            Positioned(
              bottom: screenHeight * 0.013,
              right: screenWidth * 0.04,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Implement the action for the Edit Profile button here
                },
                icon: Icon(Icons.edit),
                label: Text(
                  "Edit Profile",
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 69, 41, 191),
                  onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.031,
              left: screenWidth * 0.08,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "23K Followers",
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.031,
              right: screenWidth * 0.4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "120k Following",
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(height: 20),
              AboutMe(
                label: "About Me",
                content: _aboutme, // Display selected location
                userId: widget.currentUserEmail,
                onPressed: () async {
                  final AddedJobDescription = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddAboutMe(userId: widget.currentUserEmail,),
                    ),
                  );
                  if (AddedJobDescription != null) {
                    onJobDescriptionAdded(AddedJobDescription);
                  }
                },
              ),
              SizedBox(
                height: 8,
              ),
              WorkExperience(
                label: 'Work experience',
                content: _workexperience,
                onPressed: () {
                   Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddWorkExperiencePage(),
      ),
    );
                },
              )
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}

class AboutMe extends StatelessWidget {
  final String label;
  final String? content;
  final VoidCallback? onPressed;
    final String userId;

  const AboutMe({required this.label, this.content, this.onPressed, required this.userId});

  @override
  Widget build(BuildContext context) {
    print(content);
    if (content != '') {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.person_2_outlined,
                    color: Color(0xFFFCA34D),
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Color(0xFFFCA34D),
                    ),
                    onPressed: onPressed,
                  ),
                ],
              ),
              Divider(
                color: Color.fromARGB(255, 221, 220, 220),
                thickness: 1,
              ),
              SizedBox(height: 10),
              Text(
                content!,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      );
    } else {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.person_2_outlined,
                color: Color(0xFFFCA34D),
              ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Spacer(),
              IconButton(
                icon: Icon(
                  Icons.add_circle_outline_outlined,
                  color: Color(0xFFFCA34D),
                ),
                onPressed: onPressed,
              ),
            ],
          ),
        ),
      );
    }
  }
}

class WorkExperience extends StatelessWidget {
  final String label;
  final String? content;
  final VoidCallback? onPressed;

  const WorkExperience({required this.label, this.content, this.onPressed});

  @override
  Widget build(BuildContext context) {
    print(content);
    if (content != '') {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.person_2_outlined,
                    color: Color(0xFFFCA34D),
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Color(0xFFFCA34D),
                    ),
                    onPressed: onPressed,
                  ),
                ],
              ),
              Divider(
                color: Color.fromARGB(255, 221, 220, 220),
                thickness: 1,
              ),
              SizedBox(height: 10),
              Text(
                content!,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      );
    } else {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.work,
                color: Color(0xFFFCA34D),
              ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Spacer(),
              IconButton(
                icon: Icon(
                  Icons.add_circle_outline_outlined,
                  color: Color(0xFFFCA34D),
                ),
                onPressed: onPressed,
              ),
            ],
          ),
        ),
      );
    }
  }
}
