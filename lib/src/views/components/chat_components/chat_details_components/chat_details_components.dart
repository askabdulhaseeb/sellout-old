import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sellout_team/src/blocs/chat/chat_cubit/chat_cubit.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/models/call_model.dart';
import 'package:sellout_team/src/models/message_model.dart';
import 'package:sellout_team/src/models/user_model.dart';
import 'package:sellout_team/src/services/call_services/call_services.dart';
import 'package:sellout_team/src/views/components/components.dart';
import 'package:sellout_team/src/views/navBar/chat/calls/call_screen.dart';
import 'package:sellout_team/src/views/navBar/chat/calls/voice.dart';
import 'package:sellout_team/src/views/widgets/chats/bottom_sheet/sending_items_Widget.dart';
import 'package:sellout_team/src/views/widgets/chats/message_body/current_user_message_widget.dart';
import 'package:sellout_team/src/views/widgets/chats/message_body/other_user_message_widget.dart';
import 'package:sellout_team/src/views/widgets/chats/type_body/type_message_widget.dart';

class ChatDetailsComponents {
  static Widget messageBody(
      {required AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snap}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 80, 8.0, 0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SingleChildScrollView(
          child: ListView.separated(
              reverse: true,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                MessageModel messageModel =
                    MessageModel.fromJson(snap.data?.docs[index].data());

                if (messageModel.userId == kUid) {
                  return CurrentUserMessageWidget(
                      isVideo: messageModel.isVideo!,
                      isDoc: messageModel.isDoc!,
                      isPhoto: messageModel.isPhoto!,
                      geoPoint: messageModel.geoPoint!,
                      content: '${messageModel.messageContent}');
                }
                return OtherUserMessageWidget(
                  geoPoint: messageModel.geoPoint!,
                  isDoc: messageModel.isDoc!,
                  isVideo: messageModel.isVideo!,
                  isPhoto: messageModel.isPhoto!,
                  recieverUserImage: messageModel.receiverImage!,
                  content: messageModel.messageContent!,
                );
              },
              separatorBuilder: (context, index) => Components.kDivider,
              itemCount: snap.data!.docs.length),
        ),
      ),
    );
  }

  static Widget typeMessageBody(
      {required ChatCubit cubit,
      required BuildContext context,
      required scaffoldKey,
      required UserModel userModel,
      required TextEditingController messageController,
      required formKey}) {
    return TypeMessageContainer(
      onAddPressed: () {
        scaffoldKey.currentState?.showBottomSheet((context) {
          return buildBottomSheet(
              context: context, cubit: cubit, userModel: userModel);
        });
      },
      onCameraPressed: () {
        cubit.pickAnImage(
            imageSource: ImageSource.camera, recieverModel: userModel);
      },
      textField: TextFormField(
        controller: messageController,
        decoration: InputDecoration(
            hintText: 'Type a message....', border: InputBorder.none),
        onFieldSubmitted: (value) {
          if (formKey.currentState!.validate()) {
            MessageModel messageModel = messageModelReuse(
                userModel: userModel,
                messageContent: messageController.text,
                isPhoto: false);
            cubit.sendMessage(
                messageModel: messageModel, recieverModel: userModel);
          }

          FocusScope.of(context).unfocus();

          messageController.text = '';
        },
      ),
    );
  }

  static Widget appBarBody(
      {required BuildContext context,
      required ChatCubit cubit,
      required UserModel userModel}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
      child: Container(
        decoration: Components.kElevatedContainer,
        height: Components.kHeight(context) * 0.1,
        width: Components.kWidth(context),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: kPrimaryColor,
                )),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.4),
                  ),
                  shape: BoxShape.circle),
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage('${userModel.image}'),
              ),
            ),
            Components.kVerticalDivider,
            Expanded(
              child: Text(
                '${userModel.name}',
                overflow: TextOverflow.ellipsis,
                style: Components.kHeadLineSix(context),
              ),
            ),
            IconButton(
                onPressed: () async {
                  Call call = Call(
                      callerId: kUserModel?.id,
                      callerName: kUserModel?.name,
                      callerPic: kUserModel?.image,
                      callDate: Timestamp.now(),
                      channelId:
                          DateTime.now().microsecondsSinceEpoch.toString(),
                      isVideo: true,
                      completed: false,
                      hasDialled: true,
                      isAccepted: false,
                      receiverId: userModel.id,
                      receiverName: userModel.name,
                      receiverPic: userModel.image);

                  PermissionStatus camera = await Permission.camera.request();
                  PermissionStatus mic = await Permission.microphone.request();
                  if (camera.isGranted && mic.isGranted) {
                    await CallServices().makeCall(call);
                    Components.navigateTo(context, CallScreen(call));
                  } else {
                    print('Camera and Mic Denied');
                  }
                },
                icon: Icon(
                  Icons.video_call,
                  size: 30,
                  color: kPrimaryColor,
                )),
            IconButton(
                onPressed: () async {
                  //     Components.navigateTo(context, VoiceCall());

                  Call call = Call(
                      callerId: kUserModel?.id,
                      callerName: kUserModel?.name,
                      callerPic: kUserModel?.image,
                      callDate: Timestamp.now(),
                      channelId:
                          DateTime.now().microsecondsSinceEpoch.toString(),
                      isVideo: false,
                      completed: false,
                      hasDialled: true,
                      isAccepted: false,
                      receiverId: userModel.id,
                      receiverName: userModel.name,
                      receiverPic: userModel.image);

                  Components.navigateTo(context, Voice(call, true));
                },
                icon: Icon(
                  Icons.call,
                  size: 30,
                  color: kPrimaryColor,
                )),
          ],
        ),
      ),
    );
  }

  static MessageModel messageModelReuse(
      {required String messageContent,
      required bool isPhoto,
      required UserModel userModel}) {
    return MessageModel(
        isDoc: false,
        isVideo: false,
        geoPoint: GeoPoint(0, 0),
        isPhoto: isPhoto,
        userId: kUid,
        receiverId: userModel.id,
        receiverName: userModel.name,
        receiverImage: userModel.image,
        messageContent: messageContent,
        date: Timestamp.now());
  }

  static Widget buildBottomSheet(
      {required BuildContext context,
      required ChatCubit cubit,
      required UserModel userModel}) {
    return Container(
      height: Components.kHeight(context) * 0.45,
      width: Components.kWidth(context) * 0.8,
      padding: const EdgeInsets.only(left: 8),
      decoration: Components.kElevatedContainer,
      child: Column(
        children: [
          SendingItemsWidget(
            icon: Icons.photo_library,
            text: 'Photo',
            function: () {
              cubit.pickAnImage(
                  imageSource: ImageSource.gallery, recieverModel: userModel);
            },
          ),
          const Divider(),
          SendingItemsWidget(
            icon: Icons.video_camera_back,
            text: 'Video',
            function: () {
              cubit.pickAVideo(recieverModel: userModel);
            },
          ),
          const Divider(),
          SendingItemsWidget(
            icon: Icons.text_snippet,
            text: 'Document',
            function: () {
              cubit.pickADoc(recieverModel: userModel);
            },
          ),
          const Divider(),
          SendingItemsWidget(
            icon: Icons.location_on,
            text: 'Location',
            function: () {
              cubit.sendUserLocation(recieverModel: userModel);
            },
          ),
          const Divider(),
          SendingItemsWidget(
            icon: Icons.account_circle,
            text: 'Address',
            function: () {},
          ),
        ],
      ),
    );
  }
}
