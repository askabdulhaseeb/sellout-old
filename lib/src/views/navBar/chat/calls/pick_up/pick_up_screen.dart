import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/models/call_model.dart';
import 'package:sellout_team/src/services/call_services/call_services.dart';
import 'package:sellout_team/src/views/components/components.dart';
import 'package:sellout_team/src/views/navBar/chat/calls/call_screen.dart';
import 'package:sellout_team/src/views/navBar/chat/calls/voice.dart';

class PickupScreen extends StatefulWidget {
  late final Call call;
  late final bool isVideo;

  PickupScreen(this.call , this.isVideo);

  @override
  _PickupScreenState createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {
  
  @override
  void initState() {
    // TODO: implement initState
    WidgetsFlutterBinding.ensureInitialized();
    playAudio();
    super.initState();
  }

  playAudio() async {
    final player = AudioPlayer();

    player.setAsset(
      'assets/tones/simple_ringtone.mp3',
    );
    player.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Incoming...",
              style: Components.kHeadLineFour(context)
                  ?.copyWith(color: Colors.black),
            ),
            Components.kDivider,
            Text(
             !widget.isVideo ? "voice call" : "video call",
              style: Components.kBodyOne(context),
            ),
            const SizedBox(height: 50),
            CircleAvatar(
              backgroundImage: NetworkImage('${widget.call.callerPic}'),
              radius: 80,
            ),
            Components.kDivider,
            Text(
              '${widget.call.callerName}',
              style: Components.kHeadLineSix(context),
            ),
            SizedBox(height: 75),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: kPrimaryColor)),
                  child: IconButton(
                    icon: Icon(Icons.call_end),
                    color: Colors.redAccent,
                    onPressed: () async {
                      await CallServices().rejectCall(widget.call);
                    },
                  ),
                ),
                SizedBox(width: 25),
                Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.green)),
                    child: IconButton(
                        icon: Icon(Icons.call),
                        color: Colors.green,
                        onPressed: () async {

                         if(widget.isVideo){
                            PermissionStatus camera =
                                await Permission.camera.request();
                            PermissionStatus mic =
                                await Permission.microphone.request();
                            if (camera.isGranted && mic.isGranted) {

                              await CallServices().acceptCall(widget.call);
                              Components.navigateTo(
                                  context, CallScreen(widget.call));
                            } else {
                              print('Camera and Mic Denied');
                            }
                         } else {
                             PermissionStatus mic =
                                await Permission.microphone.request();
                                if(mic.isGranted){
                                  await CallServices().acceptCall(widget.call);
                              Components.navigateTo(
                                  context,Voice(widget.call , false));
                                } else {
                              print('Mic Denied');
                            }
                         }

                        
                        })),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
