class UserModel{

  String? name;
  String? id;
  String? email;
  String? image;
  

  UserModel(
  {
    required this.name,
    required this.id,
    required this.email,
    required this.image
}
      );

  UserModel.fromFirebase(Map<String , dynamic>? map){
    id = map?['id'];
    name = map?['name'];
    email = map?['email'];
    image = map?['image'];
  }

  toMap(){
    return {
      'id' : id,
      'name': name,
      'email' : email ,
      'image' : image
    };
  }
}