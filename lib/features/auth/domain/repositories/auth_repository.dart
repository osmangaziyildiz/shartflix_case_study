import 'package:shartflix/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login({
    required String email, 
    required String password,
  });

  Future<UserEntity> register({
    required String email,
    required String name,
    required String password,
  });
  
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> logout();
} 