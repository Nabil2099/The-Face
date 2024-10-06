import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newproject/components/text_box.dart';

class UserProfile extends StatefulWidget {
  UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final user = FirebaseFirestore.instance.collection('users');

  File? _image; // To store the picked image
  final ImagePicker _picker = ImagePicker();

  Future<void> editProfile(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text('Edit $field',
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold)),
        content: TextField(
          cursorColor: Theme.of(context).colorScheme.primary,
          autofocus: true,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: 'Enter $field',
            hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.secondary),
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

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      // Upload image to Firebase Storage
      await uploadImageToFirebase();
    }
  }

  Future<void> uploadImageToFirebase() async {
    if (_image == null) return;

    try {
      // Create a reference to the Firebase Storage location
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child(currentUser.email! + '.jpg');

      // Upload the file to Firebase Storage
      await storageRef.putFile(_image!);

      // Get the URL of the uploaded image
      final imageUrl = await storageRef.getDownloadURL();

      // Save the URL to Firestore
      await user.doc(currentUser.email).update({'profilePicture': imageUrl});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile picture updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
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
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: const Offset(0, 3), // changes position of shadow
                        ),
                      ]
                        ,
                        shape: BoxShape.circle,
                        border: Border.all(
                          style: BorderStyle.solid,
                            color: Theme.of(context).colorScheme.secondary,
                            width: 2)),
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: pickImage, // Call the pickImage function when tapped
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: userData?['profilePicture'] != null
                            ? NetworkImage(userData!['profilePicture'])
                            : null,
                        child: userData?['profilePicture'] == null
                            ? Icon(
                                Icons.person,
                                size: 80,
                                color: Theme.of(context).colorScheme.secondary,
                              )
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
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
                    onPressed: () => editProfile("bio"),
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
