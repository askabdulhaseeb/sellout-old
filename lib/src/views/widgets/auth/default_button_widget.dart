import 'package:flutter/material.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/views/components/components.dart';

class DefaultButtonWidget extends StatelessWidget {
  const DefaultButtonWidget({
    Key? key,
    required this.text,
    required this.function,
    required this.color,
    this.hasBorder = false,
    this.isTextWeightThick = true,
    this.isSmallerHeight = false,
  }) : super(key: key);
  final String text;
  final Function() function;
  final Color color;
  final bool hasBorder;
  final bool isTextWeightThick;
  final bool isSmallerHeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Components.kWidth(context),
      height: isSmallerHeight == false
          ? Components.kHeight(context) * 0.065
          : Components.kHeight(context) * 0.050,
      child: ElevatedButton(
        onPressed: function,
        child: Text(
          text,
          style: Theme.of(context).textTheme.subtitle1?.copyWith(
              fontWeight:
                  isTextWeightThick ? FontWeight.bold : FontWeight.normal,
              color: color == Colors.white ? kPrimaryColor : Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            side: hasBorder
                ? const BorderSide(color: Colors.white)
                : const BorderSide(color: kPrimaryColor),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          primary: color,
          shadowColor: color.withOpacity(1),
        ),
      ),
    );
  }
}
