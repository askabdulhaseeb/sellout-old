import 'package:cloud_firestore/cloud_firestore.dart';

class StoriesModel {
  String? userId;
  String? userName;
  String? userImage;
  Timestamp? date;
  List<String> stories = [];
  List<String> extensions = [];

  StoriesModel(
      {required this.userId,
      required this.userName,
      required this.userImage,
      required this.date,
      required this.stories,
      required this.extensions});

  StoriesModel.fromJson(Map<String, dynamic>? json) {
    userId = json?['userId'];
    userName = json?['userName'];
    userImage = json?['userImage'];
    date = json?['date'];
    if (json?['stories'] != null) {
      json?['stories'].forEach((story) {
        stories.add(story);
      });
    }
    if (json?['extensions'] != null) {
      json?['extensions'].forEach((extension) {
        extensions.add(extension);
      });
    }
  }

  toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userImage': userImage,
      'date' :date,
      'stories': stories,
      'extensions': extensions
    };
  }
}
