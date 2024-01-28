import 'package:flutter/material.dart';

class CompanyTypeScreen extends StatefulWidget {
  @override
  _CompanyTypeScreenState createState() => _CompanyTypeScreenState();
}

class _CompanyTypeScreenState extends State<CompanyTypeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> allCompanyTypes = [
    "Public Company",
    "Private Company",
    "Limited Liability Company (LLC)",
    "Sole Proprietorship",
    "Partnership",
    "Corporation",
    "Nonprofit Organization",
    "Cooperative",
    "Joint Venture",
    "Franchise",
    "Holding Company",
    "Subsidiary",
    "Multinational Company",
  ];
  List<String> filteredCompanyTypes = [];
  String selectedCompanyType = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    filteredCompanyTypes = allCompanyTypes;
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredCompanyTypes = allCompanyTypes;
      } else {
        filteredCompanyTypes = allCompanyTypes
            .where((type) => type.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  void setCompanyType(String type) {
    setState(() {
      selectedCompanyType = type;
      _searchController.text = type; // Populate search field
    });
  }

  void selectCompanyTypeAndPop(String type) {
    Navigator.pop(context, type);
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
                  'Company Type',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 35),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search for a company type...',
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          filteredCompanyTypes = allCompanyTypes;
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
              itemCount: filteredCompanyTypes.length,
              itemBuilder: (context, index) {
                final type = filteredCompanyTypes[index];
                return ListTile(
                  title: Text(type),
                  onTap: () {
                    selectCompanyTypeAndPop(type);
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
