import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/models/call_model.dart';

class CallServices {
  final CollectionReference callCollection =
      FirebaseFirestore.instance.collection('calls');

  Stream<DocumentSnapshot> callStream(String uid) =>
      callCollection.doc(uid).snapshots();

  Future<bool> makeCall(Call call) async {
    try {
      call.hasDialled = true;
      call.isAccepted = false;
      Map<String, dynamic> hasDialledMap = call.toMap(call);

      call.hasDialled = false;
      call.isAccepted = false;
      Map<String, dynamic> hasNotDialledMap = call.toMap(call);

      await callCollection
          .doc(call.callerId)
          .collection('calls')
          .doc(hasDialledMap['channelId'])
          .set(hasDialledMap);
      await callCollection
          .doc(call.receiverId)
          .collection('calls')
          .doc(hasNotDialledMap['channelId'])
          .set(hasNotDialledMap);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> acceptCall(Call call) async {
    try {
      call.isAccepted = true;
      Map<String, dynamic> callMap = call.toMap(call);

      await callCollection
          .doc(call.callerId)
          .collection('calls')
          .doc(call.channelId)
          .update(callMap);
      await callCollection
          .doc(call.receiverId)
          .collection('calls')
          .doc(call.channelId)
          .update(callMap);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> endCall(Call call) async {
    try {
      call.completed = true;
      call.callerId == kUid ? call.hasDialled = true : call.hasDialled = false;
      Map<String, dynamic> callMap = call.toMap(call);

      await callCollection
          .doc(call.callerId)
          .collection('calls')
          .doc(call.channelId)
          .update(callMap);
      await callCollection
          .doc(call.receiverId)
          .collection('calls')
          .doc(call.channelId)
          .update(callMap);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  rejectCall(Call call) async {
    try {
      call.completed = true;
      call.isAccepted = false;
      Map<String, dynamic> callMap = call.toMap(call);

      await callCollection
          .doc(call.callerId)
          .collection('calls')
          .doc(call.channelId)
          .update(callMap);
      await callCollection
          .doc(call.receiverId)
          .collection('calls')
          .doc(call.channelId)
          .update(callMap);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
