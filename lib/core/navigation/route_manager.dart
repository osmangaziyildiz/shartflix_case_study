import 'package:go_router/go_router.dart';
import 'package:shartflix/features/auth/presentation/screens/login_screen.dart';
import 'package:shartflix/core/navigation/app_routes.dart';

class RouteManager {
  static GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    initialLocation: Routes.login,
    routes: [
      // Auth Routes
      GoRoute(
        path: Routes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      
      // TODO: Diğer route'lar buraya eklenecek
      // GoRoute(
      //   path: Routes.home,
      //   name: 'home',
      //   builder: (context, state) => const HomeScreen(),
      // ),
      
      // GoRoute(
      //   path: Routes.profile,
      //   name: 'profile',
      //   builder: (context, state) => const ProfileScreen(),
      // ),
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