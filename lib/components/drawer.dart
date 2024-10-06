import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'my_list_tile.dart';
class MyDrawer extends StatelessWidget {
  final user = FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).get();
  final Function()? userProfile;
  final Function()? signOut;
   MyDrawer({super.key,
   required this.userProfile,
   required this.signOut
   });
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black87,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //Body
          Column(
            children: [
              //Header
              DrawerHeader(child:
              Icon(Icons.person, size: 50, color: Colors.white),
              ),
              //Home ListTile
              MyListTile(
                  text: "H O M E",
                  icon: Icons.home,
                  onTap: () => Navigator.pop(context)
              ),
              //Profile ListTile
              MyListTile(
                  text: "P R O F I L E",
                  icon: Icons.person,
                  onTap: userProfile),
              //Chat App ListTile (Coming Soon)
              MyListTile(text: "C H A T",
                  icon: Icons.chat,
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Coming Soon")))
              ),
              //Friends ListTile (Coming Soon)
              MyListTile(text: "F R I E N D S",
                  icon: Icons.people,
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Coming Soon")))
              ),
            ],
          ),
          //Sign Out ListTile
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: MyListTile(
                text: "S I G N O U T",
                icon: Icons.logout_outlined,
                onTap: signOut),
          )




        ],
      ),

    ) ;
  }
}
