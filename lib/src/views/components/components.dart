import 'package:flutter/material.dart';
import 'package:sellout_team/src/constants/constants.dart';

class Components {
  static TextStyle? kBodyOne(context) => Theme.of(context).textTheme.bodyText1;

  static TextStyle? kHeadLineFour(context) =>
      Theme.of(context).textTheme.headline4;

  static TextStyle? kHeadLineFive(context) =>
      Theme.of(context).textTheme.headline5;

  static TextStyle? kHeadLineSix(context) =>
      Theme.of(context).textTheme.headline6;

  static TextStyle? kCaption(context) => Theme.of(context).textTheme.caption;

  static double kHeight(context) => MediaQuery.of(context).size.height;
  static double kWidth(context) => MediaQuery.of(context).size.width;

  static navigateTo(context, widget) =>
      Navigator.push(context, MaterialPageRoute(builder: (context) => widget));

  static navigateAndRemoveUntil(context, widget) =>
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => widget), (route) => false);

  static const BottomNavigationBarThemeData kNavBarStyle =
      BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    showSelectedLabels: false,
    showUnselectedLabels: false,
    selectedItemColor: kPrimaryColor,
    unselectedItemColor: Colors.black,
    selectedIconTheme: IconThemeData(size: 35),
    unselectedIconTheme: IconThemeData(size: 35),
  );

  static const AppBarTheme kAppBarTheme =
      AppBarTheme(elevation: 0.0, color: Colors.white);

  static const Divider kDivider = Divider(color: Colors.white);

  static const Divider kTextFieldDivider = Divider(color: Colors.black38);

  static const VerticalDivider kVerticalDivider = VerticalDivider(
    color: Colors.white,
  );

  static kSnackBar(context, String text, {bool isSuccess = false}) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isSuccess ? Colors.green[400] : Colors.red,
        content: Text(
          text,
          textAlign: TextAlign.center,
          style: Components.kBodyOne(context)?.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  static BoxDecoration kElevatedContainer = BoxDecoration(
    borderRadius: BorderRadius.circular(8.0),
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        blurRadius: 2.0,
        spreadRadius: 0.0,
        offset: const Offset(2.0, 2.0), // shadow direction: bottom right
      )
    ],
  );

  static List<StatelessWidget> kTabs = [
    const Tab(icon: Icon(Icons.account_box, size: 35)),
    const Tab(icon: Icon(Icons.groups, size: 35)),
    const Tab(icon: Icon(Icons.phone, size: 35)),
  ];
}
