class UsersModel {
  final List<UserModel> users;

  UsersModel({this.users});

  factory UsersModel.fromJson(List<dynamic> json) {
    var users = json.map((userItem) => UserModel.fromJson(userItem)).toList();
    return UsersModel(users: users);
  }
}

class UserModel {
  final String id, email, name, username, userId;
  UserModel({this.id, this.email, this.name, this.username, this.userId});

  factory UserModel.fromJson(dynamic json) {
    return UserModel(
      id: json['id'].toString(),
      // email: json['email'].toString(),
      // name: json['name'],
      username: json['username'],
    );
  }
}