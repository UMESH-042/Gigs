import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CompanySearchScreen extends StatefulWidget {
  @override
  _CompanySearchScreenState createState() => _CompanySearchScreenState();
}

class _CompanySearchScreenState extends State<CompanySearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> searchResults = [];
  String selectedCompany = '';

  Future<void> searchCompanies(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }

    final response = await http.get(
      Uri.parse(
          'https://api-private.thecompaniesapi.com/v1/companies?search=$query&simplified=true&size=5'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final companies = data['companies'] as List<dynamic>;
      print(companies);
      setState(() {
        searchResults = companies;
      });
    } else {
      print("error");
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    searchCompanies(_searchController.text);
  }

  void setCompany(String company) {
    setState(() {
      selectedCompany = company;
      _searchController.text = company; // Populate search field
    });
  }

  void selectCompanyAndPop(String company) {
    Navigator.pop(context, company);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black, // Set icon color to black
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Center(
            child: Text(
              'Company',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (query) {
                searchCompanies(query);
              },
              decoration: InputDecoration(
                hintText: 'Search for a company...',
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
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final company = searchResults[index];
                final companyname = company['name'];
                var domain = company['domain'];
                final lowercaseCompanyName = companyname.toLowerCase();

                if (lowercaseCompanyName == 'google') {
                  domain = 'google.com';
                }

                return ListTile(
                  onTap: () {
                    print(company['name']);
                    selectCompanyAndPop(company['name'] ?? '');
                  },
                  title: Text(company['name']),
                  subtitle: company['industryMain'] != null
                      ? Text('Company . ${company['industryMain']}')
                      : null,
                  leading: Image.network(
                    'https://poweredwith.nyc3.cdn.digitaloceanspaces.com/images/domains/$domain.jpg',
                    width: 40,
                    height: 40,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.network(
                          'https://www.haliburtonforest.com/wp-content/uploads/2017/08/placeholder-square.jpg');
                    },
                  ),
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
