// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gigs/settings/settings.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:file_picker/file_picker.dart';

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
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  String selectedGender = '';
  String selectedCountryCode = '+1';

  Future<void> _changeImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      PlatformFile file = result.files.first;

      // Upload the selected image to Firebase Storage
      String storagePath =
          'user_images/${widget.currentUserEmail}/${DateTime.now().millisecondsSinceEpoch}';
      firebase_storage.Reference storageReference =
          firebase_storage.FirebaseStorage.instance.ref(storagePath);
      await storageReference.putFile(File(file.path!));

      // Get the download URL of the uploaded image
      String imageUrl = await storageReference.getDownloadURL();

      // Update the 'imageUrl' in the 'users' collection
      await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: widget.currentUserEmail)
          .get()
          .then((QuerySnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.docs.isNotEmpty) {
          final DocumentReference<Map<String, dynamic>> documentReference =
              snapshot.docs.first.reference;
          documentReference.update({'imageUrl': imageUrl});
        }
      });
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => EditProfilePage(
                  currentUserEmail: widget.currentUserEmail,
                  imageUrl: widget.imageUrl)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      // backgroundColor: Color.fromARGB(255, 251, 251, 249),
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsPage()));
                  },
                  icon: Icon(Icons.settings),
                ),
              ],
            ),
            Positioned(
              bottom: screenHeight * 0.031,
              left: screenWidth * 0.08,
              child: ElevatedButton.icon(
                onPressed: () {
                  _changeImage();
                },
                icon: Icon(Icons.edit),
                label: Text(
                  "Change Image",
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 69, 41, 191),
                  onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
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
                        Container(
                          padding: EdgeInsets.all(8),
                          height: 55,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              Radio(
                                activeColor: Colors.orange,
                                value: 'male',
                                groupValue: selectedGender,
                                onChanged: (value) {
                                  setState(() {
                                    selectedGender = value.toString();
                                  });
                                },
                              ),
                              Text('Male'),
                            ],
                          ),
                        ),
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
                        Container(
                          padding: EdgeInsets.all(8),
                          // decoration: BoxDecoration(
                          //   border: Border.all(
                          //     color: selectedGender == 'female'
                          //         ? Colors
                          //             .pink // Change color based on selection
                          //         : Colors.grey,
                          //   ),
                          //   borderRadius: BorderRadius.circular(8),
                          // ),
                          height: 55,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              Radio(
                                activeColor: Colors.orange,
                                value: 'female',
                                groupValue: selectedGender,
                                onChanged: (value) {
                                  setState(() {
                                    selectedGender = value.toString();
                                  });
                                },
                              ),
                              Text('Female'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              label('Email'),
              const SizedBox(
                height: 12,
              ),
              email(),
              SizedBox(
                height: 20,
              ),
              label('Phone Number'),
              const SizedBox(
                height: 12,
              ),
              mobile(),
              SizedBox(
                height: 20,
              ),
              label('Location'),
              const SizedBox(
                height: 12,
              ),
              location(),
              SizedBox(
                height: 20,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    // if (_fullnameController.text.isNotEmpty &&
                    //     _emailController.text.isNotEmpty) {
                    //   // Update Full Name and Email in the 'users' collection
                    //   await FirebaseFirestore.instance
                    //       .collection('users')
                    //       .where('email', isEqualTo: widget.currentUserEmail)
                    //       .get()
                    //       .then((QuerySnapshot<Map<String, dynamic>>
                    //           snapshot) async {
                    //     if (snapshot.docs.isNotEmpty) {
                    //       final DocumentReference<Map<String, dynamic>>
                    //           documentReference = snapshot.docs.first.reference;
                    //       await documentReference.update({
                    //         'name': _fullnameController.text,
                    //         'email': _emailController.text,
                    //       });
                    //     }
                    //   });
                    // }

                    // // Update DateOfBirth, Gender, PhoneNumber, and Location in the 'users' collection
                    // await FirebaseFirestore.instance
                    //     .collection('users')
                    //     .where('email', isEqualTo: widget.currentUserEmail)
                    //     .get()
                    //     .then((QuerySnapshot<Map<String, dynamic>>
                    //         snapshot) async {
                    //   if (snapshot.docs.isNotEmpty) {
                    //     final DocumentReference<Map<String, dynamic>>
                    //         documentReference = snapshot.docs.first.reference;
                    //     await documentReference.update({
                    //       'dateOfBirth': _DOBController.text,
                    //       'gender': selectedGender,
                    //       'phoneNumber':
                    //           selectedCountryCode + _phoneNumberController.text,
                    //       'location': _locationController.text,
                    //     });
                    //   }
                    // });
                    if (_fullnameController.text.isNotEmpty &&
                        _emailController.text.isNotEmpty) {
                      // Update Full Name and Email in the 'users' collection
                      await FirebaseFirestore.instance
                          .collection('users')
                          .where('email', isEqualTo: widget.currentUserEmail)
                          .get()
                          .then((QuerySnapshot<Map<String, dynamic>>
                              snapshot) async {
                        if (snapshot.docs.isNotEmpty) {
                          final DocumentReference<Map<String, dynamic>>
                              documentReference = snapshot.docs.first.reference;
                          await documentReference.update({
                            'name': _fullnameController.text,
                            'email': _emailController.text,
                          });
                        }
                      });
                    }

                    // Check and update DateOfBirth if not empty
                    if (_DOBController.text.isNotEmpty) {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .where('email', isEqualTo: widget.currentUserEmail)
                          .get()
                          .then((QuerySnapshot<Map<String, dynamic>>
                              snapshot) async {
                        if (snapshot.docs.isNotEmpty) {
                          final DocumentReference<Map<String, dynamic>>
                              documentReference = snapshot.docs.first.reference;
                          await documentReference
                              .update({'dateOfBirth': _DOBController.text});
                        }
                      });
                    }

                    // Check and update Gender if not empty
                    if (selectedGender.isNotEmpty) {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .where('email', isEqualTo: widget.currentUserEmail)
                          .get()
                          .then((QuerySnapshot<Map<String, dynamic>>
                              snapshot) async {
                        if (snapshot.docs.isNotEmpty) {
                          final DocumentReference<Map<String, dynamic>>
                              documentReference = snapshot.docs.first.reference;
                          await documentReference
                              .update({'gender': selectedGender});
                        }
                      });
                    }

                    // Check and update PhoneNumber if not empty
                    if (_phoneNumberController.text.isNotEmpty) {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .where('email', isEqualTo: widget.currentUserEmail)
                          .get()
                          .then((QuerySnapshot<Map<String, dynamic>>
                              snapshot) async {
                        if (snapshot.docs.isNotEmpty) {
                          final DocumentReference<Map<String, dynamic>>
                              documentReference = snapshot.docs.first.reference;
                          await documentReference.update({
                            'phoneNumber': selectedCountryCode +
                                _phoneNumberController.text,
                          });
                        }
                      });
                    }

                    // Check and update Location if not empty
                    if (_locationController.text.isNotEmpty) {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .where('email', isEqualTo: widget.currentUserEmail)
                          .get()
                          .then((QuerySnapshot<Map<String, dynamic>>
                              snapshot) async {
                        if (snapshot.docs.isNotEmpty) {
                          final DocumentReference<Map<String, dynamic>>
                              documentReference = snapshot.docs.first.reference;
                          await documentReference
                              .update({'location': _locationController.text});
                        }
                      });
                    }
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF130160),
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    minimumSize: Size(195, 55),
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

  Widget email() {
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
          controller: _emailController,
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

  Widget mobile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Country code dropdown
            Container(
              padding: EdgeInsets.all(8),
              height: 55,
              width: MediaQuery.of(context).size.width * 0.3,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: DropdownButton<String>(
                value: selectedCountryCode,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 24,
                elevation: 16,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCountryCode = newValue!;
                  });
                },
                items: [
                  '+1',
                  '+91',
                  '+44',
                  '+81'
                ] // Add more country codes as needed
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            SizedBox(width: 16.0),

            // Mobile number input field
            Expanded(
              child: Container(
                padding: EdgeInsets.all(8),
                height: 55,
                width: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextFormField(
                  controller: _phoneNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'Mobile Number',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget location() {
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
          controller: _locationController,
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
