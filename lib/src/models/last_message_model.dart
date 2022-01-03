import 'package:cloud_firestore/cloud_firestore.dart';

class LastMessagesModel {
  String? userId;
  String? userName;
  String? userEmail;
  String? userImage;
  String? lastMessageContent;
  Timestamp? lastMessageDate;

  LastMessagesModel({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userImage,
    required this.lastMessageContent,
    required this.lastMessageDate,
  });

  LastMessagesModel.fromJson(Map<String, dynamic>? json) {
    userId = json?['userId'];
    userName = json?['userName'];
    userEmail = json?['userEmail'];
    userImage = json?['userImage'];
    lastMessageContent = json?['lastMessageContent'];
    lastMessageDate = json?['lastMessageDate'];
  }

  toMap() {
    return {
      'userId' : userId,
      'userName' : userName,
      'userEmail' : userEmail,
      'userImage' : userImage,
      'lastMessageDate': lastMessageDate,
      'lastMessageContent': lastMessageContent,
    };
  }
}
