import 'package:flutter/material.dart';
class MyTextField extends StatelessWidget {
   String hintText;
   TextEditingController controller;
   bool obscureText;
  MyTextField({
    required this.hintText,
    required this.controller,
    this.obscureText = false,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextFormField(
        cursorColor: Colors.black,
        style: TextStyle(color: Colors.black),
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding:  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          fillColor: Colors.grey,
          filled: true,
          hintStyle: TextStyle(color: Colors.black),
          errorStyle: TextStyle(color: Colors.red),
          prefixIcon: Icon(
            Icons.person,
            color: Colors.black,
          ),
          suffixIcon: Icon(Icons.lock, color: Colors.black),

            ),
      ),
    );
  }
}

class PostTextField extends StatelessWidget {
  String hintText;
  TextEditingController controller;
  bool obscureText;
  Function()? onTap;
  PostTextField({
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: TextFormField(
        onTap: onTap,
        cursorColor: Theme.of(context).colorScheme.secondary,
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).colorScheme.primary,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          hintText: hintText,
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
            borderRadius: BorderRadius.circular(25),
          )
        ),
      ),
    );
  }
}
