import 'package:cloud_firestore/cloud_firestore.dart';

class GroupChatMessageModel {
  String? message;
  Timestamp? date;
  String? userId;
  String? userName;
  String? userImage;
  bool? isPhoto;
  bool? isVideo;
  bool? isDoc;
  GeoPoint? geoPoint;

  GroupChatMessageModel(
      {required this.message,
      required this.date,
      required this.userId,
      required this.userName,
      required this.userImage,
      required this.isPhoto,
      required this.isVideo,
      required this.isDoc,
      required this.geoPoint});

  GroupChatMessageModel.fromJson(Map<String, dynamic>? json) {
    message = json?['message'];
    date = json?['date'];
    userId = json?['userId'];
    userName = json?['userName'];
    userImage = json?['userImage'];
    isPhoto = json?['isPhoto'];
    isVideo = json?['isVideo'];
    isDoc = json?['isDoc'];
    geoPoint = json?['geoPoint'];
  }

  toMap() {
    return {
      'message': message,
      'date': date,
      'userId': userId,
      'userName': userName,
      'userImage': userImage,
      'isPhoto': isPhoto,
      'isVideo': isVideo,
      'isDoc' : isDoc,
      'geoPoint': geoPoint
    };
  }
}
