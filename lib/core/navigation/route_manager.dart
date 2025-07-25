import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:shartflix/core/widgets/error_screen.dart';
import 'package:shartflix/features/auth/domain/repositories/auth_repository.dart';
import 'package:shartflix/features/auth/presentation/screens/login_screen.dart';
import 'package:shartflix/core/navigation/app_routes.dart';
import 'package:shartflix/features/auth/presentation/screens/register_screen.dart';
import 'package:shartflix/features/home/presentation/screens/discover_screen.dart';
import 'package:shartflix/features/profile/presentation/screens/my_profile_screen.dart';
import 'package:shartflix/core/widgets/app_bottom_nav_bar.dart';
import 'package:shartflix/features/profile/presentation/screens/photo_upload_screen.dart';
import 'package:shartflix/features/splash/presentation/screens/splash_screen.dart';
import 'package:shartflix/core/services/service_locator.dart';

class RouteManager {
  static GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    initialLocation: Routes.splash,
    routes: [
      GoRoute(
        path: Routes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      // --- TABS: Home & Profile ---
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return Scaffold(
            body: navigationShell,
            bottomNavigationBar: AppBottomNavBar(
              currentIndex: navigationShell.currentIndex,
              onTap: (index) => navigationShell.goBranch(index),
            ),
          );
        },
        branches: [
          // Home tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.discover,
                name: 'discover',
                builder: (context, state) => const DiscoverScreen(),
              ),
            ],
          ),
          // Profile tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.myProfile,
                name: 'my-profile',
                builder: (context, state) => const MyProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      // --- Tab dışı sayfalar (bottom bar yok) ---
      GoRoute(
        path: Routes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: Routes.register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: Routes.photoUpload,
        name: 'photo-upload',
        builder: (context, state) => const PhotoUploadScreen(),
      ),
    ],

    // Error sayfası
    errorBuilder: (context, state) => const ErrorScreen(),

    // Navigation guard'lar için
    redirect: (context, state) async {
      final authRepository = sl<AuthRepository>();
      final token = await authRepository.getToken();
      final isLoggedIn = token != null;

      final unauthenticatedRoutes = [
        Routes.login,
        Routes.register,
        Routes.splash
      ];

      // Eğer kullanıcı giriş yapmamışsa ve gitmek istediği sayfa
      // güvenli olmayan (herkesin erişebileceği) bir sayfa değilse, login'e yönlendir.
      if (!isLoggedIn && !unauthenticatedRoutes.contains(state.matchedLocation)) {
        return Routes.login;
      }

      return null;
    },
  );
}
