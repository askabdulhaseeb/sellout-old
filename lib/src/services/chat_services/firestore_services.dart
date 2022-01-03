import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sellout_team/src/constants/constants.dart';

class FirestoreServices {
  Future<void> addUserToFirestore(
      {required String id, required Map<String, dynamic> map}) async {
    await FirebaseFirestore.instance.collection('users').doc(id).set(map);
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllUsersService() async {
    return await FirebaseFirestore.instance.collection('users').get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>>
      getCurrentUserDataService(String uid) async {
    return await FirebaseFirestore.instance.collection('users').doc(uid).get();
  }

  Future<void> storeMessageForCurrentUser(
      {required String receiverId,
      required Map<String, dynamic> messageModel}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(kUid)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .doc()
        .set(messageModel);
  }

  Future<void> storeMessageForReceiverUser(
      {required String receiverId,
      required Map<String, dynamic> messageModel}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(kUid)
        .collection('messages')
        .doc()
        .set(messageModel);
  }

  getCurrentChatsService(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('chats')
        .orderBy('lastMessageDate', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessagesService(
      {required String recieverId}) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(kUid)
        .collection('chats')
        .doc(recieverId)
        .collection('messages')
        .orderBy('date', descending: true)
        .snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUserChatsServeice() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(kUid)
        .collection('chats')
        .get();
  }

  Future<void> storeLastMessageForCurrentUserService(
      {required String? userId,
      required String? recieverId,
      required Map<String, dynamic> lastMessageModel}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('chats')
        .doc(recieverId)
        .set(lastMessageModel);
  }

  Future<void> storeLastMessageForReciever(
      {required String? recieverId,
      required String? userId,
      required Map<String, dynamic> lastMessageModel}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(recieverId)
        .collection('chats')
        .doc(userId)
        .set(lastMessageModel);
  }

  Future<DocumentReference<Map<String, dynamic>>> sendMessageToGroupService(
      String id, Map<String, dynamic> groupMap) async {
    return await FirebaseFirestore.instance
        .collection('groups')
        .doc(id)
        .collection('messages')
        .add(groupMap);
  }

  Future<void> sendLastGroupMessageService(
      String id, Map<String, dynamic> groupMap) async {
    await FirebaseFirestore.instance.collection('groups').doc(id).set(groupMap);
  }

  Future<void> addGroupChatService(String id, String name) async {
    await FirebaseFirestore.instance
        .collection('groups')
        .doc(id)
        .set({'id': id, 'name': name});
  }

  Future<void> addGroupUsersService(
      String id, String userId, Map<String, dynamic> userMap) async {
    await FirebaseFirestore.instance
        .collection('groups')
        .doc(id)
        .collection('users')
        .doc(userId)
        .set(userMap);
  }

  Future<QuerySnapshot<Map<String, dynamic>>> chatsSearchService(
      String userId, String value) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('chats')
        .where('userName', isEqualTo: value)
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> groupSearchService(
      String userId, String value) async {
    return await FirebaseFirestore.instance
        .collection('groups')
        .where('usersId', arrayContains: userId)
        .where('name', isEqualTo: value)
        .get();
  }

  Future<void> addStoriesService(
      {required String? userId,
      required Map<String, dynamic> storiesMap}) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('stories')
        .doc()
        .set(storiesMap);
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getStoriesService(
      String userId) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('stories')
        .orderBy('date', descending: true)
        .get();
  }

  Future<void> deleteChatService(String userId, String otherUserId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('chats')
        .doc(otherUserId)
        .delete();
  }

  // Future<void> deleteChatMessagesService(
  //     String userId, String otherUserId) async {
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(userId)
  //       .collection('chats')
  //       .doc(otherUserId)

  //       .collection('messages')
  //       .doc()
  //       .delete();
  // }
}
