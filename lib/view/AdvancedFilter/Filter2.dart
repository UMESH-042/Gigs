import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Ad2FilterPage extends StatefulWidget {
  const Ad2FilterPage({super.key});

  @override
  State<Ad2FilterPage> createState() => _Ad2FilterPageState();
}

class _Ad2FilterPageState extends State<Ad2FilterPage> {
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _subcategoryController = TextEditingController();
  TextEditingController _locationController = TextEditingController();

  double _startValue = 0.0;
  double _endValue = 50000.0;

  List<String> selectedJobTypes = [];
  List<String> selectedCities = [];
  List<String> selectedSpecializations = [];
  String _selectedLastUpdate = 'Recent';
  String _selectedWorkplace = 'On-site';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Filter',
                    style: TextStyle(
                      color: Colors.indigo[900],
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
                ),
                SizedBox(height: 47),
                label('Category'),
                const SizedBox(
                  height: 15,
                ),
                Category(),
                SizedBox(height: 25),
                label('Sub Category'),
                const SizedBox(
                  height: 15,
                ),
                SubCategory(),
                SizedBox(height: 25),
                label('Location'),
                const SizedBox(
                  height: 15,
                ),
                location(),
                SizedBox(height: 25),
                label('Salary'),
                const SizedBox(
                  height: 15,
                ),
                salaryRangeSlider(),
                SizedBox(height: 25),
                label('Job Type'),
                const SizedBox(
                  height: 15,
                ),
                jobTypeChips(),
                SizedBox(height: 25),
                label('Last Update'),
                const SizedBox(
                  height: 15,
                ),
                lastUpdateRadioOptions(),
                SizedBox(
                  height: 25,
                ),
                label('Type of Workplace'),
                const SizedBox(
                  height: 15,
                ),
                workplaceRadioOptions(),
                SizedBox(
                  height: 25,
                ),
                label('City'),
                const SizedBox(
                  height: 15,
                ),
                cityCheckboxOptions(),
                SizedBox(
                  height: 25,
                ),
                label('Specialization'),
                const SizedBox(
                  height: 15,
                ),
                specializationCheckboxOptions(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _categoryController.clear();
                    _subcategoryController.clear();
                    _locationController.clear();
                    _startValue = 0.0;
                    _endValue = 50000.0;
                    selectedJobTypes.clear();
                    selectedCities.clear();
                    selectedSpecializations.clear();
                    _selectedLastUpdate = 'Recent';
                    _selectedWorkplace = 'On-site';
                  });
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text('Reset'),
              ),
              ElevatedButton(
                onPressed: () {
                  Map<String, dynamic> selectedValues = {
                    'category': _categoryController.text,
                    'subCategory': _subcategoryController.text,
                    'location': _locationController.text,
                    'minSalary': _startValue,
                    'maxSalary': _endValue,
                    'jobTypes': selectedJobTypes,
                    'lastUpdate': _selectedLastUpdate,
                    'workplace': _selectedWorkplace,
                    'cities': selectedCities,
                    'specializations': selectedSpecializations,
                  };

                  // Pass the selected values back to the previous screen
                  Navigator.pop(context, selectedValues);
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF130160),
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text('APPLY NOW'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget Category() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('jobs').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator(); // Loading indicator while fetching data
        }

        var categories = <String>{};

        for (var doc in snapshot.data!.docs) {
          var category = doc['category'];
          if (category != null && category is String) {
            categories.add(category);
          }
        }

        List<String> uniqueCategories =
            categories.toList(); // Convert to list to remove duplicates

        return Container(
          height: 55,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: DropdownButtonFormField(
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 20, right: 20),
            ),
            isExpanded: true,
            hint: Text('Select Category'),
            value: _categoryController.text.isNotEmpty
                ? _categoryController.text
                : null,
            onChanged: (String? newValue) {
              setState(() {
                _categoryController.text = newValue ?? '';
              });
            },
            items: uniqueCategories
                .map<DropdownMenuItem<String>>((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget SubCategory() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('jobs').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator(); // Loading indicator while fetching data
        }

        var jobPositions = <String>{};

        for (var doc in snapshot.data!.docs) {
          var jobPosition = doc['jobPosition'];
          if (jobPosition != null && jobPosition is String) {
            jobPositions.add(jobPosition);
          }
        }

        List<String> uniqueJobPositions = jobPositions
            .toSet()
            .toList(); // Convert to set to remove duplicates

        return Container(
          height: 55,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: DropdownButtonFormField(
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 20, right: 20),
            ),
            isExpanded: true,
            hint: Text('Select Sub Category'),
            value: _subcategoryController.text.isNotEmpty
                ? _subcategoryController.text
                : null,
            onChanged: (String? newValue) {
              setState(() {
                _subcategoryController.text = newValue ?? '';
              });
            },
            items: uniqueJobPositions
                .map<DropdownMenuItem<String>>((String jobPosition) {
              return DropdownMenuItem<String>(
                value: jobPosition,
                child: Text(jobPosition),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget location() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('jobs').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        var jobLocations = <String>{};

        for (var doc in snapshot.data!.docs) {
          var jobLocation = doc['jobLocation'];
          if (jobLocation != null && jobLocation is String) {
            jobLocations.add(jobLocation);
          }
        }

        List<String> uniqueJobLocations =
            jobLocations.toSet().toList(); // Remove duplicates

        return Container(
          height: 55,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: DropdownButtonFormField(
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 20, right: 20),
            ),
            isExpanded: true,
            hint: Text('Select Location'),
            value: _locationController.text.isNotEmpty
                ? _locationController.text
                : null,
            onChanged: (String? newValue) {
              setState(() {
                _locationController.text = newValue ?? '';
              });
            },
            items: uniqueJobLocations
                .map<DropdownMenuItem<String>>((String jobLocation) {
              // Split the city name into words
              List<String> words = jobLocation.split(', ');

              // Display the first word before the comma and the last word after the comma
              String displayText = words.isNotEmpty
                  ? '${words.first}, ${words.last}'
                  : jobLocation;

              return DropdownMenuItem<String>(
                value: jobLocation,
                child: Text(displayText),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget label(String label) {
    return Text(
      label,
      style: TextStyle(
        color: Colors.indigo[900]!,
        fontWeight: FontWeight.w600,
        fontSize: 18,
        letterSpacing: 0.2,
      ),
    );
  }

  Widget salaryRangeSlider() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Min:  \$${(_startValue / 1000).toStringAsFixed(1)}K'),
            Text('Max:  \$${(_endValue / 1000).toStringAsFixed(1)}K'),
          ],
        ),
        RangeSlider(
          inactiveColor: Color.fromARGB(255, 211, 211, 211),
          activeColor: Color(0xFFFCA34D),
          values: RangeValues(_startValue, _endValue),
          min: 0,
          max: 50000,
          divisions: 10,
          onChanged: (RangeValues values) {
            setState(() {
              _startValue = values.start;
              _endValue = values.end;
            });
          },
          labels: RangeLabels(
            '\$${(_startValue / 1000).toStringAsFixed(1)}K',
            '\$${(_endValue / 1000).toStringAsFixed(1)}K',
          ),
        ),
      ],
    );
  }

  Widget jobTypeChips() {
    return Center(
      child: Wrap(
        spacing: 6.0,
        children: [
          // buildJobTypeChip("Full Time"),
          // buildJobTypeChip("Part Time"),
          // buildJobTypeChip("Contract"),
          // buildJobTypeChip("Apprenticeship"),
          // buildJobTypeChip("Project-based"),
          buildJobTypeContainer("Full Time"),
          buildJobTypeContainer("Part Time"),
          buildJobTypeContainer("Contract"),
          buildJobTypeContainer("Apprenticeship"),
          buildJobTypeContainer("Project-based"),
        ],
      ),
    );
  }

  Widget buildJobTypeContainer(String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (selectedJobTypes.contains(label)) {
            selectedJobTypes.remove(label);
          } else {
            selectedJobTypes.add(label);
          }
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: selectedJobTypes.contains(label)
              ? Color(0xFFFCA34D)
              : Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16.0,
            color: selectedJobTypes.contains(label)
                ? Colors.white
                : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget lastUpdateRadioOptions() {
    return Column(
      children: <Widget>[
        RadioListTile<String>(
          activeColor: Color(0xFFFCA34D),
          title: const Text('Recent'),
          value: 'Recent',
          groupValue: _selectedLastUpdate,
          onChanged: (String? value) {
            setState(() {
              _selectedLastUpdate = value!;
            });
          },
        ),
        RadioListTile<String>(
          activeColor: Color(0xFFFCA34D),
          title: const Text('Last week'),
          value: 'Last week',
          groupValue: _selectedLastUpdate,
          onChanged: (String? value) {
            setState(() {
              _selectedLastUpdate = value!;
            });
          },
        ),
        RadioListTile<String>(
          activeColor: Color(0xFFFCA34D),
          title: const Text('Last month'),
          value: 'Last month',
          groupValue: _selectedLastUpdate,
          onChanged: (String? value) {
            setState(() {
              _selectedLastUpdate = value!;
            });
          },
        ),
        RadioListTile<String>(
          activeColor: Color(0xFFFCA34D),
          title: const Text('Any time'),
          value: 'Any time',
          groupValue: _selectedLastUpdate,
          onChanged: (String? value) {
            setState(() {
              _selectedLastUpdate = value!;
            });
          },
        ),
      ],
    );
  }

  Widget workplaceRadioOptions() {
    return Column(
      children: <Widget>[
        RadioListTile<String>(
          activeColor: Color(0xFFFCA34D),
          title: const Text('On-site'),
          value: 'On-site',
          groupValue: _selectedWorkplace,
          onChanged: (String? value) {
            setState(() {
              _selectedWorkplace = value!;
            });
          },
        ),
        RadioListTile<String>(
          activeColor: Color(0xFFFCA34D),
          title: const Text('Hybrid'),
          value: 'Hybrid',
          groupValue: _selectedWorkplace,
          onChanged: (String? value) {
            setState(() {
              _selectedWorkplace = value!;
            });
          },
        ),
        RadioListTile<String>(
          activeColor: Color(0xFFFCA34D),
          title: const Text('Remote'),
          value: 'Remote',
          groupValue: _selectedWorkplace,
          onChanged: (String? value) {
            setState(() {
              _selectedWorkplace = value!;
            });
          },
        ),
      ],
    );
  }

  Widget cityCheckboxOptions() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('jobs').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator(); // Loading indicator while fetching data
        }

        var cities = <String>{};

        for (var doc in snapshot.data!.docs) {
          var jobLocation = doc['jobLocation'];
          if (jobLocation != null && jobLocation is String) {
            cities.add(jobLocation);
          }
        }

        return Column(
          children: cities.map((city) {
            // Split the city name into words
            List<String> words = city.split(', ');

            // Display the first word before the comma and the last word after the comma
            String displayText =
                words.isNotEmpty ? '${words.first}, ${words.last}' : city;

            return CheckboxListTile(
              activeColor: Color(0xFFFCA34D),
              title: Text(displayText),
              value: selectedCities.contains(city),
              onChanged: (bool? value) {
                setState(() {
                  if (value != null) {
                    if (value) {
                      selectedCities.add(city);
                    } else {
                      selectedCities.remove(city);
                    }
                  }
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            );
          }).toList(),
        );
      },
    );
  }

  Widget specializationCheckboxOptions() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('jobs').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator(); // Loading indicator while fetching data
        }

        var specializations = <String>{};

        for (var doc in snapshot.data!.docs) {
          var category = doc['category'];
          if (category != null && category is String) {
            specializations.add(category);
          }
        }

        return Column(
          children: specializations.map((specialization) {
            return CheckboxListTile(
              activeColor: Color(0xFFFCA34D),
              title: Text(specialization),
              value: selectedSpecializations.contains(specialization),
              onChanged: (bool? value) {
                setState(() {
                  if (value != null) {
                    if (value) {
                      selectedSpecializations.add(specialization);
                    } else {
                      selectedSpecializations.remove(specialization);
                    }
                  }
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            );
          }).toList(),
        );
      },
    );
  }
}
