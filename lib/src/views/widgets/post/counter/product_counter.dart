import 'package:flutter/material.dart';
import 'package:sellout_team/src/constants/constants.dart';

class ProductCounter extends StatelessWidget {
  late final String text;
  late final Function() increment;
  late final Function() decrement;

  ProductCounter(
      {required this.text, required this.increment, required this.decrement});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: decrement,
          icon: Icon(
            Icons.remove_circle_outline,
            color: kPrimaryColor,
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(40, 2, 40, 2),
          child: Text('$text'),
        ),
        IconButton(
          onPressed: increment,
          icon: Icon(
            Icons.add_circle,
            color: kPrimaryColor,
          ),
        ),
      ],
    );
  }
}
