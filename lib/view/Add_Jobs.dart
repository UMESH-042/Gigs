import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gigs/APIs/Add_Job_Description.dart';
import 'package:gigs/APIs/Job_Category_API.dart';
import 'package:gigs/APIs/Job_position_API.dart';
import 'package:gigs/APIs/Places_API.dart';
import 'package:gigs/APIs/Salary.dart';
import 'package:gigs/APIs/companies_API.dart';
import 'package:gigs/CompanyDetails/CompanyDetailsPage.dart';
import 'package:gigs/notifications/notification_service.dart';
import 'package:gigs/view/Homes_Screen.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'bottomSheet.dart';
import 'package:http/http.dart' as http;

// added comment
class AddJobs extends StatefulWidget {
  const AddJobs({super.key});

  @override
  State<AddJobs> createState() => _AddJobsState();
}

class _AddJobsState extends State<AddJobs> {
  String selectedJobLocation = '';
  String selectedWorkplace = '';
  String selectedCompany = '';
  String selectedEmploymentType = '';
  String selectedJobPosition = '';
  String JobDescription = '';
  String currentUserEmail = '';
  String selectedSalary = '';
  String selectedCategory = '';
 NotificationsService notificationsService = NotificationsService();
  @override
  void initState() {
    super.initState();
    getCurrentUserEmail().then((email) {
      setState(() {
        currentUserEmail =
            email ?? ''; // Set to an empty string if email is null
      });
    });
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _showInitialDialog();
    });
      FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((event) {
      // print('FCM Message Received');
      LocalNotificationService.display(event);
    });
      notificationsService.initialiseNotifications();
  }

  void _showInitialDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Welcome to the Add Jobs Page'),
          content: Text('Please add the company details.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CompanyDetailsPage()),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<String?> getCurrentUserEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    return user?.email;
  }

  void onSalaryAdded(String salary) {
    setState(() {
      selectedSalary = salary;
    });
  }

  void onJobPositionAdded(String position) {
    setState(() {
      selectedJobPosition = position;
    });
  }

  void onJobCategoryAdded(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  void onJobLocationAdded(String location) {
    setState(() {
      selectedJobLocation = location;
    });
  }

  void onCompanyAdded(String company) {
    setState(() {
      selectedCompany = company;
    });
  }

  void onJobDescriptionAdded(String description) {
    setState(() {
      JobDescription = description;
    });
  }

  Future<void> addJobToFirestore(
      String jobPosition,
      String jobLocation,
      String workplaceType,
      String company,
      String employmentType,
      String jobDescription,
      String salary,
      String category) async {
    try {
      final CollectionReference jobsCollection =
          FirebaseFirestore.instance.collection('jobs');
      final currentUserEmail = await getCurrentUserEmail();
      await jobsCollection.add({
        'jobPosition': jobPosition,
        'jobLocation': jobLocation,
        'workplaceType': workplaceType,
        'company': company,
        'employmentType': employmentType,
        'jobDescription': jobDescription,
        'salary': salary,
        'category': category,
        'postedBy': currentUserEmail,
        'timestamp': FieldValue.serverTimestamp(), // Add a timestamp
      });

      print('Job added to Firestore');

      String? imageUrl;
      String? userName;
      try {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();

        imageUrl = userSnapshot.get('imageUrl');
        userName = userSnapshot.get('name');
      } catch (e) {
        print("Error fetching imageUrl: $e");
      }
      sendNotificationToAllUsers(userName!, 'New Job has been Added in $selectedCategory');
     
       await Future.delayed(
            Duration(milliseconds: 500)); // Adjust the delay time as needed

        Navigator.pop(context); // Navigate after the delay
    } catch (e) {
      print('Error adding job to Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // getCurrentUserEmail().then((email) {
    //   setState(() {
    //     currentUserEmail =
    //         email ?? ''; // Set to an empty string if email is null
    //   });
    // });
    print(selectedJobLocation);
    print(selectedWorkplace);
    print(selectedCompany);
    print(selectedEmploymentType);
    print(selectedJobPosition);
    print(JobDescription);
    print(currentUserEmail);
    print(selectedCategory);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 241, 241, 241),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () async {
              addJobToFirestore(
                  selectedJobPosition,
                  selectedJobLocation,
                  selectedWorkplace,
                  selectedCompany,
                  selectedEmploymentType,
                  JobDescription,
                  selectedSalary,
                  selectedCategory);
            },
            child: Text(
              "Post",
              style: TextStyle(color: Color(0xFFFCA34D), fontSize: 17),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  "Add a Job",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 40),
              JobPosition(
                label: "Job Position",
                content: selectedJobPosition, // Display selected location
                onPressed: () async {
                  final selectedJobPosition = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JobPositionSearchScreen(),
                    ),
                  );
                  if (selectedJobPosition != null) {
                    onJobPositionAdded(selectedJobPosition);
                  }
                },
              ),
              SizedBox(height: 8),
              TypeOfWorkPlace(
                label: "Type of workplace",
                selectedWorkplace: selectedWorkplace,
                onPressed: () async {
                  final selectedOption = await showModalBottomSheet<String>(
                    context: context,
                    builder: (context) => BottomSheetForWorkplace(
                      onOptionSelected: (option) {
                        setState(() {
                          selectedWorkplace = option;
                        });
                      },
                    ),
                  );
                  if (selectedOption != null) {
                    setState(() {
                      selectedWorkplace = selectedOption;
                    });
                  }
                },
              ),
              SizedBox(height: 8),
              JobLocation(
                label: "Job Location",
                content: selectedJobLocation, // Display selected location
                onPressed: () async {
                  final selectedLocation = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlaceSearchScreen(),
                    ),
                  );
                  if (selectedLocation != null) {
                    onJobLocationAdded(selectedLocation);
                  }
                },
              ),
              SizedBox(height: 8),
              CompanyName(
                label: "Company",
                content: selectedCompany,
                onPressed: () async {
                  final selectedCompany = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CompanySearchScreen(),
                    ),
                  );
                  if (selectedCompany != null) {
                    onCompanyAdded(selectedCompany);
                  }
                },
              ),
              SizedBox(height: 8),
              EmploymentType(
                label: "Employment Type",
                selectedEmploymentType: selectedEmploymentType,
                onPressed: () async {
                  final selectedOption = await showModalBottomSheet<String>(
                    context: context,
                    builder: (context) => BottomSheetForEmploymentType(
                      onOptionSelected: (option) {
                        setState(() {
                          selectedEmploymentType = option;
                        });
                      },
                    ),
                  );
                  if (selectedOption != null) {
                    setState(() {
                      selectedEmploymentType = selectedOption;
                    });
                  }
                },
              ),
              SizedBox(height: 8),
              Description(
                label: "Description",
                content: JobDescription, // Display selected location
                onPressed: () async {
                  final AddedJobDescription = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddDescriptionScreen(),
                    ),
                  );
                  if (AddedJobDescription != null) {
                    onJobDescriptionAdded(AddedJobDescription);
                  }
                },
              ),
              SizedBox(
                height: 8,
              ),
              Salary(
                label: "Salary",
                content: selectedSalary,
                onPressed: () async {
                  final addedSalary = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SalaryEntryScreen(),
                    ),
                  );
                  if (addedSalary != null) {
                    onSalaryAdded(addedSalary);
                  }
                },
              ),
              SizedBox(
                height: 8,
              ),
              JobCategory(
                label: "Category",
                content: selectedCategory,
                onPressed: () async {
                  final addedCategory = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JobCategoryScreen(),
                    ),
                  );
                  if (addedCategory != null) {
                    onJobCategoryAdded(addedCategory);
                  }
                },
              )
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }

  Future<void> sendNotificationToAllUsers(
      String userName, String message) async {
    try {
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

      QuerySnapshot usersSnapshot =
          await FirebaseFirestore.instance.collection('users').get();

      for (QueryDocumentSnapshot user in usersSnapshot.docs) {
        String token = user.get('token');

        final data = {
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done',
          'userName': userName,
          'message': message,
        };

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

        if (response.statusCode == 200) {
          String notificationId = Uuid().v4();
          await FirebaseFirestore.instance
              .collection('notifications')
              .doc(notificationId)
              .set({
            'notificationId': notificationId,
            'userName': userName,
            'message': message,
            'SendTo': user['email'],
            'imageUrl': imageUrl,
            'timestamp': FieldValue.serverTimestamp(),
          });
          print("Notification sent to ${user['email']} successfully");
        } else {
          print("Error sending notification to ${user['email']}");
        }
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}

class CompanyName extends StatelessWidget {
  final String label;
  final String? content;
  final VoidCallback? onPressed;

  const CompanyName({required this.label, this.content, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8), // Add some spacing
                  if (content != null)
                    Text(
                      content!,
                      style: TextStyle(fontSize: 16),
                    ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                content == '' ? Icons.add_circle_outline_outlined : Icons.edit,
                color: Color(0xFFFCA34D),
              ),
              onPressed: onPressed,
            ),
          ],
        ),
      ),
    );
  }
}

class JobPosition extends StatelessWidget {
  final String label;
  final String? content;
  final VoidCallback? onPressed;

  const JobPosition({required this.label, this.content, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8), // Add some spacing
                  if (content != null)
                    Text(
                      content!,
                      style: TextStyle(fontSize: 16),
                    ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                content == '' ? Icons.add_circle_outline_outlined : Icons.edit,
                color: Color(0xFFFCA34D),
              ),
              onPressed: onPressed,
            ),
          ],
        ),
      ),
    );
  }
}

class JobLocation extends StatelessWidget {
  final String label;
  final String? content;
  final VoidCallback? onPressed;

  const JobLocation({required this.label, this.content, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8), // Add some spacing
                  if (content != null)
                    Text(
                      content!,
                      style: TextStyle(fontSize: 16),
                    ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                content == '' ? Icons.add_circle_outline_outlined : Icons.edit,
                color: Color(0xFFFCA34D),
              ),
              onPressed: onPressed,
            ),
          ],
        ),
      ),
    );
  }
}

class Description extends StatelessWidget {
  final String label;
  final String? content;
  final VoidCallback? onPressed;

  const Description({required this.label, this.content, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8), // Add some spacing
                  if (content != null)
                    Text(
                      content!,
                      style: TextStyle(fontSize: 16),
                    ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                content == '' ? Icons.add_circle_outline_outlined : Icons.edit,
                color: Color(0xFFFCA34D),
              ),
              onPressed: onPressed,
            ),
          ],
        ),
      ),
    );
  }
}

class TypeOfWorkPlace extends StatelessWidget {
  final String label;
  final String selectedWorkplace;
  final VoidCallback onPressed;

  const TypeOfWorkPlace({
    required this.label,
    required this.selectedWorkplace,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(
                    selectedWorkplace == ''
                        ? Icons.add_circle_outline_outlined
                        : Icons.edit,
                    color: Color(0xFFFCA34D),
                  ),
                  onPressed: onPressed,
                ),
              ],
            ),
            Text(
              selectedWorkplace, // Display selected workplace as subtitle
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

class EmploymentType extends StatelessWidget {
  final String label;
  final String selectedEmploymentType;
  final VoidCallback onPressed;

  const EmploymentType({
    required this.label,
    required this.selectedEmploymentType,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(
                    selectedEmploymentType == ''
                        ? Icons.add_circle_outline_outlined
                        : Icons.edit,
                    color: Color(0xFFFCA34D),
                  ),
                  onPressed: onPressed,
                ),
              ],
            ),
            Text(
              selectedEmploymentType, // Display selected workplace as subtitle
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

class Salary extends StatelessWidget {
  final String label;
  final String? content;
  final VoidCallback? onPressed;

  const Salary({required this.label, this.content, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  if (content != null)
                    Text(
                      '\$$content',
                      style: TextStyle(fontSize: 16),
                    ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                content == '' ? Icons.add_circle_outline_outlined : Icons.edit,
                color: Color(0xFFFCA34D),
              ),
              onPressed: onPressed,
            ),
          ],
        ),
      ),
    );
  }
}

class JobCategory extends StatelessWidget {
  final String label;
  final String? content;
  final VoidCallback? onPressed;

  const JobCategory({required this.label, this.content, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8), // Add some spacing
                  if (content != null)
                    Text(
                      content!,
                      style: TextStyle(fontSize: 16),
                    ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                content == '' ? Icons.add_circle_outline_outlined : Icons.edit,
                color: Color(0xFFFCA34D),
              ),
              onPressed: onPressed,
            ),
          ],
        ),
      ),
    );
  }
}
