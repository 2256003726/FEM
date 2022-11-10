class UserModel {
  String userId;
  String userName;
  String userPassword;
  String userRole;
  String userToken;
  String userTel;
  String userImage;

  UserModel({
    this.userId,
    this.userImage,
    this.userName,
    this.userPassword,
    this.userRole,
    this.userTel,
    this.userToken
  });

  factory UserModel.fromJson(dynamic json) {
    return UserModel(
      userId: json['userId'],
      userImage: json['userImage'],
      userName: json['userName'],
      userPassword: json['userPassword'],
      userRole: json['userRole'],
      userTel: json['userTel'],
      userToken: json['userToken'],  
    );
  }
}

class UserListModel {
  List<UserModel> data;
  UserListModel(this.data);
  factory UserListModel.fromJson(List json) {
    return UserListModel(
      json.map((i) => UserModel.fromJson(i)).toList()
    );
  }
}