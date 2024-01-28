import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

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
  final String jobLocation;

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
    required this.jobLocation,
  }) : super(key: key);

  @override
  _ApplicationPageState createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> {
  bool showJobDetails = true;

  @override
  void initState() {
    super.initState();
    // Initialize timeago
    timeago.setLocaleMessages('en', timeago.EnMessages());
  }

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

  String getTimeAgo(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    Duration timeAgo = DateTime.now().difference(dateTime);
    return timeago.format(DateTime.now().subtract(timeAgo), locale: 'en');
  }

  String getFirstWordBeforeComma(String input) {
    // Extract and return the first word before the comma in the input string
    var parts = input.split(',');
    return parts.isNotEmpty ? parts.first : input;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 35,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://poweredwith.nyc3.cdn.digitaloceanspaces.com/images/domains/${widget.companyName.toLowerCase()}.com.jpg',
                    ),
                    radius: 50,
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.companyName,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '  •  ',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(width: 8),
                        Text(
                          getFirstWordBeforeComma(widget.jobLocation),
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '  •  ',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '${getTimeAgo(widget.timestamp)}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
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
                  SizedBox(height: 16),
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
