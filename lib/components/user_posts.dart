import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newproject/components/comments.dart';
import 'delete_button.dart';
import 'like_button.dart';
import 'comment_button.dart';
import 'package:newproject/helper/helper_methods.dart';

class UserPosts extends StatefulWidget {
  final String username;
  final String post;
  late String postId;
  final List<String> likes;

  UserPosts({
    super.key,
    required this.username,
    required this.post,
    required this.postId,
    required this.likes,
  });

  @override
  State<UserPosts> createState() => _UserPostsState();
}

class _UserPostsState extends State<UserPosts> {
  final TextEditingController _commentController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;
  bool isLiked = false;
  late final DocumentReference postRef;

  // Initialize post reference
  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser!.email);
    postRef = FirebaseFirestore.instance.collection('user_posts').doc(widget.postId);
  }

// Function to toggle like
  void toggleLike() {
    setState(() {
      if (isLiked) {
        postRef.update({'Likes': FieldValue.arrayRemove([currentUser!.email])});
      } else {
        postRef.update({'Likes': FieldValue.arrayUnion([currentUser!.email])});
      }
      isLiked = !isLiked;
    });
  }
// Function to add comment
  void addComment(String commentText) {
    FirebaseFirestore.instance
        .collection("user_posts")
        .doc(widget.postId)
        .collection("Comments")
        .add({
      "Comment": commentText,
      "Commented_By": currentUser!.email,
      "Commented_At": Timestamp.now(),
    });
  }
// Function to show comments dialog
  void showCommentsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Comments"),
        content: TextField(
          controller: _commentController,
          decoration: InputDecoration(
            hintText: "Add a comment",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          // Save button
          TextButton(
            style: TextButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.secondary),
            child: Text("Save"),
            onPressed: () {
              addComment(_commentController.text);
              _commentController.clear();
              Navigator.of(context).pop();
            },
          ),
          // Cancel button
          TextButton(
            style: TextButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.secondary),
            child: Text("Cancel"),
            onPressed: () {
              _commentController.clear();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

// Function to delete post
  void deletePost() {
    showDialog(context: context,
        builder:(context) => AlertDialog(
          title: Text("Delete Post"),
          content: Text("Are you sure you want to delete this post?"),
          actions: [
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.secondary),
              child: Text("Yes"),
              onPressed: () async {
                // Delete all likes
                await postRef.update({'Likes': []});
                // Get all comments
                final comments = await FirebaseFirestore.
                instance.collection("user_posts").doc(widget.postId).
                collection("Comments").get();
                // Delete all comments
                for (var comment in comments.docs) {
                  await FirebaseFirestore.instance.collection("user_posts").
                  doc(widget.postId).
                  collection("Comments").doc(comment.id).delete();
                }
                // Delete post
                await postRef.delete().then((value) => print("Post deleted")).
                catchError((error) => print("Failed to delete post: $error"));
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.secondary),
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ));
  }




  @override
  Widget build(BuildContext context) {
    //the face post
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      padding: const EdgeInsets.all(25),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Username and Post
          Row(
            children: [
              //group of text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.username,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(widget.post),
                ],
              ),
              const Spacer(),
              // Delete button
              if(widget.username == currentUser!.email)
                DeleteButton(
                  onDelete: deletePost,
                )

            ],
          ),
          SizedBox(height: 10),
          // Like and Comment Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                LikeButton(
                  onTap: toggleLike,
                  isLiked: isLiked,
                ),
                const SizedBox(width: 4),
                Text(
                  "${widget.likes.length} Likes",
                ),
                const SizedBox(width: 10),
                CommentButton(
                  onPressed: showCommentsDialog,
                ),
                const SizedBox(width: 5),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("user_posts")
                      .doc(widget.postId)
                      .collection("Comments")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      int commentCount = snapshot.data!.docs.length;
                      return Text("$commentCount Comments");
                    } else {
                      return Text("0 Comments");
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Comments Section
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("user_posts")
                .doc(widget.postId)
                .collection("Comments")
                .orderBy("Commented_At", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Text("No Comments");
              }
              return ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((doc) {
                  final commentData = doc.data() as Map<String, dynamic>;
                  return Comments(
                    text: commentData['Comment'],
                    user: commentData['Commented_By'],
                    time: formatData(commentData['Commented_At']),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}