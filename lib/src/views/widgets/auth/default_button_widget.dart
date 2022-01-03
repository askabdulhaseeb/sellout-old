import 'package:flutter/material.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/views/components/components.dart';

class DefaultButtonWidget extends StatelessWidget {
  late final String text;
  late final Function() function;
  late final Color color;
  late final bool hasBorder;
  late final isTextWeightThick;
  late final isSmallerHeight;

  DefaultButtonWidget(
      {required this.text,
      required this.function,
      required this.color,
      this.hasBorder = false,
      this.isTextWeightThick = true,
      this.isSmallerHeight = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Components.kWidth(context),
      height: isSmallerHeight == false
          ? Components.kHeight(context) * 0.065
          : Components.kHeight(context) * 0.045,
      child: ElevatedButton(
        onPressed: function,
        child: Text(
          text,
          style: Theme.of(context).textTheme.subtitle1?.copyWith(
              fontWeight:
                  isTextWeightThick ? FontWeight.bold : FontWeight.normal,
              color: color == Colors.white ? kPrimaryColor : Colors.white),

          // Components.kBodyOne(context)?.copyWith(
          //     fontWeight: FontWeight.bold,
          //     color: color == Colors.white ? kPrimaryColor : Colors.white),
        ),
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              side: hasBorder
                  ? BorderSide(color: Colors.white)
                  : BorderSide(color: kPrimaryColor),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            primary: color,
            shadowColor: color.withOpacity(1)),
      ),
    );
  }
}
