// import 'package:flutter/material.dart';

// class LanguageSearchScreen extends StatefulWidget {
//   @override
//   _LanguageSearchScreenState createState() => _LanguageSearchScreenState();
// }

// class _LanguageSearchScreenState extends State<LanguageSearchScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   List<String> searchResults = [];
// List<String> languages = [
//   "English",
//   "Spanish",
//   "French",
//   "German",
//   "Chinese",
//   "Arabic",
//   "Russian",
//   "Japanese",
//   "Portuguese",
//   "Italian",
//   "Dutch",
//   "Korean",
//   "Swedish",
//   "Turkish",
//   "Polish",
//   "Danish",
//   "Norwegian",
//   "Finnish",
//   "Greek",
//   "Hungarian",
//   "Czech",
//   "Thai",
//   "Hindi",
//   "Bengali",
//   "Swahili",
//   "Hebrew",
//   "Vietnamese",
//   "Indonesian",
//   "Malay",
//   "Tagalog",
//   "Romanian",
//   "Ukrainian",
//   "Persian",
//   "Urdu",
//   "Bulgarian",
//   "Croatian",
//   "Slovak",
//   "Slovenian",
//   "Serbian",
//   "Estonian",
//   "Latvian",
//   "Lithuanian",
//   "Icelandic",
//   "Irish",
//   "Scottish Gaelic",
//   "Welsh",
//   "Fijian",
//   "Maori",
//   "Samoan",
//   "Tongan",
//   "Hawaiian",
//   "Navajo",
//   "Cherokee",
//   "Inuktitut",
//   "Yoruba",
//   "Zulu",
//   "Swedish",
//   "Kurdish",
//   "Tamil",
//   "Punjabi",
//   "Gujarati",
//   "Marathi",
//   "Kannada",
//   "Telugu",
//   "Malayalam",
//   "Sinhala",
//   "Nepali",
//   "Tibetan",
//   "Burmese",
//   "Khmer",
//   "Lao",
//   "Mongolian",
//   "Uzbek",
//   "Kazakh",
//   "Turkmen",
//   "Tajik",
//   "Azerbaijani",
//   "Georgian",
//   "Armenian",
//   "Kyrgyz",
//   "Tatar",
//   "Bashkir",
//   "Chechen",
//   "Chuvash",
//   "Udmurt",
//   "Mari",
//   "Moksha",
//   "Erzya",
//   "Komi",
//   "Karelian",
//   "Sami",
//   "Estonian",
//   "Latvian",
//   "Lithuanian",
//   "Belarusian",
//   "Moldovan",
//   "Albanian",
//   "Macedonian",
//   "Bosnian",
//   "Montenegrin",
//   "Kosovan",
//   "Luxembourgish",
//   "Esperanto",
//   "Interlingua",
//   "Esperanto",
//   "Interlingua",
//   "Klingon",
//   "Pirate Speak",
//   "Esperanto",
//   "Interlingua",
//   "Klingon",
//   "Pirate Speak",
//   "Pig Latin"
// ];

//   void searchLanguage(String query) {
//     if (query.isEmpty) {
//       setState(() {
//         searchResults = [];
//       });
//       return;
//     }

//     final filteredLanguages = languages
//         .where(
//             (language) => language.toLowerCase().contains(query.toLowerCase()))
//         .toList();

//     setState(() {
//       searchResults = filteredLanguages;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _searchController.addListener(_onSearchChanged);
//   }

//   void _onSearchChanged() {
//     searchLanguage(_searchController.text);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color.fromARGB(255, 241, 241, 241),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         iconTheme: IconThemeData(color: Colors.black),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context); // Navigate back
//           },
//         ),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Text(
//                   'Language Search',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 35),
//                 TextField(
//                   controller: _searchController,
//                   onChanged: (query) {
//                     searchLanguage(query);
//                   },
//                   decoration: InputDecoration(
//                     hintText: 'Search for a language...',
//                     prefixIcon: Icon(Icons.search),
//                     suffixIcon: IconButton(
//                       icon: Icon(Icons.clear),
//                       onPressed: () {
//                         _searchController.clear();
//                         setState(() {
//                           searchResults = [];
//                         });
//                       },
//                     ),
//                     filled: true,
//                     fillColor: Colors.white,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(20.0),
//                       borderSide: BorderSide.none,
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: searchResults.length,
//               itemBuilder: (context, index) {
//                 final language = searchResults[index];
//                 return ListTile(
//                   title: Text(language),
//                   // You can add more details about the language
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _searchController.removeListener(_onSearchChanged);
//     _searchController.dispose();
//     super.dispose();
//   }
// }

import 'package:flutter/material.dart';
import 'package:gigs/firebase/firebaseService.dart';

class LanguageSearchScreen extends StatefulWidget {
  final String userEmail;

  const LanguageSearchScreen({super.key, required this.userEmail});

  @override
  _LanguageSearchScreenState createState() => _LanguageSearchScreenState();
}

class _LanguageSearchScreenState extends State<LanguageSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> searchResults = [];
  List<String> selectedLanguages = [];
  List<String> languages = [
    "English",
    "Spanish",
    "French",
    "German",
    "Chinese",
    "Arabic",
    "Russian",
    "Japanese",
    "Portuguese",
    "Italian",
    "Dutch",
    "Korean",
    "Swedish",
    "Turkish",
    "Polish",
    "Danish",
    "Norwegian",
    "Finnish",
    "Greek",
    "Hungarian",
    "Czech",
    "Thai",
    "Hindi",
    "Bengali",
    "Swahili",
    "Hebrew",
    "Vietnamese",
    "Indonesian",
    "Malay",
    "Tagalog",
    "Romanian",
    "Ukrainian",
    "Persian",
    "Urdu",
    "Bulgarian",
    "Croatian",
    "Slovak",
    "Slovenian",
    "Serbian",
    "Estonian",
    "Latvian",
    "Lithuanian",
    "Icelandic",
    "Irish",
    "Scottish Gaelic",
    "Welsh",
    "Fijian",
    "Maori",
    "Samoan",
    "Tongan",
    "Hawaiian",
    "Navajo",
    "Cherokee",
    "Inuktitut",
    "Yoruba",
    "Zulu",
    "Swedish",
    "Kurdish",
    "Tamil",
    "Punjabi",
    "Gujarati",
    "Marathi",
    "Kannada",
    "Telugu",
    "Malayalam",
    "Sinhala",
    "Nepali",
    "Tibetan",
    "Burmese",
    "Khmer",
    "Lao",
    "Mongolian",
    "Uzbek",
    "Kazakh",
    "Turkmen",
    "Tajik",
    "Azerbaijani",
    "Georgian",
    "Armenian",
    "Kyrgyz",
    "Tatar",
    "Bashkir",
    "Chechen",
    "Chuvash",
    "Udmurt",
    "Mari",
    "Moksha",
    "Erzya",
    "Komi",
    "Karelian",
    "Sami",
    "Estonian",
    "Latvian",
    "Lithuanian",
    "Belarusian",
    "Moldovan",
    "Albanian",
    "Macedonian",
    "Bosnian",
    "Montenegrin",
    "Kosovan",
    "Luxembourgish",
    "Esperanto",
    "Interlingua",
    "Esperanto",
    "Interlingua",
    "Klingon",
    "Pirate Speak",
    "Esperanto",
    "Interlingua",
    "Klingon",
    "Pirate Speak",
    "Pig Latin"
  ];

  void searchLanguage(String query) {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }

    final filteredLanguages = languages
        .where(
            (language) => language.toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      searchResults = filteredLanguages;
    });
  }

  void toggleLanguageSelection(String language) {
    if (selectedLanguages.contains(language)) {
      setState(() {
        selectedLanguages.remove(language);
      });
    } else {
      setState(() {
        selectedLanguages.add(language);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    searchLanguage(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    print(widget.userEmail);
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
                  'Language Search',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 35),
                TextField(
                  controller: _searchController,
                  onChanged: (query) {
                    searchLanguage(query);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search for a language...',
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
                final language = searchResults[index];
                final isSelected = selectedLanguages.contains(language);

                return ListTile(
                  title: Text(language),
                  onTap: () {
                    toggleLanguageSelection(language);
                  },
                  // Highlight selected languages
                  // tileColor: isSelected ? Colors.blue.withOpacity(0.3) : null,
                  tileColor: isSelected?Color(0xFF130160).withOpacity(0.3):null,
                  trailing: isSelected
                      ? Icon(Icons.check)
                      : null, // Checkmark for selected languages
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: selectedLanguages.map((language) {
                return Chip(
                  label: Text(language),
                  onDeleted: () {
                    toggleLanguageSelection(language);
                  },
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                if (selectedLanguages.isNotEmpty) {
                  final firestoreService = FirestoreService();

                  // Add the selected skills to Firestore
                  await firestoreService.addLanguages(
                      widget.userEmail, selectedLanguages);
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
