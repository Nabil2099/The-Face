import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:newproject/components/text_field.dart';
import 'package:newproject/components/buttons.dart';
import 'login_page.dart';
class RegisterPage extends StatefulWidget {
  final Function()? on_tap;
  RegisterPage({Key? key, this.on_tap}) : super(key: key);
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //UsersDb
  final usersDb = FirebaseFirestore.instance.collection('users');
  //Controllers
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  void signUp() async {
    //circle progress indicator
    showDialog(
        context: context,
        builder: (context) => Center(
        child: CircularProgressIndicator(
          color: Colors.black,
        )
    ));
    //Confirm password
    if(passwordController.text!= confirmPasswordController.text){
      Navigator.pop(context);
      displayError("Passwords do not match");
      return;
    }
//Create user
    try{
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text);
      //after Create user, add user to database
      usersDb.doc(userCredential.user!.email).set({
        'username': usernameController.text,
        'bio':"Empty bio.....",
        'email': emailController.text,
        'password': passwordController.text,
      });
      //pop progress indicator
      Navigator.pop(context);
      //clear controllers
      usernameController.clear();
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();
      //go to login page
    }on FirebaseAuthException catch(e){
      //pop progress indicator
      Navigator.pop(context);
      //display error message
      displayError(e.code);
      return;
    }
  }
  //display error message
  void displayError(String error) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Text(error)
        ));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Column(
                  children: [
                    SizedBox(height: 100),
                    Text("The Face", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),),
                    Icon(Icons.account_circle_outlined, size: 120, color: Colors.black),
                    Text("Create an account", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),),
                    SizedBox(height: 20),
                    MyTextField(hintText: "Username", controller: usernameController),
                    SizedBox(height: 20),
                    MyTextField(hintText: "Email", controller: emailController),
                    SizedBox(height: 20),
                    MyTextField(hintText: "Password", controller: passwordController, obscureText: true),
                    SizedBox(height: 20),
                    MyTextField(hintText: "Confirm Password", controller: confirmPasswordController, obscureText: true),
                    SizedBox(height: 20),
                    Buttons(text: "Register", onPressed: signUp,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account?"),
                        SizedBox(width: 10),
                        GestureDetector(onTap: widget.on_tap, child: Text("Login", style:
                        TextStyle(color: Colors.black, fontWeight: FontWeight.bold,)))
                      ],
                    )
                  ],
                ),



              ],
            ),
          ),
        ),
      ),
    );
  }
}
