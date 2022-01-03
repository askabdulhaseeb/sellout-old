import 'package:flutter/material.dart';
import 'package:sellout_team/src/views/components/components.dart';

class TabBarDivider extends StatelessWidget {
  late final IconData icon;

  TabBarDivider(this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: Components.kHeight(context) * 0.079 +
            MediaQuery.of(context).padding.bottom,
        padding: EdgeInsets.all(0),
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border(
                right: BorderSide(
                    color: Colors.grey.withOpacity(0.2),
                    width: 1,
                    style: BorderStyle.solid))),
        child: Tab(
          icon: Icon(icon, size: 35),
        ));
  }
}
