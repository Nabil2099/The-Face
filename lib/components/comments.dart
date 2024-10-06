import 'package:flutter/material.dart ';

class Comments extends StatelessWidget {
  final String text;
  final String user;
  final String time;
  const Comments({super.key,
  required this.text,
  required this.user,
  required this.time});


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        border: Border(
          top: BorderSide(color: Colors.grey, width: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary)),
            Text(time, style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
            Text(text, style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
          ],
            )
      ),
    ) ;
  }
}
