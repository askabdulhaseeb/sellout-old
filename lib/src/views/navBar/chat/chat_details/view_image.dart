import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sellout_team/src/views/components/components.dart';
import 'package:sellout_team/src/views/widgets/images/chat_image.dart';

class ViewImage extends StatelessWidget {
  late final String imageUrl;
  late final bool isFile;
  final File? imageFile;
  ViewImage(this.imageUrl, {this.isFile = false, this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
          child: isFile
              ? Container(
                  height: Components.kHeight(context),
                  width: Components.kWidth(context),
                  child: Image(image: FileImage(imageFile!)))
              : ChatImage(
                  content: imageUrl,
                  height: Components.kHeight(context),
                  width: Components.kWidth(context),
                )),
    );
  }
}
