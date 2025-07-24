import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shartflix/core/constants/app_colors.dart';
import 'package:shartflix/core/services/service_locator.dart';
import 'package:shartflix/core/utils/font_helper.dart';
import 'package:shartflix/core/utils/localization_manager.dart';
import 'package:shartflix/features/home/presentation/viewmodels/home_view_model.dart';
import 'package:shartflix/features/home/presentation/viewmodels/home_event.dart';
import 'package:shartflix/features/home/presentation/viewmodels/home_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeViewModel>()..add(FetchMovies()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<HomeViewModel>().add(FetchMovies());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    // Trigger loading when 90% of the page is scrolled
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Filmler'.localized,
          style: TextStyle(
            fontFamily: FontHelper.euclidCircularA().fontFamily,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: BlocBuilder<HomeViewModel, HomeState>(
          builder: (context, state) {
            switch (state.status) {
              case HomeStatus.error:
                return Center(child: Text('Fimler Yüklenemedi :('.localized,style: TextStyle(
                  fontFamily: FontHelper.euclidCircularA().fontFamily,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13.sp,
                ),));
              case HomeStatus.loading:
                return const Center(child: CircularProgressIndicator());
              case HomeStatus.success:
              case HomeStatus.loadingMore:
                if (state.movies.isEmpty) {
                  return Center(child: Text('Gösterilecek film bulunamadı.'.localized,style: TextStyle(
                  fontFamily: FontHelper.euclidCircularA().fontFamily,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13.sp,
                ),));
                }
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final double cardWidth = (constraints.maxWidth - 14.w) / 2;
                    return SingleChildScrollView(
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: Column(
                        children: [
                          Wrap(
                            spacing: 14.w,
                            runSpacing: 18.h,
                            children: state.movies.map((movie) {
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
                          if (state.status == HomeStatus.loadingMore)
                            Padding(
                              padding: EdgeInsets.only(top: 16.h),
                              child: const CircularProgressIndicator(),
                            ),
                        ],
                      ),
                    );
                  },
                );
              default:
                return const SizedBox.shrink();
            }
          },
        ),
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
