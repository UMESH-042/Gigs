import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gigs/Screens/Landing_page.dart';
import 'package:gigs/Screens/Open_your_email.dart';
import 'package:gigs/Screens/login_screen.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  AnimatedSplashScreen(
            duration: 2000,
            splash: Image.asset('assets/splash_logo.png'),
            nextScreen: LandingPage(),
            splashTransition: SplashTransition.fadeTransition,
            backgroundColor:Color(0xFF130160)));

  }
}
