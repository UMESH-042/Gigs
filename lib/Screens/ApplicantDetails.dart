import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ApplicantDetailsPage extends StatelessWidget {
  final String jobPosition;
  final String companyName;
  final String jobLocation;
  final String employmentType;
  final String jobDescription;
  final String category;
  final Timestamp timestamp;
  final String salary;
  final String postedBy;
  final String workplaceType;

  ApplicantDetailsPage({
    required this.jobPosition,
    required this.companyName,
    required this.jobLocation,
    required this.employmentType,
    required this.jobDescription,
    required this.category,
    required this.timestamp,
    required this.salary,
    required this.postedBy,
    required this.workplaceType,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Applicant Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display detailed information about the applicant
            // Customize this based on your design
            Text(
              'Job Position: $jobPosition',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Company Name: $companyName'),
            Text('Job Location: $jobLocation'),
            Text('Employment Type: $employmentType'),
            Text('Job Description: $jobDescription'),
            Text('Category: $category'),
            Text('Timestamp: ${getTimeAgo(timestamp.toDate())}'),
            Text('Salary: $salary'),
            Text('Posted By: $postedBy'),
            Text('Workplace Type: $workplaceType'),
            // Add more details as needed

            SizedBox(height: 20),

            // Add a button to view the user's profile
            ElevatedButton(
              onPressed: () {
                // Implement navigation to view user's profile
                // You can use Navigator.push to navigate to the profile page
              },
              child: Text('View User Profile'),
            ),
          ],
        ),
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
}
