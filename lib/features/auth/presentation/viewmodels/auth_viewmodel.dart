import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shartflix/features/auth/domain/usecases/login_usecase.dart';
import 'package:shartflix/features/auth/domain/usecases/register_usecase.dart';
import 'package:shartflix/features/auth/presentation/viewmodels/auth_state.dart';

class AuthViewmodel extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;

  AuthViewmodel({required this.loginUseCase, required this.registerUseCase}) : super(AuthInitial());

  @override
  Future<void> close() {
    debugPrint('AuthViewmodel closed');
    return super.close();
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthLoading());
      final user = await loginUseCase(
        email: email,
        password: password,
      );
      emit(AuthSuccess(user: user));
    } catch (e) {
      emit(AuthError(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> register({
    required String email,
    required String name,
    required String password,
    required String passwordAgain,
  }) async {
    try {
      emit(AuthLoading());
      final user = await registerUseCase(
        email: email,
        name: name,
        password: password,
        passwordAgain: passwordAgain,
      );
      emit(AuthSuccess(user: user));
    } catch (e) {
      emit(AuthError(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  void reset() {
    emit(AuthInitial());
  }
} 