import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellout_team/src/blocs/chat/chat_cubit/chat_cubit.dart';
import 'package:sellout_team/src/blocs/chat/chat_states/chat_states.dart';
import 'package:sellout_team/src/blocs/post/post_cubit/post_cubit.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/models/user_model.dart';
import 'package:sellout_team/src/services/chat_services/firestore_services.dart';
import 'package:sellout_team/src/views/components/chat_components/chat_details_components/chat_details_components.dart';
import 'package:sellout_team/src/views/components/components.dart';

class ChatDetailsScreen extends StatefulWidget {
  late final UserModel model;
  ChatDetailsScreen(this.model);

  @override
  _ChatDetailsScreenState createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final messageController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  // ScrollController? _controller;

  // @override
  // void initState() {
  //   _controller = ScrollController();
  //   WidgetsBinding.instance?.addPostFrameCallback((_) {
  //     _controller?.jumpTo(_controller!.position.minScrollExtent);
  //   });
  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _controller?.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return BlocConsumer<ChatCubit, ChatStates>(
        listener: (context, state) {
          if (state is ChatPickImageErrorState) {
            Components.kSnackBar(context, state.error);
          }
          if (state is ChatPickAdocErrorState) {
            Components.kSnackBar(context, state.error);
          }
          if (state is ChatPickFileErrorState) {
            Components.kSnackBar(context, state.error);
          }
        },
        builder: (context, state) {
          var cubit = ChatCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            body: Stack(
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      cubit.isLoading
                          ? Expanded(
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: kPrimaryColor,
                                ),
                              ),
                            )
                          : StreamBuilder(
                              stream: FirestoreServices().getMessagesService(
                                  recieverId: widget.model.id!),
                              builder: (context,
                                  AsyncSnapshot<
                                          QuerySnapshot<Map<String, dynamic>>>
                                      snap) {
                                if (!snap.hasData && snap.data == null) {
                                  return Expanded(child: Container());
                                }
                                return Expanded(
                                    child: ChatDetailsComponents.messageBody(
                                        snap: snap));
                              }),
                      cubit.isUserBlocked
                          ? Container(
                              height: Components.kHeight(context) * 0.07,
                              margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              padding: const EdgeInsets.all(4),
                              decoration: Components.kElevatedContainer,
                              child: Center(
                                  child: Text(
                                'You cannot reply to this user',
                                style: Components.kBodyOne(context),
                              )),
                            )
                          : ChatDetailsComponents.typeMessageBody(
                              context: context,
                              cubit: cubit,
                              formKey: formKey,
                              messageController: messageController,
                              scaffoldKey: scaffoldKey,
                              userModel: widget.model)
                    ],
                  ),
                ),
                ChatDetailsComponents.appBarBody(
                    context: context, cubit: cubit, userModel: widget.model)
              ],
            ),
          );
        },
      );
    });
  }
}
