import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;
  
  static const String _tokenKey = 'auth_token';

  AuthLocalDataSourceImpl({required this.secureStorage});

  @override
  Future<void> saveToken(String token) async {
    await secureStorage.write(key: _tokenKey, value: token);
  }

  @override
  Future<String?> getToken() async {
    return await secureStorage.read(key: _tokenKey);
  }

  @override
  Future<void> deleteToken() async {
    await secureStorage.delete(key: _tokenKey);
  }
} 