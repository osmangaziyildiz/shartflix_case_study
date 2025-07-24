import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shartflix/core/constants/app_colors.dart';
import 'package:shartflix/core/navigation/app_routes.dart';
import 'package:shartflix/core/services/service_locator.dart';
import 'package:shartflix/core/utils/font_helper.dart';
import 'package:shartflix/core/utils/localization_manager.dart';
import 'package:shartflix/features/profile/presentation/widgets/profile_top_bar.dart';
import 'package:shartflix/features/profile/presentation/widgets/profile_section.dart';
import 'package:shartflix/features/profile/presentation/widgets/profile_favorite_films.dart';
import 'package:shartflix/features/profile/presentation/viewmodels/profile_view_model.dart';
import 'package:shartflix/features/profile/presentation/viewmodels/profile_state.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  late final ProfileViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = sl<ProfileViewModel>()..fetchProfile();
  }

  @override
  void dispose() {
    _viewModel.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _viewModel,
      child: BlocBuilder<ProfileViewModel, ProfileState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ProfileTopBar(),
                    SizedBox(height: 24.h),
                    if (state.status == ProfileStatus.loading && state.user == null)
                      const Expanded(
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    if (state.status == ProfileStatus.error)
                      Expanded(
                        child: Center(
                          child: Text(
                            state.errorMessage?.localized ?? 'Beklenmedik bir hata oluştu'.localized,
                            style: TextStyle(
                              fontFamily:
                                  FontHelper.euclidCircularA().fontFamily,
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 13.sp,
                            ),
                          ),
                        ),
                      ),
                    if (state.user != null) ...[
                      ProfileSection(
                        user: state.user!,
                        onPhotoUpload: () {
                          context
                              .push(Routes.photoUpload)
                              .then((_) => _viewModel.fetchProfile());
                        },
                      ),
                      SizedBox(height: 28.h),
                      ProfileFavoriteFilms(movies: state.favoriteMovies),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
