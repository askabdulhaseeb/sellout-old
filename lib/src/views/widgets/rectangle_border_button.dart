import 'package:flutter/material.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/views/components/components.dart';

class RectangleBorderButttonWidget extends StatelessWidget {
  late final String text;
  late final bool isNotPrimaryColor;
  late final bool isDisabled;
  late final Function() function;

  RectangleBorderButttonWidget(
      {required this.text,
      required this.function,
      this.isNotPrimaryColor = false,
      this.isDisabled = false});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: isDisabled ? null : function,
      disabledColor: Colors.grey,
      color: isNotPrimaryColor ? Colors.white : kPrimaryColor,
      minWidth: double.infinity,
      padding: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Text(
        '$text',
        style: Components.kBodyOne(context)?.copyWith(
            color: isNotPrimaryColor ? kPrimaryColor : Colors.white,
            fontWeight: FontWeight.normal),
      ),
    );
  }
}
