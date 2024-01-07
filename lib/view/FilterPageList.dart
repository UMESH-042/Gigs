import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// class FilterPage extends StatefulWidget {
//   const FilterPage({Key? key}) : super(key: key);

//   @override
//   State<FilterPage> createState() => _FilterPageState();
// }

// class _FilterPageState extends State<FilterPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize:
//             Size.fromHeight(220), // Set the desired height of the app bar
//         child: Stack(
//           children: [
//             AppBar(
//               backgroundColor: Color.fromARGB(255, 31, 11, 118),
//               automaticallyImplyLeading: false, // Remove back button
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.vertical(
//                   bottom: Radius.circular(20), // Adjust the radius as needed
//                 ),
//               ),
//               leading: IconButton(
//                 icon: Icon(Icons.arrow_back),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//               ),
//             ),
//             Positioned(
//               top: 100, // Adjust the vertical position as needed
//               left: 25,
//               right: 25,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(15.0),
//                     ),
//                     child: TextField(
//                       decoration: InputDecoration(
//                         hintText: 'Job Position',
//                         border: InputBorder.none,
//                         prefixIcon: Icon(Icons.search,color: Color.fromARGB(255, 31, 11, 118),),
//                         contentPadding: EdgeInsets.all(10.0),
//                       ),
//                       style: TextStyle(color: Colors.black),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Positioned(
//               bottom: 40, // Adjust the vertical position as needed
//               left: 25,
//               right: 25,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(15.0),
//                     ),
//                     child: TextField(
//                       decoration: InputDecoration(
//                         hintText: 'Location',
//                         border: InputBorder.none,
//                         prefixIcon: Icon(Icons.location_pin,color: Color(0xFFFCA34D),),
//                         contentPadding: EdgeInsets.all(10.0),
//                       ),
//                       style: TextStyle(color: Colors.black),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: Center(
//         child: Text('Umesh'),
//       ),
//     );
//   }
// }
class FilterPage extends StatefulWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(220),
        child: Stack(
          children: [
            AppBar(
              backgroundColor: Color.fromARGB(255, 31, 11, 118),
              automaticallyImplyLeading: false,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Positioned(
              top: 100,
              left: 25,
              right: 25,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Job Position',
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.search,
                          color: Color.fromARGB(255, 31, 11, 118),
                        ),
                        contentPadding: EdgeInsets.all(10.0),
                      ),
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 40,
              left: 25,
              right: 25,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Location',
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.location_pin,
                          color: Color(0xFFFCA34D),
                        ),
                        contentPadding: EdgeInsets.all(10.0),
                      ),
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('jobs').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No jobs available.'));
            }

            var jobs = snapshot.data!.docs;

            return ListView.builder(
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                var job = jobs[index].data() as Map<String, dynamic>;

                return _buildJobDisplayCard(
                  job['jobPosition'],
                  job['company'],
                  job['jobLocation'],
                  job['employmentType'],
                  job['jobDescription'],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildJobDisplayCard(
    String jobPosition,
    String companyName,
    String jobLocation,
    String employmentType,
    String jobDescription,
  ) {
    print(toTitleCase(jobPosition));
    List<String> locationParts = jobLocation.split(',');

    String firstWordBeforeComma = locationParts.length > 1
        ? locationParts[0].trim().split(' ')[0]
        : jobLocation.trim().split(' ')[0];

    String lastWord = locationParts.last.trim();

    String shortenedLocation = '$firstWordBeforeComma, $lastWord';
    print(shortenedLocation);

    var domain = companyName.toLowerCase();

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://poweredwith.nyc3.cdn.digitaloceanspaces.com/images/domains/$domain.com.jpg'), // Use company logo URL
                    radius: 30,
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        toTitleCase(jobPosition),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(companyName),
                      Text(shortenedLocation),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12),
              // Row(
              //   children: [
              //     SizedBox(width: 8),
              //     Chip(label: Text(jobPosition)),
              //     SizedBox(width: 8),
              //     Chip(label: Text(employmentType)),
              //     SizedBox(width: 8),
              //     Container(
              //       height: 35,
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(15),
              //         color:
              //             Colors.orange, // Set the background color to orange
              //       ),
              //       child: ElevatedButton(
              //         onPressed: () {
              //           // Add apply button functionality
              //           // You may want to implement a method to handle job application
              //           // E.g., _applyToJob(jobPosition, companyName);
              //         },
              //         style: ElevatedButton.styleFrom(
              //           primary: Colors
              //               .transparent, // Set the button background to transparent
              //           elevation: 0, // Remove the button shadow
              //         ),
              //         child: Text(
              //           'Apply',
              //           style: TextStyle(color: Colors.white),
              //         ),
              //       ),
              //     ),
              //     SizedBox(width: 8),
              //   ],
              // ),

              Row(
                children: [
                  SizedBox(width: 8),
                  Chip(label: Text(toTitleCase(jobPosition))),
                  SizedBox(width: 8),
                  Chip(label: Text(employmentType)),
                  SizedBox(width: 8),
                ],
              ),

              SizedBox(height: 12),
              Text(jobDescription),
            ],
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Icon(
              Icons.bookmark_border_outlined,
              // color: Colors.grey,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }

  String toTitleCase(String text) {
    return text.replaceAllMapped(
      RegExp(r'\b\w'),
      (match) => match.group(0)!.toUpperCase(),
    );
  }
}
