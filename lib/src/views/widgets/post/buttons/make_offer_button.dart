import 'package:flutter/material.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/views/components/components.dart';

class MakeOfferButton extends StatelessWidget {
  late final Function() function;
  MakeOfferButton(this.function);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: function,
      color: kPrimaryColor,
      elevation: 5.0,
      padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Text(
        'Make Offer',
        style: Components.kHeadLineSix(context)
            ?.copyWith(color: Colors.white, fontWeight: FontWeight.normal),
      ),
    );
  }
}
