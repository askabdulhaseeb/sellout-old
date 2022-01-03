import 'dart:developer';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/views/components/components.dart';
import 'package:sellout_team/src/views/liveBid/utils/appId.dart';
import 'package:sellout_team/src/views/widgets/auth/default_button_widget.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;

class LiveBidScreen extends StatefulWidget {
  String channelName;
  String userName;
  bool isBroadcaster;
  String liveBidId;
  String bidName;

  LiveBidScreen(
      {Key? key,
        required this.channelName,
        required this.userName,
        required this.isBroadcaster,
        required this.liveBidId,
        required this.bidName,
      })
      : super(key: key);
  @override
  _LiveBidScreenState createState() => _LiveBidScreenState();
}

class _LiveBidScreenState extends State<LiveBidScreen> {

  late final RtcEngine _engine;
  bool isJoined = false, switchCamera = true, switchRender = true;
  List<int> remoteUid = [];
  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.channelName);
    this._initEngine();
  }

  @override
  void dispose() {
    super.dispose();
    _engine.destroy();
  }

  _initEngine() async {
    _engine = await RtcEngine.createWithContext(RtcEngineContext(appId));
    this._addListeners();

    await _engine.enableVideo();
    await _engine.startPreview();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(ClientRole.Broadcaster);
    _joinChannel();
  }

  _addListeners() {
    _engine.setEventHandler(RtcEngineEventHandler(
      joinChannelSuccess: (channel, uid, elapsed) {
        log('joinChannelSuccess ${channel} ${uid} ${elapsed}');
        setState(() {
          isJoined = true;
        });
      },
      userJoined: (uid, elapsed) {
        log('userJoined  ${uid} ${elapsed}');
        setState(() {
          remoteUid.add(uid);
        });
      },
      userOffline: (uid, reason) {
        log('userOffline  ${uid} ${reason}');
        setState(() {
          remoteUid.removeWhere((element) => element == uid);
        });
      },
      leaveChannel: (stats) {
        log('leaveChannel ${stats.toJson()}');
        setState(() {
          isJoined = false;
          remoteUid.clear();
        });
      },
    ));
  }

  _joinChannel() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await [Permission.microphone, Permission.camera].request();
    }
    await _engine.joinChannel(tokenn, "test", null, 0);
  }

  _leaveChannel() async {
    await _engine.leaveChannel();
  }

  _switchCamera() {
    _engine.switchCamera().then((value) {
      setState(() {
        switchCamera = !switchCamera;
      });
    }).catchError((err) {
      log('switchCamera $err');
    });
  }

  _switchRender() {
    setState(() {
      switchRender = !switchRender;
      remoteUid = List.of(remoteUid.reversed);
    });
  }

  _renderVideo() {
    return Expanded(
      child: Stack(
        children: [
          RtcLocalView.SurfaceView(),
          Align(
            alignment: Alignment.topLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.of(remoteUid.map(
                      (e) => GestureDetector(
                    onTap: this._switchRender,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 120,
                        height: 120,
                        child: RtcRemoteView.SurfaceView(
                          uid: e,
                        ),
                      ),
                    ),
                  ),
                )),
              ),
            ),
          )
        ],
      ),
    );
  }

  showDialog(){

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red.shade800,
        title: Text("Live Bid", style: TextStyle(color: Colors.white),),
        leading: GestureDetector(
          onTap: (){
            
            _leaveChannel();
            Navigator.pop(context,false);

          },
            child: Icon(Icons.keyboard_backspace, color: Colors.white,)),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              child: _renderVideo(),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.bidName,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  "0",
                                  style: TextStyle(
                                      color: Colors.red.shade800,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text("Bids")
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                "0",
                                style: TextStyle(
                                    color: Colors.red.shade800,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text("Increments")
                            ],
                          ),
                        ),
                      )),
                      Expanded(
                          child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                "0",
                                style: TextStyle(
                                    color: Colors.red.shade800,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text("Items")
                            ],
                          ),
                        ),
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: Components.kWidth(context),
                    height: Components.kHeight(context) * 0.045,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "0",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: kPrimaryColor),

                            // Components.kBodyOne(context)?.copyWith(
                            //     fontWeight: FontWeight.bold,
                            //     color: color == Colors.white ? kPrimaryColor : Colors.white),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.add_box_outlined,
                            color: Colors.red.shade800,
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                          primary: Colors.white,
                          shadowColor: Colors.white.withOpacity(1)),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DefaultButtonWidget(
                    text: 'Bid Now',
                    isTextWeightThick: false,
                    isSmallerHeight: true,
                    function: () {
                      // if (formKey.currentState!.validate()) {
                      //   cubit.login(
                      //       email: emailController.text,
                      //       passwords: passwordController.text);
                      // }
                    },
                    color: kPrimaryColor,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DefaultButtonWidget(
                    text: 'Set Max Bid',
                    isTextWeightThick: false,
                    isSmallerHeight: true,
                    hasBorder: true,
                    function: () {
                      // if (formKey.currentState!.validate()) {
                      //   cubit.login(
                      //       email: emailController.text,
                      //       passwords: passwordController.text);
                      // }
                    },
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DefaultButtonWidget(
                    text: 'Buy Now',
                    isTextWeightThick: false,
                    isSmallerHeight: true,
                    function: () {
                      // if (formKey.currentState!.validate()) {
                      //   cubit.login(
                      //       email: emailController.text,
                      //       passwords: passwordController.text);
                      // }
                    },
                    color: kPrimaryColor,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Contact Information",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 90,
                        width: 90,
                        child: CircleAvatar(
                          backgroundColor: Colors.red.shade800,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                              child: Image.network(
                                  kUserModel!.image.toString(),
                                  height: 90,
                                  width: 90,
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(kUserModel!.name.toString())
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
