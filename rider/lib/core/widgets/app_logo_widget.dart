import 'package:flutter/material.dart';
import 'package:xtridelink_driver/gen/assets.gen.dart';

class AppLogoWidget extends StatelessWidget {
  const AppLogoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'app-logo',
      child: Material(
        color: Colors.transparent,
        child: PhysicalModel(
          color: Colors.grey,
          elevation: 5,
          borderRadius: BorderRadius.circular(8),
          clipBehavior: Clip.antiAlias,
          child: Assets.images.logo.image(width: 150, height: 150),
        ),
      ),
    );
  }
}
