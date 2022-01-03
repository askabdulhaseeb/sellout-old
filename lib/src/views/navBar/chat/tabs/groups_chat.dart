import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sellout_team/src/blocs/chat/chat_cubit/chat_cubit.dart';
import 'package:sellout_team/src/blocs/chat/chat_states/chat_states.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/models/last_group_chat_message_model.dart';
import 'package:sellout_team/src/views/components/components.dart';
import 'package:sellout_team/src/views/navBar/chat/group_chat/add_group_screen.dart';
import 'package:sellout_team/src/views/navBar/chat/group_chat/group_chat_details.dart';
import 'package:sellout_team/src/views/widgets/chats/last_chats/chat_bar_row_widget.dart';

class GroupsChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ChatCubit.get(context);
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: kPrimaryColor,
            onPressed: () {
              Components.navigateTo(
                  context, AddGroupScreen(cubit.users, kUserModel!));
            },
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('groups')
                    .where('usersId', arrayContains: kUid)
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snap) {
                  if (snap.hasData) {
                    return ListView.separated(
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          LastGroupChatMessage groupModel =
                              LastGroupChatMessage.fromJson(
                                  snap.data!.docs[index].data());
                          return InkWell(
                            onTap: () {
                              Components.navigateTo(
                                  context,
                                  GroupChatDetailsScreen(
                                      id: '${groupModel.id}',
                                      name: '${groupModel.name}',
                                      usersId: groupModel.usersId));
                            },
                            child: ChatBarRowWidget(
                              imageWidget: CircleAvatar(
                                  minRadius: 30, child: Icon(Icons.group)),
                              name: '${groupModel.name}',
                              captionWidget: Row(
                                children: [
                                  Text(
                                    groupModel.lastUserId == kUid
                                        ? 'You : '
                                        : '',
                                    style: Components.kCaption(context)
                                        ?.copyWith(color: Colors.grey),
                                  ),
                                  Text(
                                    _content(groupModel.lastMessage),
                                    style: Components.kCaption(context)
                                        ?.copyWith(color: Colors.grey),
                                  )
                                ],
                              ),
                              endWidget: Text(
                                '${DateFormat.jm().format(groupModel.date!.toDate())}',
                                style: Components.kCaption(context)
                                    ?.copyWith(color: Colors.grey),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider();
                        },
                        itemCount: snap.data!.docs.length);
                  }

                  return Container(
                    child: Center(
                      child: Text(
                        'No group chats',
                        style: Components.kBodyOne(context),
                      ),
                    ),
                  );
                }),
          ),
        );
      },
    );
  }

  String _content(String? content) {
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
