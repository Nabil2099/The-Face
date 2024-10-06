import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:newproject/components/text_field.dart';
import 'package:newproject/components/buttons.dart';
import 'register_page.dart';
class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({Key? key, this.onTap}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  // signIn function
  void signIn() async {
    //loading
    showDialog(
      context: context,
      builder: (context) => Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.secondary,
        )
      )

    );
    //try to sign in with email and password
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text);
      //pop loading dialog
      if(context.mounted)
        Navigator.of(context).pop();
    }on FirebaseAuthException
      catch(e){
      //pop loading dialog
      Navigator.of(context).pop();
      //display error message
      displayError(e.code);
    }
    }
    //Handle Errors
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
                    Text("The Face", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary),),
                    Icon(Icons.account_circle_outlined, size: 120, color: Theme.of(context).colorScheme.secondary),
                    Text("Sign In", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary),),
                    SizedBox(height: 20),
                    MyTextField(hintText: "Email", controller: emailController, obscureText: false),
                    SizedBox(height: 20),
                    MyTextField(hintText: "Password", controller: passwordController, obscureText: true),
                    SizedBox(height: 20),
                    Buttons(text: "Sign In", onPressed: signIn),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account?"),
                          SizedBox(width: 10),
                          GestureDetector(onTap: widget.onTap, child: Text("Sign Up", style:
                          TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold,)))
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
