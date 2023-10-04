import 'dart:convert';
import 'package:gigs/firebase/firebaseService.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class SkillSearchScreen extends StatefulWidget {
  @override
  _SkillSearchScreenState createState() => _SkillSearchScreenState();
}

class _SkillSearchScreenState extends State<SkillSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> searchResults = [];
  List<String> selectedSkills = [];

  Future<void> searchSkill(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }

    final response = await http
        .get(Uri.parse('https://internshala.com/autocomplete/skill/$query'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        searchResults = List<String>.from(data['result']);
      });
    } else {
      // Handle error
    }
  }

  void toggleSkillSelection(String skill) {
    if (selectedSkills.contains(skill)) {
      selectedSkills.remove(skill);
    } else {
      selectedSkills.add(skill);
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    searchSkill(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    print(selectedSkills);
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
                  'Skill Search',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 35),
                TextField(
                  controller: _searchController,
                  onChanged: (query) {
                    searchSkill(query);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search for a skill...',
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
            // child: ListView.builder(
            //   itemCount: searchResults.length,
            //   itemBuilder: (context, index) {
            //     final skill = searchResults[index];
            //     return ListTile(
            //       title: Text(skill),
            //       // You can add more details about the skill
            //     );
            //   },
            // ),
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final skill = searchResults[index];
                final isSelected = selectedSkills.contains(skill);

                return ListTile(
                  title: Text(skill),
                  onTap: () {
                    setState(() {
                      toggleSkillSelection(skill);
                    });
                  },
                  // Highlight selected skills
                  tileColor: isSelected ? Colors.blue.withOpacity(0.3) : null,
                  trailing: isSelected
                      ? Icon(Icons.check)
                      : null, // Checkmark for selected skills
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: selectedSkills.map((skill) {
                return Chip(
                  label: Text(skill),
                  onDeleted: () {
                    setState(() {
                      toggleSkillSelection(skill);
                    });
                  },
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                    // Check if there are selected skills
      if (selectedSkills.isNotEmpty) {
        
        final firestoreService = FirestoreService();

        // Add the selected skills to Firestore
        await firestoreService.addSkills('202151042@iiitvadodara.ac.in', selectedSkills);

        // Navigate back to the previous screen
        Navigator.pop(context);
      }

              },
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
          SizedBox(
            height: 20,
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
