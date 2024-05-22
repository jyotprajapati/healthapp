import 'package:firstbus/services/health_services.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';

class HelthRepository extends GetxController {
  var healthPoint = [].obs;
  var error = "".obs;
  var isLoading = false.obs;
  HealthService healthService = HealthService();

  @override
  void onInit() {
    super.onInit();
    fetchHealthData();
  }

  void fetchHealthData() async {
    try {
      isLoading.value = true;
      Health().installHealthConnect();
       Health().configure(useHealthConnectIfAvailable: true);
      await healthService.authorize();
      final healthData = await healthService.fetchData();
      healthPoint.assignAll(healthData);
      error.value = "";
      isLoading.value = false;
    } catch (e) {
      error.value = e.toString();
    }
    update();
  }
}
