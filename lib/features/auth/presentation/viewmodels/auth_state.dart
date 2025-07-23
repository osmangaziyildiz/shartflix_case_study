import 'package:shartflix/features/auth/domain/entities/user_entity.dart';

abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final UserEntity user;

  const AuthSuccess({required this.user});
}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});
} 