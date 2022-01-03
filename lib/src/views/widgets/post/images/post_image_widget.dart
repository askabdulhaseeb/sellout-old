import 'package:flutter/material.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/views/components/components.dart';

class PostImageWidget extends StatelessWidget {
  late final String image;
  PostImageWidget(this.image);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Container(
        child: Image(
          image: NetworkImage('$image'),
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return Container(
              height: Components.kHeight(context) * 0.4,
              width: Components.kWidth(context),
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
          },
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
