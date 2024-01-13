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
                Center(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF130160),
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      minimumSize: Size(160, 48),
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
        fontSize: 17.5,
        letterSpacing: 0.2,
      ),
    );
  }
}
