import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SavedJobsPage extends StatefulWidget {
  @override
  _SavedJobsPageState createState() => _SavedJobsPageState();
}

class _SavedJobsPageState extends State<SavedJobsPage> {
  List<Map<String, dynamic>> savedJobs = [];
  bool isLoading = true;
  bool isDeletingJobs = false;

  @override
  void initState() {
    super.initState();
    fetchSavedJobs();
  }

  Future<void> fetchSavedJobs() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String currentUserId = user.uid;

        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('savedJobs')
            .where('userId', isEqualTo: currentUserId)
            .get();

        savedJobs =
            querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching saved jobs: $e');
      // Handle the error, show a message, or take appropriate action
    }
  }

  Future<void> deleteAllSavedJobs() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String currentUserId = user.uid;

        setState(() {
          isDeletingJobs = true;
        });

        await FirebaseFirestore.instance
            .collection('savedJobs')
            .where('userId', isEqualTo: currentUserId)
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.delete();
          });
        });

        // Show shimmer for a few seconds
        await Future.delayed(Duration(seconds: 2)); // Adjust the duration as needed

        setState(() {
          savedJobs.clear();
          isDeletingJobs = false;
        });

        // Fetch saved jobs again to check if there are any
        fetchSavedJobs();
      }
    } catch (e) {
      print('Error deleting saved jobs: $e');
      // Handle the error, show a message, or take appropriate action
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 241, 241, 241),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.orange),
        title: Center(
          child: Text(
            'Saved Jobs',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              deleteAllSavedJobs();
            },
            icon: Icon(Icons.delete),
          )
        ],
      ),
      body: isLoading
          ? ShimmerList()
          : isDeletingJobs
              ? ShimmerList()
              : savedJobs.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ListView.builder(
                        itemCount: savedJobs.length,
                        itemBuilder: (context, index) {
                          var job = savedJobs[index];

                          return _buildJobDisplayCard(
                            job['jobPosition'],
                            job['company'],
                            job['jobLocation'],
                            job['employmentType'],
                            job['jobDescription'],
                            job['category'],
                            job['timestamp'],
                            job['salary'],
                          );
                        },
                      ),
                    )
                  : Center(
                      child: savedJobs.isEmpty
                          ? Text(
                              'No Saved Jobs Found',
                              style: TextStyle(fontSize: 18),
                            )
                          : Container(),
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
                        'https://poweredwith.nyc3.cdn.digitaloceanspaces.com/images/domains/$domain.com.jpg'),
                    radius: 30,
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        toTitleCase(jobPosition),
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                    timeAgo,
                    style: TextStyle(color: const Color.fromARGB(255, 118, 117, 117), fontSize: 13),
                  ),
                  Text(
                    formattedSalary,
                    style: TextStyle(color: const Color.fromARGB(255, 16, 16, 16)),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String toTitleCase(String text) {
    return text.replaceAllMapped(
      RegExp(r'\b\w'),
      (match) => match.group(0)!.toUpperCase(),
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

class ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 120.0,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }
}
