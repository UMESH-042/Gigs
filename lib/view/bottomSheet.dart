// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gigs/Screens/login_screen.dart';
import 'package:gigs/Screens/methods.dart';

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
      height: size.height / 15,
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
    Key? key,
    required this.onOptionSelected,
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

class BottomSheetForEmploymentType extends StatefulWidget {
  final void Function(String selectedOption) onOptionSelected;
  const BottomSheetForEmploymentType({
    Key? key,
    required this.onOptionSelected,
  }) : super(key: key);

  @override
  State<BottomSheetForEmploymentType> createState() =>
      _BottomSheetForEmploymentTypeState();
}

class _BottomSheetForEmploymentTypeState
    extends State<BottomSheetForEmploymentType> {
  String selectedEmploymentType = '';
  @override
  Widget build(BuildContext context) {
    print(selectedEmploymentType);
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.6,
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
          SizedBox(height: 30),
          Text(
            "Choose Job Type",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 23,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            "Determine and choose the type of work according to what you want !!",
            style: TextStyle(
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20), // Add spacing
          RadioOption(
            title: "Full Time",
            subtitle: "",
            isSelected: selectedEmploymentType == "Full Time",
            onTap: () {
              setState(() {
                selectedEmploymentType = "Full Time";
              });
              widget.onOptionSelected(selectedEmploymentType); // Notify parent
              Navigator.pop(context); // Close the bottom sheet
            },
          ),
          RadioOption(
            title: "Part Time",
            subtitle: "",
            isSelected: selectedEmploymentType == "Part Time",
            onTap: () {
              setState(() {
                selectedEmploymentType = "Part Time";
              });
              widget.onOptionSelected(selectedEmploymentType); // Notify parent
              Navigator.pop(context); // Close the bottom sheet
            },
          ),
          RadioOption(
            title: "Contract",
            subtitle: "",
            isSelected: selectedEmploymentType == "Contract",
            onTap: () {
              setState(() {
                selectedEmploymentType = "Contract";
              });
              widget.onOptionSelected(selectedEmploymentType); // Notify parent
              Navigator.pop(context); // Close the bottom sheet
            },
          ),
          RadioOption(
            title: "Temporary",
            subtitle: "",
            isSelected: selectedEmploymentType == "Temporary",
            onTap: () {
              setState(() {
                selectedEmploymentType = "Temporary";
              });
              widget.onOptionSelected(selectedEmploymentType); // Notify parent
              Navigator.pop(context); // Close the bottom sheet
            },
          ),
          RadioOption(
            title: "volunteer",
            subtitle: "",
            isSelected: selectedEmploymentType == "volunteer",
            onTap: () {
              setState(() {
                selectedEmploymentType = "volunteer";
              });
              widget.onOptionSelected(selectedEmploymentType); // Notify parent
              Navigator.pop(context); // Close the bottom sheet
            },
          ),
          RadioOption(
            title: "Apprenticeship",
            subtitle: "",
            isSelected: selectedEmploymentType == "Apprenticeship",
            onTap: () {
              setState(() {
                selectedEmploymentType = "Apprenticeship";
              });
              widget.onOptionSelected(selectedEmploymentType); // Notify parent
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
        padding: EdgeInsets.symmetric(
            vertical: 8, horizontal: 15), // Adjusted vertical padding
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16, // Adjusted font size
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Color(0xFF130160) : Colors.black,
                  ),
                ),
                SizedBox(height: 2), // Adjusted height
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
                    ? Icon(Icons.circle,
                        size: 10, color: Colors.orange) // Adjusted size
                    : Container(
                        width: 10,
                        height: 10,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class bottomSheetForLogout extends StatefulWidget {
  const bottomSheetForLogout({
    Key? key,
  }) : super(key: key);

  @override
  State<bottomSheetForLogout> createState() => _bottomSheetForLogoutState();
}

class _bottomSheetForLogoutState extends State<bottomSheetForLogout> {
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
            "Log Out",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 23,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            "Are you sure you want to leave?",
            style: TextStyle(
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40),
          customYes(size),
          SizedBox(height: 10),
          customNo(size),
        ],
      ),
    );
  }

  Widget customNo(Size size) {
    return SizedBox(
      height: size.height / 15,
      width: size.width / 1.2,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          primary: Color(0xFFD6CDFE),
          onPrimary: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(
          'CANCEL',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      // After successful logout, navigate to the login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      print("Error occurred during logout: $e");
      // Handle any error that occurred during logout (if any).
    }
  }

  Widget customYes(Size size) {
    return SizedBox(
      height: size.height / 15,
      width: size.width / 1.2,
      child: ElevatedButton(
        onPressed: () {
          _logout();
        },
        style: ElevatedButton.styleFrom(
          primary: Color(0xFF130160),
          onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(
          'YES',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
