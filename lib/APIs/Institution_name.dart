
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class UniversitySearchScreen extends StatefulWidget {
  @override
  _UniversitySearchScreenState createState() => _UniversitySearchScreenState();
}

class _UniversitySearchScreenState extends State<UniversitySearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> searchResults = [];

  Future<void> searchUniversities(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }

    final response = await http
        .get(Uri.parse('http://universities.hipolabs.com/search?name=$query'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        searchResults = data;
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
    searchUniversities(_searchController.text);
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
                SizedBox(
                  height: 20,
                ),
                Text(
                  'University Search',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 35),
                TextField(
                  controller: _searchController,
                  onChanged: (query) {
                    searchUniversities(query);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search for a university...',
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
                final university = searchResults[index];
                return ListTile(
                  title: Text(university['name']),
                  subtitle: Text(university['country']),
                  onTap: (){
                      Navigator.pop(context,university['name']);
                  },
                  // You can add more details about the university
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
