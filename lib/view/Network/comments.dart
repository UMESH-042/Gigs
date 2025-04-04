import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentBottomSheet extends StatefulWidget {
  final String postId;

  CommentBottomSheet({Key? key, required this.postId}) : super(key: key);

  @override
  _CommentBottomSheetState createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Add a comment',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            _buildCommentInputField(),
            SizedBox(height: 16),
            _buildCommentSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentInputField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.grey[200],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Write your comment...',
                  border: InputBorder.none,
                ),
                maxLines: 3,
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                _postComment();
              },
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Comments',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        _buildCommentCount(),
        SizedBox(height: 8),
        _buildCommentList(),
      ],
    );
  }

  Widget _buildCommentCount() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('comments')
          .where('postId', isEqualTo: widget.postId)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Text('Loading...');
        }

        int commentCount = snapshot.data!.docs.length;
        return Text(
          '$commentCount Comments',
          style: TextStyle(
            fontSize: 16,
          ),
        );
      },
    );
  }

  Color _generateRandomColor(String input) {
    final random = Random(input.hashCode);

    // Generate dark color with a minimum brightness
    Color generateDarkColor() {
      return Color.fromARGB(
        255,
        random.nextInt(100) + 50, // Adjust the minimum brightness here
        random.nextInt(100) + 50, // Adjust the minimum brightness here
        random.nextInt(100) + 50, // Adjust the minimum brightness here
      );
    }

    return generateDarkColor();
  }

  
  Widget _buildCommentList() {
  return StreamBuilder(
    stream: FirebaseFirestore.instance
        .collection('comments')
        .where('postId', isEqualTo: widget.postId)
        .orderBy('timestamp', descending: true)
        .snapshots(),
    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (!snapshot.hasData) {
        return Text('Loading...');
      }

      var comments = snapshot.data!.docs;

      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: comments.length,
        itemBuilder: (context, index) {
          var comment = comments[index];
          var commentText = comment['text'];
          var commentUser = comment['userId'];
          var timestamp = comment['timestamp'] as Timestamp?;

          // Handle null timestamp
          if (timestamp == null) {
            timestamp = Timestamp.now(); // Use current time as a fallback
          }

          Color randomColor = _generateRandomColor(commentUser);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: FutureBuilder(
                  future: _getUsername(commentUser),
                  builder: (context, AsyncSnapshot<String> usernameSnapshot) {
                    if (usernameSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircleAvatar(child: Text(''));
                    } else if (usernameSnapshot.hasError) {
                      return CircleAvatar(child: Text(''));
                    }

                    var username = usernameSnapshot.data ?? 'Unknown User';

                    return CircleAvatar(
                      backgroundColor: randomColor,
                      child: Text(
                        username[0],
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  },
                ),
                title: FutureBuilder(
                  future: _getUsername(commentUser),
                  builder: (context, AsyncSnapshot<String> usernameSnapshot) {
                    if (usernameSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Text('Loading...');
                    } else if (usernameSnapshot.hasError) {
                      return Text('Error loading username');
                    }

                    var username = usernameSnapshot.data ?? 'Unknown User';

                    return Text(
                      username,
                      style: TextStyle(fontSize: 14),
                    );
                  },
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      commentText,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
                trailing: Text(
                  _formatTimestamp(timestamp),
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Divider(thickness: 1, color: Colors.grey),
              SizedBox(height: 8),
            ],
          );
        },
      );
    },
  );
}


  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) {
      return 'Unknown Time';
    }
    var timeAgo = timeago.format(
      timestamp.toDate(),
      allowFromNow: true,
    );
    return timeAgo;
  }

  Future<void> _postComment() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser!;
    final uid = user.uid;

    if (_commentController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('comments').add({
        'postId': widget.postId,
        'userId': uid,
        'text': _commentController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _commentController.clear();
    }
  }

  Future<String> _getUsername(String userId) async {
    var userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists) {
      return userDoc['name'];
    } else {
      return 'Unknown User';
    }
  }
}
