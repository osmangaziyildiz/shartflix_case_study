import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shartflix/core/constants/app_colors.dart';
import 'package:shartflix/core/utils/font_helper.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final String prefixIcon;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final VoidCallback? onToggleVisibility;
  final bool showVisibilityToggle;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.isPassword = false,
    this.controller,
    this.keyboardType,
    this.obscureText,
    this.onToggleVisibility,
    this.showVisibilityToggle = true,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final bool effectiveObscureText = widget.obscureText ?? _obscureText;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: TextField(
        cursorColor: AppColors.textPrimary,
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        obscureText: widget.isPassword ? effectiveObscureText : false,
        style: TextStyle(
          fontFamily: FontHelper.euclidCircularA().fontFamily,
          color: AppColors.textPrimary,
          fontSize: 16.sp,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            fontFamily: FontHelper.euclidCircularA().fontFamily,
            fontWeight: FontWeight.w400,
            color: AppColors.textPrimary.withValues(alpha: 0.5),
            fontSize: 12.sp,
          ),
          prefixIcon: Image.asset(
            widget.prefixIcon,
            scale: 1.4.h,
            width: 22.w,
            height: 22.h,
          ),
          suffixIcon: widget.isPassword && widget.showVisibilityToggle
              ? IconButton(
                  icon: Icon(
                    effectiveObscureText ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.textPrimary,
                    size: 22.sp,
                  ),
                  onPressed: widget.onToggleVisibility ?? () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(
            left: 16.w,
            right: 16.w,
            top: 15.h,
            bottom: 15.h,
          ),
        ),
      ),
    );
  }
}
 