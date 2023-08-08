import 'package:flutter/material.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:gigs/Screens/forgot_password.dart';

import 'login_screen.dart';

class CheckEmailPage extends StatefulWidget {
  final String email;

  CheckEmailPage({required this.email});

  @override
  State<CheckEmailPage> createState() => _CheckEmailPageState();
}

class _CheckEmailPageState extends State<CheckEmailPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: size.height / 5),
              Text(
                "Check Your Email",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Image.asset(
                'assets/forgot_password.png',
                height: size.height / 4,
                width: size.width / 1.5,
                fit: BoxFit.contain,
              ),
              SizedBox(height: size.height / 15),
              Center(
                child: customBackButtonforOpenEmail(size),
              ),
              SizedBox(height: size.height / 30),
              Center(
                child: customBackButton(size),
              ),
              SizedBox(
                    height: size.height / 22,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('You have not received the email?  ',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          )),
                      GestureDetector(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => ForgotPasswordPage())),
                        child: Text(
                          "Resend",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Color(0xFFFCA34D),
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget customBackButton(Size size) {
    return SizedBox(
      height: size.height / 14,
      width: size.width / 1.2,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginScreen()));
        },
        style: ElevatedButton.styleFrom(
          primary: Color(0xFFD6CDFE),
          onPrimary: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(
          'BACK TO LOGIN',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget customBackButtonforOpenEmail(Size size) {
    return SizedBox(
      height: size.height / 14,
      width: size.width / 1.2,
      child: ElevatedButton(
        onPressed: () async {
          // Replace 'com.google.android.gm' with the correct package name for Gmail app on Android.
          await LaunchApp.openApp(
            androidPackageName: 'com.google.android.gm',
            openStore: true,
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
          'Open Your Email',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
