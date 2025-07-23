import 'package:shartflix/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:shartflix/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:shartflix/features/auth/data/models/login_request_model.dart';
import 'package:shartflix/features/auth/data/models/register_request_model.dart';
import 'package:shartflix/features/auth/domain/entities/user_entity.dart';
import 'package:shartflix/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    final request = LoginRequestModel(
      email: email,
      password: password,
    );
    final response = await remoteDataSource.login(request);
    await localDataSource.saveToken(response.data.token);
    return response.toEntity();
  }

  @override
  Future<UserEntity> register({
    required String email,
    required String name,
    required String password,
  }) async {
    final request = RegisterRequestModel(
      email: email,
      name: name,
      password: password,
    );
    final response = await remoteDataSource.register(request);
    await localDataSource.saveToken(response.data.token);
    return response.toEntity();
  }

  @override
  Future<void> saveToken(String token) async {
    await localDataSource.saveToken(token);
  }

  @override
  Future<String?> getToken() async {
    return await localDataSource.getToken();
  }

  @override
  Future<void> logout() async {
    await localDataSource.deleteToken();
  }
} 