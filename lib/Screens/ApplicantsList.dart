import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gigs/Screens/ApplicantDetails.dart';

class ApplicantListPage extends StatefulWidget {
  final String currentUserEmail;

  ApplicantListPage({required this.currentUserEmail});

  @override
  _ApplicantListPageState createState() => _ApplicantListPageState();
}

class _ApplicantListPageState extends State<ApplicantListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 241, 241, 241),
      appBar: AppBar(
        title: Text(
          'Applicant List',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('applicants')
            .where('postedBy', isEqualTo: widget.currentUserEmail)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error loading applicants: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No applicants found'));
          } else {
            List<DocumentSnapshot> applicants = snapshot.data!.docs;
            return ListView.builder(
              itemCount: applicants.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> applicantData =
                    applicants[index].data() as Map<String, dynamic>;
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildUserJobApplicationCard(
                      applicantData['jobPosition'],
                      applicantData['companyName'],
                      applicantData['jobLocation'],
                      applicantData['employmentType'],
                      applicantData['jobDescription'],
                      applicantData['category'],
                      applicantData['timestamp'],
                      applicantData['salary'],
                      applicantData['postedBy'],
                      applicantData['workplaceType'],
                      applicantData['information'],
                      applicantData['applicantEmail'],
                      applicantData['resumeData']),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildUserJobApplicationCard(
      String jobPosition,
      String companyName,
      String jobLocation,
      String employmentType,
      String jobDescription,
      String category,
      Timestamp timestamp,
      String salary,
      String postedBy,
      String workplaceType,
      String information,
      String applicantEmail,
      Map resumeData) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: applicantEmail)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
              child: Text('Error loading user details: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('User details not found'));
        } else {
          var userData =
              snapshot.data!.docs.first.data() as Map<String, dynamic>;

          String userName = userData['name'];
          String email = userData['email'];
          String imageUrl = userData['imageUrl'];

          List<String> locationParts = jobLocation.split(',');
          String firstWordBeforeComma = locationParts.length > 1
              ? locationParts[0].trim().split(' ')[0]
              : jobLocation.trim().split(' ')[0];
          String lastWord = locationParts.last.trim();
          String shortenedLocation = '$firstWordBeforeComma, $lastWord';

          double salaryValue = double.parse(salary);
          String timeAgo = getTimeAgo(timestamp.toDate());
          String formattedSalary = salaryValue > 1000
              ? '\$${(salaryValue / 1000).toString()} K/Mo'
              : '${salaryValue.toInt()}';

          return GestureDetector(
            onTap: () {
              // Navigate to a detailed view page when the card is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ApplicantDetailsPage(
                    jobPosition: jobPosition,
                    companyName: companyName,
                    jobLocation: shortenedLocation,
                    employmentType: employmentType,
                    jobDescription: jobDescription,
                    category: category,
                    timestamp: timestamp,
                    salary: formattedSalary,
                    postedBy: userName, // Display user's name instead of email
                    workplaceType: workplaceType,
                    resumeData: resumeData,
                    information: information,
                    email: email,
                  ),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
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
                            backgroundImage:
                                NetworkImage(imageUrl), // Use user's imageUrl
                            radius: 30,
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userName,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  child: Text(
                                    'Applied for $employmentType $jobPosition in $category sector at $companyName',
                                    maxLines: 2, // Limit the number of lines
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            timeAgo,
                            style: TextStyle(
                                color: const Color.fromARGB(255, 118, 117, 117),
                                fontSize: 13),
                          ),
                          Text(
                            formattedSalary,
                            style: TextStyle(
                                color: const Color.fromARGB(255, 16, 16, 16)),
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
      },
    );
  }

  String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'just now';
    }
  }

  String toTitleCase(String text) {
    return text.replaceAllMapped(
      RegExp(r'\b\w'),
      (match) => match.group(0)!.toUpperCase(),
    );
  }
}
