import 'package:flutter/material.dart';
import 'package:gigs/APIs/Places_API.dart';

class AddJobs extends StatefulWidget {
  const AddJobs({super.key});

  @override
  State<AddJobs> createState() => _AddJobsState();
}

class _AddJobsState extends State<AddJobs> {
  String selectedJobLocation = '';

  void onJobLocationAdded(String location) {
    setState(() {
      selectedJobLocation = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(selectedJobLocation);
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
            onPressed: () {
              // Handle the "Post" button action
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
              JobInfoCard(label: "Job Position"),
              SizedBox(height: 8),
              JobInfoCard(label: "Type of Workplace"),
              SizedBox(height: 8),
              JobInfoCardforLocation(
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
              JobInfoCard(label: "Company"),
              SizedBox(height: 8),
              JobInfoCard(label: "Employment Type"),
              SizedBox(height: 8),
              JobInfoCard(label: "Description"),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}

class JobInfoCardforLocation extends StatelessWidget {
  final String label;
  final String? content;
  final VoidCallback? onPressed;

  const JobInfoCardforLocation(
      {required this.label, this.content, this.onPressed});

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
                color: content == null ? Color(0xFFFCA34D) : Color(0xFFFCA34D),
              ),
              onPressed: onPressed,
            ),
          ],
        ),
      ),
    );
  }
}

class JobInfoCard extends StatelessWidget {
  final String label;

  const JobInfoCard({required this.label});

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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: Icon(Icons.add_circle_outline_outlined,
                  color: Color(0xFFFCA34D)),
              onPressed: () {
                // Handle adding information for this card
              },
            ),
          ],
        ),
      ),
    );
  }
}
