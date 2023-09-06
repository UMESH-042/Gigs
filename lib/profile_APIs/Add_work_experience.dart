import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

class AddWorkExperiencePage extends StatefulWidget {
  @override
  _AddWorkExperiencePageState createState() => _AddWorkExperiencePageState();
}

class _AddWorkExperiencePageState extends State<AddWorkExperiencePage> {
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TextEditingController _jobtitleController = TextEditingController();
  TextEditingController _companyController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
              // Row for Start Date and End Date
              // Row(
              //   children: [
              //     Expanded(
              //       child: DateInput(
              //         _startDateController,
              //         'Start Date',
              //         _selectDate,
              //       ),
              //     ),
              //     SizedBox(width: 16.0), // Add some spacing between fields
              //     Expanded(
              //       child: DateInput(
              //         _endDateController,
              //         'End Date',
              //         _selectDate,
              //       ),
              //     ),
              //   ],
              // ),
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
              SizedBox(height: 20),
              label('Description'),
              const SizedBox(
                height: 12,
              ),
              Description(),
              SizedBox(height: 20),
              // Save Button
              ElevatedButton(
                onPressed: () {
                  // Implement save logic here
                },
                child: Text('Save'),
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
          color: Colors.white70,
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
}
