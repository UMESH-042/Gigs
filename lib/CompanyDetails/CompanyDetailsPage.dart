// import 'dart:ffi';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gigs/APIs/Company_Type.dart';
import 'package:gigs/APIs/Industry.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:velocity_x/velocity_x.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class CompanyDetailsPage extends StatefulWidget {
  @override
  _CompanyDetailsPageState createState() => _CompanyDetailsPageState();
}

class _CompanyDetailsPageState extends State<CompanyDetailsPage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _aboutcompanyController = TextEditingController();
  final TextEditingController _websitelinkController = TextEditingController();
  final TextEditingController _industryController = TextEditingController();
  final TextEditingController _employeesizeController = TextEditingController();
  final TextEditingController _headofficeController = TextEditingController();
  final TextEditingController _companytypeController = TextEditingController();
  final TextEditingController _sinceController = TextEditingController();
  final TextEditingController _specializationController =
      TextEditingController();
  List<dynamic> searchResults = [];
  String selectedCompany = '';
  List<XFile> _imageList = [];

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

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imageList.add(image);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 243, 243),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.pop(context); // Navigate back
        //   },
        // ),
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
            const SizedBox(
              height: 12,
            ),
            HeadOffice(),
            SizedBox(
              height: 20,
            ),
            label('Company Type'),
            const SizedBox(
              height: 12,
            ),
            CompanyType(),
            SizedBox(
              height: 20,
            ),
            label('Since'),
            const SizedBox(height: 12),
            Since(),
            SizedBox(
              height: 20,
            ),
            label('Specialization'),
            const SizedBox(
              height: 12,
            ),
            Specialization(),
            SizedBox(
              height: 20,
            ),
            label('Company Gallery'),
            const SizedBox(
              height: 12,
            ),
            ImageUpload(),
            SizedBox(
              height: 20,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _saveDetails();
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
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _aboutcompanyController.dispose();
    _searchController.dispose();
    _employeesizeController.dispose();
    _industryController.dispose();
    _websitelinkController.dispose();
    _headofficeController.dispose();
    _companytypeController.dispose();
    _sinceController.dispose();
    _specializationController.dispose();
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
        controller: _employeesizeController,
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

  Widget CompanyType() {
    return GestureDetector(
      onTap: () async {
        final selectedValue = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CompanyTypeScreen()),
        );

        if (selectedValue != null) {
          setState(() {
            _companytypeController.text =
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
            controller: _companytypeController,
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

  Widget Since() {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        keyboardType: TextInputType.number,
        maxLength: 4,
        controller: _sinceController,
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

  Widget Specialization() {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _specializationController,
        maxLines: null,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 17,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Write Specializations of the company here",
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 17),
          contentPadding: EdgeInsets.only(left: 20, right: 20),
        ),
      ),
    ).py12();
  }

  Widget ImageUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton.icon(
          onPressed: _pickImage,
          icon: Icon(Icons.add_a_photo),
          label: Text('Add Image'),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            backgroundColor:
                MaterialStateProperty.all<Color>(Color(0xFF130160)),
            shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(20.0), // Adjust the radius as needed
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        if (_imageList.isNotEmpty)
          Column(
            children: [
              Text(
                'Selected Images:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _imageList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        _viewImage(index);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(_imageList[index].path),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  icon: Icon(Icons.cancel),
                                  onPressed: () {
                                    setState(() {
                                      _imageList.removeAt(index);
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
      ],
    );
  }

  void _viewImage(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ImageViewScreen(imagePath: _imageList[index].path),
      ),
    );
  }

  Future<void> _saveDetails() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Saving company details...'),
            ],
          ),
        );
      },
    );
    try {
      // Get the current user ID (assuming you have user authentication)
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      final firebase_storage.Reference storageReference = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('company_images');

      // Check if user ID is available
      if (userId != null) {
        // Create a reference to the Firestore collection
        CollectionReference companies =
            FirebaseFirestore.instance.collection('companies');
        List<String> imageUrls = [];
        for (int i = 0; i < _imageList.length; i++) {
          //   final String imageName = 'image_$i.jpg';
          //   final firebase_storage.UploadTask uploadTask = storageReference
          //       .child(imageName)
          //       .putFile(File(_imageList[i].path));

          //   await uploadTask.whenComplete(() async {
          //     final imageUrl =
          //         await storageReference.child(imageName).getDownloadURL();
          //     imageUrls.add(imageUrl);
          //   });
          // }
          final String imageName =
              'image_${DateTime.now().millisecondsSinceEpoch}.jpg';
          final firebase_storage.UploadTask uploadTask = storageReference
              .child(imageName)
              .putFile(File(_imageList[i].path));

          await uploadTask.whenComplete(() async {
            final imageUrl =
                await storageReference.child(imageName).getDownloadURL();
            imageUrls.add(imageUrl);
          });
        }
        print(imageUrls);
        // Add a new document with a unique ID
        await companies.add({
          'userId': userId,
          'companyName': _searchController.text,
          'aboutCompany': _aboutcompanyController.text,
          'websiteLink': _websitelinkController.text,
          'industry': _industryController.text,
          'employeeSize': _employeesizeController.text,
          'headOffice': _headofficeController.text,
          'companyType': _companytypeController.text,
          'since': _sinceController.text,
          'specialization': _specializationController.text,
          'imageUrls': imageUrls,
          'timestamp': FieldValue.serverTimestamp(), // Add a timestamp
        });
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        // Show a success m essage
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Company details saved successfully!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        // Navigator.pop(context);
      }
    } catch (e) {
      // Show an error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to save company details. Please try again.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}

class ImageViewScreen extends StatelessWidget {
  final String imagePath;

  const ImageViewScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Image.file(
          File(imagePath),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
