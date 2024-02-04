import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gigs/view/Chats/ChatRoom.dart';
import 'package:shimmer/shimmer.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserEmail;
  const ChatScreen({Key? key, required this.currentUserEmail})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  late Stream<QuerySnapshot> _usersStream;
  TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _usersList = [];
  List<Map<String, dynamic>> searchResults = [];
  bool isLoading = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _usersStream = FirebaseFirestore.instance.collection('users').snapshots();
    WidgetsBinding.instance.addObserver(this);
    setStatus("Online");

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  void setStatus(String status) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      "status": status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //Online
      setStatus("online");
    } else {
      //Offline
      setStatus("Offline");
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void onSearch() async {
    setState(() {
      isLoading = true;
    });

    // Simulating an asynchronous search
    await Future.delayed(Duration(seconds: 2));

    // Perform the search in the database based on the searched email
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .where('name', isEqualTo: _searchController.text)
            .get();

    setState(() {
      searchResults.clear();

      if (querySnapshot.size > 0) {
        // Retrieve the name from the search result and add it to the searchResults list
        final Map<String, dynamic> userMap = querySnapshot.docs[0].data();
        searchResults.insert(0, userMap);
      }

      isLoading = false;
    });
  }

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  void openChatRoom(DocumentSnapshot user) {
    Map<String, dynamic> userMap = user.data() as Map<String, dynamic>;
    String roomId = chatRoomId(
      widget.currentUserEmail,
      userMap['email'],
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatRoomScreen(
          chatRoomId: roomId,
          currentUserEmail: widget.currentUserEmail,
          otherUserEmail: userMap['email'],
          userMap: userMap,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 249, 250, 251),
      appBar: AppBar(
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 235, 237, 240),
        elevation: 0,
        // leading: IconButton(
        //   icon: Icon(
        //     Icons.arrow_back_ios,
        //     color: Colors.black,
        //   ),
        //   onPressed: () {

        //   },
        // ),
        title: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              if (value.isNotEmpty) {
                onSearch();
              }
            },
            decoration: InputDecoration(
              hintText: 'Search User',
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search),
              contentPadding: EdgeInsets.all(10.0),
            ),
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: isLoading
          ? ShimmerList()
          : Column(
              children: [
                SizedBox(height: 20),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _usersStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      _usersList = snapshot.data!.docs;

                      _usersList.removeWhere(
                          (user) => user['email'] == widget.currentUserEmail);

                      if (_searchController.text.isNotEmpty) {
                        _usersList = _usersList
                            .where((user) => user['name']
                                .toLowerCase()
                                .contains(_searchController.text.toLowerCase()))
                            .toList();
                      }

                      return ListView.builder(
                        itemCount: _usersList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final user = _usersList[index];
                          final userName = user['name'];
                          final userEmail = user['email'];
                          final imageUrl = user['imageUrl'];
                          final userType = user['userType'];

                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 16.0,
                            ),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: ListTile(
                                onTap: () => openChatRoom(user),
                                // leading: CircleAvatar(
                                //   backgroundImage: NetworkImage(imageUrl),
                                // ),
                                leading: imageUrl != null
                                    ? CachedNetworkImage(
                                        imageUrl: imageUrl,
                                        placeholder: (context, url) =>
                                            Container(
                                          width: 60,
                                          height: 60,
                                          color: Colors.white,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                CircleAvatar(
                                          backgroundImage: imageProvider,
                                          radius: 30.0,
                                        ),
                                      )
                                    : CircleAvatar(
                                        backgroundColor: Colors.grey[400],
                                        child: Icon(Icons.person,
                                            color: Colors.white),
                                      ),
                                title: userType == 'admin'
                                    ? Text(userName + '(Admin)')
                                    : Text(userName),
                                subtitle: Text(userEmail),
                                // Other user details can be displayed here
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

// class ShimmerEffect extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;

//     return Container(
//       width: screenWidth,
//       height: screenHeight,
//       child: Shimmer.fromColors(
//         baseColor: Colors.grey,
//         highlightColor: Colors.grey,
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               SizedBox(height: 20),
//               Container(
//                 width: screenWidth * 0.8,
//                 height: 40,
//                 color: Colors.white,
//               ),
//               SizedBox(height: 10),
//               Container(
//                 width: screenWidth * 0.6,
//                 height: 20,
//                 color: Colors.white,
//               ),
//               SizedBox(height: 20),
//               Container(
//                 width: screenWidth * 0.9,
//                 height: 150,
//                 color: Colors.white,
//               ),
//               SizedBox(height: 20),
//               Container(
//                 width: screenWidth * 0.7,
//                 height: 30,
//                 color: Colors.white,
//               ),
//               SizedBox(height: 10),
//               Container(
//                 width: screenWidth * 0.5,
//                 height: 20,
//                 color: Colors.white,
//               ),
//               SizedBox(height: 20),
//               Container(
//                 width: screenWidth * 0.8,
//                 height: 80,
//                 color: Colors.white,
//               ),
//               SizedBox(height: 20),
//               Container(
//                 width: screenWidth * 0.7,
//                 height: 30,
//                 color: Colors.white,
//               ),
//               SizedBox(height: 10),
//               Container(
//                 width: screenWidth * 0.4,
//                 height: 20,
//                 color: Colors.white,
//               ),
//               SizedBox(height: 20),
//               Container(
//                 width: screenWidth * 0.9,
//                 height: 120,
//                 color: Colors.white,
//               ),
//               SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 120.0,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }
}
