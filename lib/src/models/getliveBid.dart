class GetLiveBidModel {
  bool? status;
  List<GetLiveBidData>? data;

  GetLiveBidModel({this.status, this.data});

  GetLiveBidModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <GetLiveBidData>[];
      json['data'].forEach((v) {
        data!.add(new GetLiveBidData.fromJson(v));
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

class GetLiveBidData {
  String? name;
  String? itemDescription;
  String? startingPrice;
  String? privacy;
  String? channelName;
  String? status;
  String? created;
  String? userId;
  String? userName;
  String? userEmail;
  String? userPhone;
  String? userImage;

  GetLiveBidData(
      {this.name,
        this.itemDescription,
        this.startingPrice,
        this.privacy,
        this.channelName,
        this.status,
        this.created,
        this.userId,
        this.userName,
        this.userEmail,
        this.userPhone,
        this.userImage});

  GetLiveBidData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    itemDescription = json['itemDescription'];
    startingPrice = json['startingPrice'];
    privacy = json['privacy'];
    channelName = json['channelName'];
    status = json['status'];
    created = json['created'];
    userId = json['userId'];
    userName = json['userName'];
    userEmail = json['userEmail'];
    userPhone = json['userPhone'];
    userImage = json['userImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['itemDescription'] = this.itemDescription;
    data['startingPrice'] = this.startingPrice;
    data['privacy'] = this.privacy;
    data['channelName'] = this.channelName;
    data['status'] = this.status;
    data['created'] = this.created;
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    data['userEmail'] = this.userEmail;
    data['userPhone'] = this.userPhone;
    data['userImage'] = this.userImage;
    return data;
  }
}