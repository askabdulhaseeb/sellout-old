import 'package:cloud_firestore/cloud_firestore.dart';

class CartModel {
  String? cartId;
  String? postUserId;
  String? postId;
  String? content;
  String? price;
  Timestamp? date;
  String? maxQuantity;
  String? quantity;
  List<String> media = [];
  List<String> extensions = [];

  CartModel({
    required this.cartId,
    required this.postUserId,
    required this.postId,
    required this.content,
    required this.price,
    required this.date,
    required this.maxQuantity,
    required this.quantity,
    required this.media,
    required this.extensions,
  });

  CartModel.fromJson(Map<String, dynamic>? json) {
    cartId = json?['cartId'];
    postUserId = json?['postUserId'];
    postId = json?['postId'];
    content = json?['content'];
    price = json?['price'];
    date = json?['date'];
    maxQuantity = json?['maxQuantity'];
    quantity = json?['quantity'];
    if (json?['media'] != null) {
      json?['media'].forEach((mediaItem) {
        media.add(mediaItem);
      });
    }
    if (json?['extensions'] != null) {
      json?['extensions'].forEach((extensionsItem) {
        extensions.add(extensionsItem);
      });
    }
  }

  toMap() {
    return {
      'cartId': cartId,
      'postUserId': postUserId,
      'postId': postId,
      'content': content,
      'price': price,
      'date': date,
      'maxQuantity': maxQuantity,
      'quantity': quantity,
      'media': media,
      'extensions': extensions,
    };
  }
}
