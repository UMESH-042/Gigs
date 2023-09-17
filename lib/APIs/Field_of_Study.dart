
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class FieldOfStudySearchScreen extends StatefulWidget {
  @override
  _FieldOfStudySearchScreenState createState() =>
      _FieldOfStudySearchScreenState();
}


class _FieldOfStudySearchScreenState extends State<FieldOfStudySearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> searchResults = [];

  Future<void> searchFieldOfStudy(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }

    final response = await http.get(
        Uri.parse('https://internshala.com/autocomplete/stream/$query'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        searchResults = List<String>.from(data['result']);
      });
    } else {
      // Handle error
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    searchFieldOfStudy(_searchController.text);
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
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20,),
                Text(
                  'Field of Study Search',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 35),
                TextField(
                  controller: _searchController,
                  onChanged: (query) {
                    searchFieldOfStudy(query);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search for a field of study...',
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          searchResults = [];
                        });
                      },
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final fieldOfStudy = searchResults[index];
                return ListTile(
                  title: Text(fieldOfStudy),
                  onTap: (){
                    Navigator.pop(context,fieldOfStudy);
                  },
                  // You can add more details about the field of study
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }
}
