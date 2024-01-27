import 'package:flutter/material.dart';
import 'package:gigs/APIs/Industry.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:velocity_x/velocity_x.dart';

class CompanyDetailsPage extends StatefulWidget {
  @override
  _CompanyDetailsPageState createState() => _CompanyDetailsPageState();
}

class _CompanyDetailsPageState extends State<CompanyDetailsPage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _aboutcompanyController = TextEditingController();
  final TextEditingController _websitelinkController = TextEditingController();
  final TextEditingController _industryController = TextEditingController();
  final TextEditingController _employeesizedController =
      TextEditingController();
  final TextEditingController _headofficeController = TextEditingController();
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
          'https://api.thecompaniesapi.com/v1/companies?search=$query&simplified=true&size=5'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final companies = data['companies'] as List<dynamic>;
      setState(() {
        searchResults = companies;
      });
    } else {
      print("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
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
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              'Add Company Detail',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40),
            label('Company'),
            const SizedBox(
              height: 12,
            ),
            companySearch(),
            SizedBox(height: 20),
            label('About Company'),
            const SizedBox(
              height: 12,
            ),
            AboutCompany(),
            SizedBox(height: 20),
            label('Website'),
            const SizedBox(
              height: 12,
            ),
            WebsiteLink(),
            SizedBox(
              height: 20,
            ),
            label('Industry'),
            const SizedBox(
              height: 12,
            ),
            Industry(),
            SizedBox(
              height: 20,
            ),
            label('Employee Size'),
            const SizedBox(
              height: 12,
            ),
            EmployeeSize(),
            SizedBox(
              height: 20,
            ),
            label('Head Office'),
            const SizedBox(height: 12,),
            HeadOffice(),
            SizedBox(height: 20,),
              
            ElevatedButton(
              onPressed: () {
                // Validate and save the company details to Firebase
                // Example: SaveDataToFirebase();
                Navigator.pop(context); // Navigate back after saving
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _aboutcompanyController.dispose();
    _searchController.dispose();
    _employeesizedController.dispose();
    _industryController.dispose();
    _websitelinkController.dispose();
    _headofficeController.dispose();
    super.dispose();
  }

  Widget label(String label) {
    return Text(label,
        style: TextStyle(
          color: Colors.indigo[900]!,
          fontWeight: FontWeight.w600,
          fontSize: 17.5,
          letterSpacing: 0.2,
        ));
  }

  Widget AboutCompany() {
    return Container(
      height: 155,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _aboutcompanyController,
        maxLines: null,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 17,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Write additional information here",
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 17),
          contentPadding: EdgeInsets.only(left: 20, right: 20),
        ),
      ),
    ).py12();
  }

  Widget companySearch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (query) {
              searchCompanies(query);
            },
            decoration: InputDecoration(
              labelText: 'Search for a company...',
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear, color: Colors.grey),
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    searchResults = [];
                  });
                },
              ),
              border: InputBorder.none,
            ),
          ),
        ),
        SizedBox(height: 16),
        if (searchResults.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Search Results:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              for (var company in searchResults)
                ListTile(
                  leading: Image.network(
                    'https://poweredwith.nyc3.cdn.digitaloceanspaces.com/images/domains/${company['domain']}.jpg',
                    width: 40,
                    height: 40,
                    errorBuilder: (context, error, stackTrace) {
                      if (error is http.ClientException &&
                          error.message.contains('403')) {
                        return Image.network(
                          'https://www.haliburtonforest.com/wp-content/uploads/2017/08/placeholder-square.jpg',
                          width: 40,
                          height: 40,
                        );
                      } else {
                        return Image.network(
                          'https://www.haliburtonforest.com/wp-content/uploads/2017/08/placeholder-square.jpg',
                          width: 40,
                          height: 40,
                        );
                      }
                    },
                  ),
                  title: Text(company['name'] ?? ''),
                  onTap: () {
                    setState(() {
                      selectedCompany = company['name'] ?? '';
                      _searchController.text = selectedCompany;
                      searchResults = []; // Clear search results
                    });
                  },
                ),
              SizedBox(height: 16),
            ],
          ),
      ],
    );
  }

  Widget WebsiteLink() {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _websitelinkController,
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
    );
  }

  Widget Industry() {
    return GestureDetector(
      onTap: () async {
        final selectedValue = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => IndustryScreen()),
        );

        if (selectedValue != null) {
          setState(() {
            _industryController.text =
                selectedValue; // Set the selected value in your controller
          });
        }
      },
      child: Container(
        height: 55,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: IgnorePointer(
          child: TextFormField(
            controller: _industryController,
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

  Widget EmployeeSize() {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: _employeesizedController,
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
    );
  }

  Widget HeadOffice() {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _headofficeController,
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
    );
  }
}
