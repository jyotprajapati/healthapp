
import 'package:firstbus/controller/helth_repository.dart';
import 'package:firstbus/controller/splash_screen_controller.dart';
import 'package:get/instance_manager.dart';


class SplashScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<SplashController>(SplashController());
  }
}
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HelthRepository());
  }
}


