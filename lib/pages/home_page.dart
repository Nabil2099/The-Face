import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newproject/components/buttons.dart';
import 'package:newproject/components/drawer.dart';
import 'package:newproject/components/text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:newproject/components/user_posts.dart';
import 'user_profile.dart';
import 'package:newproject/main.dart';
import 'the_posts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Firebase collection for posts
  final userPosts = FirebaseFirestore.instance.collection('user_posts');
  final currentUser = FirebaseAuth.instance.currentUser!;
  final TextEditingController postController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 2,
        shadowColor: Theme.of(context).colorScheme.secondary,
        centerTitle: true,
        title:  Text(
          'The Face',
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            icon: Icon(
              color: Theme.of(context).colorScheme.secondary,
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              MyApp.of(context)?.toggleTheme();
            },
          ),
        ],
      ),
      drawer: MyDrawer(
        signOut: () => FirebaseAuth.instance.signOut(),
        userProfile: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserProfile(),
            ),
          );
        },
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: PostButton(
                      onPressed:
                      () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => Posts())),
                      text: "What's on your mind?",
                        ),
                    ),
                ],
              ),
              Expanded(
                child: StreamBuilder(
                  stream: userPosts.orderBy(
                    "TimeStamp",
                    descending: false,
                  ).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final post = snapshot.data!.docs[index].data();
                          return UserPosts(
                            username: post['username'],
                            post: post['post'],
                            likes: List.from(post['Likes'] ?? []),
                            postId: snapshot.data!.docs[index].id,
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Text("Something went wrong: ${snapshot.error}");
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
