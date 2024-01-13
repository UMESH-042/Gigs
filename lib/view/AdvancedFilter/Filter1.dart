// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class Ad1Filterpage extends StatefulWidget {
//   const Ad1Filterpage({Key? key}) : super(key: key);

//   @override
//   State<Ad1Filterpage> createState() => _Ad1FilterpageState();
// }

// class Category {
//   final String name;
//   bool isSelected;

//   Category(this.name, this.isSelected);
// }

// class _Ad1FilterpageState extends State<Ad1Filterpage> {
//   TextEditingController _searchController = TextEditingController();
//   List<Category> categories = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchCategories();
//   }

//   Future<void> fetchCategories() async {
//     // Fetch distinct values for the 'category' field from the 'jobs' collection
//     QuerySnapshot querySnapshot =
//         await FirebaseFirestore.instance.collection('jobs').get();

//     // Extract distinct category values
//     Set<String> distinctCategories = Set<String>();
//     querySnapshot.docs.forEach((doc) {
//       var categoryName = doc['category'];
//       distinctCategories.add(categoryName);
//     });

//     // Initialize the categories list
//     categories = distinctCategories
//         .map((categoryName) => Category(categoryName, false))
//         .toList();

//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color.fromARGB(255, 241, 241, 241),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         iconTheme: IconThemeData(color: Colors.black),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context); // Navigate back
//           },
//         ),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(30.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _searchController,
//                     onChanged: (query) {},
//                     decoration: InputDecoration(
//                       hintText: 'Search...',
//                       prefixIcon: Icon(Icons.search),
//                       filled: true,
//                       fillColor: Colors.white,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(20.0),
//                         borderSide: BorderSide.none,
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 16),
//                 Container(
//                   width: 51,
//                   height: 49,
//                   decoration: BoxDecoration(
//                     color: Color(0xFFFCA34D),
//                     borderRadius: BorderRadius.circular(15.0),
//                   ),
//                   child: IconButton(
//                     icon: Icon(
//                       Icons.filter_list,
//                       color: Colors.white,
//                     ),
//                     onPressed: () {},
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 20),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 30.0),
//             child: Text(
//               'Specialization',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           SizedBox(height: 25),
//           Center(
//             child: Wrap(
//               spacing: 16.0,
//               runSpacing: 16.0,
//               children: categories.map((category) {
//                 return GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       categories.forEach((c) => c.isSelected = false);
//                       category.isSelected = !category.isSelected;
//                     });
//                   },
//                   child: Container(
//                     width: MediaQuery.of(context).size.width / 2 - 30,
//                     height: 160,
//                     decoration: BoxDecoration(
//                       color: category.isSelected
//                           ? Color(0xFFFCA34D)
//                           : Colors.white,
//                       borderRadius: BorderRadius.circular(20.0),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.5),
//                           spreadRadius: 2,
//                           blurRadius: 5,
//                           offset: Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         // Replace with your desired icon or use a package like 'flutter_icons'
//                         Icon(
//                           Icons.category, // Placeholder icon for demonstration
//                           color: category.isSelected
//                               ? Colors.white
//                               : Colors.black,
//                           size: 40,
//                         ),
//                         SizedBox(height: 8),
//                         Text(
//                           category.name,
//                           style: TextStyle(
//                             fontSize: 18,
//                             color: category.isSelected
//                                 ? Colors.white
//                                 : Colors.black,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Ad1Filterpage extends StatefulWidget {
  const Ad1Filterpage({Key? key}) : super(key: key);

  @override
  State<Ad1Filterpage> createState() => _Ad1FilterpageState();
}

class Category {
  final String name;
  bool isSelected;
  int jobCount;

  Category(this.name, this.isSelected, this.jobCount);
}

class _Ad1FilterpageState extends State<Ad1Filterpage> {
  TextEditingController _searchController = TextEditingController();
  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    // Fetch distinct values for the 'category' field from the 'jobs' collection
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('jobs').get();

    // Extract distinct category values
    Set<String> distinctCategories = Set<String>();
    querySnapshot.docs.forEach((doc) {
      var categoryName = doc['category'];
      distinctCategories.add(categoryName);
    });

    // Initialize the categories list
    categories = distinctCategories
        .map((categoryName) =>
            Category(categoryName, false, getJobCount(categoryName, querySnapshot)))
        .toList();

    setState(() {});
  }

  int getJobCount(String categoryName, QuerySnapshot querySnapshot) {
    return querySnapshot.docs
        .where((doc) => doc['category'] == categoryName)
        .length;
  }

  @override
  Widget build(BuildContext context) {
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (query) {},
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Container(
                  width: 51,
                  height: 49,
                  decoration: BoxDecoration(
                    color: Color(0xFFFCA34D),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.filter_list,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              'Specialization',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 25),
          Center(
            child: Wrap(
              spacing: 16.0,
              runSpacing: 16.0,
              children: categories.map((category) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      categories.forEach((c) {
                        c.isSelected = false;
                      });
                      category.isSelected = !category.isSelected;
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2 - 30,
                    height: 160,
                    decoration: BoxDecoration(
                      color: category.isSelected
                          ? Color(0xFFFCA34D)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Replace with your desired icon or use a package like 'flutter_icons'
                        Icon(
                          Icons.category, // Placeholder icon for demonstration
                          color: category.isSelected
                              ? Colors.white
                              : Colors.black,
                          size: 40,
                        ),
                        SizedBox(height: 8),
                        Text(
                          category.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: category.isSelected
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '${category.jobCount} Jobs',
                          style: TextStyle(
                            fontSize: 14,
                            color: category.isSelected
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
