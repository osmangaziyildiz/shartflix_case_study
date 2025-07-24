import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shartflix/core/constants/app_colors.dart';
import 'package:shartflix/core/utils/font_helper.dart';
import 'package:shartflix/core/utils/localization_manager.dart';
import 'package:shartflix/features/profile/domain/entities/user_profile_entity.dart';

class ProfileSection extends StatelessWidget {
  final UserProfileEntity user;
  final VoidCallback onPhotoUpload;
  const ProfileSection({super.key, required this.user, required this.onPhotoUpload});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 26.r,
          backgroundColor: Colors.white.withValues(alpha: 0.2),
          backgroundImage: user.photoUrl.isNotEmpty
              ? NetworkImage(user.photoUrl)
              : null,
          child: user.photoUrl.isEmpty
              ? Icon(Icons.camera_alt_rounded, color: AppColors.textPrimary.withValues(alpha: 0.5), size: 22.sp)
              : null,
        ),
        SizedBox(width: 16.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.name,
              style: TextStyle(
                fontFamily: FontHelper.euclidCircularA().fontFamily,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
                fontSize: 15.sp,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'ID: ${user.id.length > 10 ? '${user.id.substring(0, 10)}...' : user.id}',
              style: TextStyle(
                fontFamily: FontHelper.euclidCircularA().fontFamily,
                color: AppColors.textPrimary.withValues(alpha: 0.5),
                fontWeight: FontWeight.w400,
                fontSize: 12.sp,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const Spacer(),
        GestureDetector(
          onTap: onPhotoUpload,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 9.h),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(10.r),
              child: Text(
                'Fotoğraf Ekle'.localized,
                style: TextStyle(
                  fontFamily: FontHelper.euclidCircularA().fontFamily,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13.sp,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
