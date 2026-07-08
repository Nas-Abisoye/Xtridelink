import 'package:flutter/material.dart';
import 'package:xtridelink/gen/assets.gen.dart';

class SimpleLoadingWidget extends StatefulWidget {
  const SimpleLoadingWidget({
    super.key,
    this.color,
  });
  final Color? color;

  @override
  State<SimpleLoadingWidget> createState() => _SimpleLoadingWidgetState();
}

class _SimpleLoadingWidgetState extends State<SimpleLoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
    animation = Tween<double>(begin: 1, end: 0.2).animate(
      CurvedAnimation(parent: animationController, curve: Curves.decelerate),
    );

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScaleTransition(
        scale: animation,
        child: Assets.images.logo.image(width: 70, height: 70),
      ),
    );
  }
}
