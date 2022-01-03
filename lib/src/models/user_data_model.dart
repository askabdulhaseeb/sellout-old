import 'package:sellout_team/src/constants/constants.dart';

class UserInfoModel {
  bool? status;
  String? message;
  UserData? data;

  UserInfoModel(
      {required this.status, required this.message, required this.data});

  UserInfoModel.fromJson(Map<String, dynamic>? json) {
    status = json?['status'];
    message = json?['message'];
    data =
        (json?['data'] != null ? new UserData.fromJson(json?['data']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class UserData {
  String? id;
  String? name;
  String? email;
  String? password;
  String? phone;
  String? userimg;
  String? biography;
  String? token;
  String? category;
  String? ispublic;
  String? username;
  String? created;
  String? modified;
  String? status;

  UserData(
      {this.id,
      this.name,
      this.email,
      this.password,
      this.phone,
      this.userimg,
      this.biography,
      this.token,
      this.category,
      this.ispublic,
      this.username,
      this.created,
      this.modified,
      this.status});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    phone = json['phone'];
    userimg = json['userimg'];
    biography = json['biography'];
    token = json['token'] ?? "";
    category = json['category'];
    ispublic = json['ispublic'];
    username = json['username'];
    created = json['created'];
    modified = json['modified'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['phone'] = this.phone;
    data['userimg'] = this.userimg;
    data['biography'] = this.biography;
    data['token'] = this.token;
    data['category'] = this.category;
    data['ispublic'] = this.ispublic;
    data['username'] = this.username;
    data['created'] = this.created;
    data['modified'] = this.modified;
    data['status'] = this.status;
    return data;
  }
}
