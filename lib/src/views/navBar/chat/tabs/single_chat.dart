import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellout_team/src/blocs/chat/chat_cubit/chat_cubit.dart';
import 'package:sellout_team/src/blocs/chat/chat_states/chat_states.dart';
import 'package:sellout_team/src/blocs/user/user_cubit/user_cubit.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/services/chat_services/firestore_services.dart';
import 'package:sellout_team/src/views/components/chat_components/single_chat_components/single_chat_components.dart';
import 'package:sellout_team/src/views/components/components.dart';

class SingleChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return BlocConsumer<ChatCubit, ChatStates>(
        listener: (context, state) {
          if (state is ChatDeleteChatSuccessState) {
            Components.kSnackBar(context, 'Deleted successfully',
                isSuccess: true);
          }
          if (state is ChatDeleteChatErrorState) {
            Components.kSnackBar(context, 'Something went wrong');
          }
          if (UserCubit.get(context).isBlockSuccess) {
            Components.kSnackBar(context, 'Blocked successfully!',
                isSuccess: true);
          }
        },
        builder: (context, state) {
          var cubit = ChatCubit.get(context);
          return StreamBuilder(
              stream: FirestoreServices()
                  .getCurrentChatsService('${kUserModel?.id}'),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snap) {
                if (snap.hasData == false) {
                  return Container(
                    child: Center(
                      child: Text(
                        'No chats',
                        style: Components.kBodyOne(context),
                      ),
                    ),
                  );
                }
                return SingleChatComponents.currentChatsBody(
                    snap: snap, cubit: cubit);
              });
        },
      );
    });
  }
}
