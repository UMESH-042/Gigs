// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

import '../firebase/firebaseService.dart';
import 'Add_about_me.dart';

class AddWorkExperiencePage extends StatefulWidget {
  final String email;
  const AddWorkExperiencePage({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  _AddWorkExperiencePageState createState() => _AddWorkExperiencePageState();
}

class _AddWorkExperiencePageState extends State<AddWorkExperiencePage> {
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TextEditingController _jobtitleController = TextEditingController();
  TextEditingController _companyController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  bool isCurrentPosition = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    print(widget.email);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 243, 243),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                'Add work experience',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 35),
              label('Job Title'),
              const SizedBox(
                height: 12,
              ),
              JobTitle(),
              SizedBox(height: 20),
              label('Company'),
              const SizedBox(
                height: 12,
              ),
              Company(),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        label('Start Date'),
                        const SizedBox(
                          height: 12,
                        ),
                        DateInput(
                          _startDateController,
                          'Start Date',
                          _selectDate,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.0), // Add some spacing between fields
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        label('End Date'),
                        const SizedBox(
                          height: 12,
                        ),
                        DateInput(
                          _endDateController,
                          'End Date',
                          _selectDate,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(children: [
                Checkbox(
                  value: isCurrentPosition,
                  onChanged: (newValue) {
                    setState(() {
                      isCurrentPosition = newValue!;
                    });
                  },
                  activeColor: Color.fromARGB(255, 107, 107, 107),
                ),
                Text('This is my postion now')
              ]),
              SizedBox(height: 20),
              label('Description'),
              const SizedBox(
                height: 12,
              ),
              Description(),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Add spacing between buttons
                  ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled:
                            true, // Make the bottom sheet scrollable
                        builder: (context) => Container(
                          height:
                              size.height / 2.5, // Set the desired sheet height
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 40,
                                height: 3,
                                color: Color(0xFF130160),
                              ),
                              SizedBox(
                                height: 45,
                              ),
                              Text(
                                "Remove Work Experience?",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 23,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 16),
                              Text(
                                "Are you sure you want to delete this work experience?",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 30),
                              SizedBox(
                                height: size.height / 14,
                                width: size.width / 1.4,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(0xFF130160),
                                    onPrimary: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  child: Text(
                                    'CONTINUE FILLING',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(
                                  height: 17), // Add spacing between button
                              SizedBox(
                                height: size.height / 14,
                                width: size.width / 1.4,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(0xFFD6CDFE),
                                    onPrimary: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  child: Text(
                                    'UNDO CHANGES',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Color(0xFFD6CDFE),
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        minimumSize: Size(160, 48)),
                    child: Text(
                      'Remove',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled:
                            true, // Make the bottom sheet scrollable
                        builder: (context) => Container(
                          height:
                              size.height / 2.5, // Set the desired sheet height
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 40,
                                height: 3,
                                color: Color(0xFF130160),
                              ),
                              SizedBox(
                                height: 45,
                              ),
                              Text(
                                "Undo Changes?",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 23,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 16),
                              Text(
                                "Are you sure you want to change what you entered?",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 30),
                              SizedBox(
                                height: size.height / 14,
                                width: size.width / 1.4,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(0xFF130160),
                                    onPrimary: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  child: Text(
                                    'CONTINUE FILLING',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(
                                  height: 17), // Add spacing between button
                              SizedBox(
                                height: size.height / 14,
                                width: size.width / 1.4,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    try {
                                      // Create a map for the work experience entry
                                      final workExperienceEntry = {
                                        'jobTitle': _jobtitleController.text,
                                        'company': _companyController.text,
                                        'startDate': _startDateController.text,
                                        'endDate': _endDateController.text,
                                        'isCurrent': isCurrentPosition,
                                        'description':
                                            _descriptionController.text,
                                      };

                                      // Replace 'userId' with the actual user ID of the current user
                                  

                                      // Add the work experience entry to Firestore
                                      await FirestoreService()
                                          .addWorkExperience(
                                              widget.email, workExperienceEntry);

                                      // Close the bottom sheet
                                      Navigator.pop(context);
                                       Navigator.pop(context);

                                    } catch (e) {
                                      print('Error adding work experience: $e');
                                      // Handle the error as needed
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(0xFFD6CDFE),
                                    onPrimary: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  child: Text(
                                    'UNDO CHANGES',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Color(0xFF130160),
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        minimumSize: Size(160, 48)),
                    child: Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime picked = (await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        )) ??
        DateTime.now();

    if (picked != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      controller.text = formattedDate;
    }
  }

  Widget Description() {
    return Container(
      height: 155,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _descriptionController,
        maxLines: null,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 17,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Write additional information here",
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 17),
          contentPadding: EdgeInsets.only(left: 20, right: 20),
        ),
      ),
    ).py12();
  }

  Widget JobTitle() {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _jobtitleController,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 17,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "",
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 17),
          contentPadding: EdgeInsets.only(left: 20, right: 20),
        ),
      ),
    );
  }

  Widget Company() {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _companyController,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 17,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "",
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 17),
          contentPadding: EdgeInsets.only(left: 20, right: 20),
        ),
      ),
    );
  }

  Widget DateInput(TextEditingController controller, String labelText,
      Function(BuildContext, TextEditingController) onTapCallback) {
    return Container(
        height: 55,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextFormField(
          controller: controller,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 17,
          ),
          readOnly: true,
          onTap: () {
            onTapCallback(context, controller);
          },
          // decoration: InputDecoration(
          //   labelText: "",
          //   suffixIcon: Icon(Icons.calendar_today),
          // ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "",
            contentPadding: EdgeInsets.only(left: 20, right: 20),
          ),
        ));
  }

  Widget label(String label) {
    return Text(label,
        style: TextStyle(
          color: Colors.indigo[900]!,
          fontWeight: FontWeight.w600,
          fontSize: 16.5,
          letterSpacing: 0.2,
        ));
  }

  Widget customPostButton(Size size) {
    return SizedBox(
      height: size.height / 14,
      width: size.width / 1.2,
      child: ElevatedButton(
        onPressed: () {
          // Show a bottom sheet with a button to call addAboutme
          showModalBottomSheet(
            context: context,
            isScrollControlled: true, // Make the bottom sheet scrollable
            builder: (context) => Container(
              height: size.height / 2.5, // Set the desired sheet height
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 3,
                    color: Color(0xFF130160),
                  ),
                  SizedBox(
                    height: 45,
                  ),
                  Text(
                    "Undo Changes?",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Are you sure you want to change what you entered?",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    height: size.height / 14,
                    width: size.width / 1.4,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF130160),
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        'CONTINUE FILLING',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 17), // Add spacing between buttons

                  SizedBox(
                    height: size.height / 14,
                    width: size.width / 1.4,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFD6CDFE),
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        'UNDO CHANGES',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          primary: Color(0xFF130160),
          onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(
          'Save',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}






