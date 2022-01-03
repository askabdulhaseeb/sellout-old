import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/views/components/components.dart';
import 'package:sellout_team/src/views/navBar/chat/chat_details/video_view.dart';
import 'package:sellout_team/src/views/navBar/chat/chat_details/view_image.dart';
import 'package:sellout_team/src/views/widgets/images/chat_image.dart';
import 'package:sellout_team/src/views/widgets/video/video_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class CurrentUserMessageWidget extends StatelessWidget {
  late final String content;
  late final bool isPhoto;
  late final bool isVideo;
  late final bool isDoc;

  late final GeoPoint geoPoint;

  CurrentUserMessageWidget(
      {required this.content,
      required this.isPhoto,
      required this.isVideo,
      required this.geoPoint,
      required this.isDoc});
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: contentView(context),
        decoration: BoxDecoration(
          color: isPhoto ? Colors.white : kPrimaryColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
            topLeft: Radius.circular(8),
          ),
        ),
      ),
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
          // to open the location in google maps
          String googleUrl =
              'https://www.google.com/maps/search/?api=1&query=${geoPoint.latitude},${geoPoint.longitude}';
          await _launchURL(googleUrl);
        },
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: [
              Icon(
                Icons.location_on,
                color: Colors.white,
                size: 30,
              ),
              Text(
                'Location',
                style: Components.kBodyOne(context)?.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              // Text(
              //   '${geoPoint.latitude}\n${geoPoint.longitude}',
              //   style: Components.kBodyOne(context)?.copyWith(
              //       color: Colors.white, fontWeight: FontWeight.bold),
              // )
            ],
          ),
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
            // the document will be downloaded
            await _launchURL(content);
          },
          icon: Icon(
            Icons.text_snippet,
            color: Colors.white,
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
          ?.copyWith(color: Colors.white, fontWeight: FontWeight.normal),
    );
  }
}
