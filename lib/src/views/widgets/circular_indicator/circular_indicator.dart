import 'package:flutter/material.dart';
import 'package:sellout_team/src/constants/constants.dart';

class CircularIndicator extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: kPrimaryColor,
      ),
    );
  }
}