import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink_driver/core/constants/assets.dart';
import 'package:xtridelink_driver/core/constants/extensions.dart';
import 'package:xtridelink_driver/core/services/location/index.dart';
import 'package:xtridelink_driver/core/services/navigation/index.dart';
import 'package:xtridelink_driver/core/services/navigation/routes.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/helpers.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../di/get_it.dart';
import '../../../components/button.dart';
import '../../../cubit/profile/index.dart';

class SetupUserLocation extends StatelessWidget {
  const SetupUserLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightSec,
      body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              HelperFunc.sb(10.h),
              // Align(
              //     alignment: Alignment.topRight,
              //     child: TextButton(
              //         onPressed: () => globalReplaceWith(route: Routes.base),
              //         child: Text('Skip',
              //                 style: AppTextStyles.semiBold(
              //                     color: Colors.black, fontSize: 13))
              //             .pd(EdgeInsets.only(right: 20.w)))),
              // HelperFunc.sb(20.h),
              Expanded(
                  child: Image.asset(Assets.location).pd(EdgeInsets.all(40.w))),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.h),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(50.r))),
                child: SafeArea(
                  child: Column(
                    children: [
                      HelperFunc.sb(40.h),
                      Text('Set default\nlocation',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.boldText(fontSize: 28)),
                      HelperFunc.sb(15.h),
                      Text('Set location for where to operate from to have visibility of logistics partners near you.',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.regularText(
                                  color: AppColors.grey))
                          .pd(EdgeInsets.symmetric(horizontal: 25.w)),
                      HelperFunc.sb(100.h),
                      AppButton(
                          btnText: 'Choose my current location',
                          onTap: () async {
                            HelperFunc.showLoader();
                            final position =
                                await getItInst<LocationMapService>()
                                    .getPosition();
                            final location =
                                await getItInst<LocationMapService>()
                                    .getLocationFromPosition(position);
                            globalPop();
                            if (location != null && context.mounted) {
                              context.read<ProfileCubit>().setLocation(
                                  location: location,
                                  latitude: position.latitude,
                                  longitude: position.longitude,
                                  onSuccess: () =>
                                      globalReplaceWith(route: Routes.base));
                            }
                          }),
                      HelperFunc.sb(5.h),
                      TextButton(
                          onPressed: () =>
                              globalNavigateTo(route: Routes.chooseLocation),
                          child: Text('Change location',
                              style: AppTextStyles.mediumText(
                                  fontSize: 12.5, color: Colors.black)))
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
