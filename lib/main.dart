import 'dart:io';

import 'package:firstbus/utils/binding_utils.dart';
import 'package:firstbus/utils/routes_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? prefs;
Future initSharedPreferences() async {
  prefs = await SharedPreferences.getInstance();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSharedPreferences();
 authorize();

  // var status3 = await Permission;
  //  Health health = Health();
  // final status3 = await health.getHealthConnectSdkStatus();
  runApp(const MyApp());
} 

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Health',
        theme: ThemeData(
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
        ),
        themeMode: ThemeMode.system,
        initialRoute: Routes.splashScreen,
        //    initialRoute: Routes.homeScreen,
        initialBinding: SplashScreenBinding(),
        getPages: getPages,
      ),
    );
  }
}

  Future<void> authorize() async {

    const List<HealthDataType> dataTypesIOS = [
  // HealthDataType.ACTIVE_ENERGY_BURNED,
  // HealthDataType.AUDIOGRAM,
  // HealthDataType.BLOOD_GLUCOSE,
  // HealthDataType.BLOOD_OXYGEN,
  // HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
  // HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
  // HealthDataType.BODY_FAT_PERCENTAGE,
  // HealthDataType.BODY_MASS_INDEX,
  // HealthDataType.BODY_TEMPERATURE,
  // HealthDataType.DIETARY_CARBS_CONSUMED,
  // HealthDataType.DIETARY_CAFFEINE,
  // HealthDataType.DIETARY_ENERGY_CONSUMED,
  // HealthDataType.DIETARY_FATS_CONSUMED,
  // HealthDataType.DIETARY_PROTEIN_CONSUMED,
  // HealthDataType.ELECTRODERMAL_ACTIVITY,
  // HealthDataType.FORCED_EXPIRATORY_VOLUME,
  // HealthDataType.HEART_RATE,
  // HealthDataType.HEART_RATE_VARIABILITY_SDNN,
  // HealthDataType.HEIGHT,
  // HealthDataType.RESPIRATORY_RATE,
  // HealthDataType.PERIPHERAL_PERFUSION_INDEX,
  HealthDataType.STEPS,
  // HealthDataType.WAIST_CIRCUMFERENCE,
  // HealthDataType.WEIGHT,
  // HealthDataType.FLIGHTS_CLIMBED,
  // HealthDataType.DISTANCE_WALKING_RUNNING,
  // HealthDataType.MINDFULNESS,
  // HealthDataType.SLEEP_AWAKE,
  // HealthDataType.SLEEP_ASLEEP,
  // HealthDataType.SLEEP_IN_BED,
  // HealthDataType.SLEEP_DEEP,
  // HealthDataType.SLEEP_REM,
  // HealthDataType.WATER,
  // HealthDataType.EXERCISE_TIME,
  // HealthDataType.WORKOUT,
  // HealthDataType.HEADACHE_NOT_PRESENT,
  // HealthDataType.HEADACHE_MILD,
  // HealthDataType.HEADACHE_MODERATE,
  // HealthDataType.HEADACHE_SEVERE,
  // HealthDataType.HEADACHE_UNSPECIFIED,

  // // note that a phone cannot write these ECG-based types - only read them
  // HealthDataType.ELECTROCARDIOGRAM,
  // HealthDataType.HIGH_HEART_RATE_EVENT,
  // HealthDataType.IRREGULAR_HEART_RATE_EVENT,
  // HealthDataType.LOW_HEART_RATE_EVENT,
  // HealthDataType.RESTING_HEART_RATE,
  // HealthDataType.WALKING_HEART_RATE,

  // HealthDataType.NUTRITION,
];

/// List of data types available on Android.
///
/// Note that these are only the ones supported on Android's Health Connect API.
/// Android's Google Fit have more types that we support in the [HealthDataType]
/// enumeration.
const List<HealthDataType> dataTypesAndroid = [
  // HealthDataType.ACTIVE_ENERGY_BURNED,
  // HealthDataType.BASAL_ENERGY_BURNED,
  // HealthDataType.BLOOD_GLUCOSE,
  // HealthDataType.BLOOD_OXYGEN,
  // HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
  // HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
  // HealthDataType.BODY_FAT_PERCENTAGE,
  // HealthDataType.HEIGHT,
  // HealthDataType.WEIGHT,
  // // HealthDataType.BODY_MASS_INDEX,
  // HealthDataType.BODY_TEMPERATURE,
  // HealthDataType.HEART_RATE,
  HealthDataType.STEPS,
  // HealthDataType.MOVE_MINUTES, // TODO: Find alternative for Health Connect
  // HealthDataType.DISTANCE_DELTA,
  // HealthDataType.RESPIRATORY_RATE,
  // HealthDataType.SLEEP_AWAKE,
  // HealthDataType.SLEEP_ASLEEP,
  // HealthDataType.SLEEP_LIGHT,
  // HealthDataType.SLEEP_DEEP,
  // HealthDataType.SLEEP_REM,
  // HealthDataType.SLEEP_SESSION,
  // HealthDataType.WATER,
  // HealthDataType.WORKOUT,
  // HealthDataType.RESTING_HEART_RATE,
  // HealthDataType.FLIGHTS_CLIMBED,
  // HealthDataType.NUTRITION,
  // HealthDataType.TOTAL_CALORIES_BURNED,
];

  List<HealthDataType>  types = (Platform.isAndroid)
      ? dataTypesAndroid
      : (Platform.isIOS)
          ? dataTypesIOS
          : []; 
    List<HealthDataAccess>  permissions =
      types.map((e) => HealthDataAccess.READ).toList();

    await Permission.activityRecognition.request();
    await Permission.location.request();

    bool? hasPermissions =
        await Health().hasPermissions(types, permissions: permissions);

    hasPermissions = false;

    bool authorized = false;

    if (!hasPermissions) {
      try {
        authorized = await Health()
            .requestAuthorization(types, permissions: permissions);
      } catch (error) {
        debugPrint("Exception in authorize: $error");
      }
    }

  }
