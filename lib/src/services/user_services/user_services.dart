import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/models/cart_model.dart';
import 'package:sellout_team/src/models/user_data_model.dart';
import 'package:sellout_team/src/models/user_model.dart';
import 'package:sellout_team/src/services/post_services/post_services.dart';
import 'package:http/http.dart' as http;

class UserServices {
  addUserInfoService(String id, Map<String, dynamic> userMap) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('info')
        .doc(id)
        .set(userMap);
  }

  updateUserInfoService(String id, Map<String, dynamic> userMap) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('info')
        .doc(id)
        .update(userMap);
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserInfoService(
      String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('info')
        .doc(id)
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getPostsForCurrentUserService(
      String id) async {
    return await FirebaseFirestore.instance
        .collection('posts')
        .where('userId', isEqualTo: id)
        .orderBy('date', descending: true)
        .get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getPostByIdService(
      String postId) async {
    return await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getPostsByCategoryService(
      String userId, String selectedCategory) async {
    return await FirebaseFirestore.instance
        .collection('posts')
        .where('userId', isEqualTo: userId)
        .where('category', isEqualTo: selectedCategory)
        .get();
  }

  Future<void> addToCartService(
      String id, String cartId, Map<String, dynamic> cartMap) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('cart')
        .doc(cartId)
        .set(cartMap);
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getCartService(String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('cart')
        .get();
  }

  Future<void> deleteCartItemService(String id, String cartId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('cart')
        .doc(cartId)
        .delete();
  }

  Future<void> updateCartService(String id, CartModel cartModel) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('cart')
        .doc(cartModel.cartId)
        .update(cartModel.toMap());
  }

  Future<void> addSupport(
      {required UserInfoModel otherUserModel,
      required String currentUserId,
      required UserInfoModel currentUserModel}) async {


    debugPrint(otherUserModel.data!.id.toString());

    try {
      var url = baseURL + kAddSupport;

      String username = 'kamleshRahul';
      String password = 'paramSoft@123';

      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));
      final response = await http.post(Uri.parse(url), body: {
        "UserId": kUserModel!.id.toString(),
        "SupportUserid": otherUserModel.data!.id.toString()}, headers: {
        'authorization': basicAuth,
        'Accept': 'application/json',
        "Authorization": "Basic a2FtbGVzaFJhaHVsOnBhcmFtU29mdEAxMjM=",
        "X-API-KEY": "708ea968-1013-4828-a2b2-b010f08205d5"
      });
      final responseData = json.decode(response.body);

      if (responseData["status"] == false) {
        throw HttpException(responseData["message"]);
      } else {
      }

    } catch (error) {
      print(error);
    }

    // await FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(currentUserId)
    //     .collection('supporting')
    //     .doc(otherUserModel.id)
    //     .set(otherUserModel.toMap());

    // await FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(otherUserModel.id)
    //     .collection('supporters')
    //     .doc(currentUserId)
    //     .set(currentUserModel.toMap());
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getSupportingService(
      String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('supporting')
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getSupportersService(
      String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('supporters')
        .get();
  }

  deleteSupport(String otherUserId, String currentUserId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('supporting')
        .doc(otherUserId)
        .delete();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(otherUserId)
        .collection('supporters')
        .doc(currentUserId)
        .delete();
  }

  Future<void> sendReportService(UserInfoModel userInfoModel) async {
    // await FirebaseFirestore.instance
    //     .collection('reports')
    //     .doc(userInfoModel.id)
    //     .set(userInfoModel.toMap());
  }

  Future<void> blockUser(
      {required UserModel userBlocker, required UserModel userBlocked}) async {
    await FirebaseFirestore.instance
        .collection('blocks')
        .doc(userBlocker.id)
        .collection('blocks')
        .doc(userBlocked.id)
        .set(userBlocked.toMap());
  }

  Future<void> hideUserService(
      {required UserModel userHider, required UserModel userHiden}) async {
    await FirebaseFirestore.instance
        .collection('hide')
        .doc(userHider.id)
        .collection('hide')
        .doc(userHiden.id)
        .set(userHiden.toMap());
  }
}
