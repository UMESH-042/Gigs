import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:gigs/view/FilterPageList.dart';
import 'package:gigs/view/Porfile/Application_Page.dart';

class DisplayJobs extends StatefulWidget {
  const DisplayJobs({super.key});

  @override
  State<DisplayJobs> createState() => _DisplayJobsState();
}

class _DisplayJobsState extends State<DisplayJobs> {
  String _userName = ""; // Initialize the user's name
  int remoteJobCount = 0;
  int employmentTypeFTCount = 0;
  int employmentTypePTCount = 0;

  late StreamController<bool> _updateController;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _updateController = StreamController<bool>();
    _setupFirestoreListener();
  }

  void _setupFirestoreListener() {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .snapshots()
          .listen((userDoc) {
        if (userDoc.exists) {
          _loadUserData();
        }
      });
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
          String userName =
              userDoc['name'] ?? "User"; // Default to "User" if no name is set
          String userImageUrl = userDoc['imageUrl'] ??
              ""; // Default to empty if no image URL is set

          if (userDoc.exists) {
            // ... (unchanged code)

            // Fetch job data from Firestore specifically for remote jobs
            QuerySnapshot remoteJobsSnapshot = await FirebaseFirestore.instance
                .collection('jobs')
                .where('workplaceType', isEqualTo: 'Remote')
                .get();

            QuerySnapshot employmentTypeFT = await FirebaseFirestore.instance
                .collection('jobs')
                .where('employmentType', isEqualTo: 'Full Time')
                .get();

            QuerySnapshot employmentTypePT = await FirebaseFirestore.instance
                .collection('jobs')
                .where('employmentType', isEqualTo: 'Part Time')
                .get();

            // Calculate count for remote jobs
            remoteJobCount = remoteJobsSnapshot.size;
            employmentTypeFTCount = employmentTypeFT.size;
            employmentTypePTCount = employmentTypePT.size;
            setState(() {
              _userName = userName;
            });
          }
        }
      }
    } catch (e) {
      print("Error occurred while loading user data: $e");
    }
  }

  @override
  void dispose() {
    _updateController.close();
    super.dispose();
  }

  String getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      // Handle the case when the user is not signed in
      return ''; // or throw an exception, return null, etc.
    }
  }

  void saveJob(Map<String, dynamic> jobDetails) async {
    // Add the current user's ID to the job details
    String currentUserId = getCurrentUserId();
    jobDetails['userId'] = currentUserId;

    // Generate a unique job ID for the saved job
    String jobId = getUniqueJobId(jobDetails); // Implement this function

    // Check if the job is already saved
    if (await isJobSaved(currentUserId, jobId)) {
      // Job is already saved, show a message to the user
      showSnackbar('Job has already been saved!');
    } else {
      // Save the job details in the "savedJobs" collection
      await FirebaseFirestore.instance
          .collection('savedJobs')
          .doc(jobId)
          .set(jobDetails);

      // Notify the user that the job has been saved
      showSnackbar('Job saved successfully!');
    }
  }

  void showSnackbar(String message) {
    // Display a Snackbar with the specified message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  String getUniqueJobId(Map<String, dynamic> jobDetails) {
    // Create a unique job ID based on relevant fields
    String jobPosition = jobDetails['jobPosition'];
    String companyName = jobDetails['company'];
    String uniqueKey = '$jobPosition-$companyName';

    String jobId = uniqueKey.hashCode.toUnsigned(30).toString();

    return jobId;
  }

  Future<bool> isJobSaved(String userId, String jobId) async {
    // Check if the job with the specified ID is already saved by the user
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('savedJobs')
        .doc(jobId)
        .get();

    return snapshot.exists && snapshot['userId'] == userId;
  }

  @override
  Widget build(BuildContext context) {
    print(remoteJobCount);
    print(employmentTypeFTCount);
    print(employmentTypePTCount);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 240, 240),
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
              SizedBox(height: 25),
              // Advertisements Card
              Container(
                height: 178, // Adjust the height as needed
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color.fromARGB(
                      255, 31, 11, 118), // Change color as needed
                  borderRadius: BorderRadius.circular(10),
                ),
                // Add your advertisement content here
                child: Center(
                  child: Text(
                    'Advertisement',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
              // Find Your Job Text
              Text(
                'Find Your job',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 24),

              // Cards for Remote, Full Time, Part Time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildJobCard('Remote Job'),
                  Column(
                    children: [
                      _buildJobCardforFT('Full Time'),
                      SizedBox(height: 8),
                      _buildJobCardforPT('Part Time'),
                    ],
                  ),
                ],
              ),
              // SizedBox(height: 24),
              SizedBox(height: 16),
              Text(
                'Recent Job List',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 16),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream:
                      FirebaseFirestore.instance.collection('jobs').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }

                    var jobs = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: jobs.length,
                      itemBuilder: (context, index) {
                        var job = jobs[index].data() as Map<String, dynamic>;

                        return GestureDetector(
                          onVerticalDragEnd: (details) {
                            // Check if the user has scrolled down
                            if (details.primaryVelocity! < 0) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      FilterPage(), // Replace NewPage with your new page widget
                                ),
                              );
                            }
                          },
                          child: _buildJobDisplayCard(
                              job['jobPosition'],
                              job['company'],
                              job['jobLocation'],
                              job['employmentType'],
                              job['jobDescription'],
                              job['category'],
                              job['postedBy'],
                              job['salary'],
                              job['workplaceType'],
                              job['timestamp'], () {
                            saveJob(job);
                          }),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJobCard(String label) {
    return Container(
      width: 175, // Adjust the width as needed
      height: 188, // Adjust the height as needed
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 176, 221, 243), // Change color as needed
        borderRadius: BorderRadius.circular(10),
      ),
      // Add your card content here, for example:
      child: Center(
        child: Text(
          '          $remoteJobCount\n$label',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildJobCardforFT(String label) {
    final double cardWidth = MediaQuery.of(context).size.width * 0.42;
    final double cardHeight = MediaQuery.of(context).size.height * 0.11;

    return Container(
      // width: 175, // Adjust the width as needed
      // height: 90, // Adjust the height as needed
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 193, 168, 236), // Change color as needed
        borderRadius: BorderRadius.circular(10),
      ),
      // Add your card content here, for example:
      child: Center(
        child: Text(
          '      $employmentTypeFTCount\n$label',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildJobCardforPT(String label) {
    final double cardWidth = MediaQuery.of(context).size.width * 0.42;
    final double cardHeight = MediaQuery.of(context).size.height * 0.11;
    return Container(
      width: cardWidth,
      height: cardHeight,
      // width: 175, // Adjust the width as needed
      // height: 90, // Adjust the height as needed
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 238, 200, 144), // Change color as needed
        borderRadius: BorderRadius.circular(10),
      ),
      // Add your card content here, for example:
      child: Center(
        child: Text(
          '      $employmentTypePTCount\n$label',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildJobDisplayCard(
    String jobPosition,
    String companyName,
    String jobLocation,
    String employmentType,
    String jobDescription,
    String Category,
    String postedBy,
    String salary,
    String workplaceType,
    Timestamp timeStamp,
    Function() onSavePressed,
  ) {
    List<String> locationParts = jobLocation.split(',');

    String firstWordBeforeComma = locationParts.length > 1
        ? locationParts[0].trim().split(' ')[0]
        : jobLocation.trim().split(' ')[0];

    String lastWord = locationParts.last.trim();

    String shortenedLocation = '$firstWordBeforeComma, $lastWord';
    print(shortenedLocation);

    var domain = companyName.toLowerCase();

    return Container(
      // margin: EdgeInsets.only(bottom: 16),
      // padding: EdgeInsets.all(16),
 margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.016),
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://poweredwith.nyc3.cdn.digitaloceanspaces.com/images/domains/$domain.com.jpg'), // Use company logo URL
                    radius: 30,
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        toTitleCase(jobPosition),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(companyName),
                      Text(shortenedLocation),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  SizedBox(width: 8),
                  Chip(label: Text(toTitleCase(jobPosition))),
                  SizedBox(width: 8),
                  Chip(label: Text(employmentType)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.orange,
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ApplicationPage(
                                jobPosition: jobPosition,
                                companyName: companyName,
                                jobDescription: jobDescription,
                                employmentType: employmentType,
                                category: Category,
                                postedBy: postedBy,
                                salary: salary,
                                workplaceType: workplaceType,
                                timestamp: timeStamp,
                                jobLocation: jobLocation,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.transparent,
                          elevation: 0,
                        ),
                        child: Text(
                          'Apply',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                ],
              ),
              SizedBox(height: 12),
              Text(jobDescription),
            ],
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: onSavePressed,
              child: Icon(
                Icons.bookmark_border_outlined,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String toTitleCase(String text) {
    return text.replaceAllMapped(
      RegExp(r'\b\w'),
      (match) => match.group(0)!.toUpperCase(),
    );
  }
}
