import 'package:flutter/material.dart';
class LikeButton extends StatelessWidget {
  //Data
  bool isLiked;
  void Function()? onTap;
  LikeButton({super.key,
  required this.onTap,
  required this.isLiked,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        size: 35,
        isLiked? Icons.favorite : Icons.favorite_border,
        color: isLiked? Colors.red : Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
