import 'package:firstbus/utils/routes_utils.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  RxBool align = false.obs;
  RxBool visible = false.obs;
  @override
  void onInit() {
      initSetup().then((_) async {
      // Once setup is complete then load the animation
      _startAnimation();
    });

    super.onInit();
  }

    Future<void> initSetup() {
    /// This is sample delay to represent the loading of the app
    return Future.delayed(const Duration(seconds: 2));
  }

  void _startAnimation() async{
 align.value = !(align.value);
    await Future.delayed(const Duration(milliseconds: 100));
    setupComplete();
  }

  Future<void> setupComplete() async {
    // Once setup is complete then load the animation and do the necessary navigation
    visible = true.obs;
    await Future.delayed(const Duration(seconds: 1));
    Get.toNamed(Routes.homeScreen);
  }

}
