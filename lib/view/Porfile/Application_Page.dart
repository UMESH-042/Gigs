import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gigs/firebase/firebaseService.dart';
import 'package:gigs/notifications/notification_service.dart';
import 'package:gigs/view/Porfile/Profile_page.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

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
  bool applicationSubmitted = false;

  File? selectedFile;
  String? selectedFileName;
  String? fileSizeError;
  NotificationsService notificationsService = NotificationsService();

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
  Future<void> saveFileToFirestore(
    String userEmail,
    Map<String, dynamic> applicationData,
  ) async {
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
    UploadTask task =
        storage.ref('applicants_cvs/$fileName').putFile(selectedFile!);

    // Wait for the upload to complete
    await task;

    // Get the URL of the uploaded file
    String downloadURL =
        await storage.ref('applicants_cvs/$fileName').getDownloadURL();

    // Store the download URL in a collection named 'user_cvs'
    // and associate it with the user's email
    try {
      final resumeData = {
        'URL': downloadURL,
        'FileName': selectedFileName,
        'FileSize': '${selectedFile!.lengthSync() ~/ 1024}kb',
      };

      // Combine applicationData and resumeData
      Map<String, dynamic> combinedData = {
        ...applicationData,
        'resumeData': resumeData,
      };

      await FirestoreService().addApplicationData(combinedData);
    } catch (e) {
      print('Error adding Resume Data: $e');
      // Handle the error as needed
    }

    // Clear the selected file
    clearSelectedFile();
    // Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    // Initialize timeago
    timeago.setLocaleMessages('en', timeago.EnMessages());
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((event) {
      // print('FCM Message Received');
      LocalNotificationService.display(event);
    });
    notificationsService.initialiseNotifications();
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
    return timeago.format(DateTime.now().subtract(timeAgo), locale: 'en_short');
  }

  String getFirstWordBeforeComma(String input) {
    // Extract and return the first word before the comma in the input string
    var parts = input.split(',');
    return parts.isNotEmpty ? parts.first : input;
  }

  Future<bool> checkIfUserAlreadyApplied(String userEmail, String jobId) async {
    try {
      // Check if the user has already applied for the given job
      QuerySnapshot<Map<String, dynamic>> applicationsSnapshot =
          await FirebaseFirestore.instance
              .collection('applicants')
              .where('applicantEmail', isEqualTo: userEmail)
              .where('jobId', isEqualTo: jobId)
              .limit(1)
              .get();

      return applicationsSnapshot.docs.isNotEmpty;
    } catch (e) {
      // Handle any errors that might occur during the check
      print("Error checking if user already applied: $e");
      return false; // Return false in case of an error
    }
  }

  String generateUniqueJobId(String jobPosition, String companyName,
      String jobLocation, Timestamp timestamp) {
    // Take the first character of each detail
    String jobPositionFirstChar = jobPosition.isNotEmpty ? jobPosition[0] : '';
    String companyNameFirstChar = companyName.isNotEmpty ? companyName[0] : '';
    String jobLocationFirstChar = jobLocation.isNotEmpty ? jobLocation[0] : '';

    // Concatenate the first characters and timestamp
    String jobId =
        '$jobPositionFirstChar$companyNameFirstChar$jobLocationFirstChar${timestamp.seconds}';

    return jobId;
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
                        // Expanded(
                        //   child: Text(
                        //     '${getTimeAgo(widget.timestamp)}',
                        //     style: TextStyle(fontSize: 16),
                        //     overflow: TextOverflow.ellipsis,
                        //   ),
                        // ),
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
                          SizedBox(width: MediaQuery.of(context).size.width * 0.03),
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
                    const SizedBox(
                      height: 12,
                    ),
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
                          List<String> imageUrls =
                              List.from(companyData?['imageUrls'] ?? []);
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabelAndContent("About Company",
                                  companyData?['aboutCompany']),
                              SizedBox(
                                height: 10,
                              ),
                                _buildLabelAndContent(
                                    "Website", companyData?['websiteLink']),
                              SizedBox(
                                height: 10,
                              ),
                              _buildLabelAndContent(
                                  "Industry", companyData?['industry']),
                              SizedBox(
                                height: 10,
                              ),
                              _buildLabelAndContent("Employee Size",
                                  companyData?['employeeSize']),
                              SizedBox(
                                height: 10,
                              ),
                              _buildLabelAndContent(
                                  "Head Office", companyData?['headOffice']),
                              SizedBox(
                                height: 10,
                              ),
                              _buildLabelAndContent(
                                  "Type", companyData?['companyType']),
                              SizedBox(
                                height: 10,
                              ),
                              _buildLabelAndContent(
                                  "Since", companyData?['since']),
                              SizedBox(
                                height: 10,
                              ),
                              _buildLabelAndContent("Specialization",
                                  companyData?['specialization']),
                              SizedBox(
                                height: 10,
                              ),
                              label("Company gallery"),
                              SizedBox(
                                height: 20,
                              ),
                              _buildImageGallery(imageUrls),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      String jobId = generateUniqueJobId(
                        widget.jobPosition,
                        widget.companyName,
                        widget.jobLocation,
                        widget.timestamp,
                      );
                      String userEmail = await getUserEmail();
                      bool hasAlreadyApplied =
                          await checkIfUserAlreadyApplied(userEmail, jobId);
                      if (hasAlreadyApplied) {
                        // Show a dialog indicating that the user has already applied
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Already Applied'),
                              content: Text(
                                  'You have already applied for this job.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        // Show the "Please wait" dialog
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Please Wait'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 16),
                                  Text(
                                    'Application is being submitted...',
                                    style: TextStyle(fontSize: 18),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          },
                        );

                        try {
                          // Get the current user's email or user id (replace 'getUserEmail()' with your actual method)
                          String userEmail = await getUserEmail();

                          // Prepare the application details
                          Map<String, dynamic> applicationData = {
                            'jobPosition': widget.jobPosition,
                            'companyName': widget.companyName,
                            'jobDescription': widget.jobDescription,
                            'employmentType': widget.employmentType,
                            'category': widget.category,
                            'postedBy': widget.postedBy,
                            'salary': widget.salary,
                            'workplaceType': widget.workplaceType,
                            'timestamp': Timestamp.now(),
                            'jobLocation': widget.jobLocation,
                            'applicantEmail': userEmail,
                            'information': _informationController.text,
                            'jobId': jobId,
                          };

                          // Save the file to Firebase Storage and get the download URL
                          await saveFileToFirestore(userEmail, applicationData);

                          String? userName;
                          String? userToken =
                              await getUserTokenByEmail(widget.postedBy);
                          print('user token is :- $userToken');
                          try {
                            DocumentSnapshot userSnapshot =
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .get();

                            userName = userSnapshot.get('name');
                          } catch (e) {
                            print("Error fetching imageUrl: $e");
                          }

                          sendNotification(
                              userName!,
                              "Applied for ${widget.jobPosition}",
                              userToken!,
                              widget.postedBy);
                          // Close the "Please wait" dialog
                          Navigator.pop(context);

                          // Show the success dialog
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Successful',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'Congratulations, your application has been sent',
                                        style: TextStyle(fontSize: 18),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 24),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(
                                              context); // Close the success dialog
                                          Navigator.pop(
                                              context); // Close the application page
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Color(0xFF130160),
                                          onPrimary: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          minimumSize: Size(200, 49),
                                        ),
                                        child: Text(
                                          'Back to Home',
                                          style: TextStyle(fontSize: 17.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        } catch (e) {
                          // Handle errors, e.g., show an error dialog
                          print('Error submitting application: $e');
                          Navigator.pop(
                              context); // Close the "Please wait" dialog
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Error'),
                                content: Text(
                                    'Failed to submit the application. Please try again.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF130160),
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      minimumSize: Size(275, 49),
                    ),
                    child: Text(
                      'APPLY NOW',
                      style: TextStyle(fontSize: 17.5),
                    ),
                  ).centered(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  sendNotification(String userName, String message, String token,
      String postedByEmail) async {
    final data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'userName': userName,
      'message': message,
    };

    try {
      http.Response response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAGNLlsWY:APA91bHic5VqqER8euXs_uxxqwar5VHmAxw_2rVMaTH6QYaD2MG3TTGh6W_xxMfqyHzbvPHrvkDqyFUvk6J8sNy0W7CaowxSGP23x-VZmAVFNAV59xZoF74SLpK4L6E8mM6bVETHKSTm'
        },
        body: jsonEncode(<String, dynamic>{
          'notification': <String, dynamic>{
            'title': '$userName',
            'body': '$message',
          },
          'priority': 'high',
          'data': data,
          'to': '$token',
        }),
      );
      String? imageUrl;
      try {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();

        imageUrl = userSnapshot.get('imageUrl');
      } catch (e) {
        print("Error fetching imageUrl: $e");
      }

      if (response.statusCode == 200) {
        String notificationId = Uuid().v4();
        await FirebaseFirestore.instance
            .collection('notifications')
            .doc(notificationId)
            .set({
          'notificationId': notificationId,
          'userName': userName,
          'message': message,
          'SendTo': postedByEmail,
          'imageUrl': imageUrl,
          'timestamp': FieldValue.serverTimestamp(),
        });
        print("Notification sent successfully");
      } else {
        print("Error sending notification");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<String?> getUserTokenByEmail(String email) async {
    try {
      // Query the users collection to get the user with the specified email
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document (user) and retrieve the user's token
        String? userToken = querySnapshot.docs[0].get('token');
        return userToken;
      }
    } catch (e) {
      print('Error getting user token: $e');
    }

    return null; // Return null if the user with the specified email is not found or an error occurs
  }

  Future<String> getUserEmail() async {
    try {
      // Assume you are using Firebase Authentication
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // If the user is logged in, return the email
        return user.email ?? '';
      } else {
        // Handle the case when the user is not logged in
        throw Exception('User not logged in');
      }
    } catch (e) {
      print('Error getting user email: $e');
      throw e; // Propagate the error to the calling code
    }
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

  Widget _buildImageGallery(List<String> imageUrls) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: imageUrls.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            // Implement logic to view the tapped image in a larger size
            // You can use a dialog or navigate to a new screen to show the full image
            _viewImage(imageUrls[index]);
          },
          child: Image.network(
            imageUrls[index],
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }

  // Function to view the image in a larger size
  void _viewImage(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }
}
