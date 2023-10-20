import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gigs/profile_APIs/Add_Education.dart';
import 'package:gigs/profile_APIs/Add_about_me.dart';
import 'package:gigs/profile_APIs/Add_appreciation.dart';
import 'package:gigs/profile_APIs/Add_language.dart';
import 'package:gigs/profile_APIs/Add_resume.dart';
import 'package:gigs/profile_APIs/Add_skills.dart';

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
  List<Map<String, dynamic>> _workExperienceList = [];
  List<Map<String, dynamic>> _educationList = [];
  List<String> skillsDataList = [];
  List<String> LanguageDataList = [];
  List<Map<String, dynamic>> _AppreciationList = [];

  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

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

// Fetch work experience data from Firestore
  void fetchWorkExperienceData() async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.currentUserEmail)
          .get();

      if (docSnapshot.exists) {
        final userData = docSnapshot.data();

        if (userData != null) {
          final workExperience = userData['workExperience'] as List<dynamic>?;
          if (workExperience != null) {
            setState(() {
              _workExperienceList = List<Map<String, dynamic>>.from(
                workExperience,
              );
            });
          }
        }
      }
    } catch (e) {
      print('Error fetching Work Experience: $e');
    }
  }

// Fetch work experience data from Firestore
  void fetchEducationData() async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.currentUserEmail)
          .get();

      if (docSnapshot.exists) {
        final userData = docSnapshot.data();

        if (userData != null) {
          final Education = userData['education'] as List<dynamic>?;
          if (Education != null) {
            setState(() {
              _educationList = List<Map<String, dynamic>>.from(
                Education,
              );
            });
          }
        }
      }
    } catch (e) {
      print('Error fetching Work Experience: $e');
    }
  }

  //Fetch Appreciation data from Firestore
  void fetchAppreciationData() async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.currentUserEmail)
          .get();

      if (docSnapshot.exists) {
        final userData = docSnapshot.data();

        if (userData != null) {
          final Appreciation = userData['appreciation'] as List<dynamic>?;
          if (Appreciation != null) {
            setState(() {
              _AppreciationList = List<Map<String, dynamic>>.from(
                Appreciation,
              );
            });
          }
        }
      }
    } catch (e) {
      print('Error fetching Work Experience: $e');
    }
  }

// Fetch skills data from Firestore
  void fetchSkillsData() async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.currentUserEmail)
          .get();

      if (docSnapshot.exists) {
        final userData = docSnapshot.data();

        if (userData != null) {
          final skills = userData['skills'] as List<dynamic>?;
          if (skills != null) {
            setState(() {
              skillsDataList = List<String>.from(
                skills,
              );
            });
          }
        }
      }
    } catch (e) {
      print('Error fetching Skills: $e');
    }
  }

  // Fetch languages data from Firestore
  void fetchLanguagesData() async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.currentUserEmail)
          .get();

      if (docSnapshot.exists) {
        final userData = docSnapshot.data();

        if (userData != null) {
          final languages = userData['languages'] as List<dynamic>?;
          if (languages != null) {
            setState(() {
              LanguageDataList = List<String>.from(
                languages,
              );
            });
          }
        }
      }
    } catch (e) {
      print('Error fetching Languages: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch "About Me" content from Firestore when the widget is created
    fetchAboutMeContent();
    fetchWorkExperienceData();
    fetchEducationData();
    fetchSkillsData();
    fetchLanguagesData();
    fetchAppreciationData();
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
          _aboutme =
              docSnapshot.data()?['aboutMe'] ?? ''; // Get the "aboutMe" field
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
    print(_workExperienceList);
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
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          // Implement your refresh logic here
          fetchAboutMeContent();
          fetchWorkExperienceData();
          fetchEducationData();
          fetchSkillsData();
          fetchLanguagesData();
          fetchAppreciationData();
        },
        child: SingleChildScrollView(
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
                        builder: (context) => AddAboutMe(
                          userId: widget.currentUserEmail,
                        ),
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
                  workExperienceData: _workExperienceList,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddWorkExperiencePage(
                          email: widget.currentUserEmail,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 8,
                ),
                Education(
                  label: 'Education',
                  EducationData: _educationList,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddEducationPage(
                                email: widget.currentUserEmail)));
                  },
                ),
                SizedBox(
                  height: 8,
                ),
                Skills(
                  label: 'Skills',
                  skills: skillsDataList,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SkillSearchScreen(
                                  userEmail: widget.currentUserEmail,
                                )));
                  },
                ),
                SizedBox(
                  height: 8,
                ),
                LanguageSkills(
                  label: 'Language',
                  language: LanguageDataList,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LanguageSearchScreen(
                                  userEmail: widget.currentUserEmail,
                                )));
                  },
                ),
                SizedBox(
                  height: 8,
                ),
                Appreciation(
                  label: 'Appreciation',
                  AppreciationData: _AppreciationList,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AppreciationScreen(
                                  userEmail: widget.currentUserEmail,
                                )));
                  },
                ),
                Resume(
                  label: "Resume",
                  ResumeData: [],
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UploadCVWidget()));
                  },
                )
              ],
            ),
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}

// Added comments

class AboutMe extends StatelessWidget {
  final String label;
  final String? content;
  final VoidCallback? onPressed;
  final String userId;

  const AboutMe(
      {required this.label,
      this.content,
      this.onPressed,
      required this.userId});

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
  final List<Map<String, dynamic>> workExperienceData;
  final VoidCallback? onPressed;

  const WorkExperience({
    required this.label,
    required this.workExperienceData,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    print(workExperienceData);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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
            for (var i = 0; i < workExperienceData.length; i++)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    color: Color.fromARGB(255, 221, 220, 220),
                    thickness: 1,
                  ),
                  SizedBox(height: 10),
                  Text(
                    workExperienceData[i]['jobTitle'] ?? '',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(
                        workExperienceData[i]['company'] ?? '',
                        style: TextStyle(fontSize: 16),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.orange, // Orange edit icon color
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        workExperienceData[i]['startDate'] ?? '',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(width: 5),
                      Text('--'),
                      SizedBox(width: 5),
                      Text(
                        workExperienceData[i]['endDate'] ?? '',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class Education extends StatelessWidget {
  final String label;
  final List<Map<String, dynamic>> EducationData;
  final VoidCallback? onPressed;

  const Education({
    required this.label,
    required this.EducationData,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    print(EducationData);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.school_outlined,
                  color: Color(0xFFFCA34D),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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
            for (var i = 0; i < EducationData.length; i++)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    color: Color.fromARGB(255, 221, 220, 220),
                    thickness: 1,
                  ),
                  SizedBox(height: 10),
                  Text(
                    EducationData[i]['levelOfEducation'] ?? '',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(
                        EducationData[i]['fieldOfStudy'] ?? '',
                        style: TextStyle(fontSize: 16),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.orange, // Orange edit icon color
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        EducationData[i]['startDate'] ?? '',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(width: 5),
                      Text('--'),
                      SizedBox(width: 5),
                      Text(
                        EducationData[i]['endDate'] ?? '',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class Skills extends StatelessWidget {
  final String label;
  final List<String>? skills;
  final VoidCallback? onPressed;

  const Skills({
    required this.label,
    this.skills,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
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
                  Icons.star_outline,
                  color: Color(0xFFFCA34D),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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
            if (skills != null && skills!.isNotEmpty)
              Divider(
                color: Color.fromARGB(255, 221, 220, 220),
                thickness: 1,
              ),
            if (skills != null && skills!.isNotEmpty)
              Wrap(
                spacing: 8.0, // Adjust spacing as needed
                children: skills!.map((skill) {
                  return Chip(
                    label: Text(skill),
                    backgroundColor: const Color.fromARGB(
                        255, 216, 216, 216), // Adjust chip color
                  );
                }).toList(),
              ),
            if (skills == null || skills!.isEmpty)
              Row(
                children: [
                  // Icon(
                  //   Icons.star_outline,
                  //   color: Color(0xFFFCA34D),
                  // ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "No skills added",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class LanguageSkills extends StatelessWidget {
  final String label;
  final List<String>? language;
  final VoidCallback? onPressed;

  const LanguageSkills({
    required this.label,
    this.language,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
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
                  Icons.language,
                  color: Color(0xFFFCA34D),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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
            if (language != null && language!.isNotEmpty)
              Divider(
                color: Color.fromARGB(255, 221, 220, 220),
                thickness: 1,
              ),
            if (language != null && language!.isNotEmpty)
              Wrap(
                spacing: 8.0, // Adjust spacing as needed
                children: language!.map((skill) {
                  return Chip(
                    label: Text(skill),
                    backgroundColor: const Color.fromARGB(255, 216, 216, 216),
                  );
                }).toList(),
              ),
            if (language == null || language!.isEmpty)
              Row(
                children: [
                  // Icon(
                  //   Icons.language,
                  //   color: Color(0xFFFCA34D),
                  // ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "No language skills added",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class Appreciation extends StatelessWidget {
  final String label;
  final List<Map<String, dynamic>> AppreciationData;
  final VoidCallback? onPressed;

  const Appreciation({
    required this.label,
    required this.AppreciationData,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    print(AppreciationData);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.data_thresholding_outlined,
                  color: Color(0xFFFCA34D),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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
            for (var i = 0; i < AppreciationData.length; i++)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    color: Color.fromARGB(255, 221, 220, 220),
                    thickness: 1,
                  ),
                  SizedBox(height: 10),
                  Text(
                    AppreciationData[i]['awardname'] ?? '',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(
                        AppreciationData[i]['AchievementAchieved'] ?? '',
                        style: TextStyle(fontSize: 16),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.orange, // Orange edit icon color
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      // Text(
                      //   AppreciationData[i]['startDate'] ?? '',
                      //   style: TextStyle(fontSize: 14),
                      // ),
                      SizedBox(width: 5),
                      Text('--'),
                      SizedBox(width: 5),
                      Text(
                        AppreciationData[i]['endDate'] ?? '',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class Resume extends StatelessWidget {
  final String label;
  final List<Map<String, dynamic>> ResumeData;
  final VoidCallback? onPressed;

  const Resume({
    required this.label,
    required this.ResumeData,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    print(ResumeData);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.data_thresholding_outlined,
                  color: Color(0xFFFCA34D),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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
            for (var i = 0; i < ResumeData.length; i++)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    color: Color.fromARGB(255, 221, 220, 220),
                    thickness: 1,
                  ),
                  SizedBox(height: 10),
                  Text(
                    ResumeData[i]['awardname'] ?? '',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(
                        ResumeData[i]['AchievementAchieved'] ?? '',
                        style: TextStyle(fontSize: 16),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.orange, // Orange edit icon color
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      // Text(
                      //   AppreciationData[i]['startDate'] ?? '',
                      //   style: TextStyle(fontSize: 14),
                      // ),
                      SizedBox(width: 5),
                      Text('--'),
                      SizedBox(width: 5),
                      Text(
                        ResumeData[i]['endDate'] ?? '',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
