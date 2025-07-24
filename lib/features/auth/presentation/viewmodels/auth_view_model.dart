import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shartflix/core/error/exceptions.dart';
import 'package:shartflix/core/utils/localization_manager.dart';
import 'package:shartflix/features/auth/domain/usecases/login_usecase.dart';
import 'package:shartflix/features/auth/domain/usecases/register_usecase.dart';
import 'package:shartflix/features/auth/presentation/viewmodels/auth_state.dart';

class AuthViewModel extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;

  AuthViewModel({required this.loginUseCase, required this.registerUseCase})
    : super(AuthInitial());

  Future<void> login({required String email, required String password}) async {
    try {
      emit(AuthLoading());
      final user = await loginUseCase(email: email, password: password);
      emit(AuthSuccess(user: user));
    } on ServerException catch (e) {
      emit(AuthError(message: e.message.localized));
    } catch (e) {
      emit(AuthError(message: 'Beklenmedik bir hata oluştu'.localized));
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
    } on ServerException catch (e) {
      emit(AuthError(message: e.message.localized));
    } catch (e) {
      emit(AuthError(message: 'Beklenmedik bir hata oluştu'.localized));
    }
  }
}
