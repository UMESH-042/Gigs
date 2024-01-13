import 'package:flutter/material.dart';

class JobCategoryScreen extends StatefulWidget {
  @override
  _JobCategoryScreenState createState() => _JobCategoryScreenState();
}

class _JobCategoryScreenState extends State<JobCategoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> allJobCategory = [
    "IT",
    "Health",
    "Finance",
    "Engineering",
    "Sales and Marketing",
    "Education",
    "Customer Service",
    "Human Resources (HR)",
    "Manufacturing and Production",
    "Retail",
    "Hospitality and Tourism",
    "Construction and Architecture",
    "Legal",
    "Media and Communications",
    "Research and Development",
    "Social Services",
    "Transportation and Logistics",
    "Design",
    "Restaurant",
    "Programmer",
    "Telecommunications",
    "Science",
    "Agriculture and Farming",
    "Government and Public Administration",
    "Nonprofit and Volunteering",
    "Energy",
    "Real Estate",
    "Fitness and Wellness",
    "Automotive",
    "Pharmaceutical",
    "Consulting",
    "E-commerce",
  ];
  List<String> filteredJobCategory = [];
  String selectedJobCategory = ''; // To store selected job position

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    filteredJobCategory = allJobCategory;
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredJobCategory = allJobCategory;
      } else {
        filteredJobCategory = allJobCategory
            .where((position) => position.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  void setJobCategory(String category) {
    setState(() {
      selectedJobCategory = category;
      _searchController.text = category; // Populate search field
    });
  }

  void selectJobCategoryAndPop(String category) {
    Navigator.pop(context, category);
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
                  'Job Category',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 35),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search for a job category...',
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          filteredJobCategory = allJobCategory;
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
              itemCount: filteredJobCategory.length,
              itemBuilder: (context, index) {
                final position = filteredJobCategory[index];
                return ListTile(
                  title: Text(position),
                  onTap: () {
                    selectJobCategoryAndPop(position);
                  },
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
