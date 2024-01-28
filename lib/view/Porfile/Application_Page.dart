// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:gigs/view/Add_Jobs.dart';

class ApplicationPage extends StatefulWidget {
  final String jobPosition;
  final String companyName;
  final String jobDescription;
  final String employmentType;
  final String category;
  final String postedBy;
  final String salary;
  final String workplaceType;
  final Timestamp timestamp;

  ApplicationPage({
    Key? key,
    required this.jobPosition,
    required this.companyName,
    required this.jobDescription,
    required this.employmentType,
    required this.category,
    required this.postedBy,
    required this.salary,
    required this.workplaceType,
    required this.timestamp,
  }) : super(key: key);

  @override
  _ApplicationPageState createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> {
  bool showJobDetails = true;

  Future<DocumentSnapshot<Map<String, dynamic>>> getCompanyDetails() async {
    try {
      // Fetch company details from the "companies" collection in Firestore
      QuerySnapshot<Map<String, dynamic>> companySnapshot =
          await FirebaseFirestore.instance
              .collection('companies')
              .where('companyName', isEqualTo: widget.companyName)
              .limit(1)
              .get();

      if (companySnapshot.docs.isNotEmpty) {
        return companySnapshot.docs.first;
      } else {
        // No matching document found
        return FirebaseFirestore.instance.doc('companies/nonexistent').get();
      }
    } catch (e) {
      // Handle any errors that might occur during the fetch
      print("Error fetching company details: $e");
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Apply for ${widget.jobPosition} at ${widget.companyName}'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCircularButtonJobDetails(
                  onPressed: () {
                    setState(() {
                      showJobDetails = true;
                    });
                  },
                ),
                _buildCircularButtonCompanyDetails(
                  onPressed: () {
                    setState(() {
                      showJobDetails = false;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    showJobDetails ? 'Job Details' : 'Company Details',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  if (showJobDetails) ...[
                    Text('Position: ${widget.jobPosition}'),
                    Text('Company: ${widget.companyName}'),
                    Text('Employment Type: ${widget.employmentType}'),
                    Text('Job Description: ${widget.jobDescription}'),
                    Text('Category: ${widget.category}'),
                    Text('Salary: \$${widget.salary}'),
                    Text('Workplace Type: ${widget.workplaceType}'),
                    Text('Job Posted By: ${widget.postedBy}'),
          
                  ] else
                    FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      future: getCompanyDetails(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error loading company details');
                        } else {
                          // Display company details
                          var companyData = snapshot.data!.data();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Company Description: ${companyData?['aboutCompany']}'),
                              Text(
                                  'Head Office Location: ${companyData?['headoffice']}'),
                              Text(
                                  'Company Type: ${companyData?['companyType']}'),
                              Text(
                                  'Employee Size: ${companyData?['employeeSize']}'),
                              Text('Industry: ${companyData?['industry']}'),
                              Text('Since: ${companyData?['since']} Years'),
                              Text(
                                  'Specialization: ${companyData?['specialization']}'),
                              Text(
                                  'Website Link : ${companyData?['websiteLink']}'),
                              Text('Image Urls: ${companyData?['imageUrls']}'),
                              // Add other company details as needed
                            ],
                          );
                        }
                      },
                    ),
                  SizedBox(height: 16),
                  Text(
                    'Application Form',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  // Add your application form widgets here
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularButtonJobDetails({required VoidCallback onPressed}) {
    return Container(
      width: 165,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        color: Color(0xFF130160), // You can change the color as needed
      ),
      child: TextButton(
          onPressed: onPressed,
          child: Center(
              child: Text(
            'Description',
            style: TextStyle(color: Colors.white),
          ))),
    );
  }

  Widget _buildCircularButtonCompanyDetails({required VoidCallback onPressed}) {
    return Container(
      width: 165,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        color: Color(0xFFD6CDFE), // You can change the color as needed
      ),
      child: TextButton(
          onPressed: onPressed,
          child: Center(
              child: Text(
            'Company',
            style: TextStyle(color: Colors.black),
          ))),
    );
  }
}
