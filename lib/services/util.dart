import 'package:health/health.dart';

/// List of data types available on iOS
const List<HealthDataType> dataTypesIOS = [
  HealthDataType.STEPS,
  // HealthDataType.TOTAL_CALORIES_BURNED,
];

/// List of data types available on Android.
///
/// Note that these are only the ones supported on Android's Health Connect API.
/// Android's Google Fit have more types that we support in the [HealthDataType]
/// enumeration.
const List<HealthDataType> dataTypesAndroid = [
  HealthDataType.STEPS,
  // HealthDataType.TOTAL_CALORIES_BURNED,
];
