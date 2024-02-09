// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';

import 'package:gigs/view/Porfile/userProfile.dart';

class ApplicantDetailsPage extends StatefulWidget {
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
  final Map resumeData;
  final String information;
  final String email;

  ApplicantDetailsPage({
    Key? key,
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
    required this.resumeData,
    required this.information,
    required this.email,
  }) : super(key: key);

  @override
  State<ApplicantDetailsPage> createState() => _ApplicantDetailsPageState();
}

class _ApplicantDetailsPageState extends State<ApplicantDetailsPage> {
  PDFDocument? document;
  String? Filename;

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  void loadDocument() async {
    try {
      // Load PDF document from URL or local file path
      document = await PDFDocument.fromURL(widget.resumeData['URL']);
      Filename = widget.resumeData['FileName'];
      setState(() {});
    } catch (e) {
      print('Error loading PDF: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 241, 241, 241),
      appBar: AppBar(
        title: Text(
          'Applicant Details',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
           Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProfileScreen(useremail: widget.email),
                        ),
                      );
        },
        label: Text("Applicant's Profile"),
        icon: Icon(Icons.person),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        backgroundColor: Color(0xFF130160),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              _buildLabelAndContent('About Applicant', widget.information),
              SizedBox(height: 20),
              label('Resume'),
              if (document != null)
                GestureDetector(
                  onTap: () {
                    // Navigate to PDF viewer when the container is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PDFViewer(document: document!),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PDFViewer(document: document!),
                          ),
                        );
                      },
                      child: CustomPaint(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 140.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Color.fromARGB(255, 227, 217, 229),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.insert_drive_file,
                                      size: 40,
                                      color: Color.fromARGB(255, 209, 75, 37)),
                                  SizedBox(width: 8),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        Filename!,
                                        style: TextStyle(fontSize: 16.0),
                                      ),
                                      Text(
                                        '${widget.resumeData['FileSize']} KB',
                                        style: TextStyle(fontSize: 12.0),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              SizedBox(
                height: 30,
              ),
              label('Job Details'),
              SizedBox(
                height: 35,
              ),
              _buildLabelAndContent('Company Name', widget.companyName),
              SizedBox(
                height: 10,
              ),
              _buildLabelAndContent('Job Location', widget.jobLocation),
              SizedBox(
                height: 10,
              ),
              _buildLabelAndContent('Employment Type', widget.employmentType),
              SizedBox(
                height: 10,
              ),
              _buildLabelAndContent('Job Description', widget.jobDescription),
              SizedBox(
                height: 10,
              ),
              _buildLabelAndContent('Category', widget.category),
              SizedBox(
                height: 10,
              ),
              _buildLabelAndContent(
                  'Posted', getTimeAgo(widget.timestamp.toDate())),
              SizedBox(
                height: 10,
              ),
              _buildLabelAndContent('Salary', widget.salary),
              SizedBox(
                height: 10,
              ),
              _buildLabelAndContent('Workplace Type', widget.workplaceType),
            ],
          ),
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

  Widget _buildLabelAndContent(String label, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.indigo[900]!,
            fontWeight: FontWeight.w600,
            fontSize: 17,
            letterSpacing: 0.2,
          ),
        ),
        SizedBox(height: 12),
        Text(
          content,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget label(String label) {
    return Text(label,
        style: TextStyle(
          color: Colors.indigo[900]!,
          fontWeight: FontWeight.w600,
          fontSize: 20,
          letterSpacing: 0.2,
        ));
  }
}
