class AuthModel {
  final String id;
  final ErrorModel error;
  final String token;

  AuthModel({this.id, this.error, this.token});

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      id: json['id'] as String,
      error: json['error'] != null ? ErrorModel.fromJson(json['error']) : null,
      token: json['token'] as String
    );
  }
}

class ErrorModel {
  final String path;
  final String message;

  ErrorModel({this.path, this.message});

  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    return ErrorModel(path: json['path'], message: json['message']);
  }
}