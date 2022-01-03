import 'package:flutter/material.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/views/components/components.dart';

class SendingItemsWidget extends StatelessWidget {
  late final IconData icon;
  late final String text;
  late final Function() function;

  SendingItemsWidget({required this.icon, required this.text , required this.function});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: Container(
        height: Components.kHeight(context) * 0.065,
        child: Row(
          children: [
            Icon(
              icon,
              color: kPrimaryColor,
            ),
            Components.kVerticalDivider,
            Text(
              '$text',
              style: Components.kBodyOne(context),
            ),
          ],
        ),
      ),
    );
  }
}
