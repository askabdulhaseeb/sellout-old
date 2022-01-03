class OfferModel {
  String? postId;
  int? quantity;
  int? price;
  String? userId;
  String? userName;
  String? postUserId;

  OfferModel({
    required this.postId,
    required this.postUserId,
    required this.userId,
    required this.userName,
    required this.quantity,
    required this.price
  });

  OfferModel.fromJson(Map<String, dynamic>? json) {
    postId = json?['postId'];
    quantity = json?['quantity'];
    price = json?['price'];
    userId = json?['userId'];
    userName = json?['userName'];
    postUserId = json?['postUserId'];
  }

  toMap() {
    return {
      'postId': postId,
      'quantity': quantity,
      'price': price,
      'userId': userId,
      'userName': userName,
      'postUserId': postUserId,
    };
  }
}
