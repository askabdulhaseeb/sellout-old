import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/views/components/components.dart';
import 'package:sellout_team/src/views/navBar/chat/chat_details/video_view.dart';
import 'package:sellout_team/src/views/navBar/chat/chat_details/view_image.dart';
import 'package:sellout_team/src/views/widgets/images/chat_image.dart';
import 'package:sellout_team/src/views/widgets/video/video_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class OtherUserMessageWidget extends StatelessWidget {
  late final String recieverUserImage;
  late final String content;
  late final bool isPhoto;
  late final bool isVideo;
  late final bool isDoc;
  late final GeoPoint geoPoint;

  OtherUserMessageWidget(
      {required this.recieverUserImage,
      required this.content,
      required this.isPhoto,
      required this.isVideo,
      required this.geoPoint,
      required this.isDoc});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
              shape: BoxShape.circle),
          child: CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage('$recieverUserImage'),
          ),
        ),
        const SizedBox(
          width: 2,
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: contentView(context),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 2.0,
                spreadRadius: 0.0,
                offset: Offset(2.0, 2.0), // shadow direction: bottom right
              )
            ],
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  _launchURL(String content) async {
    final url = '$content';
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (error) {
      print(error.toString());
    }
  }

  Widget contentView(BuildContext context) {
    if (geoPoint.latitude != 0) {
      return InkWell(
        onTap: () async {
          String googleUrl =
              'https://www.google.com/maps/search/?api=1&query=${geoPoint.latitude},${geoPoint.longitude}';
          await _launchURL(googleUrl);
        },
        child: Column(
          children: [
            Icon(
              Icons.location_on,
              color: kPrimaryColor,
              size: 40,
            ),
            Text(
              'Location',
              style: Components.kBodyOne(context)
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }
    if (isPhoto) {
      return InkWell(
          onTap: () => Components.navigateTo(context, ViewImage(content)),
          child: content.isEmpty
              ? Icon(Icons.error)
              : ChatImage(
                  content: content,
                  height: Components.kHeight(context) * 0.3,
                  width: Components.kWidth(context) * 0.6,
                ));
    }
    if (isDoc) {
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: IconButton(
          onPressed: () async {
            await _launchURL(content);
            //  Components.navigateTo(context, DocView(content));
          },
          icon: Icon(
            Icons.text_snippet,
            color: kPrimaryColor,
            size: 40,
          ),
        ),
      );
    }
    if (isVideo) {
      return InkWell(
        onTap: () {
          Components.navigateTo(context, VideoView(content));
        },
        child: Container(
            width: Components.kHeight(context) * 0.2,
            child: VideoWidget(content)),
      );
    }

    return Text(
      '$content',
      textAlign: TextAlign.end,
      style: Components.kBodyOne(context)
          ?.copyWith(color: kPrimaryColor, fontWeight: FontWeight.normal),
    );
  }
}
