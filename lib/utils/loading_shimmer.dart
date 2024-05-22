import 'package:firstbus/utils/colors.dart';
import 'package:firstbus/utils/theme_value.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingShimmer extends StatelessWidget {
  const LoadingShimmer({
    required this.loading,
    required this.child,
    this.width,
    this.height,
    this.borderRadius,
    Key? key,
  }) : super(key: key);

  final Widget? child;
  final double? width;
  final double? height;
  final bool loading;

  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: _transitionBuilder,
      child: loading
          ? ClipRRect(
              borderRadius: borderRadius ?? BorderRadius.circular(10),
              child: Shimmer(
                period: const Duration(seconds: 2),
                 gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[context
                    .themeValue(light: AppColor.black, dark: AppColor.white)
                    .withOpacity(0.005), context
                    .themeValue(light: AppColor.black, dark: AppColor.white)
                    .withOpacity(0.005),]),
                child: Container(
                  color: context
                      .themeValue(light: AppColor.black, dark: AppColor.white)
                      .withOpacity(0.05),
                  alignment: Alignment.center,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: height ?? 0,
                      minWidth: width ?? 0,
                    ),
                    child: IgnorePointer(
                      child: Opacity(
                        opacity: 0,
                        child: child,
                      ),
                    ),
                  ),
                ),
              ),
            )
          : child,
    );
  }

  Widget _transitionBuilder(child, animation) =>
      FadeTransition(opacity: animation, child: child);
}
