import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../core/constants/old_assets.dart';
import '../../core/constants/colors.dart';

class CarLoader extends StatefulWidget {
  final num height, increment;
  final void Function() onTimerCompleted;
  final Future<void> Function() awaitFunction;
  const CarLoader(
      {super.key,
      required this.height,
      required this.onTimerCompleted,
      required this.awaitFunction,
      required this.increment});

  @override
  State<CarLoader> createState() => _CarLoaderState();
}

class _CarLoaderState extends State<CarLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(minutes: 3))
          ..repeat();
    widget.awaitFunction().then((value) => widget.onTimerCompleted());
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget getAnimatedContainer(double value) => Transform.scale(
      scale: value,
      child: Container(
          height: (widget.height + widget.increment).h,
          width: double.infinity,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.withValues(alpha: .2))));

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animationController,
        builder: (BuildContext context, Widget? child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              getAnimatedContainer(_animationController.value),
              getAnimatedContainer(_animationController.value + .35),
              getAnimatedContainer(_animationController.value + .7),
              CircleAvatar(
                  radius: (widget.height / 2).r,
                  backgroundColor: AppColors.grey.withValues(alpha: .5),
                  child: SvgPicture.asset(Assets.car,
                      height: (widget.height * .4).h,
                      width: (widget.height * .6).w))
            ],
          );
        });
  }
}
