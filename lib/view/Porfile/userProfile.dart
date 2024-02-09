import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gigs/view/Network/comments.dart';
import 'package:gigs/view/Porfile/Application_Page.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;

class ProfileScreen extends StatefulWidget {
  final String useremail;

  const ProfileScreen({Key? key, required this.useremail}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String username;
  late String profileImageUrl;
  late String aboutMe;
  List<String> resumeData = [];
  List<String> appreciation = [];
  List<String> education = [];
  List<String> languages = [];
  List<String> skills = [];
  List<String> workExperience = [];
  bool aboutUser = true;
  bool PostsByuser = false;
  bool JobsByUser = false;

  bool isLoading = true;

  List<Map<String, dynamic>> userPosts = [];

  @override
  void initState() {
    super.initState();
    username = '';
    profileImageUrl = '';
    aboutMe = '';
    resumeData = [];
    appreciation = [];
    education = [];
    languages = [];
    skills = [];
    workExperience = [];
    userPosts = [];

    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: widget.useremail)
          .get();

      DocumentSnapshot userProfileSnapshot = await FirebaseFirestore.instance
          .collection('usersProfile')
          .doc(widget.useremail)
          .get();

      QuerySnapshot<Map<String, dynamic>> postsSnapshot =
          await FirebaseFirestore.instance
              .collection('posts')
              .where('email', isEqualTo: widget.useremail)
              .get();

      if (postsSnapshot.docs.isNotEmpty) {
        setState(() {
          userPosts = postsSnapshot.docs.map((doc) => doc.data()).toList();
        });
      } else {
        // Handle case when no posts are found
        print('No posts found for user with email: ${widget.useremail}');
      }

      // Check if data is available
      if (usersSnapshot.docs.isNotEmpty) {
        // Assuming "username" and "profileImageUrl" are fields in the documents
        setState(() {
          username = usersSnapshot.docs[0]['name'];
          profileImageUrl = usersSnapshot.docs[0]['imageUrl'];
        });
      } else {
        // Handle case when no data is found in the "users" collection
        print(
            'No data found in the "users" collection for user with email: ${widget.useremail}');
      }

      setState(() {
        aboutMe = userProfileSnapshot['aboutMe'];
      });

      processField(userProfileSnapshot, 'Resume', (field) {
        setState(() {
          resumeData =
              List<String>.from((field as List).map((e) => e.toString()));
        });
      });

      processField(userProfileSnapshot, 'appreciation', (field) {
        setState(() {
          appreciation =
              List<String>.from((field as List).map((e) => e.toString()));
        });
      });

      processField(userProfileSnapshot, 'education', (field) {
        setState(() {
          education =
              List<String>.from((field as List).map((e) => e.toString()));
        });
      });

      processField(userProfileSnapshot, 'languages', (field) {
        setState(() {
          languages =
              List<String>.from((field as List).map((e) => e.toString()));
        });
      });

      processField(userProfileSnapshot, 'skills', (field) {
        setState(() {
          skills = List<String>.from((field as List).map((e) => e.toString()));
        });
      });

      processField(userProfileSnapshot, 'workExperience', (field) {
        setState(() {
          workExperience =
              List<String>.from((field as List).map((e) => e.toString()));
        });
      });
    } catch (e) {
      // Handle errors
      print('Error fetching user data: $e');
    }
  }

  void processField(DocumentSnapshot snapshot, String fieldName,
      Function(dynamic) processFunction) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

    if (snapshot.exists &&
        data != null &&
        data[fieldName] != null &&
        data[fieldName] is List) {
      processFunction(data[fieldName]);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(aboutMe);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 241, 241, 241),
      appBar: AppBar(
        // title: Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(profileImageUrl),
                radius: 50,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                username,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildButtonForAboutUser(
                    onPressed: () {
                      setState(() {
                        aboutUser = true;
                        PostsByuser = false;
                        JobsByUser = false;
                      });
                    },
                    isSelected: aboutUser,
                  ),
                  _buildButtonForPostsByUser(
                    onPressed: () {
                      setState(() {
                        aboutUser = false;
                        PostsByuser = true;
                        JobsByUser = false;
                      });
                    },
                    isSelected: PostsByuser,
                  ),
                  _buildButtonForJobsByUser(
                    onPressed: () {
                      setState(() {
                        aboutUser = false;
                        PostsByuser = false;
                        JobsByUser = true;
                      });
                    },
                    isSelected: JobsByUser,
                  ),
                  // Add similar buttons for other sections if needed
                ],
              ),
            ),
            if (aboutUser) ...[
              // Display About Me content
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16),
                    Text(
                      'About Me:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      aboutMe != '' ? aboutMe : 'No Data available',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 16),
                    buildDataSection('Appreciation', appreciation),
                    buildDataSection('Education', education),
                    buildDataSection('Languages', languages),
                    buildDataSection('Skills', skills),
                    buildDataSection('Work Experience', workExperience),
                    buildDataSection('Resume Data', resumeData),
                  ],
                ),
              ),
            ],
            if (PostsByuser) ...[
              // Display Posts content
              _buildPosts()
            ],
            if (JobsByUser) ...[
              _buildJobs(),
            ]
          ],
        ),
      ),
    );
  }

  Widget buildDataSection(String title, List<String> data) {
    return data.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Text(
                '$title:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              for (String item in data) Text('- $item'),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Text(
                '$title:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('No Data Available'),
            ],
          );
  }

  Widget _buildButtonForPostsByUser({
    required VoidCallback onPressed,
    required bool isSelected,
  }) {
    return Container(
      width: 100,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        color: isSelected ? Color(0xFFFCA34D) : Colors.white,
      ),
      child: TextButton(
          onPressed: onPressed,
          child: Center(
              child: Text(
            'Posts',
            style: TextStyle(color: isSelected ? Colors.white : Colors.black),
          ))),
    );
  }

  Widget _buildButtonForAboutUser({
    required VoidCallback onPressed,
    required bool isSelected,
  }) {
    return Container(
      width: 100,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        color: isSelected ? Color(0xFFFCA34D) : Colors.white,
      ),
      child: TextButton(
          onPressed: onPressed,
          child: Center(
              child: Text(
            'About Me',
            style: TextStyle(color: isSelected ? Colors.white : Colors.black),
          ))),
    );
  }

  Widget _buildButtonForJobsByUser({
    required VoidCallback onPressed,
    required bool isSelected,
  }) {
    return Container(
      width: 100,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        color: isSelected ? Color(0xFFFCA34D) : Colors.white,
      ),
      child: TextButton(
          onPressed: onPressed,
          child: Center(
              child: Text(
            'Jobs',
            style: TextStyle(color: isSelected ? Colors.white : Colors.black),
          ))),
    );
  }

  Widget _buildPosts() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .where('email', isEqualTo: widget.useremail)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot post = snapshot.data!.docs[index];
            return PostCard(post: post);
          },
        );
      },
    );
  }

  Widget _buildJobs() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('jobs')
            .where('postedBy', isEqualTo: widget.useremail)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No jobs available.'));
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot jobs = snapshot.data!.docs[index];
              print(jobs['jobPosition']);
              print(jobs['company']);
              print(jobs['jobLocation']);
              print(jobs['employmentType']);
              print(jobs['jobDescription']);
              print(jobs['category']);
              print(jobs['timestamp']);
              print(jobs['salary']);
              print(jobs['postedBy']);
              print(jobs['workplaceType']);
              return Column(
                children: [
                  _buildJobsCard(
                      jobs['jobPosition'],
                      jobs['company'],
                      jobs['jobLocation'],
                      jobs['employmentType'],
                      jobs['jobDescription'],
                      jobs['category'],
                      jobs['timestamp'],
                      jobs['salary'],
                      jobs['postedBy'],
                      jobs['workplaceType'], () {
                    saveJob(jobs.data() as Map<String, dynamic>);
                  })
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildJobsCard(
    String jobPosition,
    String company,
    String jobLocation,
    String employmentType,
    String jobDescription,
    String category,
    Timestamp timestamp,
    String salary,
    String postedBy,
    String workplaceType,
    Function() onSavePressed,
  ) {
    print(toTitleCase(jobPosition));
    List<String> locationParts = jobLocation.split(',');

    String firstWordBeforeComma = locationParts.length > 1
        ? locationParts[0].trim().split(' ')[0]
        : jobLocation.trim().split(' ')[0];

    String lastWord = locationParts.last.trim();

    String shortenedLocation = '$firstWordBeforeComma, $lastWord';
    print(shortenedLocation);

    var domain = company.toLowerCase();
    double salaryValue = double.parse(salary);
    String timeAgo = getTimeAgo(timestamp.toDate());
    String formattedSalary = salaryValue > 1000
        ? '\$${(salaryValue / 1000).toString()} K/Mo'
        : '${salaryValue.toInt()}';

    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ApplicationPage(
                jobPosition: jobPosition,
                companyName: company,
                jobDescription: jobDescription,
                employmentType: employmentType,
                category: category,
                postedBy: postedBy,
                salary: salary,
                workplaceType: workplaceType,
                timestamp: timestamp,
                jobLocation: jobLocation,
              ),
            ),
          );
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 16),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                            'https://poweredwith.nyc3.cdn.digitaloceanspaces.com/images/domains/$domain.com.jpg'), // Use company logo URL
                        radius: 30,
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            toTitleCase(jobPosition),
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(company),
                          Text(shortenedLocation),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Wrap(
                    spacing: 8.0,
                    children: [
                      SizedBox(width: 4.0),
                      Chip(label: Text(toTitleCase(jobPosition))),
                      Chip(label: Text(employmentType)),
                      Chip(label: Text(category)),
                      SizedBox(width: 4.0)
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        timeAgo, // Display time ago
                        style: TextStyle(
                            color: const Color.fromARGB(255, 118, 117, 117),
                            fontSize: 13),
                      ),
                      Text(
                        formattedSalary, // Display formatted salary
                        style: TextStyle(
                            color: const Color.fromARGB(255, 16, 16, 16)),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: onSavePressed,
                  child: Icon(
                    Icons.bookmark_border_outlined,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  String getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      // Handle the case when the user is not signed in
      return ''; // or throw an exception, return null, etc.
    }
  }

  void saveJob(Map<String, dynamic> jobDetails) async {
    // Add the current user's ID to the job details
    String currentUserId = getCurrentUserId();
    jobDetails['userId'] = currentUserId;

    // Generate a unique job ID for the saved job
    String jobId = getUniqueJobId(jobDetails); // Implement this function

    // Check if the job is already saved
    if (await isJobSaved(currentUserId, jobId)) {
      // Job is already saved, show a message to the user
      showSnackbar('Job has already been saved!');
    } else {
      // Save the job details in the "savedJobs" collection
      await FirebaseFirestore.instance
          .collection('savedJobs')
          .doc(jobId)
          .set(jobDetails);

      // Notify the user that the job has been saved
      showSnackbar('Job saved successfully!');
    }
  }

  Future<bool> isJobSaved(String userId, String jobId) async {
    // Check if the job with the specified ID is already saved by the user
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('savedJobs')
        .doc(jobId)
        .get();

    return snapshot.exists && snapshot['userId'] == userId;
  }

  void showSnackbar(String message) {
    // Display a Snackbar with the specified message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  String getUniqueJobId(Map<String, dynamic> jobDetails) {
    // Create a unique job ID based on relevant fields
    String jobPosition = jobDetails['jobPosition'];
    String companyName = jobDetails['company'];
    String uniqueKey = '$jobPosition-$companyName';

    String jobId = uniqueKey.hashCode.toUnsigned(30).toString();

    return jobId;
  }

  String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'just now';
    }
  }

  String toTitleCase(String text) {
    return text.replaceAllMapped(
      RegExp(r'\b\w'),
      (match) => match.group(0)!.toUpperCase(),
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
