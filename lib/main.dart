import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gigs/Screens/Landing_page.dart';
import 'package:gigs/Screens/Open_your_email.dart';
import 'package:gigs/Screens/login_screen.dart';
import 'package:gigs/notifications/notification_service.dart';
import 'package:gigs/themes/themes.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  LocalNotificationService.initialize();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData.light(),
//         darkTheme: ThemeData.dark(),
//         home: AnimatedSplashScreen(
//             duration: 2000,
//             splash: Image.asset('assets/splash_logo.png'),
//             nextScreen: LandingPage(),
//             splashTransition: SplashTransition.fadeTransition,
//             backgroundColor: Color(0xFF130160)));
//   }
// }
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context);

          return MaterialApp(
              themeMode: themeProvider.themeMode,
              debugShowCheckedModeBanner: false,
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              home: AnimatedSplashScreen(
                  duration: 2000,
                  splash: Image.asset('assets/splash_logo.png'),
                  nextScreen: LandingPage(),
                  splashTransition: SplashTransition.fadeTransition,
                  backgroundColor: Color(0xFF130160)));
        },
      );
}
