import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shartflix/core/constants/app_colors.dart';
import 'package:shartflix/core/navigation/app_routes.dart';
import 'package:shartflix/core/utils/font_helper.dart';
import 'package:shartflix/core/utils/localization_manager.dart';

class ProfileTopBar extends StatelessWidget {
  const ProfileTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(32.r),
              border: Border.all(
                color: AppColors.textPrimary.withValues(alpha: 0.2),
                width: 1.2,
              ),
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: AppColors.textPrimary,
                size: 20.sp,
              ),
              onPressed: () {
                // TODO: Home sayfasına yönlendirme eklenecek
                
              },
            ),
          ),
        ),
        Center(
          child: Text(
            'Profil Detayı'.localized,
            style: TextStyle(
              fontFamily: FontHelper.euclidCircularA().fontFamily,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
              fontSize: 15.sp,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(22.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/icons/diamond_icon.png', width: 16.w, height: 16.h),
                SizedBox(width: 6.w),
                Text(
                  'Sınırlı Teklif'.localized,
                  style: TextStyle(
                    fontFamily: FontHelper.euclidCircularA().fontFamily,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
