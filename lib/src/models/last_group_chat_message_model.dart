import 'package:cloud_firestore/cloud_firestore.dart';

class LastGroupChatMessage {
  String? name;
  String? id;
  String? lastUserId;
  String? lastMessage;
  Timestamp? date;
  List<String> usersId = [];

  LastGroupChatMessage(
      {required this.name,
      required this.id,
      required this.lastUserId,
      required this.lastMessage,
      required this.date,
      required this.usersId});

  LastGroupChatMessage.fromJson(Map<String, dynamic>? json) {
    name = json?['name'];
    id = json?['id'];
    lastUserId = json?['lastUserId'];
    lastMessage = json?['lastMessage'];
    date = json?['date'];
    if (json?['usersId'] != null) {
      json?['usersId'].forEach((id) {
        usersId.add(id);
      });
    }
  }

  toMap() {
    return {
      'name': name,
      'id': id,
      'lastUserId': lastUserId,
      'lastMessage': lastMessage,
      'date': date,
      'usersId' : usersId
    };
  }
}
