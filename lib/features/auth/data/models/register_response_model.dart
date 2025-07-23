import 'package:shartflix/features/auth/domain/entities/user_entity.dart';

class RegisterResponseModel {
  final ResponseInfo response;
  final UserData data;

  const RegisterResponseModel({
    required this.response,
    required this.data,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      response: ResponseInfo.fromJson(json['response']),
      data: UserData.fromJson(json['data']),
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: data.id,
      name: data.name,
      email: data.email,
      photoUrl: data.photoUrl,
      token: data.token,
    );
  }
}

class ResponseInfo {
  final int code;
  final String message;

  const ResponseInfo({
    required this.code,
    required this.message,
  });

  factory ResponseInfo.fromJson(Map<String, dynamic> json) {
    return ResponseInfo(
      code: json['code'],
      message: json['message'] ?? '',
    );
  }
}

class UserData {
  final String id;
  final String name;
  final String email;
  final String photoUrl;
  final String token;

  const UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.token,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      photoUrl: json['photoUrl'] ?? '',
      token: json['token'],
    );
  }
} 