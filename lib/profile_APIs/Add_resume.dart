import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class UploadCVWidget extends StatefulWidget {
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
                onTap: (){
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
                            padding: const EdgeInsets.only(right: 20.0, bottom: 1, top: 10),
                            child: GestureDetector(
                              onTap:  clearSelectedFile,
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
    );
  }
}
