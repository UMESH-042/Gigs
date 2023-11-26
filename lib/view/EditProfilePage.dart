// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditProfilePage extends StatefulWidget {
  final String currentUserEmail;
  final String imageUrl;
  const EditProfilePage({
    Key? key,
    required this.currentUserEmail,
    required this.imageUrl,
  }) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}



class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController _fullnameController = TextEditingController();
  TextEditingController _DOBController = TextEditingController();
  TextEditingController _GenderController = TextEditingController();
 String selectedGender = '';
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(220), // Set the desired height of the app bar
        child: Stack(
          children: [
            AppBar(
              backgroundColor: Color.fromARGB(255, 31, 11, 118),
              automaticallyImplyLeading: false, // Remove back button
              flexibleSpace: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        left: 35, top: 50), // Adjust margins as needed
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(widget.imageUrl),
                      radius: 34,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .where('email', isEqualTo: widget.currentUserEmail)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Text(
                            "User's Name", // Default name
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          );
                        }

                        var userData = snapshot.data!.docs.first.data();
                        String displayName = userData['name'] ?? '';
                        print(displayName);

                        return Text(
                          displayName,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        );
                      },
                    ),
                  ),
                ],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20), // Adjust the radius as needed
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    // Implement the action for the Settings button here
                  },
                  icon: Icon(Icons.settings),
                ),
              ],
            ),
          ],
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
              label('Full Name'),
              const SizedBox(
                height: 12,
              ),
              fullname(),
              SizedBox(height: 20),
              label('Date of birth'),
              const SizedBox(
                height: 12,
              ),
              DateOfBirthInput(
                _DOBController,
                _selectDate,
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        label('Gender'),
                        const SizedBox(
                          height: 12,
                        ),
                        //add male
                        male(controller: _GenderController, onSelected: (value){
                          setState(() {
                            selectedGender=value;
                          });
                        })
                      ],
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        label(''),
                        const SizedBox(
                          height: 12,
                        ),
                        // add female
                       female(controller: _GenderController, onSelected: (value){
                        setState(() {
                          selectedGender = value;
                        });
                       })
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {},
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

  Widget fullname() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 55,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextFormField(
          controller: _fullnameController,
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
    );
  }

  Widget DateOfBirthInput(TextEditingController controller,
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
          labelText: '',
          hintText: "",
          contentPadding: EdgeInsets.only(left: 20, right: 20),
          suffixIcon: GestureDetector(
            onTap: () {
              // Handle the calendar icon tap event
              // For example, show a date picker
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              ).then((selectedDate) {
                if (selectedDate != null) {
                  // Update the controller with the selected date
                  controller.text = selectedDate.toLocal().toString();
                }
              });
            },
            child: Icon(Icons.calendar_today, color: Color(0xFF130160)),
          ),
        ),
      ),
    );
  }


  Widget male({
  required TextEditingController controller,
  required ValueChanged<String> onSelected,
}) {
  bool isSelected = controller.text.isNotEmpty;

  return GestureDetector(
    onTap: () {
      onSelected('Male');
    },
    child: Container(
      height: 55,
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue : Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: TextFormField(
          controller: controller,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 17,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Male',
            hintStyle: TextStyle(color: Colors.grey[500], fontSize: 17),
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
          ),
        ),
      ),
    ),
  );
}

  Widget female({
  required TextEditingController controller,
  required ValueChanged<String> onSelected,
}) {
  bool isSelected = controller.text.isNotEmpty;

  return GestureDetector(
    onTap: () {
      onSelected('Female');
    },
    child: Container(
      height: 55,
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue : Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: TextFormField(
          controller: controller,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 17,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Female',
            hintStyle: TextStyle(color: Colors.grey[500], fontSize: 17),
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
          ),
        ),
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
