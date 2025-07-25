import 'dart:ui';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shartflix/core/constants/app_colors.dart';
import 'package:shartflix/core/constants/app_icons.dart';
import 'package:shartflix/core/utils/font_helper.dart';
import 'package:shartflix/core/utils/localization_manager.dart';

class PremiumOfferSheet extends StatelessWidget {
  const PremiumOfferSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Stack(
                children: [
                  // Top Gradient
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: const Alignment(0.0, -1.0),
                          radius: 1.0,
                          colors: [
                            const Color(0xFFE50914).withValues(alpha: 0.3),
                            Colors.transparent,
                          ],
                          stops: const [0.2, 1.0],
                        ),
                      ),
                    ),
                  ),
                  // Bottom Gradient
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: const Alignment(0.0, 1.0),
                          radius: 1.0,
                          colors: [
                            const Color(0xFFE50914).withValues(alpha: 0.3),
                            Colors.transparent,
                          ],
                          stops: const [0.2, 1.0],
                        ),
                      ),
                    ),
                  ),
                  // Content
                  Padding(
                    padding: EdgeInsets.only(
                      left: 14.w,
                      right: 14.w,
                      top: 14.h,
                      bottom: 14.h,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildTitleSection(),
                        SizedBox(height: 22.h),
                        _buildBonusSection(),
                        SizedBox(height: 18.h),
                        _buildPackageSelectionSection(),
                        SizedBox(height: 18.h),
                        _buildSeeAllButton(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Sınırlı Teklif'.localized,
          style: TextStyle(
            fontFamily: FontHelper.euclidCircularA().fontFamily,
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20.sp,
          ),
        ),
        SizedBox(height: 8.h),
        SizedBox(
          child: Text(
            "Jeton paketini seçerek bonus\nkazanın ve yeni bölümlerin kilidini açın!"
                .localized,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: FontHelper.euclidCircularA().fontFamily,
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: 12.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBonusSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Text(
            'Alacağınız Bonuslar'.localized,
            style: TextStyle(
              fontFamily: FontHelper.euclidCircularA().fontFamily,
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 15.sp,
            ),
          ),
          SizedBox(height: 14.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              _BonusItem(
                iconPath: AppIcons.featureIcon1,
                label: 'Premium\nHesap',
              ),
              _BonusItem(
                iconPath: AppIcons.featureIcon2,
                label: 'Daha Fazla\nEşleşme',
              ),
              _BonusItem(
                iconPath: AppIcons.featureIcon3,
                label: 'Öne\nÇıkarma',
              ),
              _BonusItem(
                iconPath: AppIcons.featureIcon4,
                label: 'Daha Fazla\nBeğeni',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPackageSelectionSection() {
    return Column(
      children: [
        Text(
          textAlign: TextAlign.center,
          'Kilidi açmak için bir jeton paketi seçin'.localized,
          style: TextStyle(
            fontFamily: FontHelper.euclidCircularA().fontFamily,
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 15.sp,
          ),
        ),
        SizedBox(height: 24.h),
        Row(
          spacing: 10.w,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: _PackageItem(
                discount: '+10%',
                originalPrice: '200',
                discountedPrice: '330',
                price: '99,99',
              ),
            ),
            const Expanded(
              child: _PackageItem(
                discount: '+70%',
                originalPrice: '2.000',
                discountedPrice: '3.375',
                price: '799,99',
                isFeatured: true,
              ),
            ),
            const Expanded(
              child: _PackageItem(
                discount: '+35%',
                originalPrice: '1.000',
                discountedPrice: '1.350',
                price: '399,99',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSeeAllButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: Text(
          'Tüm Jetonları Gör'.localized,
          style: TextStyle(
            fontFamily: FontHelper.euclidCircularA().fontFamily,
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 15.sp,
          ),
        ),
      ),
    );
  }
}

class _BonusItem extends StatelessWidget {
  final String iconPath;
  final String label;
  const _BonusItem({required this.iconPath, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 56.r,
          width: 56.r,
          decoration: BoxDecoration(
            color: const Color(0xFF6F060B),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                offset: const Offset(-1, -1),
                blurRadius: 7,
                color: Colors.white.withValues(alpha: 0.5),
                inset: true,
              ),
              BoxShadow(
                offset: const Offset(1, 1),
                blurRadius: 7,
                color: Colors.white.withValues(alpha: 0.5),
                inset: true,
              ),
            ],
          ),
          child: Image.asset(iconPath, scale: 1.2),
        ),
        SizedBox(height: 8.h),
        Text(
          label.localized,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: FontHelper.euclidCircularA().fontFamily,
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }
}

class _PackageItem extends StatelessWidget {
  final String discount;
  final String originalPrice;
  final String discountedPrice;
  final String price;
  final bool isFeatured;

  const _PackageItem({
    required this.discount,
    required this.originalPrice,
    required this.discountedPrice,
    required this.price,
    this.isFeatured = false,
  });

  @override
  Widget build(BuildContext context) {
    final badge = Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isFeatured ? const Color(0xFF5949E6) : const Color(0xFF6F060B),
        borderRadius: BorderRadius.circular(18.5.r),
        boxShadow: [
          BoxShadow(
            offset: const Offset(-1, -1),
            spreadRadius: 0.5,
            blurRadius: 5,
            color: Colors.white.withValues(alpha: 0.5),
            inset: true,
          ),
          BoxShadow(
            offset: const Offset(1, 1),
            spreadRadius: 0.5,
            blurRadius: 5,
            color: Colors.white.withValues(alpha: 0.5),
            inset: true,
          ),
        ],
      ),
      child: Text(
        discount,
        style: TextStyle(
          fontFamily: FontHelper.euclidCircularA().fontFamily,
          color: Colors.white,
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
    );

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          height: 215.h,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topLeft,
              radius: 2.2,
              colors: [
                isFeatured ? const Color(0xFF5949E6) : const Color(0xFF6F060B),
                AppColors.primary,
              ],
            ),
            borderRadius: BorderRadius.circular(14.r),
            boxShadow: [
              BoxShadow(
                offset: const Offset(-1, -1),
                spreadRadius: 0.5,
                blurRadius: 5,
                color: Colors.white.withValues(alpha: 0.5),
                inset: true,
              ),
              BoxShadow(
                offset: const Offset(1, 1),
                spreadRadius: 0.5,
                blurRadius: 5,
                color: Colors.white.withValues(alpha: 0.5),
                inset: true,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Opacity(opacity: 0.0, child: badge),
              Column(
                children: [
                  Text(
                    originalPrice,
                    style: TextStyle(
                      fontFamily: FontHelper.euclidCircularA().fontFamily,
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  Text(
                    discountedPrice,
                    style: TextStyle(
                      height: 0.7.h,
                      fontFamily: FontHelper.euclidCircularA().fontFamily,
                      color: Colors.white,
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'Jeton'.localized,
                    style: TextStyle(
                      fontFamily: FontHelper.euclidCircularA().fontFamily,
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Divider(
                    color: Colors.white.withValues(alpha: 0.2),
                    indent: 10.w,
                    endIndent: 10.w,
                  ),
                  SizedBox(height: 4.h),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '₺',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        TextSpan(
                          text: price,
                          style: TextStyle(
                            fontFamily: FontHelper.euclidCircularA().fontFamily,
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Başına haftalık'.localized,
                    style: TextStyle(
                      fontFamily: FontHelper.euclidCircularA().fontFamily,
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(top: -11.h, child: badge),
      ],
    );
  }
}
