// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:gigs/view/Porfile/Profile_page.dart';

import '../firebase/firebaseService.dart';

class AppreciationScreen extends StatefulWidget {
  final String userEmail;
  final String imageUrl;
  const AppreciationScreen({
    Key? key,
    required this.userEmail,
    required this.imageUrl,
  }) : super(key: key);

  @override
  _AppreciationScreenState createState() => _AppreciationScreenState();
}

class _AppreciationScreenState extends State<AppreciationScreen> {
  TextEditingController _awardnameController = TextEditingController();
  TextEditingController _achievementachievedController =
      TextEditingController();
  TextEditingController _appreciationEndDateController =
      TextEditingController();
  TextEditingController _AppreciationDescriptionController =
      TextEditingController();
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
                'Add Appreciation',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 35),
              label('Award name'),
              const SizedBox(
                height: 12,
              ),
              AwardName(),
              SizedBox(height: 20),
              label('Category/Achievement achieved'),
              const SizedBox(
                height: 12,
              ),
              AchievementAchieved(),
              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        label('End Date'),
                        const SizedBox(
                          height: 12,
                        ),
                        DateInput(
                          _appreciationEndDateController,
                          'End Date',
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
                        // label('End Date'),
                        // const SizedBox(
                        //   height: 12,
                        // ),
                        // DateInput(
                        //   _educationEndDateController,
                        //   'End Date',
                        //   _selectDate,
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              label('Description'),
              const SizedBox(
                height: 12,
              ),
              AppreciationDescription(),
              SizedBox(height: 50),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      final Appreciation = {
                        'awardname': _awardnameController.text,
                        'AchievementAchieved':
                            _achievementachievedController.text,
                        'endDate': _appreciationEndDateController.text,
                        'description': _AppreciationDescriptionController.text,
                      };

                      await FirestoreService()
                          .addAppreciation(widget.userEmail, Appreciation);
                      Navigator.pop(context);

                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage(
                                  currentUserEmail: widget.userEmail,
                                  imageUrl: widget.imageUrl)));
                    } catch (e) {
                      print('Error adding work experience: $e');
                      // Handle the error as needed
                    }
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

  Widget AwardName() {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _awardnameController,
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

  Widget AchievementAchieved() {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _achievementachievedController,
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

  Widget AppreciationDescription() {
    return Container(
      height: 155,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _AppreciationDescriptionController,
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
