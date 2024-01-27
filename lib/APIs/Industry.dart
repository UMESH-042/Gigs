import 'package:flutter/material.dart';

class IndustryScreen extends StatefulWidget {
  @override
  _IndustryScreenState createState() => _IndustryScreenState();
}

class _IndustryScreenState extends State<IndustryScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> allIndustries = [
    "Technology",
    "Automotive",
    "Financial Services",
    "Retail",
    "Healthcare",
    "Energy",
    "Telecommunications",
    "Aerospace and Defense",
    "Consumer Goods",
    "Entertainment and Media",
    "Internet Products",
    "Transportation and Logistics",
    "Manufacturing",
    "Pharmaceuticals and Biotechnology",
    "Food and Beverage",
    "Renewable Energy",
    "Real Estate and Property Development",
    "Hospitality and Travel",
    "Education and E-learning",
    "Gaming and Entertainment Software",
    "Fitness and Wellness",
    "Social Media",
    "Telecom Equipment",
    "Engineering and Construction",
    "Chemicals",
    "Insurance",
    "Agriculture and Agribusiness",
    "Space Exploration and Technology",
    "Cruise Lines",
    "Fashion and Apparel",
  ];
  List<String> filteredIndustries = [];
  String selectedIndustry = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    filteredIndustries = allIndustries;
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredIndustries = allIndustries;
      } else {
        filteredIndustries = allIndustries
            .where((industry) => industry.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  void setIndustry(String industry) {
    setState(() {
      selectedIndustry = industry;
      _searchController.text = industry; // Populate search field
    });
  }

  void selectIndustryAndPop(String industry) {
    Navigator.pop(context, industry);
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
                  'Industry',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 35),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search for an industry...',
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          filteredIndustries = allIndustries;
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
              itemCount: filteredIndustries.length,
              itemBuilder: (context, index) {
                final industry = filteredIndustries[index];
                return ListTile(
                  title: Text(industry),
                  onTap: () {
                    selectIndustryAndPop(industry);
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
