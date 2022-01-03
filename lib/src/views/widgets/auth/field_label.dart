import 'package:flutter/material.dart';
import 'package:sellout_team/src/views/components/components.dart';

class FieldLabel extends StatelessWidget {
  late final String text;

  FieldLabel({
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '$text'.toUpperCase(),
      style:
          Components.kBodyOne(context)?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}
