import 'package:flutter/material.dart';
import 'package:sellout_team/src/constants/constants.dart';

class ChatImage extends StatelessWidget {
  late final String content;
  late final double height;
  late final double width;

  ChatImage({
required this.content,
required this.height,
required this.width
  });

  @override
  Widget build(BuildContext context) {
    return Image(
        image: NetworkImage('$content'),
        height: height,
        width: width,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            height: height,
            width: width,
            child: Center(
              child: CircularProgressIndicator(
                color: kPrimaryColor,
                value: progress.expectedTotalBytes != null
                    ? progress.cumulativeBytesLoaded /
                        progress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        });
  }
}
