import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shartflix/core/constants/app_colors.dart';
import 'package:shartflix/core/constants/app_icons.dart';
import 'package:shartflix/core/navigation/app_routes.dart';
import 'package:shartflix/core/services/service_locator.dart';
import 'package:shartflix/core/utils/font_helper.dart';
import 'package:shartflix/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:shartflix/features/auth/presentation/widgets/custom_login_button.dart';
import 'package:shartflix/features/auth/presentation/widgets/social_login_button.dart';
import 'package:shartflix/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:shartflix/features/auth/presentation/viewmodels/auth_state.dart';
import 'package:shartflix/core/utils/localization_manager.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordAgainController =
      TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordAgainController.dispose();
    super.dispose();
  }

  void _onRegister(BuildContext context) {
    context.read<AuthViewModel>().register(
      email: _emailController.text.trim(),
      name: _nameController.text.trim(),
      password: _passwordController.text,
      passwordAgain: _passwordAgainController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthViewModel>(),
      child: Builder(
        builder: (context) {
          return BlocListener<AuthViewModel, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) {
                context.go(Routes.home);
              } else if (state is AuthError) {
                showTopSnackBar(
                  Overlay.of(context),
                  CustomSnackBar.error(message: state.message),
                );
              }
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: AppColors.background,
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Header
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Hoş geldiniz'.localized,
                            style: TextStyle(
                              fontFamily:
                                  FontHelper.euclidCircularA().fontFamily,
                              color: AppColors.textPrimary,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          SizedBox(
                            width: 244.w,
                            child: Text(
                              'Tempus varius a vitae interdum id tortor elementum tristique eleifend at.'
                                  .localized,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily:
                                    FontHelper.euclidCircularA().fontFamily,
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w400,
                                fontSize: 13.sp,
                                letterSpacing: 0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40.h),
                      // Form
                      Column(
                        spacing: 12.h,
                        children: [
                          CustomTextField(
                            hintText: 'Ad Soyad'.localized,
                            prefixIcon: AppIcons.userIcon,
                            controller: _nameController,
                          ),
                          CustomTextField(
                            hintText: 'E-Posta'.localized,
                            prefixIcon: AppIcons.emailIcon,
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          CustomTextField(
                            hintText: 'Şifre'.localized,
                            prefixIcon: AppIcons.unlockIcon,
                            controller: _passwordController,
                            isPassword: true,
                            obscureText: _obscureText,
                            onToggleVisibility: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                          CustomTextField(
                            hintText: 'Şifre Tekrar'.localized,
                            prefixIcon: AppIcons.unlockIcon,
                            controller: _passwordAgainController,
                            isPassword: true,
                            obscureText: _obscureText,
                            showVisibilityToggle: false,
                          ),
                        ],
                      ),
                      SizedBox(height: 14.h),
                      // Sözleşme
                      Padding(
                        padding: EdgeInsets.only(
                          left: 4.w,
                          right: 4.w,
                          bottom: 8.h,
                        ),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Kullanıcı sözleşmesini '.localized,
                                style: TextStyle(
                                  fontFamily:
                                      FontHelper.euclidCircularA().fontFamily,
                                  color: AppColors.textPrimary.withValues(
                                    alpha: 0.5,
                                  ),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextSpan(
                                text: 'okudum ve kabul ediyorum.'.localized,
                                style: TextStyle(
                                  fontFamily:
                                      FontHelper.euclidCircularA().fontFamily,
                                  color: AppColors.textPrimary,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppColors.textPrimary,
                                  decorationThickness: 1.2,
                                ),
                              ),
                              TextSpan(
                                text:
                                    ' Bu sözleşmeyi okuyarak devam ediniz lütfen.'
                                        .localized,
                                style: TextStyle(
                                  fontFamily:
                                      FontHelper.euclidCircularA().fontFamily,
                                  color: AppColors.textPrimary.withValues(
                                    alpha: 0.5,
                                  ),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 38.h),
                      // Kayıt Ol Butonu
                      BlocBuilder<AuthViewModel, AuthState>(
                        builder: (context, state) {
                          return CustomLoginButton(
                            text: 'Şimdi Kaydol'.localized,
                            isLoading: state is AuthLoading,
                            onPressed:
                                state is AuthLoading
                                    ? () {}
                                    : () => _onRegister(context),
                          );
                        },
                      ),
                      SizedBox(height: 30.h),
                      // Sosyal Login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SocialLoginButton(
                            iconPath: AppIcons.google,
                            onPressed: () {},
                          ),
                          SizedBox(width: 16.w),
                          SocialLoginButton(
                            iconPath: AppIcons.apple,
                            onPressed: () {},
                          ),
                          SizedBox(width: 16.w),
                          SocialLoginButton(
                            iconPath: AppIcons.facebook,
                            onPressed: () {},
                          ),
                        ],
                      ),
                      SizedBox(height: 22.h),
                      // Girişe Yönlendirme
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Zaten bir hesabın var mı?'.localized,
                            style: TextStyle(
                              fontFamily:
                                  FontHelper.euclidCircularA().fontFamily,
                              color: AppColors.textPrimary.withValues(
                                alpha: 0.5,
                              ),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              context.push(Routes.login);
                            },
                            child: Text(
                              'Giriş Yap!'.localized,
                              style: TextStyle(
                                fontFamily:
                                    FontHelper.euclidCircularA().fontFamily,
                                color: AppColors.textPrimary,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.h),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
