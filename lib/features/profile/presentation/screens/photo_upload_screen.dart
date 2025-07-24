import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shartflix/core/constants/app_colors.dart';
import 'package:shartflix/core/utils/font_helper.dart';
import 'package:shartflix/core/services/service_locator.dart';
import 'package:shartflix/core/utils/localization_manager.dart';
import 'package:shartflix/features/profile/presentation/viewmodels/profile_view_model.dart';
import 'package:shartflix/features/profile/presentation/viewmodels/profile_state.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class PhotoUploadScreen extends StatelessWidget {
  const PhotoUploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfileViewModel>(),
      child: const _PhotoUploadView(),
    );
  }
}

class _PhotoUploadView extends StatefulWidget {
  const _PhotoUploadView();

  @override
  State<_PhotoUploadView> createState() => _PhotoUploadViewState();
}

class _PhotoUploadViewState extends State<_PhotoUploadView> {
  File? _selectedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  void _upload() {
    if (_selectedImage == null) return;
    context.read<ProfileViewModel>().uploadPhoto(_selectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileViewModel, ProfileState>(
      listener: (context, state) {
        if (state.status == ProfileStatus.success) {
          context.pop();
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(message: 'Fotoğraf başarıyla yüklendi'.localized),
            displayDuration: const Duration(milliseconds: 300),
          );
        } else if (state.status == ProfileStatus.error &&
            state.errorMessage != null) {
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(message: state.errorMessage!),
            displayDuration: const Duration(milliseconds: 300),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
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
                            context.pop();
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
                  ],
                ),
                SizedBox(height: 25.h),
                Text(
                  'Fotoğraflarınızı Yükleyin'.localized,
                  style: TextStyle(
                    fontFamily: FontHelper.euclidCircularA().fontFamily,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  'Resources out incentivize\nrelaxation floor loss cc.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: FontHelper.euclidCircularA().fontFamily,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w400,
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(height: 35.h),
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 165.w,
                      height: 155.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(28.r),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.12),
                          width: 1.2,
                        ),
                      ),
                      child:
                          _selectedImage == null
                              ? Center(
                                child: Icon(
                                  Icons.add,
                                  color: AppColors.textPrimary.withValues(
                                    alpha: 0.5,
                                  ),
                                  size: 36.sp,
                                ),
                              )
                              : ClipRRect(
                                borderRadius: BorderRadius.circular(24.r),
                                child: Image.file(
                                  _selectedImage!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: BlocBuilder<ProfileViewModel, ProfileState>(
                      builder: (context, state) {
                        final isLoading = state.status == ProfileStatus.loading;
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            elevation: 0,
                          ),
                          onPressed: isLoading ? null : _upload,
                          child:
                              isLoading
                                  ? const CircularProgressIndicator()
                                  : Text(
                                    'Devam Et'.localized,
                                    style: TextStyle(
                                      fontFamily:
                                          FontHelper.euclidCircularA()
                                              .fontFamily,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15.sp,
                                    ),
                                  ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
