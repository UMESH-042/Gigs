import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gigs/Animation/Like_animation.dart';
import 'package:gigs/view/Network/comments.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:timeago/timeago.dart' as timeago;

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
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('timestamp', descending: true)
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

class _PostCardState extends State<PostCard> with TickerProviderStateMixin {
  int likesCount = 0;
  int commentsCount = 0;
  bool isLiked = false;

  late AnimationController _likeAnimationController;
  late Animation<double> _likeAnimation;
  void _listenToComments() {
    FirebaseFirestore.instance
        .collection('comments')
        .where('postId', isEqualTo: widget.post.id)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      setState(() {
        commentsCount = snapshot.size;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _likeAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 5),
    );

    _likeAnimation = Tween<double>(begin: 24, end: 30).animate(
      CurvedAnimation(
        parent: _likeAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _getLikesCount();
    // _getCommentsCount();
    _checkIfLiked();
    _listenToComments();
    _listenToLikes();
  }





    Future<void> _listenToLikes() async {
    FirebaseFirestore.instance
        .collection('likes')
        .where('postId', isEqualTo: widget.post.id)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      setState(() {
        likesCount = snapshot.size;
      });
    });
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

  void _showCommentBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return CommentBottomSheet(postId: widget.post.id);
      },
    );
  }

  @override
  void dispose() {
    _likeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Timestamp timestamp = widget.post['timestamp'];
    DateTime postDateTime = timestamp.toDate();

    String timeAgo = timeago.format(postDateTime, locale: 'en');
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            // color: Colors.grey.withOpacity(0.3),
            color: Color(0xFFD6CDFE),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              title: Text(widget.post['userName'] ?? ''),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(timeAgo),
                  SizedBox(height: 15),
                ],
              ),
              leading: CircleAvatar(
                backgroundImage:
                    NetworkImage(widget.post['userImageUrl'] ?? ''),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.post['title'] ?? '',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(widget.post['description'] ?? ''),
                ],
              ),
            ),
            if (widget.post['imageUrl'] != '')
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
                    placeholder: (context, url) => Center(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [],
                ),
              ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Color(0xFFD6CDFE), // Set your desired color here
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _likePost,
                        child: AnimatedBuilder(
                          animation: _likeAnimation,
                          builder: (context, child) {
                            return Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: isLiked ? Colors.red : Colors.grey,
                              size: _likeAnimation.value,
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 4), // Adjust the spacing here
                      Text(likesCount.toString()),
                    ],
                  ),
                  // Text(likesCount.toString()),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.mode_comment_outlined),
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) =>
                          //         CommentsPage(postId: widget.post.id),
                          //   ),
                          // );
                          _showCommentBottomSheet();
                        },
                      ),
                      SizedBox(width: 4), // Adjust the spacing here
                      Text(commentsCount.toString()),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () {
                      // Implement logic for sharing the post
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Future<void> _likePost() async {
  //   final FirebaseAuth auth = FirebaseAuth.instance;
  //   final User user = auth.currentUser!;
  //   final uid = user.uid;

  //   QuerySnapshot existingLikes = await FirebaseFirestore.instance
  //       .collection('likes')
  //       .where('postId', isEqualTo: widget.post.id)
  //       .where('userId', isEqualTo: uid)
  //       .get();

  //   if (existingLikes.docs.isEmpty) {
  //     // If the user hasn't liked the post, add a new like
  //     await FirebaseFirestore.instance.collection('likes').add({
  //       'postId': widget.post.id,
  //       'userId': uid,
  //     });
  //   } else {
  //     // If the user has already liked the post, remove the like
  //     await FirebaseFirestore.instance
  //         .collection('likes')
  //         .doc(existingLikes.docs.first.id)
  //         .delete();
  //   }

  //   // Update the liked state and refresh likes count

  //   // Toggle the like state
  //   setState(() {
  //     _getLikesCount();
  //     isLiked = !isLiked;
  //   });

  //   // Play the like animation
  //   _likeAnimationController.forward(from: 0);
  //   _likeAnimationController.addStatusListener((status) {
  //     if (status == AnimationStatus.completed) {
  //       // _likeAnimationController..reset()..forward();
  //       _likeAnimationController.reset();
  //     }
  //   });
  // }
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
      await FirebaseFirestore.instance
          .collection('likes')
          .doc(existingLikes.docs.first.id)
          .delete();
    }

    // No need to manually update likesCount, it will be updated in real-time

    setState(() {
      isLiked = !isLiked;
    });

    _likeAnimationController.forward(from: 0);
    _likeAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _likeAnimationController.reset();
      }
    });
  }
}

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
