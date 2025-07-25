import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shartflix/core/services/service_locator.dart';
import 'package:shartflix/core/utils/localization_manager.dart';
import 'package:shartflix/core/navigation/route_manager.dart';
import 'package:shartflix/core/theme/app_theme.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize services
  await setupServiceLocator();
  await LocalizationManager.init();
  await ScreenUtil.ensureScreenSize();
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Shartflix',
          theme: AppTheme.mainTheme,
          routerConfig: RouteManager.router,
        );
      },
    );
  }
}
