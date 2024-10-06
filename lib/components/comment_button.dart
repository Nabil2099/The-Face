import 'package:flutter/material.dart';

class CommentButton extends StatelessWidget {
  final void Function()? onPressed;
  const CommentButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), // Reduced corner radius
          color: Colors.transparent,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, // Make the button as small as possible
          children: [
            Icon(
              Icons.comment_outlined,
              color: Colors.grey[600],
              size: 16, // Reduced icon size for better fit
            ),
            const SizedBox(width: 4), // Reduced spacing between icon and text
            Flexible(
              child: Text(
                'Comment',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14, // Reduced font size to fit smaller screens
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
