import 'package:shartflix/features/profile/domain/entities/user_profile_entity.dart';

class UserProfileModel {
  final String id;
  final String name;
  final String email;
  final String photoUrl;

  const UserProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.photoUrl,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      photoUrl: json['photoUrl'] ?? '',
    );
  }

  UserProfileEntity toEntity() {
    return UserProfileEntity(
      id: id,
      name: name,
      email: email,
      photoUrl: photoUrl,
    );
  }
} 