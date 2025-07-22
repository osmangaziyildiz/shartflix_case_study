import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shartflix/core/constants/app_colors.dart';
import 'package:shartflix/core/constants/app_icons.dart';
import 'package:shartflix/core/utils/font_helper.dart';
import 'package:shartflix/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:shartflix/features/auth/presentation/widgets/custom_button.dart';
import 'package:shartflix/features/auth/presentation/widgets/social_login_button.dart';
import 'package:shartflix/core/utils/localization_manager.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Header Section
              Column(
                children: [
                  Text(
                    'Merhabalar'.localized,
                    style: TextStyle(
                      fontFamily: FontHelper.euclidCircularA().fontFamily,
                      color: AppColors.textPrimary,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  SizedBox(
                    width: 236.w,
                    child: Text(
                      'Tempus varius a vitae interdum id tortor elementum tristique elefend at.'
                          .localized,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: FontHelper.euclidCircularA().fontFamily,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        fontSize: 13.sp,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 40.h),

              // Form Section
              Column(
                children: [
                  CustomTextField(
                    hintText: 'E-Posta'.localized,
                    prefixIcon: Icons.email_outlined,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 14.h),
                  CustomTextField(
                    hintText: 'Şifre'.localized,
                    prefixIcon: Icons.lock_outline,
                    controller: _passwordController,
                    isPassword: true,
                  ),
                  SizedBox(height: 14.h),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {
                        // TODO: Forgot password logic
                      },
                      child: Text(
                        'Şifremi unuttum'.localized,
                        style: TextStyle(
                          fontFamily: FontHelper.euclidCircularA().fontFamily,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.textPrimary,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 14.h),

              // Login Button
              CustomButton(
                text: 'Giriş Yap'.localized,
                onPressed: () {
                  // TODO: Login logic
                },
              ),

              SizedBox(height: 30.h),

              // Social Login Section
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SocialLoginButton(
                    iconPath: AppIcons.google,
                    onPressed: () {
                      // TODO: Google login
                    },
                  ),
                  SizedBox(width: 16.w),
                  SocialLoginButton(
                    iconPath: AppIcons.apple,
                    onPressed: () {
                      // TODO: Apple login
                    },
                  ),
                  SizedBox(width: 16.w),
                  SocialLoginButton(
                    iconPath: AppIcons.facebook,
                    onPressed: () {
                      // TODO: Facebook login
                    },
                  ),
                ],
              ),
              SizedBox(height: 22.h),
              // Sign Up Section
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Bir hesabın yok mu?'.localized,
                    style: TextStyle(
                      fontFamily: FontHelper.euclidCircularA().fontFamily,
                      color: AppColors.textPrimary.withValues(alpha: 0.5),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: Navigate to sign up
                    },
                    child: Text(
                      'Kayıt Ol!'.localized,
                      style: TextStyle(
                        fontFamily: FontHelper.euclidCircularA().fontFamily,
                        color: AppColors.textPrimary,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
            ],
          ),
        ),
      ),
    );
  }
}
