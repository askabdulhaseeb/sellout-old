class PostModelMain {
  bool? status;
  List<PostModel>? data;

  PostModelMain({this.status, this.data});

  PostModelMain.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <PostModel>[];
      json['data'].forEach((v) {
        data!.add(new PostModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PostModel {
  String? id;
  String? content;
  String? categoryId;
  String? country;
  String? description;
  String? userId;
  String? isCollection;
  String? isNew;
  String? isOffer;
  String? locality;
  String? price;
  String? quantity;
  String? postDate;
  String? created;
  String? userName;
  String? userEmail;
  String? userPhone;
  String? userImage;
  List<Images>?images;

  PostModel(
      {this.id,
        this.content,
        this.categoryId,
        this.country,
        this.description,
        this.userId,
        this.isCollection,
        this.isNew,
        this.isOffer,
        this.locality,
        this.price,
        this.quantity,
        this.postDate,
        this.created,
        this.userName,
        this.userEmail,
        this.userPhone,
        this.userImage,
        this.images});

  PostModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    categoryId = json['categoryId'];
    country = json['country'];
    description = json['description'];
    userId = json['userId'];
    isCollection = json['isCollection'];
    isNew = json['isNew'];
    isOffer = json['isOffer'];
    locality = json['locality'];
    price = json['price'];
    quantity = json['quantity'];
    postDate = json['postDate'];
    created = json['created'];
    userName = json['userName'];
    userEmail = json['userEmail'];
    userPhone = json['userPhone'];
    userImage = json['userImage'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['content'] = this.content;
    data['categoryId'] = this.categoryId;
    data['country'] = this.country;
    data['description'] = this.description;
    data['userId'] = this.userId;
    data['isCollection'] = this.isCollection;
    data['isNew'] = this.isNew;
    data['isOffer'] = this.isOffer;
    data['locality'] = this.locality;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['postDate'] = this.postDate;
    data['created'] = this.created;
    data['userName'] = this.userName;
    data['userEmail'] = this.userEmail;
    data['userPhone'] = this.userPhone;
    data['userImage'] = this.userImage;
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Images {
  String? imageId;
  String? imageUrl;

  Images({this.imageId, this.imageUrl});

  Images.fromJson(Map<String, dynamic> json) {
    imageId = json['imageId'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imageId'] = this.imageId;
    data['imageUrl'] = this.imageUrl;
    return data;
  }
}