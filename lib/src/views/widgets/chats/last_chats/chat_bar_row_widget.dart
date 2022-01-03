import 'package:flutter/material.dart';
import 'package:sellout_team/src/views/components/components.dart';

class ChatBarRowWidget extends StatelessWidget {
  late final Widget imageWidget;
  late final String name;
  late final Widget captionWidget;
  late final Widget endWidget;

  ChatBarRowWidget(
      {required this.name,
      required this.imageWidget,
      required this.captionWidget,
      required this.endWidget});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Components.kHeight(context) * 0.12,
      margin: EdgeInsets.all(8),
      padding: const EdgeInsets.all(10),
      decoration: Components.kElevatedContainer,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          imageWidget,
          const SizedBox(
            width: 5,
          ),
          const SizedBox(
            width: 8,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$name',
                style: Components.kBodyOne(context)
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              captionWidget
            ],
          ),
          Spacer(),
          Padding(padding: const EdgeInsets.only(right: 10), child: endWidget)
        ],
      ),
    );
  }
}
