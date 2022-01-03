import 'package:flutter/material.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/views/components/components.dart';

class TypeMessageContainer extends StatelessWidget {
  late final Function() onAddPressed;
  late final Function() onCameraPressed;
  late final Widget textField;

  TypeMessageContainer(
      {required this.onAddPressed,
      required this.onCameraPressed,
      required this.textField});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Components.kHeight(context) * 0.07,
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.withOpacity(0.4)),
          borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          IconButton(
              onPressed: onAddPressed,
              icon: Icon(
                Icons.add_box,
                color: kPrimaryColor,
                size: 30,
              )),
          Expanded(child: textField),
          IconButton(
              onPressed: onCameraPressed,
              icon: Icon(
                Icons.camera_alt,
                size: 30,
              )),
        ],
      ),
    );
  }
}
