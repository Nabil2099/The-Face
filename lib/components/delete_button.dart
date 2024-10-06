import 'package:flutter/material.dart';
class DeleteButton extends StatelessWidget {
  void Function()? onDelete;
  DeleteButton({super.key,
  required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDelete,
      child: Icon(
        Icons.delete,
        size: 24,
        color: Colors.red,
      ),
    );
  }
}
