import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddWorkExperiencePage extends StatefulWidget {
  @override
  _AddWorkExperiencePageState createState() => _AddWorkExperiencePageState();
}

class _AddWorkExperiencePageState extends State<AddWorkExperiencePage> {
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Work Experience'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Other input fields for job title, company, and description
            TextField(
              decoration: InputDecoration(labelText: 'Job Title'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Company'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Description'),
            ),
            // Row for Start Date and End Date
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _startDateController,
                    readOnly: true,
                    onTap: () {
                      _selectDate(context, _startDateController);
                    },
                    decoration: InputDecoration(
                      labelText: 'Start Date',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
                SizedBox(width: 16.0), // Add some spacing between fields
                Expanded(
                  child: TextField(
                    controller: _endDateController,
                    readOnly: true,
                    onTap: () {
                      _selectDate(context, _endDateController);
                    },
                    decoration: InputDecoration(
                      labelText: 'End Date',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ],
            ),
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
    );
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    )) ?? DateTime.now();

    if (picked != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      controller.text = formattedDate;
    }
  }
}
