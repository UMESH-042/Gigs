import 'package:flutter/material.dart';

class AddJobs extends StatefulWidget {
  const AddJobs({super.key});

  @override
  State<AddJobs> createState() => _AddJobsState();
}

class _AddJobsState extends State<AddJobs> {
  @override
  Widget build(BuildContext context) {
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
              SizedBox(height: 20),
              JobInfoCard(label: "Job Position"),
              JobInfoCard(label: "Type of Workplace"),
              JobInfoCard(label: "Job Location"),
              JobInfoCard(label: "Company"),
              JobInfoCard(label: "Employment Type"),
              JobInfoCard(label: "Description"),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
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
