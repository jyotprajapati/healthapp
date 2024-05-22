import 'package:firstbus/controller/helth_repository.dart';
import 'package:firstbus/utils/image_path.dart';
import 'package:firstbus/utils/loading_shimmer.dart';
import 'package:firstbus/widgets/home_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends GetView<HelthRepository> {
  const HomeScreen({Key? key}) : super(key: key);

  /// route: '/home'
  static const String route = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 50, 16, 10),

        /// featch data from repository
        child: Obx(() {
          final _healthPoint = controller.healthPoint;
          num steps;
          num calories;
          // if (controller.error.isNotEmpty) {
          //   return error.Error(controller: controller);
          // }

          /// get data from repository and assing to steps and calories
          if (_healthPoint.isNotEmpty) {
            steps = _healthPoint.first.value;
            calories = _healthPoint.last.value;
          } else {
            steps = 0;
            calories = 0;
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Hi!",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 40),

              /// if steps is null show shimmer
              HomeCard(
                iconPath: ImagePath(context).iconFootSteps,
                heading: "Steps :",
                value: steps.toDouble(),
                title: '$steps',
                goal: '15,000',
              ),

              /// if calories is null show shimmer
              HomeCard(
                iconPath: ImagePath(context).iconKcal,
                heading: "Calories Burned :",
                value: calories.toDouble(),
                title: '$calories',
                goal: '15,000',
              ),
            ],
          );
        }),
      ),
    );
  }
}
