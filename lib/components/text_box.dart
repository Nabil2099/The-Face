import 'package:flutter/material.dart';
class MyTextBox extends StatelessWidget {
  final String sectionTitle;
  final String userName;
  final String details;
  final void Function()? onPressed;
  // ignore: use_key_in_widget_constructors
  //constructor
  const MyTextBox({super.key,
  required this.sectionTitle,
  required this.userName,
  required this.details,
  required this.onPressed
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      child: Column(
            children: [
               Text(details,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,)
              ),
              Row(
                children: [
                  Text(
                    sectionTitle,
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                        )
                  ),
                  SizedBox(width: 10),
                  Text(
                    userName,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 15,
                    ),
                  ),
                  Spacer(),
                  IconButton(onPressed: onPressed,
                      icon: Icon(Icons.settings, color: Theme.of(context).colorScheme.secondary,),)

                ],

              ),
              ]
      ),


    );

  }
}

