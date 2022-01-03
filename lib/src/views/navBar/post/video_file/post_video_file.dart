import 'dart:io';

import 'package:sellout_team/src/constants/constants.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class PostVideoFile extends StatefulWidget {
  late final File video;

  PostVideoFile(this.video);

  @override
  _PostVideoFileState createState() => _PostVideoFileState();
}

class _PostVideoFileState extends State<PostVideoFile> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.file(widget.video);
    _controller?.addListener(() {
      setState(() {});
    });
    _controller?.initialize().then((_) => setState(() {}));
    _controller?.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: _controller!.value.hasError
          ? Center(
              child: Text(_controller!.value.errorDescription!),
            )
          : Center(
              child: _controller!.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio,
                      child: VideoPlayer(_controller!),
                    )
                  : Container(),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        onPressed: () {
          setState(() {
            _controller!.value.isPlaying
                ? _controller!.pause()
                : _controller!.play();
          });
        },
        child: Icon(
          _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }
}
