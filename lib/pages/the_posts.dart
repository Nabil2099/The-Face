import 'package:flutter/material.dart';
class Posts extends StatefulWidget {
  const Posts({super.key});

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Posts",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.secondary,
            letterSpacing: 1.5,
            fontFamily: 'Montserrat'
          )
                  ),
      ),
    );
  }
}

// IconButton(
// onPressed: () {
// if (postController.text.isNotEmpty) {
// userPosts.add({
// 'username': currentUser.email,
// 'post': postController.text,
// 'TimeStamp': Timestamp.now(),
// 'Likes': [],
// });
// postController.clear();
// } else {
// ScaffoldMessenger.of(context).showSnackBar(
// const SnackBar(
// content: Text("Please enter a post"),
// ),
// );
// }
// },
// icon: Icon(
// Icons.add_box_rounded,
// color: Theme.of(context).colorScheme.secondary,
// ),
// ),