import 'package:flutter/material.dart';
class Buttons extends StatelessWidget {
  String text;
  Function() onPressed;
  Buttons({
    required this.text,
    required this.onPressed,
});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: MaterialButton(
        elevation: 5,
        onPressed: onPressed,
        child: Text(text, style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
        color: Color.fromRGBO(34, 52, 73, 1.0),
        textColor: Colors.white,
        padding: const EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),),
      ),
      margin: const EdgeInsets.all(16.0),
    );
  }
}
