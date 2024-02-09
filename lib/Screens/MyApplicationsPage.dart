import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyApplicationsPage extends StatefulWidget {
  final String userEmail;

  MyApplicationsPage({required this.userEmail});

  @override
  _MyApplicationsPageState createState() => _MyApplicationsPageState();
}

class _MyApplicationsPageState extends State<MyApplicationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 241, 241, 241),
      appBar: AppBar(
        title: Text('My Applications',style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('applicants')
              .where('applicantEmail', isEqualTo: widget.userEmail)
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error loading applications: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No applications found'));
            } else {
              List<DocumentSnapshot> applications = snapshot.data!.docs;
              return ListView.builder(
                itemCount: applications.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> applicationData =
                      applications[index].data() as Map<String, dynamic>;

                  return Column(
                    children: [
                      _buildJobApplicationCard(
                        applicationData['jobPosition'],
                        applicationData['companyName'],
                        applicationData['jobLocation'],
                        applicationData['employmentType'],
                        applicationData['jobDescription'],
                        applicationData['category'],
                        applicationData['timestamp'],
                        applicationData['salary'],
                        applicationData['postedBy'],
                        applicationData['workplaceType'],
                      ),
                      SizedBox(height: 8),
                      Text(
                        getTimeAgo(applicationData['timestamp'].toDate()),
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      Divider(height: 16, color: Colors.grey),
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildJobApplicationCard(
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
  ) {
    bool isPressed = false;
    print(toTitleCase(jobPosition));
    List<String> locationParts = jobLocation.split(',');

    String firstWordBeforeComma = locationParts.length > 1
        ? locationParts[0].trim().split(' ')[0]
        : jobLocation.trim().split(' ')[0];

    String lastWord = locationParts.last.trim();

    String shortenedLocation = '$firstWordBeforeComma, $lastWord';
    print(shortenedLocation);

    var domain = companyName.toLowerCase();
    double salaryValue = double.parse(salary);
    String timeAgo = getTimeAgo(timestamp.toDate());
    String formattedSalary = salaryValue > 1000
        ? '\$${(salaryValue / 1000).toString()} K/Mo'
        : '${salaryValue.toInt()}';

    return Container(
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
              SizedBox(height: 16),
              Wrap(
                spacing: 8.0,
                children: [
                  SizedBox(width: 4.0),
                  Chip(label: Text(toTitleCase(jobPosition))),
                  Chip(label: Text(employmentType)),
                  Chip(label: Text(category)),
                  SizedBox(width: 4.0)
                ],
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    timeAgo, // Display time ago
                    style: TextStyle(
                        color: const Color.fromARGB(255, 118, 117, 117),
                        fontSize: 13),
                  ),
                  Text(
                    formattedSalary, // Display formatted salary
                    style:
                        TextStyle(color: const Color.fromARGB(255, 16, 16, 16)),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
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
