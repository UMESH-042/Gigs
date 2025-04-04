import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class PostPage extends StatefulWidget {
  final String useremail;
  const PostPage({super.key, required this.useremail});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  String _userImageUrl = "";
  String _userName = "";
  String _imageUrl = "";

  TextEditingController _posttitlecontroller = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  bool _isImageUploading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: widget.useremail)
          .get()
          .then((querySnapshot) => querySnapshot.docs.first);

      if (userDoc.exists) {
        String userImageUrl = userDoc['imageUrl'] ?? "";
        String userName = userDoc['name'] ?? "";
        setState(() {
          _userImageUrl = userImageUrl;
          _userName = userName;
        });
      }
    } catch (e) {
      print("Error occurred while loading user data: $e");
    }
  }

  Future<void> _uploadImage(ImageSource source) async {
    setState(() {
      _isImageUploading = true;
    });
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        String imageName = Uuid().v1(); // Generate a unique name for the image
        Reference storageRef =
            FirebaseStorage.instance.ref().child('images/$imageName.jpg');
        UploadTask uploadTask = storageRef.putFile(imageFile);
        TaskSnapshot taskSnapshot = await uploadTask;
        String imageUrl = await taskSnapshot.ref.getDownloadURL();
        setState(() {
          _imageUrl = imageUrl;
        });
      }
    } catch (e) {
      print("Error uploading image: $e");
    } finally {
      setState(() {
        _isImageUploading = false;
      });
    }
  }

  Future<void> _post() async {
    try {
      String postTitle = _posttitlecontroller.text;
      String description = _descriptionController.text;

      if (postTitle.isNotEmpty && description.isNotEmpty) {
        await FirebaseFirestore.instance.collection('posts').add({
          'title': postTitle,
          'description': description,
          'imageUrl': _imageUrl,
          'userImageUrl': _userImageUrl,
          'userName': _userName,
          'email': widget.useremail,
          'timestamp': FieldValue.serverTimestamp(),
        });

        print("Post Added Successfully!!");

        // Clear the text fields and image URL after posting
        _posttitlecontroller.clear();
        _descriptionController.clear();
        setState(() {
          _imageUrl = "";
        });
        await Future.delayed(
            Duration(milliseconds: 500)); // Adjust the delay time as needed

        Navigator.pop(context); // Navigate after the delay
        // Optionally, you can show a success message or navigate to a different page
      } else {
        print("Please fill in all the details");
      }
    } catch (e) {
      print("Error posting: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isImageUploading) {
      return Center(
        child: CircularProgressIndicator(), // or any other loading widget
      );
      
    } else {
      return Scaffold(
        backgroundColor: Color.fromARGB(255, 241, 241, 241),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          actions: [
            TextButton(
              onPressed: () {
                // Handle the "Post" button action
                _post();
              },
              child: Text(
                "Post",
                style: TextStyle(color: Color(0xFFFCA34D), fontSize: 17),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8), // Add horizontal padding
                  child: Text(
                    "Add Post",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 35),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8), // Add horizontal padding
                      child: CachedNetworkImage(
                        imageUrl: _userImageUrl,
                        imageBuilder: (context, imageProvider) => CircleAvatar(
                          backgroundImage: imageProvider,
                          radius: 30,
                        ),
                        placeholder: (context, url) => CircleAvatar(
                          backgroundColor: Colors.grey[300],
                          radius: 30,
                        ),
                        errorWidget: (context, url, error) => CircleAvatar(
                          backgroundColor: Colors.grey[300],
                          radius: 30,
                          child: Icon(
                            Icons.circle,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Text(
                      _userName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      label("Post title"),
                      const SizedBox(
                        height: 15,
                      ),
                      PostTitle(),
                      const SizedBox(
                        height: 20,
                      ),
                      label("Description"),
                      const SizedBox(
                        height: 15,
                      ),
                      Description(),
                      if (_imageUrl.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    child: Image.network(
                                      _imageUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
                              );
                            },
                            child: Image.network(
                              _imageUrl,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        resizeToAvoidBottomInset:
            true, // This property ensures content adjustment when the keyboard is displayed.

        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        // Handle taking a photo and attaching it to the post
                        _uploadImage(ImageSource.camera); // For camera
                      },
                      icon: Icon(Icons.camera_alt),
                      color: Color(0xFFFCA34D),
                    ),
                    IconButton(
                      onPressed: () {
                        _uploadImage(ImageSource.gallery);
                      },
                      icon: Icon(Icons.photo),
                      color: Color(0xFFFCA34D),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    // Handle adding hashtags
                  },
                  child: Text(
                    "Add Hashtag",
                    style: TextStyle(color: Color(0xFFFCA34D)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget label(String label) {
    return Text(label,
        style: TextStyle(
          color: Colors.indigo[900]!,
          fontWeight: FontWeight.w600,
          fontSize: 16.5,
          letterSpacing: 0.2,
        ));
  }

  Widget PostTitle() {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        // color: Color.fromARGB(255, 56, 47, 47),
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _posttitlecontroller,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 17,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Write the title of your post here",
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 17),
          contentPadding: EdgeInsets.only(left: 20, right: 20),
        ),
      ),
    );
  }

  Widget Description() {
    return Container(
      height: 155,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        // color: Color.fromARGB(255, 56, 47, 47),
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _descriptionController,
        maxLines: null,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 17,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "What do you want to talk about?",
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 17),
          contentPadding: EdgeInsets.only(left: 20, right: 20),
        ),
      ),
    ).py12();
  }
}
