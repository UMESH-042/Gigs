import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gigs/view/AdvancedFilter/Filter1.dart';
import 'package:timeago/timeago.dart' as timeago;

class FilterPage extends StatefulWidget {
  final Map<String, dynamic>? combinedValues;

  const FilterPage({Key? key, this.combinedValues}) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  late List<String> jobPositions = [];
  late List<String> employmentTypes = [];
  late List<String> categories = [];
  String selectedJobPosition = '';
  String selectedEmploymentType = '';
  String selectedCategory = '';
  String jobLocation = '';
  String searchQuery = '';

  @override
  void initState() {
    super.initState();

    if (widget.combinedValues != null) {
      _applyFilters(widget.combinedValues);
    } else {
      fetchFilterOptions();
    }
  }

  void _applyFilters(Map<String, dynamic>? selectedValues) {
    if (selectedValues != null) {
      print('Received result: $selectedValues');

      selectedJobPosition =
          selectedValues['selectedValues']['subCategory'] ?? '';
      selectedEmploymentType =
          selectedValues['selectedValues']['jobTypes'][0] ?? '';
      selectedCategory = selectedValues['selectedValues']['category'] ?? '';
      jobLocation = selectedValues['selectedValues']['location'] ?? '';

      print('selectedJobPosition: $selectedJobPosition');
      print('selectedEmploymentType: $selectedEmploymentType');
      print('selectedCategory: $selectedCategory');
      print('jobLocation: $jobLocation');
      // Fetch jobs based on the updated filtering criteria
      setState(() {});
    }
  }

  Future<void> fetchFilterOptions() async {
    jobPositions = await getDistinctValues('jobPosition');
    employmentTypes = await getDistinctValues('employmentType');
    categories = await getDistinctValues('category');

    setState(() {});
  }

  Future<List<String>> getDistinctValues(String fieldName) async {
    // Fetch distinct values for the specified field from the 'jobs' collection
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('jobs').get();
    List<String> distinctValues = [];

    querySnapshot.docs.forEach((doc) {
      var value = doc['$fieldName'];
      if (value != null && !distinctValues.contains(value)) {
        distinctValues.add(value);
      }
    });

    return distinctValues;
  }

  String getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      // Handle the case when the user is not signed in
      return ''; // or throw an exception, return null, etc.
    }
  }

  void saveJob(Map<String, dynamic> jobDetails) async {
    // Add the current user's ID to the job details
    String currentUserId = getCurrentUserId();
    jobDetails['userId'] = currentUserId;

    // Generate a unique job ID for the saved job
    String jobId = getUniqueJobId(jobDetails); // Implement this function

    // Check if the job is already saved
    if (await isJobSaved(currentUserId, jobId)) {
      // Job is already saved, show a message to the user
      showSnackbar('Job has already been saved!');
    } else {
      // Save the job details in the "savedJobs" collection
      await FirebaseFirestore.instance
          .collection('savedJobs')
          .doc(jobId)
          .set(jobDetails);

      // Notify the user that the job has been saved
      showSnackbar('Job saved successfully!');
    }
  }

  Future<bool> isJobSaved(String userId, String jobId) async {
    // Check if the job with the specified ID is already saved by the user
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('savedJobs')
        .doc(jobId)
        .get();

    return snapshot.exists && snapshot['userId'] == userId;
  }

  void showSnackbar(String message) {
    // Display a Snackbar with the specified message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  String getUniqueJobId(Map<String, dynamic> jobDetails) {
    // Create a unique job ID based on relevant fields
    String jobPosition = jobDetails['jobPosition'];
    String companyName = jobDetails['company'];
    String uniqueKey = '$jobPosition-$companyName';

    String jobId = uniqueKey.hashCode.toUnsigned(30).toString();

    return jobId;
  }

  @override
  Widget build(BuildContext context) {
    print(categories);
    print(employmentTypes);
    print(jobPositions);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 240, 240),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(220),
        child: Stack(
          children: [
            AppBar(
              backgroundColor: Color.fromARGB(255, 31, 11, 118),
              automaticallyImplyLeading: false,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Positioned(
              top: 100,
              left: 25,
              right: 25,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value.toLowerCase();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Job Position',
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.search,
                          color: Color.fromARGB(255, 31, 11, 118),
                        ),
                        contentPadding: EdgeInsets.all(10.0),
                      ),
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 40,
              left: 25,
              right: 25,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Location',
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.location_pin,
                          color: Color(0xFFFCA34D),
                        ),
                        contentPadding: EdgeInsets.all(10.0),
                      ),
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  SizedBox(width: 13),
                  Container(
                    width: 49,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 31, 11, 118),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.filter_list,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        Map<String, dynamic>? result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Ad1Filterpage(),
                          ),
                        );

                        // Handle the result, which includes selected values and the selected category
                        if (result != null) {
                          print('Received result: $result');
                          // Extract the selected values and category from the result
                          Map<String, dynamic>? selectedValues =
                              result['selectedValues'];
                          String? selectedCategory = result['selectedCategory'];
                          String? Positions = selectedValues!['subCategory'];
                          List<String?> empType = selectedValues!['jobTypes'];
                          String? Location = selectedValues!['location'];

                          // Process the selected values and category as needed
                          print('Selected Values: $selectedValues');
                          print('Selected Category: $selectedCategory');
                          print('jobPosition: $Positions');
                          print('employmentType: $empType');
                          print('jobLocation: $Location');
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 12),
                  ChoiceChip(
                    label: Container(
                      padding:
                          EdgeInsets.all(6.0), // Adjust the padding as needed
                      child: Text(
                        'All',
                        style: TextStyle(
                            fontSize: 16.0), // Adjust the font size as needed
                      ),
                    ),
                    selected: selectedJobPosition.isEmpty,
                    onSelected: (_) {
                      setState(() {
                        selectedJobPosition = '';
                        selectedEmploymentType = '';
                        selectedCategory = '';
                      });
                    },
                    selectedColor: Color(0xFFFCA34D),
                    labelStyle: TextStyle(
                      color: selectedJobPosition.isEmpty
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  buildRowChips(
                      'Job Positions', jobPositions, selectedJobPosition,
                      (value) {
                    setState(() {
                      selectedJobPosition = value;
                    });
                  }),
                  buildRowChips('Employment Types', employmentTypes,
                      selectedEmploymentType, (value) {
                    setState(() {
                      selectedEmploymentType = value;
                    });
                  }),
                  buildRowChips('Categories', categories, selectedCategory,
                      (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  }),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('jobs').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No jobs available.'));
                  }

                  var jobs = snapshot.data!.docs.where((job) {
                    var jobData = job.data() as Map<String, dynamic>;

                    return (selectedCategory.isEmpty ||
                            jobData['category'] == selectedCategory) &&
                        (selectedJobPosition.isEmpty ||
                            jobData['jobPosition'] == selectedJobPosition) &&
                        (selectedEmploymentType.isEmpty ||
                            jobData['employmentType'] ==
                                selectedEmploymentType) &&
                        // Check for row chips filters
                        (selectedJobPosition.isEmpty ||
                            jobData['jobPosition'] == selectedJobPosition) &&
                        (selectedEmploymentType.isEmpty ||
                            jobData['employmentType'] ==
                                selectedEmploymentType) &&
                        (selectedCategory.isEmpty ||
                            jobData['category'] == selectedCategory)&& (searchQuery.isEmpty ||
                                jobData['jobPosition'].toLowerCase().contains(searchQuery));
                  }).toList();

                  if (jobs.isEmpty) {
                    return Center(child: Text('No Jobs Found.'));
                  }

                  return ListView.builder(
                    itemCount: jobs.length,
                    itemBuilder: (context, index) {
                      var job = jobs[index].data() as Map<String, dynamic>;

                      return _buildJobDisplayCard(
                          job['jobPosition'],
                          job['company'],
                          job['jobLocation'],
                          job['employmentType'],
                          job['jobDescription'],
                          job['category'],
                          job['timestamp'],
                          job['salary'], () {
                        saveJob(job);
                      });
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRowChips(String label, List<String> values, String selectedValue,
      Function(String) onSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8.0,
            children: values.map((value) {
              return ChoiceChip(
                label: Container(
                  padding: EdgeInsets.all(6.0), // Adjust the padding as needed
                  child: Text(
                    value,
                    style: TextStyle(
                        fontSize: 16.0), // Adjust the font size as needed
                  ),
                ),
                selected: selectedValue == value,
                onSelected: (bool selected) {
                  onSelected(selected ? value : '');
                },
                selectedColor: Color(0xFFFCA34D),
                labelStyle: TextStyle(
                  color: selectedValue == value ? Colors.white : Colors.black,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildJobDisplayCard(
    String jobPosition,
    String companyName,
    String jobLocation,
    String employmentType,
    String jobDescription,
    String category,
    Timestamp timestamp,
    String salary,
    Function() onSavePressed,
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
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: onSavePressed,
              child: Icon(
                Icons.bookmark_border_outlined,
                size: 30,
              ),
            ),
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
