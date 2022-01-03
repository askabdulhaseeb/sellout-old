import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sellout_team/src/blocs/chat/chat_cubit/chat_cubit.dart';
import 'package:sellout_team/src/blocs/chat/chat_states/chat_states.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/models/group_chat_model.dart';
import 'package:sellout_team/src/views/components/chat_components/group_chat_details_components/group_chat_details_components.dart';
import 'package:sellout_team/src/views/components/components.dart';
import 'package:sellout_team/src/views/widgets/chats/message_body/current_user_message_widget.dart';
import 'package:sellout_team/src/views/widgets/chats/message_body/other_user_message_widget.dart';
import 'package:sellout_team/src/views/widgets/chats/bottom_sheet/sending_items_Widget.dart';
import 'package:sellout_team/src/views/widgets/chats/type_body/type_message_widget.dart';

class GroupChatDetailsScreen extends StatelessWidget {
  late final String name;
  late final String id;
  late final List<String> usersId;
  GroupChatDetailsScreen(
      {required this.name, required this.id, required this.usersId});

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final messageController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ChatCubit.get(context);
        return Scaffold(
          key: scaffoldKey,
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                          alignment: Alignment.bottomRight,
                          child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('groups')
                                .doc(id)
                                .collection('messages')
                                .orderBy('date')
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<
                                        QuerySnapshot<Map<String, dynamic>>>
                                    snap) {
                              if (snap.hasData) {
                                return GroupChatDetailsComponents.messageBody(
                                    snap: snap, cubit: cubit);
                              }
                              return Container();
                            },
                          )),
                    ),
                    GroupChatDetailsComponents.typeMessageMethod(
                        context: context,
                        cubit: cubit,
                        formKey: formKey,
                        scaffoldKey: scaffoldKey,
                        id: id,
                        messageController: messageController,
                        name: name,
                        usersId: usersId)
                  ],
                ),
              ),
              GroupChatDetailsComponents.appBarChat(
                  context: context, name: name)
            ],
          ),
        );
      },
    );
  }
}
