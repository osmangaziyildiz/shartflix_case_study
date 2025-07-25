import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shartflix/core/constants/app_colors.dart';
import 'package:shartflix/core/constants/app_icons.dart';
import 'package:shartflix/core/services/service_locator.dart';
import 'package:shartflix/core/utils/font_helper.dart';
import 'package:shartflix/core/utils/localization_manager.dart';
import 'package:shartflix/features/home/presentation/viewmodels/home_event.dart';
import 'package:shartflix/features/home/presentation/viewmodels/home_state.dart';
import 'package:shartflix/features/home/presentation/viewmodels/home_view_model.dart';
import 'package:shartflix/features/profile/domain/entities/movie_entity.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeViewModel>()..add(FetchMovies()),
      child: const _DiscoverView(),
    );
  }
}

class _DiscoverView extends StatefulWidget {
  const _DiscoverView();

  @override
  State<_DiscoverView> createState() => _DiscoverViewState();
}

class _DiscoverViewState extends State<_DiscoverView> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200) {
        context.read<HomeViewModel>().add(FetchMovies());
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: BlocBuilder<HomeViewModel, HomeState>(
        builder: (context, state) {
          if (state.status == HomeStatus.loading && state.movies.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == HomeStatus.error && state.movies.isEmpty) {
            return const Center(child: Text('Filmler yüklenemedi.'));
          }

          return RefreshIndicator(
            backgroundColor: Colors.white.withValues(alpha: 0.1),
            onRefresh: () async {
              context.read<HomeViewModel>().add(RefreshMovies());
              await context.read<HomeViewModel>().stream.firstWhere(
                (newState) =>
                    newState.status == HomeStatus.success ||
                    newState.status == HomeStatus.error,
              );
            },
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: state.movies.length,
              itemBuilder: (context, index) {
                final movie = state.movies[index];
                return _MoviePageItem(movie: movie, movieIndex: index);
              },
            ),
          );
        },
      ),
    );
  }
}

class _MoviePageItem extends StatefulWidget {
  final MovieEntity movie;
  final int movieIndex;
  const _MoviePageItem({required this.movie, required this.movieIndex});

  @override
  State<_MoviePageItem> createState() => _MoviePageItemState();
}

class _MoviePageItemState extends State<_MoviePageItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _rotationAnimation;
  String _plotText = '';
  bool _showReadMore = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.5),
        weight: 40.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.5, end: 1.0),
        weight: 60.0,
      ),
    ]).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _rotationAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 40.0),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.1), weight: 15.0),
      TweenSequenceItem(tween: Tween(begin: 0.1, end: -0.1), weight: 15.0),
      TweenSequenceItem(tween: Tween(begin: -0.1, end: 0.0), weight: 15.0),
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 15.0),
    ]).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reset();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateText();
    });
  }

  void _calculateText() {
    if (!mounted) return;

    final availableWidth =
        MediaQuery.of(context).size.width - 40.w - 45.w - 12.w;

    final plotSpan = TextSpan(text: widget.movie.plot, style: _plotTextStyle);

    final readMoreSpan = TextSpan(
      text: ' Daha Fazlası'.localized,
      style: _readMoreTextStyle,
    );

    final fullTextPainter = TextPainter(
      text: TextSpan(children: [plotSpan, readMoreSpan]),
      maxLines: 2,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: availableWidth);

    if (fullTextPainter.didExceedMaxLines) {
      final plotOnlyPainter = TextPainter(
        text: plotSpan,
        maxLines: 2,
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: availableWidth);

      final readMoreSize = TextPainter(
        text: readMoreSpan,
        textDirection: TextDirection.ltr,
      )..layout();
      final truncationWidth = plotOnlyPainter.width - readMoreSize.width - 15.w;

      final endOffset =
          plotOnlyPainter
              .getPositionForOffset(
                Offset(truncationWidth, plotOnlyPainter.height),
              )
              .offset;

      setState(() {
        _plotText = '${widget.movie.plot.substring(0, endOffset)}...';
        _showReadMore = true;
      });
    } else {
      setState(() {
        _plotText = widget.movie.plot;
        _showReadMore = false;
      });
    }
  }

  TextStyle get _plotTextStyle => TextStyle(
    fontFamily: FontHelper.euclidCircularA().fontFamily,
    color: Colors.white.withValues(alpha: 0.75),
    fontWeight: FontWeight.w400,
    fontSize: 13.sp,
    shadows: const [Shadow(blurRadius: 2, color: Colors.black54)],
  );

  TextStyle get _readMoreTextStyle =>
      _plotTextStyle.copyWith(fontWeight: FontWeight.bold, color: Colors.white);

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background Image
        Image.network(
          widget.movie.poster,
          fit: BoxFit.cover,
          errorBuilder:
              (context, error, stackTrace) => Container(
                color: AppColors.background,
                child: const Center(
                  child: Icon(Icons.movie, color: Colors.white24, size: 60),
                ),
              ),
        ),
        // Gradient Overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.6, 1.0],
            ),
          ),
        ),
        // Content
        Positioned(
          bottom: 10.h,
          left: 20.w,
          right: 20.w,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(AppIcons.filmIcon, width: 40.w, height: 40.h),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.movie.title,
                      style: TextStyle(
                        fontFamily: FontHelper.euclidCircularA().fontFamily,
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        shadows: const [
                          Shadow(blurRadius: 4, color: Colors.black54),
                        ],
                      ),
                    ),
                    RichText(
                      maxLines: 2,
                      text: TextSpan(
                        children: [
                          TextSpan(text: _plotText, style: _plotTextStyle),
                          if (_showReadMore)
                            TextSpan(
                              text: ' Daha Fazlası'.localized,
                              style: _readMoreTextStyle,
                              // TODO: Daha sonra detay sayfası eklenebilir.
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 14.h),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 105.h,
          right: 10.w,
          child: GestureDetector(
            onTap: () {
              if (_animationController.isAnimating) return;
              _animationController.forward();
              context.read<HomeViewModel>().add(
                ToggleFavorite(
                  movieId: widget.movie.id,
                  movieIndex: widget.movieIndex,
                ),
              );
            },
            child: SizedBox(
              width: 47.w,
              height: 70.h,
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // Blurred Background
                      ClipRRect(
                        borderRadius: BorderRadius.circular(55.r),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(50.r),
                            ),
                          ),
                        ),
                      ),
                      // Border on top
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.r),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                      ),
                      // Icon
                      Transform.rotate(
                        angle: _rotationAnimation.value,
                        child: Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Icon(
                            widget.movie.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color:
                                widget.movie.isFavorite
                                    ? Colors.white
                                    : Colors.white,
                            size: 24.sp,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
