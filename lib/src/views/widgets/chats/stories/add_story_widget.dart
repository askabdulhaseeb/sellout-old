import 'package:flutter/material.dart';
import 'package:sellout_team/src/views/components/components.dart';

class AddStoryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_circle_outline,
            size: 25,
            color: Colors.black54,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            'Add story',
            style: Components.kCaption(context)?.copyWith(
              color: Colors.black54,
            ),
          ),
        ],
      ),
      width: Components.kWidth(context) * 0.25,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey,
          //     offset: Offset(0.0, 1.0), //(x,y)
          //     blurRadius: 6.0,
          //   ),
          // ],
          border: Border.all(color: Colors.grey.withOpacity(0.3), width: 2)),
    );
  }
}
