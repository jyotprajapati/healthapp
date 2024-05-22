import 'dart:ffi';

import 'package:firstbus/controller/splash_screen_controller.dart';
import 'package:firstbus/utils/animate_with_blink.dart';
import 'package:firstbus/utils/image_path.dart';
import 'package:firstbus/widgets/show_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends GetView {
  SplashScreen({super.key});

  final SplashController splashController = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(builder: (searchController) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  // animate the pin logo on the screen
                  AnimatedAlign(
                    duration: const Duration(milliseconds: 500),
                    alignment: splashController.align.value
                        ? const Alignment(0.615, 0)
                        : Alignment.center,
                    child: const ShowImage(
                      imagePath: ImagePathCommon.splashI,
                    ),
                  ),
                  if (splashController.align.value)
                    AnimateWithBlink(
                      visible: splashController.visible.value,
                      child:
                          ShowImage(imagePath: ImagePath(context).splashBoozin),
                    ),
                ],
              ),
              const SizedBox(height: 14),
              // animate the fitness text on the screen
              AnimateWithBlink(
                visible: splashController.visible.value,
                child: const Text(
                  "Fitness",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
