import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:shartflix/core/constants/app_colors.dart';
import 'package:shartflix/core/utils/font_helper.dart';
import 'package:shartflix/core/utils/localization_manager.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.textPrimary,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Lottie.asset('assets/animations/error_animation.json'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                textAlign: TextAlign.center,
                'Sanırım bir şeyler ters gitti. \nEndişelenme, bildirimlerini aldık ve üzerinde çalışmaya başladık bile.'
                    .localized,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.sp,
                  fontFamily:
                      FontHelper.euclidCircularA(
                        fontWeight: FontWeight.w400,
                      ).fontFamily,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
