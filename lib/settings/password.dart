import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpdatePasswordPage extends StatefulWidget {
  @override
  _UpdatePasswordPageState createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
   


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
      body:SingleChildScrollView(child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 17),
              Text(
                ' Update Password',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
          SizedBox(height: 30,),
            label('Old Password'),
            SizedBox(height: 12,),
            oldpassword(),
            SizedBox(height: 20,),
            label('New Password'),
            SizedBox(height: 12,),
            newpassword(),
            SizedBox(height: 20,),
            label('Confirm Password'),
            SizedBox(height: 12,),
            confirmPassword(),
            SizedBox(height: 20),
            SizedBox(height: size.height/4,),
            Center(child: customPostButton(size)),
          ],
        ),
      ),
    )
    );
  }

  Future<void> _updatePassword() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Re-authenticate user before updating the password
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: _oldPasswordController.text.trim(),
        );
        await user.reauthenticateWithCredential(credential);

        // Check if the new password and confirm password match
        if (_newPasswordController.text.trim() ==
            _confirmPasswordController.text.trim()) {
          // Update the password
          await user.updatePassword(_newPasswordController.text.trim());

          // Display a success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Password updated successfully.'),
            ),
          );

          // Clear the text fields
          _oldPasswordController.clear();
          _newPasswordController.clear();
          _confirmPasswordController.clear();
        } else {
          // Display an error message if passwords don't match
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('New password and confirm password do not match.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      // Handle errors
      print('Error updating password: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating password. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget oldpassword() {
    return Container(
        height: 47,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child:  TextFormField(
          obscureText: true,
            controller: _oldPasswordController,
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
  Widget newpassword() {
    return Container(
        height: 47,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child:  TextFormField(
          obscureText: true,
            controller: _newPasswordController,
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
  Widget confirmPassword() {
    return Container(
        height: 47,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child:  TextFormField(
          obscureText: true,
            controller: _confirmPasswordController,
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



  Widget customPostButton(Size size) {
    return SizedBox(
      height: size.height / 14,
      width: size.width / 1.3,
      child: ElevatedButton(
        onPressed: () {
          _updatePassword();
        },
        style: ElevatedButton.styleFrom(
          primary: Color(0xFF130160),
          onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(
          'UPDATE',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

}

