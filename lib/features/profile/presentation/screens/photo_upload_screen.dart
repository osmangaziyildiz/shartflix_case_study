import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:go_router/go_router.dart';
import 'package:shartflix/core/constants/app_colors.dart';
import 'package:shartflix/core/utils/font_helper.dart';
import 'package:shartflix/core/services/service_locator.dart';
import 'package:shartflix/core/utils/localization_manager.dart';
import 'package:shartflix/features/profile/presentation/viewmodels/profile_viewmodel.dart';

class PhotoUploadScreen extends StatefulWidget {
  const PhotoUploadScreen({super.key});

  @override
  State<PhotoUploadScreen> createState() => _PhotoUploadScreenState();
}

class _PhotoUploadScreenState extends State<PhotoUploadScreen> {
  File? _selectedImage;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  Future<void> _upload(BuildContext context) async {
    if (_selectedImage == null) return;
    setState(() => _isLoading = true);
    final viewModel = sl<ProfileViewModel>();
    await viewModel.uploadPhoto(_selectedImage!);
    setState(() => _isLoading = false);
    if (context.mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        icon: Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20.sp),
                        onPressed: () {
                          Navigator.of(context).pop();
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
                    child: _selectedImage == null
                        ? Center(
                            child: Icon(Icons.add, color: AppColors.textPrimary.withValues(alpha: 0.5), size: 36.sp),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(24.r),
                            child: Image.file(_selectedImage!, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
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
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      elevation: 0,
                    ),
                    onPressed: _isLoading ? null : () => _upload(context),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Devam Et'.localized,
                            style: TextStyle(
                              fontFamily: FontHelper.euclidCircularA().fontFamily,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 15.sp,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 