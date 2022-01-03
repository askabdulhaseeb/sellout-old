import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:sellout_team/src/blocs/chat/chat_cubit/chat_cubit.dart';
import 'package:sellout_team/src/blocs/user/user_cubit/user_cubit.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/models/last_message_model.dart';
import 'package:sellout_team/src/models/user_model.dart';
import 'package:sellout_team/src/views/components/components.dart';
import 'package:sellout_team/src/views/navBar/chat/chat_details/chat_details_screen.dart';
import 'package:sellout_team/src/views/widgets/chats/last_chats/chat_bar_row_widget.dart';
import 'package:sellout_team/src/views/widgets/images/chat_circle_image_widget.dart';

class SingleChatComponents {
  static Widget currentChatsBody(
      {required AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snap,
      required ChatCubit cubit}) {
    return ListView.separated(
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          LastMessagesModel currentChats =
              LastMessagesModel.fromJson(snap.data?.docs[index].data());
          UserModel user = UserModel(
              name: currentChats.userName,
              id: currentChats.userId,
              email: currentChats.userEmail,
              image: currentChats.userImage);

          return Slidable(
            actionPane: SlidableDrawerActionPane(),
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: 'Mute',
                color: Colors.amber,
                icon: Icons.volume_off,
                onTap: () {},
              ),
              IconSlideAction(
                caption: 'Delete',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () {
                  cubit.deleteChatForCurrentUser(
                      '${kUserModel?.id}', currentChats.userId!);
                },
              ),
              IconSlideAction(
                caption: 'Block',
                color: Colors.indigo,
                icon: Icons.block,
                onTap: () async {
                  await UserCubit.get(context).getOtherUserData(user.id!);
                  await UserCubit.get(context)
                      .blockUser(userBlocker: kUserModel!, userBlocked: user);
                },
              ),
            ],
            child: InkWell(
              onTap: () async {
                await cubit.isBlocked(user.id!);
                Components.navigateTo(context, ChatDetailsScreen(user));
              },
              child: ChatBarRowWidget(
                imageWidget: ChatCircleImageWidget(
                  image: '${user.image}',
                  width: Components.kWidth(context) * 0.16,
                ),
                name: '${user.name}',
                captionWidget: Container(
                  width: Components.kWidth(context) * 0.5,
                  child: Text(
                    content(currentChats.lastMessageContent),
                    overflow: TextOverflow.ellipsis,
                    style: Components.kCaption(context)
                        ?.copyWith(color: Colors.grey),
                  ),
                ),
                endWidget: Text(
                  '${DateFormat.jm().format(currentChats.lastMessageDate!.toDate())}',
                  style: Components.kCaption(context)
                      ?.copyWith(color: Colors.grey),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
        itemCount: snap.data!.docs.length);
  }

  static String content(String? content) {
    if (content!.contains('images')) {
      return 'Photo';
    }
    if (content.contains('video')) {
      return 'Video';
    }
    if (content.contains('docs')) {
      return 'Document';
    }

    return content;
  }
}
