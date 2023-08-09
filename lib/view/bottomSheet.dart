import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gigs/view/Add_Jobs.dart';

import 'Post_page.dart';

class AddBottomSheet extends StatefulWidget {
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
              context, MaterialPageRoute(builder: (context) => PostPage()));
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
