import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gigs/firebase/firebaseService.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:velocity_x/velocity_x.dart';

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
  final TextEditingController _informationController = TextEditingController();

  File? selectedFile;
  String? selectedFileName;
  String? fileSizeError;

// Function to handle the file selection
  Future<void> _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      PlatformFile file = result.files.first; // Get the selected file
      setState(() {
        selectedFile = File(file.path!);
        selectedFileName = file.name;
        fileSizeError = null;
      });
    }
  }

  void clearSelectedFile() {
    setState(() {
      selectedFile = null;
      selectedFileName = null;
    });
  }

// Function to save the file to Firebase Storage and its URL to Firestore
  Future<void> saveFileToFirestore(String userEmail) async {
    if (selectedFile == null) {
      // Handle this case as needed (e.g., show an error message)
      return;
    }
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    // Create a reference to Firebase Storage
    final storage = FirebaseStorage.instance;

    // Generate a unique filename for the uploaded file
    String fileName = DateTime.now().millisecondsSinceEpoch.toString() +
        '_' +
        selectedFileName!;

    // Upload the file to Firebase Storage
    UploadTask task = storage.ref('user_cvs/$fileName').putFile(selectedFile!);

    // Wait for the upload to complete
    await task;

    // Get the URL of the uploaded file
    String downloadURL =
        await storage.ref('user_cvs/$fileName').getDownloadURL();

    // Store the download URL in a collection named 'user_cvs'
    // and associate it with the user's email
    try {
      final resumeData = {
        'URL': downloadURL,
        'FileName': selectedFileName,
        'FileSize': '${selectedFile!.lengthSync() ~/ 1024}kb',
      };

      await FirestoreService().addResumeData(userEmail, resumeData);
      // Navigator.pop(context);
    } catch (e) {
      print('Error adding Resume Data: $e');
      // Handle the error as needed
    }

    // Clear the selected file
    clearSelectedFile();
    Navigator.pop(context);
  }

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
    final isFileSelected = selectedFile != null;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 241, 241, 241),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                'https://poweredwith.nyc3.cdn.digitaloceanspaces.com/images/domains/${widget.companyName.toLowerCase()}.com.jpg',
              ),
              radius: 50,
            ),
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                widget.jobPosition,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                  // Text(
                  //   showJobDetails ? 'Job Details' : 'Company Details',
                  //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  // ),
                  SizedBox(height: 8),
                  if (showJobDetails) ...[
                    _buildLabelAndContent(
                        'Job Description', widget.jobDescription),
                    _buildLabelAndContent('Job Position', widget.jobPosition),
                    _buildLabelAndContent('Job Location', widget.jobLocation),
                    _buildLabelAndContent('Company', widget.companyName),
                    _buildLabelAndContent('Job Type', widget.employmentType),
                    _buildLabelAndContent('Job Category', widget.category),
                    _buildLabelAndContent('Salary', "\$${widget.salary}"),
                    _buildLabelAndContent(
                        'Workplace Type', widget.workplaceType),
                    _buildLabelAndContent('Job Posted By', widget.postedBy),
                    SizedBox(height: 16),
                    // Text(
                    //   'Application Form',
                    //   style:
                    //       TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    // ),
                    _buildLabelAndContent(
                        "Upload CV", "Add your CV/Resume to apply for a job"),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GestureDetector(
                        onTap: () {
                          _selectFile();
                        },
                        child: CustomPaint(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: isFileSelected ? 95.0 : 95.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: isFileSelected
                                  ? Color.fromARGB(255, 227, 217, 229)
                                  : Colors.white,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      isFileSelected
                                          ? Icons.insert_drive_file
                                          : Icons.cloud_upload,
                                      size: 40,
                                      color: isFileSelected
                                          ? Color.fromARGB(255, 209, 75, 37)
                                          : null,
                                    ),
                                    SizedBox(width: 8),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          selectedFile != null
                                              ? selectedFileName ??
                                                  'Upload CV/Resume'
                                              : 'Upload CV/Resume',
                                          style: TextStyle(fontSize: 16.0),
                                        ),
                                        if (selectedFile != null)
                                          Text(
                                            '${selectedFile!.lengthSync() ~/ 1024} KB',
                                            style: TextStyle(fontSize: 12.0),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                                if (isFileSelected)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 20.0, bottom: 1, top: 10),
                                    child: GestureDetector(
                                      onTap: clearSelectedFile,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.delete,
                                            color: Color.fromARGB(
                                                255, 209, 75, 37),
                                            size: 25,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Upload files in PDF format up to 5MB',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    if (fileSizeError != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          fileSizeError!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    SizedBox(
                      height: 20,
                    ),
                    label("Information"),
                   const SizedBox(height: 12,),
                    Information(),
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
                  // Add your application form widgets here
                ],
              ),
            ),
          ],
        ),
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

  Widget _buildLabelAndContent(String label, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.indigo[900]!,
            fontWeight: FontWeight.w600,
            fontSize: 18,
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
          fontSize: 17.5,
          letterSpacing: 0.2,
        ));
  }

  Widget Information() {
    return Container(
      height: 170,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _informationController,
        maxLines: null,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 17,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Explain why you are the right person for\n this job...",
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 17),
          contentPadding: EdgeInsets.only(left: 20, right: 20),
        ),
      ),
    ).py12();
  }
}
