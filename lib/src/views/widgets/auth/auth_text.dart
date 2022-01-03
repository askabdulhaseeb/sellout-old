import 'package:flutter/material.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/views/components/components.dart';

class AuthText extends StatelessWidget {
  late final String sentence;
  late final String text;
  late final Function() function;

  AuthText({
    required this.sentence , required this.text , required this.function
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$sentence',
          style: Components.kBodyOne(context),
        ),
        InkWell(
          onTap: function,
          child: Text(
            '$text',
            style: Theme.of(context).textTheme.bodyText2?.copyWith(
                color: kPrimaryColor,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline),
          ),
        )
      ],
    );
  }
}
