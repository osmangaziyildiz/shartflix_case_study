import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:shartflix/features/auth/presentation/screens/login_screen.dart';
import 'package:shartflix/core/navigation/app_routes.dart';
import 'package:shartflix/features/auth/presentation/screens/register_screen.dart';
import 'package:shartflix/features/home/presentation/screens/home_screen.dart';
import 'package:shartflix/features/profile/presentation/screens/my_profile_screen.dart';
import 'package:shartflix/core/widgets/app_bottom_nav_bar.dart';
import 'package:shartflix/features/profile/presentation/screens/photo_upload_screen.dart';

class RouteManager {
  static GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    initialLocation: Routes.home,
    routes: [
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
                path: Routes.home,
                name: 'home',
                builder: (context, state) => const HomeScreen(),
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
    errorBuilder: (context, state) => const LoginScreen(),

    // Navigation guard'lar için
    redirect: (context, state) {
      // TODO: Auth check logic buraya gelecek
      // final isLoggedIn = AuthService.isLoggedIn;
      // if (!isLoggedIn && state.location != Routes.login) {
      //   return Routes.login;
      // }
      return null;
    },
  );
}
