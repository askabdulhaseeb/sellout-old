import 'package:flutter/material.dart';
import 'package:sellout_team/src/constants/constants.dart';

class ChatCircleImageWidget extends StatelessWidget {
  late final double width;
  late final String image;
  final double? radius;
  ChatCircleImageWidget(
      {required this.width, required this.image, this.radius = 25});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      width: width,
      child: CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(
          '$image',
        ),
      ),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: Colors.grey.withOpacity(0.2))),
    );
  }
}
