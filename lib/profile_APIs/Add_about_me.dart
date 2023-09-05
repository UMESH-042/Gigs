import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddAboutMe extends StatefulWidget {
   final String userId;

  const AddAboutMe({super.key, required this.userId});
  @override
  _AddAboutMeState createState() => _AddAboutMeState();
}

class _AddAboutMeState extends State<AddAboutMe> {

FirestoreService _firestoreService = FirestoreService();


   
    final TextEditingController _aboutmeController = TextEditingController();
  String Aboutme = ''; // To store entered job description

  void addAboutme() {
  String newAboutMe = _aboutmeController.text;

  if (Aboutme != newAboutMe) {
    setState(() {
      Aboutme = newAboutMe;
      _aboutmeController.clear();
    });

     _firestoreService.addAboutMe(widget.userId, Aboutme);
  }

  Navigator.pop(context, Aboutme); // Close the bottom sheet
}


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 241, 241, 241),
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'About me',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _aboutmeController,
                    maxLines: 10,
                    decoration: InputDecoration(
                      hintText: 'Tell me about you...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            if (Aboutme.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Saved',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(Aboutme),
                  ],
                ),
              ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomCenter,
              child: customPostButton(size), // Use the custom button
            ),
          ],
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
          // Show a bottom sheet with a button to call addAboutme
          showModalBottomSheet(
            context: context,
            isScrollControlled: true, // Make the bottom sheet scrollable
            builder: (context) => Container(
              height: size.height / 2.5, // Set the desired sheet height
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
                  SizedBox(
                    height: 45,
                  ),
                  Text(
                    "Undo Changes?",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Are you sure you want to change what you entered?",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    height: size.height / 14,
                    width: size.width / 1.4,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF130160),
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        'CONTINUE FILLING',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 17), // Add spacing between buttons

                  SizedBox(
                    height: size.height / 14,
                    width: size.width / 1.4,
                    child: ElevatedButton(
                      onPressed: () {
                        addAboutme();
                        Navigator.pop(context, Aboutme);
                         _firestoreService.updateAboutMe(widget.userId, Aboutme);
                     
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFD6CDFE),
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        'UNDO CHANGES',
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
          );
        },
        style: ElevatedButton.styleFrom(
          primary: Color(0xFF130160),
          onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(
          'Save',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _aboutmeController.dispose();
    super.dispose();
  }
}





class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addAboutMe(String userId, String aboutMe) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'aboutMe': aboutMe,
      }, SetOptions(merge: true));
    } catch (e) {
      // Handle error
      print('Error adding About Me: $e');
    }
  }

  Future<void> updateAboutMe(String userId, String aboutMe) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'aboutMe': aboutMe,
      });
    } catch (e) {
      // Handle error
      print('Error updating About Me: $e');
    }
  }
}
