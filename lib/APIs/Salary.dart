
import 'package:flutter/material.dart';

class SalaryEntryScreen extends StatefulWidget {
  @override
  _SalaryEntryScreenState createState() => _SalaryEntryScreenState();
}

class _SalaryEntryScreenState extends State<SalaryEntryScreen> {
  late TextEditingController _salaryController;

  @override
  void initState() {
    super.initState();
    _salaryController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
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
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                  height: 20,
                ),
                Text(
                  'Salary',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _salaryController,
                  keyboardType:TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter Salary....',
                    filled: true,
                    fillColor: Colors.white, // You can choose the desired color
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed:  () {
                String salary = _salaryController.text.trim();
                if (salary.isNotEmpty && isNumeric(salary)) {
                  Navigator.pop(context, salary);
                } else {
                  // Handle invalid input (non-numeric)
                  // You may show an error message or take appropriate action
                }
              },
                      child: Text('Add Salary'),
                    ),
                  ],
                ),
          ],
        ),
      ),
    );
  }

  bool isNumeric(String value) {
    if (value == null) {
      return false;
    }
    return double.tryParse(value) != null;
  }
}
