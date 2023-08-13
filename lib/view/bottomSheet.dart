// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:gigs/view/Add_Jobs.dart';

import 'Post_page.dart';

class AddBottomSheet extends StatefulWidget {
  final String useremail;
  const AddBottomSheet({
    Key? key,
    required this.useremail,
  }) : super(key: key);

  @override
  State<AddBottomSheet> createState() => _AddBottomSheetState();
}

class _AddBottomSheetState extends State<AddBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: 375,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min, // To adjust the height of the content
        children: [
          Container(
            width: 40,
            height: 3,
            color: Color(0xFF130160),
          ),
          SizedBox(
            height: 70,
          ),
          Text(
            "What would you like to add?",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 23,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            "Would you like to post your tips and experiences or create a job?",
            style: TextStyle(
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40),
          customPostButton(size),
          SizedBox(height: 10),
          customMakeAJob(size),
        ],
      ),
    );
  }

  Widget customMakeAJob(Size size) {
    return SizedBox(
      height: size.height / 14,
      width: size.width / 1.2,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddJobs()));
        },
        style: ElevatedButton.styleFrom(
          primary: Color(0xFFD6CDFE),
          onPrimary: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(
          'MAKE A JOB',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget customPostButton(Size size) {
    return SizedBox(
      height: size.height / 14,
      width: size.width / 1.2,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PostPage(
                        useremail: widget.useremail,
                      )));
        },
        style: ElevatedButton.styleFrom(
          primary: Color(0xFF130160),
          onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(
          'POST',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class BottomSheetForWorkplace extends StatefulWidget {
   final void Function(String selectedOption) onOptionSelected;
  const BottomSheetForWorkplace({
    Key? key, required this.onOptionSelected,
  }) : super(key: key);

  @override
  State<BottomSheetForWorkplace> createState() =>
      _BottomSheetForWorkplaceState();
}

class _BottomSheetForWorkplaceState extends State<BottomSheetForWorkplace> {
  String selectedWorkplace = '';
  @override
  Widget build(BuildContext context) {
    print(selectedWorkplace);
    final size = MediaQuery.of(context).size;
    return Container(
      height: 400,
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
          SizedBox(height: 70),
          Text(
            "Choose the type of workplace",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 23,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            "Decide and choose the type of place to work according to what you want",
            style: TextStyle(
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20), // Add spacing
          RadioOption(
            title: "On-site",
            subtitle: "Employees come to work",
            isSelected: selectedWorkplace == "On-site",
            onTap: () {
              setState(() {
                selectedWorkplace = "On-site";
              });
              widget.onOptionSelected(selectedWorkplace); // Notify parent
          Navigator.pop(context); // Close the bottom sheet
            },
          ),
          RadioOption(
            title: "Hybrid",
            subtitle: "Employees work directly on site or off site",
            isSelected: selectedWorkplace == "Hybrid",
            onTap: () {
              setState(() {
                selectedWorkplace = "Hybrid";
              });
              widget.onOptionSelected(selectedWorkplace); // Notify parent
          Navigator.pop(context); // Close the bottom sheet
            },
          ),
          RadioOption(
            title: "Remote",
            subtitle: "Employees working off site",
            isSelected: selectedWorkplace == "Remote",
            onTap: () {
              setState(() {
                selectedWorkplace = "Remote";
              });
              widget.onOptionSelected(selectedWorkplace); // Notify parent
          Navigator.pop(context); // Close the bottom sheet
            },
          ),
        ],
      ),
    );
  }
}

class RadioOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final Function() onTap;

  const RadioOption({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Color(0xFF130160) : Colors.black,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: isSelected ? Color(0xFF130160) : Colors.grey,
                  ),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.orange : Colors.black,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(4),
                child: isSelected
                    ? Icon(Icons.circle, size: 12, color: Colors.orange)
                    : Container(
                        width: 12,
                        height: 12,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
