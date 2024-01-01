import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  Widget build(BuildContext context) {
    print(remoteJobCount);
    print(employmentTypeFTCount);
    print(employmentTypePTCount);
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJobCard(String label) {
    return Container(
      width: 175, // Adjust the width as needed
      height: 198, // Adjust the height as needed
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
    return Container(
      width: 175, // Adjust the width as needed
      height: 95, // Adjust the height as needed
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
    return Container(
      width: 175, // Adjust the width as needed
      height: 95, // Adjust the height as needed
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
}
