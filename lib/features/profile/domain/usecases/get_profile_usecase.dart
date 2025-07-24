import 'package:shartflix/features/profile/domain/entities/user_profile_entity.dart';
import 'package:shartflix/features/profile/domain/repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository repository;
  GetProfileUseCase({required this.repository});

  Future<UserProfileEntity> call() async {
    return await repository.getProfile();
  }
} 