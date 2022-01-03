import 'package:flutter/material.dart';
import 'package:sellout_team/src/views/components/components.dart';

class AddMediaContainerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Components.kWidth(context),
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.withOpacity(0.6)
           // width: 0.7
          ), borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
                border: Border.all(width: 1.4)),
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            'Add Images / Videos',
          )
        ],
      ),
    );
  }
}
