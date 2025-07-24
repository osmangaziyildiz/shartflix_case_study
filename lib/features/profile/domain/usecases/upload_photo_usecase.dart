import 'dart:io';
import 'package:shartflix/features/profile/domain/entities/user_profile_entity.dart';
import 'package:shartflix/features/profile/domain/repositories/profile_repository.dart';

class UploadPhotoUseCase {
  final ProfileRepository repository;
  UploadPhotoUseCase({required this.repository});

  Future<UserProfileEntity> call(File file) async {
    return await repository.uploadPhoto(file);
  }
} 