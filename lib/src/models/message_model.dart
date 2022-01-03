import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String? userId;
  String? receiverId;
  String? receiverName;
  String? receiverImage;
  String? messageContent;
  GeoPoint? geoPoint;
  bool? isPhoto;
  bool? isVideo;
  bool? isDoc;
  Timestamp? date;

  MessageModel({
    required this.userId,
    required this.receiverId,
    required this.receiverName,
    required this.geoPoint,
    required this.receiverImage,
    required this.messageContent,
    required this.isPhoto,
    required this.isVideo,
    required this.isDoc,
    required this.date,
  });

  MessageModel.fromJson(Map<String, dynamic>? json) {
    userId = json?['userId'];
    receiverId = json?['receiverId'];
    receiverName = json?['receiverName'];
    receiverImage = json?['receiverImage'];
    geoPoint = json?['geoPoint'];
    messageContent = json?['messageContent'];
    isPhoto = json?['isPhoto'];
    isVideo = json?['isVideo'];
    isDoc = json?['isDoc'];
    date = json?['date'];
  }

  toMap() {
    return {
      'userId': userId,
      'receiverId': receiverId,
      'receiverName': receiverName,
      'receiverImage': receiverImage,
      'messageContent': messageContent,
      'isPhoto': isPhoto,
      'isVideo' : isVideo,
      'isDoc' : isDoc,
      'date': date,
      'geoPoint' : geoPoint
    };
  }
}
