// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:gigs/view/Network/Network.dart';

// class CommentBottomSheet extends StatefulWidget {
//   final String postId;

//   CommentBottomSheet({Key? key, required this.postId}) : super(key: key);

//   @override
//   _CommentBottomSheetState createState() => _CommentBottomSheetState();
// }

// class _CommentBottomSheetState extends State<CommentBottomSheet> {
//   TextEditingController _commentController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text(
//               'Add a comment',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 8),
//             TextField(
//               controller: _commentController,
//               decoration: InputDecoration(
//                 hintText: 'Write your comment...',
//               ),
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 _postComment();
//               },
//               child: Text('Post Comment'),
//             ),
//             SizedBox(height: 16),
//             _buildCommentSection(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCommentSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         Text(
//           'Comments',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         SizedBox(height: 8),
//         _buildCommentCount(),
//         SizedBox(height: 8),
//         _buildCommentList(),
//       ],
//     );
//   }

//   Widget _buildCommentCount() {
//     return StreamBuilder(
//       stream: FirebaseFirestore.instance
//           .collection('comments')
//           .where('postId', isEqualTo: widget.postId)
//           .snapshots(),
//       builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//         if (!snapshot.hasData) {
//           return Text('Loading...');
//         }

//         int commentCount = snapshot.data!.docs.length;
//         return Text(
//           '$commentCount Comments',
//           style: TextStyle(
//             fontSize: 16,
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildCommentList() {
//     return StreamBuilder(
//       stream: FirebaseFirestore.instance
//           .collection('comments')
//           .where('postId', isEqualTo: widget.postId)
//           .snapshots(),
//       builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//         if (!snapshot.hasData) {
//           return Text('Loading...');
//         }

//         var comments = snapshot.data!.docs;

//         //       return ListView.builder(
//         //         shrinkWrap: true,
//         //         itemCount: comments.length,
//         //         itemBuilder: (context, index) {
//         //           var comment = comments[index];
//         //           var commentText = comment['text'];
//         //           var commentUser = comment['userId'];

//         //           return ListTile(
//         //             title: Text(commentText),
//         //             subtitle: Text('User: $commentUser'),
//         //           );
//         //         },
//         //       );
//         //     },
//         //   );
//         // }
//         return ListView.builder(
//           shrinkWrap: true,
//           itemCount: comments.length,
//           itemBuilder: (context, index) {
//             var comment = comments[index];
//             var commentText = comment['text'];
//             var commentUser = comment['userId'];

//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Display username
//                 FutureBuilder(
//                   future: _getUsername(commentUser),
//                   builder: (context, AsyncSnapshot<String> usernameSnapshot) {
//                     if (usernameSnapshot.connectionState ==
//                         ConnectionState.waiting) {
//                       return Text('Loading...');
//                     } else if (usernameSnapshot.hasError) {
//                       return Text('Error loading username');
//                     }

//                     var username = usernameSnapshot.data ?? 'Unknown User';

//                     return Text(
//                       username,
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     );
//                   },
//                 ),
//                 // Display comment text
//                 Text(commentText),
//                 SizedBox(height: 8),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }

//   Future<void> _postComment() async {
//     final FirebaseAuth auth = FirebaseAuth.instance;
//     final User user = auth.currentUser!;
//     final uid = user.uid;

//     if (_commentController.text.isNotEmpty) {
//       await FirebaseFirestore.instance.collection('comments').add({
//         'postId': widget.postId,
//         'userId': uid,
//         'text': _commentController.text,
//         'timestamp': FieldValue.serverTimestamp(),
//       });

//       _commentController.clear();
//        // Clear the text field after posting a comment
//     }
//   }

//   Future<String> _getUsername(String userId) async {
//     var userDoc =
//         await FirebaseFirestore.instance.collection('users').doc(userId).get();

//     if (userDoc.exists) {
//       return userDoc['name'];
//     } else {
//       return 'Unknown User';
//     }
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
            ElevatedButton(
              onPressed: () {
                _postComment();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // Use a color that fits your theme
              ),
              child: Text(
                'Post Comment',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 16),
            _buildCommentSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentInputField() {
    return TextField(
      controller: _commentController,
      decoration: InputDecoration(
        hintText: 'Write your comment...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      maxLines: 3,
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

  Widget _buildCommentList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('comments')
          .where('postId', isEqualTo: widget.postId)
          .orderBy('timestamp', descending: false)
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

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display username
                FutureBuilder(
                  future: _getUsername(commentUser),
                  builder: (context, AsyncSnapshot<String> usernameSnapshot) {
                    if (usernameSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Text('Loading...');
                    } else if (usernameSnapshot.hasError) {
                      return Text('Error loading username');
                    }

                    var username = usernameSnapshot.data ?? 'Unknown User';

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        username,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
                // Display comment text
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(commentText),
                ),
                SizedBox(height: 8),
              ],
            );
          },
        );
      },
    );
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
