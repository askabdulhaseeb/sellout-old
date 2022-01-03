import 'package:flutter/material.dart';
import 'package:sellout_team/src/views/components/components.dart';

class SocialMediaLoginButton extends StatelessWidget {
  const SocialMediaLoginButton({
    Key? key,
    required this.text,
    required this.icon,
  }) : super(key: key);
  final String text;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        icon,
        const SizedBox(height: 6),
        Text(
          text,
          style: Components.kCaption(context)?.copyWith(
            color: Colors.black,
          ),
        )
      ],
    );
  }
}
