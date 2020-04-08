class ErrorModel {
  final String path;
  final String message;

  ErrorModel({this.path, this.message});

  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    return ErrorModel(path: json['path'], message: json['message']);
  }
}
