import 'package:cloud_firestore/cloud_firestore.dart';

class Call {
  String? callerId;
  String? callerName;
  String? callerPic;
  String? receiverId;
  String? receiverName;
  String? receiverPic;
  String? channelId;
  Timestamp? callDate;
  bool? completed;
  bool? hasDialled;
  bool? isVideo;
  bool? isAccepted;

  Call(
      {required this.callerId,
      required this.callerName,
      required this.callerPic,
      required this.receiverId,
      required this.receiverName,
      required this.receiverPic,
      required this.channelId,
      required this.callDate,
      required this.completed,
      required this.hasDialled,
      required this.isVideo,
      required this.isAccepted});

  // to map
  Map<String, dynamic> toMap(Call call) {
    Map<String, dynamic> callMap = {};
    callMap["callerId"] = call.callerId;
    callMap["callerName"] = call.callerName;
    callMap["callerPic"] = call.callerPic;
    callMap["receiverId"] = call.receiverId;
    callMap["receiverName"] = call.receiverName;
    callMap["receiverPic"] = call.receiverPic;
    callMap["channelId"] = call.channelId;
    callMap["callDate"] = call.callDate;
    callMap["completed"] = call.completed;
    callMap["hasDialled"] = call.hasDialled;
    callMap["isVideo"] = call.isVideo;
    callMap["isAccepted"] = call.isAccepted;
    return callMap;
  }

  Call.fromMap(Map<String, dynamic>? callMap) {
    callerId = callMap?["callerId"];
    callerName = callMap?["callerName"];
    callerPic = callMap?["callerPic"];
    receiverId = callMap?["receiverId"];
    receiverName = callMap?["receiverName"];
    receiverPic = callMap?["receiverPic"];
    channelId = callMap?["channelId"];
    callDate = callMap?["callDate"];
    completed = callMap?["completed"];
    hasDialled = callMap?["hasDialled"];
    isVideo = callMap?["isVideo"];
    isAccepted = callMap?["isAccepted"];
  }
}
