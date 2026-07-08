import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xtridelink_driver/core/constants/colors.dart';
import '../../core/constants/assets.dart';

class ProfileAvatar extends StatelessWidget {
  final String? avatar;
  final double? radius, iconSize;
  const ProfileAvatar({super.key, this.avatar, this.iconSize, this.radius});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        backgroundImage:
            (avatar ?? '').isNotEmpty ? NetworkImage(avatar!) : null,
        backgroundColor: AppColors.midSec,
        radius: (radius ?? 25).r,
        child: (avatar ?? '').isNotEmpty
            ? null
            : SvgPicture.asset(Assets.person,
                height: iconSize, width: iconSize));
  }
}
