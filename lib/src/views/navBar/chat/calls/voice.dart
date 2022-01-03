import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/models/call_model.dart';
import 'package:sellout_team/src/services/call_services/call_services.dart';
import 'package:sellout_team/src/services/configs/agora_configs.dart';
import 'package:sellout_team/src/views/components/components.dart';

class Voice extends StatefulWidget {
  late final Call call;
  late final isCaller;
  Voice(this.call, this.isCaller);

  @override
  _VoiceState createState() => _VoiceState();
}

class _VoiceState extends State<Voice> {
  late final RtcEngine _engine;
  final List<int> _users = [];
  bool isRejected = false;
  bool isJoined = false,
      openMicrophone = true,
      enableSpeakerphone = true,
      playEffect = false;

  @override
  void initState() {
    super.initState();
    this._initEngine();
    if (widget.call.callerId != kUid) {
      playAudio();
    }
    if (widget.call.completed! && !widget.call.isAccepted!) {
      this._leaveChannel();
      isJoined = false;
      Navigator.of(context).pop();
    }
  }

  playAudio() async {
    final player = AudioPlayer();

    player.setAsset(
      'assets/tones/simple_ringtone.mp3',
    );
    player.play();
  }

  @override
  void dispose() {
    super.dispose();
    _users.clear();
    _engine.destroy();
  }

  _initEngine() async {
    _engine = await RtcEngine.createWithContext(RtcEngineContext(APP_ID));
    this._addListeners();
    await _engine.enableAudio();
  }

  _addListeners() {
    _engine.setEventHandler(RtcEngineEventHandler(
      joinChannelSuccess: (channel, uid, elapsed) {
        print('joinChannelSuccess $channel $uid $elapsed');
        setState(() {
          isJoined = true;
          _users.clear();
        });

        print('is joinnnnnned in join success $isJoined');
        print('uid $uid');
      },
        userJoined: (uid, elapsed) {
          setState(() {
            final info = 'userJoined: $uid';
          //  _infoStrings.add(info);
            _users.add(uid);
          });
        },
        userOffline: (uid, elapsed) {
          setState(() {
            final info = 'userOffline: $uid';

          //  _infoStrings.add(info);
            _users.clear();

          });
          print('list lengthhhhhhhh ${_users.length}');
          _leaveChannel();
        },
      leaveChannel: (stats) async {
        print('leaveChannel ${stats.toJson()}');

        setState(() {
          isJoined = false;
          if(stats.duration <= 0){
            isRejected = true;
          }
          _users.clear();
        });
        print('users lengthhhhhhhh ${_users.length}');
      },
    ));
  }

  _joinChannel() async {
    await Permission.microphone.request();
    if (widget.call.receiverId == kUid) {
      await CallServices().acceptCall(widget.call);
    }
    await CallServices().makeCall(widget.call);
    await _engine
        .joinChannel(null, widget.call.channelId!, null, 0)
        .catchError((onError) {
      print('error ${onError.toString()}');
    });
  }

  _leaveChannel() async {
    await _engine.leaveChannel();
    widget.call.callerId != kUid && isRejected == true  ?
    await CallServices().rejectCall(widget.call) :
    await CallServices().endCall(widget.call);
    _users.clear();

  }

  _switchMicrophone() {
    _engine.enableLocalAudio(!openMicrophone).then((value) {
      setState(() {
        openMicrophone = !openMicrophone;
      });
    }).catchError((err) {
      print('enableLocalAudio $err');
    });
  }

  _switchSpeakerphone() {
    _engine.setEnableSpeakerphone(!enableSpeakerphone).then((value) {
      setState(() {
        enableSpeakerphone = !enableSpeakerphone;
      });
    }).catchError((err) {
      print('setEnableSpeakerphone $err');
    });
  }

  @override
  Widget build(BuildContext context) {
    print('is joined $isJoined');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              widget.isCaller
                  ? Container()
                  : Column(
                      children: [
                        Text(
                          "Incoming...",
                          style: Components.kHeadLineFour(context)
                              ?.copyWith(color: Colors.black),
                        ),
                        Components.kDivider,
                        Text(
                          "voice call",
                          style: Components.kBodyOne(context),
                        ),
                      ],
                    ),
              const SizedBox(height: 30),
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(
                  widget.call.callerId == kUid
                      ? '${widget.call.receiverPic}'
                      : '${widget.call.callerPic}',
                ),
              ),
              Components.kDivider,
              Text(
                widget.call.callerId == kUid
                    ? '${widget.call.receiverName}'
                    : '${widget.call.callerName}',
                style: Components.kHeadLineFive(context)
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              answerRow(context),
            ],
          ),
          controllersRow(context)
        ],
      ),
    );
  }

  Widget answerRow(BuildContext context) {
    return Container(
      height: Components.kHeight(context) * 0.25,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [isUserAndJoined()],
      ),
    );
  }

  Widget isUserAndJoined() {
    if (!isJoined) {
      if (widget.call.callerId == kUid) {
        return CircleAvatar(
          radius: 35,
          backgroundColor: Colors.green,
          child: IconButton(
            onPressed: this._joinChannel,
            icon: Icon(
              Icons.call,
              color: Colors.white,
              size: 35,
            ),
          ),
        );
      } else {
        return Row(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: Colors.green,
              child: IconButton(
                onPressed: this._joinChannel,
                icon: Icon(
                  Icons.call,
                  color: Colors.white,
                  size: 35,
                ),
              ),
            ),
            Container(),
            const SizedBox(width: 10),
            CircleAvatar(
              radius: 35,
              backgroundColor: Colors.red,
              child: IconButton(
                onPressed: this._leaveChannel,
                icon: Icon(Icons.call_end, color: Colors.white),
              ),
            ),
          ],
        );
      }
    }
    return CircleAvatar(
      radius: 35,
      backgroundColor: Colors.red,
      child: IconButton(
        onPressed: this._leaveChannel,
        icon: Icon(Icons.call_end, color: Colors.white),
      ),
    );
  }

  Widget controllersRow(BuildContext context) {
    return Container(
      height: Components.kHeight(context) * 0.2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: kPrimaryColor)),
            child: IconButton(
                onPressed: this._switchMicrophone,
                icon: Icon(
                  openMicrophone ? Icons.mic : Icons.mic_off,
                )),
          ),
          Components.kVerticalDivider,
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: kPrimaryColor)),
            child: IconButton(
                onPressed: this._switchSpeakerphone,
                icon: Icon(
                    enableSpeakerphone ? Icons.speaker : Icons.headphones)),
          ),
        ],
      ),
    );
  }
}
