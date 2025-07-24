import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shartflix/core/constants/app_colors.dart';
import 'package:shartflix/core/utils/font_helper.dart';
import 'package:shartflix/core/utils/localization_manager.dart';
import 'package:shartflix/features/profile/domain/entities/movie_entity.dart';

class ProfileFavoriteFilms extends StatelessWidget {
  final List<MovieEntity> movies;
  const ProfileFavoriteFilms({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Beğendiğim Filmler'.localized,
            style: TextStyle(
              fontFamily: FontHelper.euclidCircularA().fontFamily,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 13.sp,
            ),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: movies.isEmpty
                ? Center(
                    child: Text(
                      'Henüz hiç bir filmi favoriye eklemediniz.'.localized,
                      style: TextStyle(
                        fontFamily: FontHelper.euclidCircularA().fontFamily,
                        color: AppColors.textPrimary.withValues(alpha: 0.5),
                        fontSize: 13.sp,
                      ),
                    ),
                  )
                : LayoutBuilder(builder: (context, constraints) {
                    final double cardWidth = (constraints.maxWidth - 14.w) / 2;
                    return SingleChildScrollView(
                      child: Wrap(
                        spacing: 14.w,
                        runSpacing: 18.h,
                        children: movies.map((movie) {
                          return SizedBox(
                            width: cardWidth,
                            child: _MovieCard(
                              image: movie.cover,
                              title: movie.title,
                              subtitle: movie.genre,
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }),
          ),
        ],
      ),
    );
  }
}

class _MovieCard extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  const _MovieCard({required this.image, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14.r),
            child: Image.network(
              image,
              width: double.infinity,
              height: 200.h,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: double.infinity,
                height: 200.h,
                color: AppColors.background,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.movie_creation_outlined, color: AppColors.textPrimary.withValues(alpha: 0.3), size: 36.sp),
                    SizedBox(height: 6.h),
                    Text(
                      'Görsel Yok'.localized,
                      style: TextStyle(
                        color: AppColors.textPrimary.withValues(alpha: 0.4),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: FontHelper.euclidCircularA().fontFamily,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Text(
              title,
              style: TextStyle(
                fontFamily: FontHelper.euclidCircularA().fontFamily,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
              ),
            ),
          ),
          if (subtitle.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              child: Text(
                subtitle,
                style: TextStyle(
                  fontFamily: FontHelper.euclidCircularA().fontFamily,
                  color: AppColors.textPrimary.withValues(alpha: 0.5),
                  fontWeight: FontWeight.w400,
                  fontSize: 12.sp,
                ),
              ),
            ),
        ],
      ),
    );
  }
} 