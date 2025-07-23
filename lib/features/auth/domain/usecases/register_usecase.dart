import 'package:shartflix/core/utils/localization_manager.dart';
import 'package:shartflix/features/auth/domain/entities/user_entity.dart';
import 'package:shartflix/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase({required this.repository});

  Future<UserEntity> call({
    required String email,
    required String name,
    required String password,
    required String passwordAgain,
  }) async {
    // Email validation
    if (email.isEmpty) {
      throw Exception('Email boş olamaz'.localized);
    }
    if (!_isValidEmail(email)) {
      throw Exception('Geçerli bir email adresi girin'.localized);
    }
    if (name.isEmpty) {
      throw Exception('Ad Soyad boş olamaz'.localized);
    }
    if (password.isEmpty) {
      throw Exception('Şifre boş olamaz'.localized);
    }
    if (password.length < 6) {
      throw Exception('Şifre en az 6 karakter olmalı'.localized);
    }
    if (password != passwordAgain) {
      throw Exception('Şifreler eşleşmiyor'.localized);
    }
    return await repository.register(
      email: email,
      name: name,
      password: password,
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}').hasMatch(email);
  }
} 