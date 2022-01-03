import 'package:sellout_team/src/models/post_model.dart';
import 'package:sellout_team/src/models/user_data_model.dart';

class GetProfileModel {
  bool? status;
  UserData? data;
  int? supporting;
  int? supporter;
  List<Post>? post;

  GetProfileModel({this.status, this.data, this.post});

  GetProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    supporting = json['supporting'];
    supporter = json['supporter'];
    data = json['data'] != null ? new UserData.fromJson(json['data']) : null;
    if (json['post'] != null) {
      post = <Post>[];
      json['post'].forEach((v) {
        post!.add(new Post.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['supporting'] = this.supporting;
    data['supporter'] = this.supporter;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.post != null) {
      data['post'] = this.post!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class Post {
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
  List<Images>?images;

  Post(
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
        this.images
      });

  Post.fromJson(Map<String, dynamic> json) {
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
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}