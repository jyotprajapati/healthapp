import 'dart:io';

import 'package:firstbus/services/util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_health_connect/flutter_health_connect.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

class HealthService {
  Health health = Health();
   List<HealthDataPoint> _healthDataList = [];
  int _nofSteps = 0;

  // All types available depending on platform (iOS ot Android).
  List<HealthDataType> get types => (Platform.isAndroid)
      ? dataTypesAndroid
      : (Platform.isIOS)
          ? dataTypesIOS
          : [];

  // Set up corresponding permissions
  // READ only
  List<HealthDataAccess> get permissions =>
      types.map((e) => HealthDataAccess.READ).toList();



  /// Authorize, i.e. get permissions to access relevant health data.
  Future<void> authorize() async {
    // If we are trying to read Step Count, Workout, Sleep or other data that requires
    // the ACTIVITY_RECOGNITION permission, we need to request the permission first.
    // This requires a special request authorization call.
    //
    // The location permission is requested for Workouts using the Distance information.
    await Permission.activityRecognition.request();
    await Permission.location.request();

    // Check if we have health permissions
    bool? hasPermissions =
        await Health().hasPermissions(types, permissions: permissions);

    // hasPermissions = false because the hasPermission cannot disclose if WRITE access exists.
    // Hence, we have to request with WRITE as well.
    hasPermissions = false;

    bool authorized = false;
    if (!hasPermissions) {
      // requesting access to the data types before reading them
      try {
        authorized = await Health()
            .requestAuthorization(types, permissions: permissions);
      } catch (error) {
        debugPrint("Exception in authorize: $error");
      }
    }
    
  }

    /// Install Google Health Connect on this phone.
  Future<void> installHealthConnect() async {
    await Health().installHealthConnect();
  }


  /// Fetch data points from the health plugin and show them in the app.
  Future<List<HealthDataPoint>> fetchData() async {

    // get data within the last 24 hours
    final now = DateTime.now();
    final yesterday = now.subtract(Duration(hours: 24));

    // Clear old data points
    _healthDataList.clear();

    try {
      // fetch health data
      List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(
        types: types,
        startTime: yesterday,
        endTime: now,
      );

      debugPrint('Total number of data points: ${healthData.length}. '
          '${healthData.length > 100 ? 'Only showing the first 100.' : ''}');

      // save all the new data points (only the first 100)
      _healthDataList.addAll(
          (healthData.length < 100) ? healthData : healthData.sublist(0, 100));
    } catch (error) {
      debugPrint("Exception in getHealthDataFromTypes: $error");
    }

    // filter out duplicates
    _healthDataList = Health().removeDuplicates(_healthDataList);

     return _healthDataList;

    
  }

//     Future<List<HealthDataPoint>> fetchHealthData() async {
//     final status = await health.getHealthConnectSdkStatus();
//     if (status != HealthConnectSdkStatus.sdkAvailable) {
//       await health.installHealthConnect();
//     }
//     health.configure(useHealthConnectIfAvailable: true);

//     /// Give a HealthDataType with the given identifier
//     final types = [
//       HealthDataType.STEPS,
//       HealthDataType.ACTIVE_ENERGY_BURNED,
//     ];

//     /// Give a permissions for the given HealthDataTypesr
//     final permissions = types.map((e) => HealthDataAccess.READ).toList();

//     /// current time
//     final now = DateTime.now();

//     /// Give a yesterday's time
//     final yesterday = now.subtract(const Duration(days: 1));

//     /// to store HealthDataPoint
//     List<HealthDataPoint> healthData = [];

//     /// request google Authorization when the app is opened for the first time
//     // bool requested =
//     //     await health.requestAuthorization(types, permissions: permissions);

//     ///check if the request is successful
//     // if (requested) {
//     /// fetch the data from the health store
//     try {
//       // Check if we have health permissions
//       bool? hasPermissions =
//           await health.hasPermissions(types, permissions: permissions);

//   if(hasPermissions??false){
//       await HealthConnectFactory.requestPermissions([
//         HealthConnectDataType.Steps,
//         HealthConnectDataType.ActiveCaloriesBurned,
//       ], readOnly: false);
//       }   final now = DateTime.now();
//     final earlier = now.subtract(Duration(minutes: 20));
// await Health().writeHealthData(
//         value: 90,
//         type: HealthDataType.STEPS,
//         startTime: earlier,
//         endTime: now);
//       // hasPermissions = false because the hasPermission cannot disclose if WRITE access exists.
//       // Hence, we have to request with WRITE as well.

//       if (!(hasPermissions??false)) {
//         // requesting access to the data types before reading them
//         try {
//         final  authorized = await Health()
//               .requestAuthorization(types, permissions: permissions);
//         } catch (error) {
//          print("Exception in authorize: $error");
//         }
//       }

//       healthData = await health.getHealthDataFromTypes(
//         startTime: yesterday,
//         endTime: now,
//         types: types,
//       );
//     } catch (e) {}
//     // } else {
//     //   /// if the request is not successful
//     //   throw AuthenticationRequired();
//     // }
//     return healthData;
//   }

}

class AuthenticationRequired extends Error {}
