import 'package:flutter/material.dart';
import 'package:sellout_team/src/constants/constants.dart';

class RemoveMediaWidget extends StatelessWidget {
  late final Function() function;
  RemoveMediaWidget({required this.function});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: IconButton(
          onPressed: function,
          icon: CircleAvatar(
              backgroundColor: kPrimaryColor,
              child: Icon(
                Icons.remove,
                color: Colors.white,
              ))),
    );
  }
}
