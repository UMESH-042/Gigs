// // import 'package:flutter/material.dart';

// // class Network extends StatefulWidget {
// //   const Network({super.key});

// //   @override
// //   State<Network> createState() => _NetworkState();
// // }

// // class _NetworkState extends State<Network> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text("Connect to the Network"),
// //       ),
// //       body: Container(
// //         child: Center(
// //           child: Text("Umesh"),
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ViewPostsPage extends StatefulWidget {
//   @override
//   _ViewPostsPageState createState() => _ViewPostsPageState();
// }

// class _ViewPostsPageState extends State<ViewPostsPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('View Posts'),
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection('posts').snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (!snapshot.hasData) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }

//           return ListView.builder(
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (context, index) {
//               DocumentSnapshot post = snapshot.data!.docs[index];
//               return PostCard(post: post);
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// class PostCard extends StatelessWidget {
//   final DocumentSnapshot post;

//   const PostCard({Key? key, required this.post}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.all(8),
//       child: Column(
//         children: [
//           ListTile(
//             title: Text(post['title'] ?? ''),
//             subtitle: Text(post['description'] ?? ''),
//             leading: CircleAvatar(
//               backgroundImage: NetworkImage(post['userImageUrl'] ?? ''),
//             ),
//           ),
//           if (post['imageUrl'] != null)
//             Image.network(
//               post['imageUrl'],
//               width: double.infinity,
//               height: 200,
//               fit: BoxFit.cover,
//             ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               IconButton(
//                 icon: Icon(Icons.thumb_up),
//                 onPressed: () {
//                   // Implement logic for liking the post
//                 },
//               ),
//               IconButton(
//                 icon: Icon(Icons.comment),
//                 onPressed: () {
//                   // Navigate to a page for comments
//                   // You can pass the post ID to the comments page
//                   // and fetch comments related to this post
//                 },
//               ),
//               IconButton(
//                 icon: Icon(Icons.share),
//                 onPressed: () {
//                   // Implement logic for sharing the post
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class CommentsPage extends StatefulWidget {
//   final String postId;

//   CommentsPage({Key? key, required this.postId}) : super(key: key);

//   @override
//   _CommentsPageState createState() => _CommentsPageState();
// }

// class _CommentsPageState extends State<CommentsPage> {
//   @override
//   Widget build(BuildContext context) {
//     // Fetch comments using widget.postId
//     // Implement UI for displaying and adding comments
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Comments'),
//       ),
//       body: Center(
//         child: Text('Comments will be displayed here.'),
//       ),
//     );
//   }
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gigs/Animation/Like_animation.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ViewPostsPage extends StatefulWidget {
  @override
  _ViewPostsPageState createState() => _ViewPostsPageState();
}

class _ViewPostsPageState extends State<ViewPostsPage> {
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot post = snapshot.data!.docs[index];
              return PostCard(post: post);
            },
          );
        },
      ),
    );
  }
}

class PostCard extends StatefulWidget {
  final DocumentSnapshot post;

  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int likesCount = 0;
  int commentsCount = 0;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    _getLikesCount();
    _getCommentsCount();
     _checkIfLiked();
  }

  Future<void> _getLikesCount() async {
    QuerySnapshot likesSnapshot = await FirebaseFirestore.instance
        .collection('likes')
        .where('postId', isEqualTo: widget.post.id)
        .get();

    setState(() {
      likesCount = likesSnapshot.size;
    });
  }

  Future<void> _getCommentsCount() async {
    QuerySnapshot commentsSnapshot = await FirebaseFirestore.instance
        .collection('comments')
        .where('postId', isEqualTo: widget.post.id)
        .get();

    setState(() {
      commentsCount = commentsSnapshot.size;
    });
  }

Future<void> _checkIfLiked() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser!;
    final uid = user.uid;

    QuerySnapshot existingLikes = await FirebaseFirestore.instance
        .collection('likes')
        .where('postId', isEqualTo: widget.post.id)
        .where('userId', isEqualTo: uid)
        .get();

    setState(() {
      isLiked = existingLikes.docs.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Card(
        elevation: 0, // Remove the elevation from Card
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              title: Text(widget.post['title'] ?? ''),
              subtitle: Text(widget.post['description'] ?? ''),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(widget.post['userImageUrl'] ?? ''),
              ),
            ),
            if (widget.post['imageUrl'] != null)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenImage(
                        imageUrl: widget.post['imageUrl'],
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: widget.post['imageUrl'],
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(
                      // child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                LikeButtonAnimation(
                  onTap: _likePost,
                  isLiked: isLiked,
                ),
                Text(likesCount.toString()),
                IconButton(
                  icon: Icon(Icons.comment),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CommentsPage(postId: widget.post.id),
                      ),
                    );
                  },
                ),
                Text(commentsCount.toString()),
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {
                    // Implement logic for sharing the post
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _likePost() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser!;
    final uid = user.uid;

    QuerySnapshot existingLikes = await FirebaseFirestore.instance
        .collection('likes')
        .where('postId', isEqualTo: widget.post.id)
        .where('userId', isEqualTo: uid)
        .get();

    if (existingLikes.docs.isEmpty) {
      await FirebaseFirestore.instance.collection('likes').add({
        'postId': widget.post.id,
        'userId': uid,
      });
    } else {
      // User has already liked the post
      // You can choose to handle this case, or ignore it
    }

    // Update the liked state and refresh likes count
    setState(() {
      isLiked = !isLiked;
      _getLikesCount();
    });
  }
}
//   Future<void> _likePost() async {
//     // Check if the user has already liked the post
//     QuerySnapshot existingLikes = await FirebaseFirestore.instance
//         .collection('likes')
//         .where('postId', isEqualTo: widget.post.id)
//         .where('userId', isEqualTo: 'currentUserId') // replace with actual user ID
//         .get();

//     if (existingLikes.docs.isEmpty) {
//       // User hasn't liked the post yet, add a like
//       await FirebaseFirestore.instance.collection('likes').add({
//         'postId': widget.post.id,
//         'userId': 'currentUserId', // replace with actual user ID
//       });
//       // Refresh likes count
//       _getLikesCount();
//     } else {
//       // User has already liked the post, you can choose to handle this case
//       print('User has already liked this post.');
//     }
//   }
// }

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PhotoViewGallery.builder(
        itemCount: 1,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(imageUrl),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
          );
        },
        scrollPhysics: BouncingScrollPhysics(),
        backgroundDecoration: BoxDecoration(
          color: Colors.black,
        ),
        pageController: PageController(),
      ),
    );
  }
}

class CommentsPage extends StatefulWidget {
  final String postId;

  CommentsPage({Key? key, required this.postId}) : super(key: key);

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('comments')
            .where('postId', isEqualTo: widget.postId)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot comment = snapshot.data!.docs[index];
              return ListTile(
                title: Text(comment['text'] ?? ''),
                subtitle: Text(comment['userId'] ?? ''),
              );
            },
          );
        },
      ),
    );
  }
}
