import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gigs/APIs/Add_Job_Description.dart';
import 'package:gigs/APIs/Job_Category_API.dart';
import 'package:gigs/APIs/Job_position_API.dart';
import 'package:gigs/APIs/Places_API.dart';
import 'package:gigs/APIs/Salary.dart';
import 'package:gigs/APIs/companies_API.dart';
import 'package:gigs/view/Homes_Screen.dart';

import 'bottomSheet.dart';

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

  @override
  void initState() {
    super.initState();
    getCurrentUserEmail().then((email) {
      setState(() {
        currentUserEmail =
            email ?? ''; // Set to an empty string if email is null
      });
    });
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
          // TextButton(
          //   onPressed: () {
          //     // Handle the "Post" button action
          //   },
          //   child: Text(
          //     "Post",
          //     style: TextStyle(color: Color(0xFFFCA34D), fontSize: 17),
          //   ),
          // ),
          TextButton(
            onPressed: () {
              addJobToFirestore(
                  selectedJobPosition,
                  selectedJobLocation,
                  selectedWorkplace,
                  selectedCompany,
                  selectedEmploymentType,
                  JobDescription,
                  selectedSalary,selectedCategory);
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage(
                          currentUserEmail: currentUserEmail,
                          requiresProfileSetup: true)));
              // Handle any other necessary actions after posting the job
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
