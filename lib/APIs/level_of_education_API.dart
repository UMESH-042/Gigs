
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class DegreeLevelSearchScreen extends StatefulWidget {
  @override
  _DegreeLevelSearchScreenState createState() =>
      _DegreeLevelSearchScreenState();
}

class _DegreeLevelSearchScreenState extends State<DegreeLevelSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> searchResults = [];

  Future<void> searchDegreeLevel(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }

    final response = await http.get(
        Uri.parse('https://internshala.com/autocomplete/degree/$query'));

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
    searchDegreeLevel(_searchController.text);
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
                  'Degree Level Search',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 35),
                TextField(
                  controller: _searchController,
                  onChanged: (query) {
                    searchDegreeLevel(query);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search for a degree level...',
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
                final degreeLevel = searchResults[index];
                return ListTile(
                  title: Text(degreeLevel),
                  onTap: (){
                     
                    Navigator.pop(context,degreeLevel);
                  },
                  // You can add more details about the degree level
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