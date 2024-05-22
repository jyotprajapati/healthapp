

import 'package:firstbus/screens/splash_screen.dart';
import 'package:firstbus/screens/home_screen.dart';
import 'package:firstbus/utils/binding_utils.dart';
import 'package:get/get.dart';

class Routes {
  static const String splashScreen = '/splashScreen';
  static const String homeScreen = '/homeScreen';
}

final getPages = [
   GetPage(
    name: Routes.splashScreen,
    page: () => SplashScreen(),
    binding: SplashScreenBinding(),
  ),
  GetPage(
    name: Routes.homeScreen,
    page: () => const HomeScreen(),
    binding: HomeBinding(),
  ),
];
