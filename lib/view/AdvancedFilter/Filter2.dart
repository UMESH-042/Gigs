import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Ad2FilterPage extends StatefulWidget {
  const Ad2FilterPage({super.key});

  @override
  State<Ad2FilterPage> createState() => _Ad2FilterPageState();
}

class _Ad2FilterPageState extends State<Ad2FilterPage> {
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _subcategoryController = TextEditingController();
  TextEditingController _locationController = TextEditingController();

   double _startValue = 0.0;
  double _endValue = 50000.0;

   List<String> selectedJobTypes = [];

  // @override
  // Widget build(BuildContext context) {
  //   final size = MediaQuery.of(context).size;
  //   return Scaffold(
  //     backgroundColor: Color.fromARGB(255, 245, 243, 243),
  //     appBar: AppBar(
  //       backgroundColor: Colors.transparent,
  //       elevation: 0,
  //       iconTheme: IconThemeData(color: Colors.black),
  //       leading: IconButton(
  //         icon: Icon(Icons.arrow_back),
  //         onPressed: () {
  //           Navigator.pop(context); // Navigate back
  //         },
  //       ),
  //     ),
  //     body: SingleChildScrollView(
  //       child: Padding(
  //         padding: const EdgeInsets.all(16.0),
  //         child: Container(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Center(
  //                 child: Text(
  //                   'Filter',
  //                   style: TextStyle(
  //                     color: Colors.indigo[900],
  //                     fontWeight: FontWeight.bold,
  //                     fontSize: 26,
  //                   ),
  //                 ),
  //               ),
  //               SizedBox(height: 47),
  //               label('Category'),
  //               const SizedBox(
  //                 height: 15,
  //               ),
  //               Category(),
  //               SizedBox(height: 25),
  //               label('Sub Category'),
  //               const SizedBox(
  //                 height: 15,
  //               ),
  //               SubCategory(),
  //               SizedBox(height: 25),
  //               label('Location'),
  //               const SizedBox(
  //                 height: 15,
  //               ),
  //               location(),
  //               SizedBox(height: 25),
  //               label('Salary'),
  //               const SizedBox(
  //                 height: 15,
  //               ),
  //                salaryRangeSlider(),
  //               SizedBox(height: 25),
  //                label('Job Type'),
  //               const SizedBox(
  //                 height: 15,
  //               ),
  //               jobTypeChips(),
  //               Center(
  //                 child: ElevatedButton(
  //                   onPressed: () {},
  //                   style: ElevatedButton.styleFrom(
  //                     primary: Color(0xFF130160),
  //                     onPrimary: Colors.white,
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(8.0),
  //                     ),
  //                     minimumSize: Size(160, 48),
  //                   ),
  //                   child: Text(
  //                     'Save',
  //                     style: TextStyle(
  //                       fontSize: 16,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 243, 243),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Filter',
                    style: TextStyle(
                      color: Colors.indigo[900],
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
                ),
                SizedBox(height: 47),
                label('Category'),
                const SizedBox(
                  height: 15,
                ),
                Category(),
                SizedBox(height: 25),
                label('Sub Category'),
                const SizedBox(
                  height: 15,
                ),
                SubCategory(),
                SizedBox(height: 25),
                label('Location'),
                const SizedBox(
                  height: 15,
                ),
                location(),
                SizedBox(height: 25),
                label('Salary'),
                const SizedBox(
                  height: 15,
                ),
                salaryRangeSlider(),
                SizedBox(height: 25),
                label('Job Type'),
                const SizedBox(
                  height: 15,
                ),
                jobTypeChips(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Implement your reset logic here
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text('Reset'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Implement your save logic here
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF130160),
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget Category() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 55,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: IgnorePointer(
          child: TextFormField(
            controller: _categoryController,
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
      ),
    );
  }

  Widget SubCategory() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 55,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: IgnorePointer(
          child: TextFormField(
            controller: _subcategoryController,
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
      ),
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
        child: IgnorePointer(
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
      ),
    );
  }

  Widget label(String label) {
    return Text(
      label,
      style: TextStyle(
        color: Colors.indigo[900]!,
        fontWeight: FontWeight.w600,
        fontSize: 18,
        letterSpacing: 0.2,
      ),
    );
  }

  
  Widget salaryRangeSlider() {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Min:  \$${(_startValue / 1000).toStringAsFixed(1)}K'),
          Text('Max:  \$${(_endValue / 1000).toStringAsFixed(1)}K'),
        ],
      ),
      RangeSlider(
        inactiveColor: Color.fromARGB(255, 211, 211, 211),
        activeColor: Color(0xFFFCA34D),
        values: RangeValues(_startValue, _endValue),
        min: 0,
        max: 50000,
        divisions: 10,
        onChanged: (RangeValues values) {
          setState(() {
            _startValue = values.start;
            _endValue = values.end;
          });
        },
        labels: RangeLabels(
          '\$${(_startValue / 1000).toStringAsFixed(1)}K',
          '\$${(_endValue / 1000).toStringAsFixed(1)}K',
        ),
      ),
    ],
  );
}

   Widget jobTypeChips() {
    return Center(
      child: Wrap(
        spacing: 6.0,
        children: [
          // buildJobTypeChip("Full Time"),
          // buildJobTypeChip("Part Time"),
          // buildJobTypeChip("Contract"),
          // buildJobTypeChip("Apprenticeship"),
          // buildJobTypeChip("Project-based"),
           buildJobTypeContainer("Full Time"),
        buildJobTypeContainer("Part Time"),
        buildJobTypeContainer("Contract"),
        buildJobTypeContainer("Apprenticeship"),
        buildJobTypeContainer("Project-based"),
        ],
      ),
    );
  }


//  Widget buildJobTypeChip(String label) {
//     return FilterChip(
//       showCheckmark: false,
//       label: Text(label),
//       onSelected: (bool selected) {
//         setState(() {
//           if (selected) {
//             selectedJobTypes.add(label);
//           } else {
//             selectedJobTypes.remove(label);
//           }
//         });
//       },
//       selected: selectedJobTypes.contains(label),
//       backgroundColor: Colors.white,
//       selectedColor: Color(0xFFFCA34D), // Customize the selected chip color
//     );
//   }
 Widget buildJobTypeContainer(String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (selectedJobTypes.contains(label)) {
            selectedJobTypes.remove(label);
          } else {
            selectedJobTypes.add(label);
          }
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: selectedJobTypes.contains(label) ? Color(0xFFFCA34D) : Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16.0,
            color: selectedJobTypes.contains(label) ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }


}
