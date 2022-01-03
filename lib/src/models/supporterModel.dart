class SupporterModel {
  bool? status;
  List<SupportUserData>? data;

  SupporterModel({this.status, this.data});

  SupporterModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <SupportUserData>[];
      json['data'].forEach((v) {
        data!.add(new SupportUserData.fromJson(v));
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

class SupportUserData {
  String? userId;
  String? userName;
  String? userEmail;
  String? userPhone;
  String? userImage;
  String? biography;

  SupportUserData(
      {this.userId,
        this.userName,
        this.userEmail,
        this.userPhone,
        this.userImage,
      this.biography});

  SupportUserData.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userName = json['userName'];
    userEmail = json['userEmail'];
    userPhone = json['userPhone'];
    userImage = json['userImage'];
    biography = json['biography'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    data['userEmail'] = this.userEmail;
    data['userPhone'] = this.userPhone;
    data['userImage'] = this.userImage;
    data['biography'] = this.biography;
    return data;
  }
}