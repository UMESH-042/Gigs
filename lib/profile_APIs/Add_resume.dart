// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:gigs/firebase/firebaseService.dart';

class UploadCVWidget extends StatefulWidget {
  final String email;
  const UploadCVWidget({
    Key? key,
    required this.email,
  }) : super(key: key);
  @override
  _UploadCVWidgetState createState() => _UploadCVWidgetState();
}

class _UploadCVWidgetState extends State<UploadCVWidget> {
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
                        'FileSize':'${selectedFile!.lengthSync() ~/ 1024}kb',
                      };
              
                      await FirestoreService()
                          .addResumeData( userEmail,resumeData);
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
  Widget build(BuildContext context) {
    final isFileSelected = selectedFile != null;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              '   Add Resume',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () {
                  _selectFile();
                },
                child: CustomPaint(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: isFileSelected ? 140.0 : 100.0,
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  selectedFile != null
                                      ? selectedFileName ?? 'Upload CV/Resume'
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
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.delete,
                                    color: Color.fromARGB(255, 209, 75, 37),
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
                'Upload files in PDF format up to 5MB. Just upload it once, and you can use it in your next application.',
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
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            saveFileToFirestore(widget.email);
          },
          style: ElevatedButton.styleFrom(
            primary: Color(0xFF130160),
            onPrimary: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            minimumSize: Size(160, 48),
          ),
          child: Text(
            'Save',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
