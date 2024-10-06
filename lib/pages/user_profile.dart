import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart%20';
import 'package:newproject/components/text_box.dart';

class UserProfile extends StatefulWidget {
  UserProfile({super.key});
  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  final user = FirebaseFirestore.instance.collection('users');

  Future<void> editProfile(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text('Edit $field',
            style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
        content: TextField(
          cursorColor: Theme.of(context).colorScheme.primary,
          autofocus: true,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: 'Enter $field',
            hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
            ),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          TextButton(
            child: Text('Save'),
            style: TextButton.styleFrom(
              textStyle: TextStyle(color: Colors.black),
              backgroundColor: Colors.green,
            ),
            onPressed: () => Navigator.of(context).pop(newValue),
          ),
          TextButton(
            child: const Text('Cancel'),
            style: TextButton.styleFrom(
              textStyle: const TextStyle(color: Colors.white),
              backgroundColor: Colors.red,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );

    // Update user data in Firestore if the new value is not empty
    if (newValue.isNotEmpty) {
      await user.doc(currentUser.email).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.email)
          .snapshots(),
      builder: (context, snapshot) {
        // Get user data from Firestore
        if (snapshot.hasData) {
          final userData = snapshot.data!.data();

          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.primary,
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              title: Text(
                'Profile Page',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(10),
              child: ListView(
                children: [
                  const SizedBox(height: 50),
                  // Profile Image
                  const Icon(Icons.person, size: 80,),

                  // User Details
                  MyTextBox(
                    details: "Profile Details",
                    userName: userData?['username'] ?? 'No Name',
                    sectionTitle: "Name",
                    onPressed: () => editProfile("username"),
                  ),

                  // Bio
                  MyTextBox(
                    details: "Your Bio",
                    sectionTitle: "Bio",
                    userName: userData?['bio'] ?? "Tell Us About Yourself",
                    onPressed: () => editProfile("bio"), // Corrected this line
                  ),

                  // User Posts
                   Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Your Posts",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Something went wrong: ' + snapshot.error.toString()),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
