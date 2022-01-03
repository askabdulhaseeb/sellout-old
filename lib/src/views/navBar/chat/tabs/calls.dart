import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/models/call_model.dart';
import 'package:sellout_team/src/views/components/components.dart';
import 'package:sellout_team/src/views/widgets/chats/last_chats/chat_bar_row_widget.dart';
import 'package:sellout_team/src/views/widgets/images/chat_circle_image_widget.dart';

class CallsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('calls')
              .doc(kUid)
              .collection('calls')
              // .where('completed', isEqualTo: true)
              .orderBy('callDate', descending: true)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snap) {
            if (snap.hasData && snap.data!.docs.length > 0) {
              return callsBody(snap);
            }
            return Container(
              child: Center(
                child: Text(
                  'No Calls',
                  style: Components.kBodyOne(context),
                ),
              ),
            );
          }),
    );
  }

  Widget callsBody(AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snap) {
    return ListView.separated(
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          Call call = Call.fromMap(snap.data?.docs[index].data());

          return ChatBarRowWidget(
            imageWidget: ChatCircleImageWidget(
                image: call.callerId == kUid
                    ? '${call.receiverPic}'
                    : '${call.callerPic}',
                width: Components.kWidth(context) * 0.2),
            name: call.callerId == kUid
                ? '${call.receiverName}'
                : '${call.callerName}',
            captionWidget: Container(
              child: Row(
                children: [
                  Icon(
                    icon(call),
                    size: 15,
                    color: !call.isAccepted! ? Colors.red : Colors.green,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${DateFormat.jm().format(call.callDate!.toDate())}',
                    style: Components.kCaption(context)
                        ?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
            endWidget: Icon(
              icon(call),
              color: !call.isAccepted! ? Colors.red : Colors.green,
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
        itemCount: snap.data!.docs.length);
  }

  IconData icon(Call call) {
    if (call.isAccepted! == false) {
      if (call.isVideo!) {
        return Icons.missed_video_call;
      }
      if (call.callerId == kUid) {
        return Icons.call_missed_outgoing;
      }

      return Icons.call_missed;
    }
    if (call.isAccepted!) {
      if (call.isVideo!) {
        return Icons.video_call;
      }
      if (call.callerId == kUid) {
        return Icons.call_made;
      }
      return Icons.call_received;
    }
    return Icons.call;
  }
}
