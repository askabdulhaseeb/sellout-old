class CategoryModelMain {
  bool? status;
  List<CategoryModel>? data;

  CategoryModelMain({required this.status, required this.data});

  CategoryModelMain.fromJson(Map<String, dynamic>? json) {
    status = json?['status'];
    if (json?['data'] != null) {
      data = <CategoryModel>[];
      json!['data'].forEach((v) {
        data!.add(CategoryModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CategoryModel {
  String? id;
  String? categoryName;
  String? status;
  String? created;
  String? modified;

  CategoryModel({required this.id, required this.categoryName, required this.status, required this.created, required this.modified});

  CategoryModel.fromJson(Map<String, dynamic>? json) {
    id = json!['id'];
    categoryName = json['categoryName'];
    status = json['status'];
    created = json['created'];
    modified = json['modified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['categoryName'] = categoryName;
    data['status'] = status;
    data['created'] = created;
    data['modified'] = modified;
    return data;
  }
}