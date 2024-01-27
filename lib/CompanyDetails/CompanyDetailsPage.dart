// CompanyDetailsPage.dart
import 'package:flutter/material.dart';

class CompanyDetailsPage extends StatefulWidget {
  @override
  _CompanyDetailsPageState createState() => _CompanyDetailsPageState();
}

class _CompanyDetailsPageState extends State<CompanyDetailsPage> {
  // Add your form fields and controllers for company details

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Company Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
         
            TextField(
              decoration: InputDecoration(labelText: 'About Company'),
              // Add a controller to retrieve the entered text
            ),
            // Add more fields...

            SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                // Validate and save the company details to Firebase
                // Example: SaveDataToFirebase();
                Navigator.pop(context); // Navigate back after saving
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
