import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';

// class LandingPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           Align(
//             alignment: Alignment.topRight,
//             child: Padding(
//               padding: const EdgeInsets.only(top: 50, right: 20),
//               child: Text(
//                 'Jobspot',
//                 style: TextStyle(
//                   fontSize: 27,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(height: 20),
//           Center(
//             child: Container(
//               child: Image.asset(
//                 'assets/landing_page_logo.png', // Replace with your image asset
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           SizedBox(height: 20),
//           Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Find Your',
//                   style: TextStyle(
//                     fontSize: 40,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   'Dream Job',
//                   style: TextStyle(
//                     decoration: TextDecoration.underline,
//                     fontSize: 40,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFFFCA34D),
//                   ),
//                 ),
//                 Text(
//                   'Here!',
//                   style: TextStyle(
//                     fontSize: 40,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 Text(
//                   'Explore all the most exciting job roles based on your interest and study major.',
//                   style: TextStyle(
//                     fontSize: 16,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Align(
//             alignment: Alignment.centerRight,
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => LoginScreen(),
//                     ),
//                   );
//                 },
//                 child: Icon(Icons.arrow_forward),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xFF130160),
//                   shape: CircleBorder(),
//                   padding: EdgeInsets.all(16),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class LandingPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     // Define a function to calculate a percentage of the screen height
//     double screenHeight(double percentage) {
//       return size.height * percentage / 100;
//     }

//     // Define a function to calculate a percentage of the screen width
//     double screenWidth(double percentage) {
//       return size.width * percentage / 100;
//     }

//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           Align(
//             alignment: Alignment.topRight,
//             child: Padding(
//               padding: EdgeInsets.only(top: screenHeight(3), right: screenWidth(4)),
//               child: Text(
//                 'Jobspot',
//                 style: TextStyle(
//                   fontSize: screenWidth(7),
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(height: screenHeight(2)),
//           Center(
//             child: Container(
//               child: Image.asset(
//                 'assets/landing_page_logo.png', // Replace with your image asset
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           SizedBox(height: screenHeight(2)),
//           Padding(
//             padding: EdgeInsets.all(screenWidth(4)),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Find Your',
//                   style: TextStyle(
//                     fontSize: screenWidth(10),
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   'Dream Job',
//                   style: TextStyle(
//                     decoration: TextDecoration.underline,
//                     fontSize: screenWidth(10),
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFFFCA34D),
//                   ),
//                 ),
//                 Text(
//                   'Here!',
//                   style: TextStyle(
//                     fontSize: screenWidth(10),
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: screenHeight(1.6)),
//                 Text(
//                   'Explore all the most exciting job roles based on your interest and study major.',
//                   style: TextStyle(
//                     fontSize: screenWidth(4.2),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Align(
//             alignment: Alignment.centerRight,
//             child: Padding(
//               padding: EdgeInsets.all(screenWidth(4)),
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => LoginScreen(),
//                     ),
//                   );
//                 },
//                 child: Icon(Icons.arrow_forward),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xFF130160),
//                   shape: CircleBorder(),
//                   padding: EdgeInsets.all(screenWidth(4)),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double imageHeight = size.height * 0.4; // Adjust this value according to your need

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 50, right: 20),
                child: Text(
                  'Jobspot',
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Container(
                height: imageHeight,
                child: Image.asset(
                  'assets/landing_page_logo.png', // Replace with your image asset
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Find Your',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Dream Job',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFCA34D),
                    ),
                  ),
                  Text(
                    'Here!',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Explore all the most exciting job roles based on your interest and study major.',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  },
                  child: Icon(Icons.arrow_forward),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF130160),
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(16),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20), // Add some space at the bottom
          ],
        ),
      ),
    );
  }
}
