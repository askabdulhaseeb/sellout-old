import 'package:flutter/material.dart';
import 'package:sellout_team/src/blocs/post/post_cubit/post_cubit.dart';
import 'package:sellout_team/src/constants/constants.dart';

class ArrowsIndicators extends StatefulWidget {
  late final PageController controller;
  late final int currentMedia;
  late final bool isLast;

  ArrowsIndicators(
      {required this.controller,
      required this.currentMedia,
      required this.isLast});

  @override
  _ArrowsIndicatorsState createState() => _ArrowsIndicatorsState();
}

class _ArrowsIndicatorsState extends State<ArrowsIndicators> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            print(widget.currentMedia);

            if (widget.isLast == false) {
              widget.controller.nextPage(
                  duration: Duration(seconds: 1),
                  curve: Curves.fastLinearToSlowEaseIn);
            }
          },
          icon: Transform.scale(
            scale: 1.4,
            child: Icon(
              Icons.arrow_back_ios,
              size: 40,
              color: kPrimaryColor,
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            print(widget.currentMedia);
            setState(() {
              if (widget.isLast == false) {
                widget.controller.nextPage(
                    duration: Duration(seconds: 1),
                    curve: Curves.fastLinearToSlowEaseIn);

                print('current ${widget.currentMedia}');
              }
            });
          },
          icon: Transform.scale(
            scale: 1.4,
            child: Icon(
              Icons.arrow_forward_ios,
              size: 40,
              color: kPrimaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
