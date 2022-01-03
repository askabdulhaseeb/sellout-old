import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellout_team/src/blocs/chat/chat_cubit/chat_cubit.dart';
import 'package:sellout_team/src/blocs/chat/chat_states/chat_states.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/models/call_model.dart';
import 'package:sellout_team/src/services/call_services/call_services.dart';
import 'package:sellout_team/src/views/navBar/chat/calls/pick_up/pick_up_screen.dart';
import 'package:sellout_team/src/views/navBar/chat/calls/voice.dart';

class PickUpLayout extends StatelessWidget {
  late final Widget scaffold;
  final CallServices callServices = CallServices();

  PickUpLayout(this.scaffold);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ChatCubit.get(context);
        if (kUserModel != null) {
          return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('calls')
                  .doc(kUserModel?.id)
                  .collection('calls')
                  .where('receiverId', isEqualTo: kUid)
                  .where('hasDialled', isEqualTo: false)
                  .where('completed', isEqualTo: false)
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  print('scvbfdbgfn');
                  Call call = Call.fromMap(snapshot.data?.docs.first.data());
                  if (!call.isVideo!) {
                    return Voice(call , false );
                  }
                  return PickupScreen(call , true);
                }
                return scaffold;
              });
        }

        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
