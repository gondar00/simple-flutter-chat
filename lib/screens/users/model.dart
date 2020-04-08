class UsersModel {
  final List<UserModel> users;

  UsersModel({this.users});

  factory UsersModel.fromJson(List<dynamic> json) {
    final List<UserModel> users = json.map((dynamic userItem) => UserModel.fromJson(userItem)).toList();
    return UsersModel(users: users);
  }
}

class UserModel {
  UserModel({this.id, this.email, this.name, this.username, this.userId});

  factory UserModel.fromJson(dynamic json) {
    return UserModel(
      id: json['id'] as String,
      username: json['username'] as String,
    );
  }

  final String id, email, name, username, userId;
}