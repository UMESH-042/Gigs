import 'package:flutter/material.dart';
import 'package:gigs/APIs/Institution_name.dart';
import 'package:intl/intl.dart';

import '../APIs/Field_of_Study.dart';
import '../APIs/level_of_education_API.dart';

class AddEducationPage extends StatefulWidget {
  final String email;
  const AddEducationPage({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  _AddEducationPageState createState() => _AddEducationPageState();
}

class _AddEducationPageState extends State<AddEducationPage> {
  TextEditingController _levelController = TextEditingController();
  TextEditingController _institutionController = TextEditingController();
  TextEditingController _fieldOfStudyController = TextEditingController();
  TextEditingController _educationStartDateController = TextEditingController();
  TextEditingController _educationEndDateController = TextEditingController();
  TextEditingController _educationDescriptionController = TextEditingController();
  bool isCurrentPosition = false;



  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
                'Add Education',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 35),
              label('Level of Education'),
              const SizedBox(
                height: 12,
              ),
              LevelOfEducation(),
              SizedBox(height: 20),
              label('Institution Name'),
              const SizedBox(
                height: 12,
              ),
              InstitutionName(),
              SizedBox(height: 20),
              label('Field of Study'),
              const SizedBox(
                height: 12,
              ),
              FieldOfStudy(),
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
                          _educationStartDateController,
                          'Start Date',
                          _selectDate,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        label('End Date'),
                        const SizedBox(
                          height: 12,
                        ),
                        DateInput(
                          _educationEndDateController,
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
                Text('This is my position now')
              ]),
              SizedBox(height: 20),
              label('Description'),
              const SizedBox(
                height: 12,
              ),
              EducationDescription(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Handle saving education data here
                  // You can access the entered data using the controllers
                  // _levelController.text, _institutionController.text, etc.
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

  // Widget LevelOfEducation() {
  //   return Container(
  //     height: 55,
  //     width: MediaQuery.of(context).size.width,
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(15),
  //     ),
  //     child: TextFormField(
  //       controller: _levelController,
  //       style: const TextStyle(
  //         color: Colors.black,
  //         fontSize: 17,
  //       ),
  //       decoration: InputDecoration(
  //         border: InputBorder.none,
  //         hintText: "",
  //         hintStyle: TextStyle(color: Colors.grey[500], fontSize: 17),
  //         contentPadding: EdgeInsets.only(left: 20, right: 20),
  //       ),
  //     ),
  //   );
  // }
  Widget LevelOfEducation() {
  return GestureDetector(
    onTap: () async {
      final selectedValue = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DegreeLevelSearchScreen()),
      );

      if (selectedValue != null) {
        setState(() {
          _levelController.text = selectedValue; // Set the selected value in your controller
        });
      }
    },
    child: Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: IgnorePointer(
        child: TextFormField(
          controller: _levelController,
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
      ),
    ),
  );
}


  // Widget InstitutionName() {
  //   return Container(
  //     height: 55,
  //     width: MediaQuery.of(context).size.width,
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(15),
  //     ),
  //     child: TextFormField(
  //       controller: _institutionController,
  //       style: const TextStyle(
  //         color: Colors.black,
  //         fontSize: 17,
  //       ),
  //       decoration: InputDecoration(
  //         border: InputBorder.none,
  //         hintText: "",
  //         hintStyle: TextStyle(color: Colors.grey[500], fontSize: 17),
  //         contentPadding: EdgeInsets.only(left: 20, right: 20),
  //       ),
  //     ),
  //   );
  // }
  Widget InstitutionName() {
  return GestureDetector(
    onTap: () async {
      final selectedValue = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UniversitySearchScreen()),
      );

      if (selectedValue != null) {
        setState(() {
          _institutionController.text = selectedValue; // Set the selected value in your controller
        });
      }
    },
    child: Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: IgnorePointer(
        child: TextFormField(
          controller: _institutionController,
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
      ),
    ),
  );
}

  Widget FieldOfStudy() {
  return GestureDetector(
    onTap: () async {
      final selectedValue = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FieldOfStudySearchScreen()),
      );

      if (selectedValue != null) {
        setState(() {
          _fieldOfStudyController.text = selectedValue; // Set the selected value in your controller
        });
      }
    },
    child: Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: IgnorePointer(
        child: TextFormField(
          controller: _fieldOfStudyController,
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
      ),
    ),
  );
}


  Widget EducationDescription() {
    return Container(
      height: 155,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _educationDescriptionController,
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
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "",
          contentPadding: EdgeInsets.only(left: 20, right: 20),
        ),
      ),
    );
  }

  Widget label(String label) {
    return Text(
      label,
      style: TextStyle(
        color: Colors.indigo[900]!,
        fontWeight: FontWeight.w600,
        fontSize: 16.5,
        letterSpacing: 0.2,
      ),
    );
  }
}
