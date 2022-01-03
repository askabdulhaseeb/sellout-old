import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sellout_team/src/models/post_model.dart';

class PostServices {
  Future<void> addPostService(PostModel postModel, String postId) async {
    // await FirebaseFirestore.instance
    //     .collection('posts')
    //     .doc(postId)
    //     .set(postModel.toMap());
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getPostsService() async {
    return await FirebaseFirestore.instance
        .collection('posts')
        .orderBy('date', descending: true)
        .get();
  }

  Future<void> addOfferService(
      {required String postUserId,
      required String postId,
      required Map<String, dynamic> map}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(postUserId)
        .collection('offers')
        .doc(postId)
        .set(map);
  }

 Future<QuerySnapshot<Map<String, dynamic>>>  getHideService(String id) async {
  return   await FirebaseFirestore.instance
        .collection('hide')
        .doc(id)
        .collection('hide')
        .get();
  }

   Future<QuerySnapshot<Map<String, dynamic>>> getBlockService(String id) async {
    return await FirebaseFirestore.instance
        .collection('blocks')
        .doc(id)
        .collection('blocks')
        .get();
  }
}
