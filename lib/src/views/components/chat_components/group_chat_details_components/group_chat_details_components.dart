import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sellout_team/src/blocs/chat/chat_cubit/chat_cubit.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/models/group_chat_model.dart';
import 'package:sellout_team/src/views/components/components.dart';
import 'package:sellout_team/src/views/widgets/chats/bottom_sheet/sending_items_Widget.dart';
import 'package:sellout_team/src/views/widgets/chats/message_body/current_user_message_widget.dart';
import 'package:sellout_team/src/views/widgets/chats/message_body/other_user_message_widget.dart';
import 'package:sellout_team/src/views/widgets/chats/type_body/type_message_widget.dart';

class GroupChatDetailsComponents {
  static Widget messageBody(
      {required AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snap,
      required ChatCubit cubit}) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SingleChildScrollView(
        child: ListView.separated(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              GroupChatMessageModel model =
                  GroupChatMessageModel.fromJson(snap.data!.docs[index].data());

              if (model.userId == kUid) {
                return CurrentUserMessageWidget(
                    content: '${model.message}',
                    isPhoto: model.isPhoto!,
                    isVideo: model.isVideo!,
                    geoPoint: model.geoPoint!,
                    isDoc: model.isDoc!);
              }
              return OtherUserMessageWidget(
                  recieverUserImage: '${model.userImage}',
                  content: '${model.message}',
                  isPhoto: model.isPhoto!,
                  isVideo: model.isVideo!,
                  geoPoint: model.geoPoint!,
                  isDoc: model.isDoc!);
            },
            separatorBuilder: (context, index) => Components.kDivider,
            itemCount: snap.data!.docs.length),
      ),
    );
  }

  static Widget typeMessageMethod(
      {required BuildContext context,
      required ChatCubit cubit,
      required formKey,
      required scaffoldKey,
      required String id,
      required String name,
      required List<String> usersId,
      required TextEditingController messageController}) {
    return Form(
      key: formKey,
      child: TypeMessageContainer(
        onAddPressed: () {
          scaffoldKey.currentState?.showBottomSheet((context) {
            return buildBottomSheet(
                context: context,
                cubit: cubit,
                id: id,
                name: name,
                usersId: usersId);
          });
        },
        onCameraPressed: () {
          cubit.pickAnImage(
              imageSource: ImageSource.camera,
              isGroup: true,
              groupId: id,
              groupName: name,
              usersId: usersId);
        },
        textField: TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return 'type a message';
            }
          },
          controller: messageController,
          decoration: InputDecoration(
              hintText: 'Type a message....', border: InputBorder.none),
          onFieldSubmitted: (value) {
            if (formKey.currentState!.validate()) {
              GroupChatMessageModel groupModel = GroupChatMessageModel(
                  message: messageController.text,
                  date: Timestamp.now(),
                  userId: kUserModel?.id,
                  userName: kUserModel?.name,
                  userImage: kUserModel?.image,
                  isPhoto: false,
                  isVideo: false,
                  isDoc: false,
                  geoPoint: GeoPoint(0.0, 0.0));
              cubit.sendMessageToGroupChat(id, name, usersId, groupModel);

              FocusScope.of(context).unfocus();

              messageController.text = '';
            }
          },
        ),
      ),
    );
  }

  static Widget appBarChat(
      {required BuildContext context, required String name}) {
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
                icon: Icon(Icons.arrow_back)),
            Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    shape: BoxShape.circle),
                child: CircleAvatar(radius: 20, child: Icon(Icons.group))),
            Components.kVerticalDivider,
            Text(
              '$name',
              style: Components.kHeadLineSix(context),
            )
          ],
        ),
      ),
    );
  }

  static Widget buildBottomSheet({
    required BuildContext context,
    required ChatCubit cubit,
    required String id,
    required String name,
    required List<String> usersId,
  }) {
    return Container(
      height: Components.kHeight(context) * 0.45,
      width: Components.kWidth(context) * 0.8,
      padding: const EdgeInsets.only(left: 8),
      decoration: Components.kElevatedContainer,
      child: Column(
        children: [
          SendingItemsWidget(
            icon: Icons.photo_library,
            text: 'Photos',
            function: () {
              cubit.pickAnImage(
                  imageSource: ImageSource.gallery,
                  isGroup: true,
                  groupId: id,
                  groupName: name,
                  usersId: usersId);
            },
          ),
          Divider(),
          SendingItemsWidget(
            icon: Icons.video_collection,
            text: 'Videos',
            function: () {
              cubit.pickAVideo(
                  isGroup: true,
                  groupId: id,
                  groupName: name,
                  usersId: usersId);
            },
          ),
          Divider(),
          SendingItemsWidget(
            icon: Icons.text_snippet,
            text: 'Document',
            function: () {
              cubit.pickADoc(
                  isGroup: true,
                  groupId: id,
                  groupName: name,
                  usersId: usersId);
            },
          ),
          Divider(),
          SendingItemsWidget(
            icon: Icons.location_on,
            function: () {
              cubit.sendUserLocation(
                  isGroup: true,
                  groupId: id,
                  groupName: name,
                  usersId: usersId);
            },
            text: 'Location',
          ),
          Divider(),
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
