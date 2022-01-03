import 'package:flutter/material.dart';
import 'package:sellout_team/src/views/components/components.dart';

class SocialMediaLoginButton extends StatelessWidget {
  late final String text;
  late final Icon icon;

  SocialMediaLoginButton({
    required this.text,
    required this.icon,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(8),
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 2.0,
              spreadRadius: 0.0,
              offset: Offset(2.0, 2.0), // shadow direction: bottom right
            )
          ],
        ),
        child: Column(
          children: [
            icon,
            const SizedBox(
              height: 6,
            ),
            Text(
              '$text',
              style:
                  Components.kCaption(context)?.copyWith(color: Colors.black),
            )
          ],
        ));
  }
}
