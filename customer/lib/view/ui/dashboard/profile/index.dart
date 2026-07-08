import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink/core/constants/old_assets.dart';
import 'package:xtridelink/core/constants/colors.dart';
import 'package:xtridelink/core/constants/enumerations.dart';
import 'package:xtridelink/core/constants/extensions.dart';
import 'package:xtridelink/core/constants/text_styles.dart';
import 'package:xtridelink/core/services/navigation/index.dart';
import 'package:xtridelink/core/services/navigation/routes.dart';
import 'package:xtridelink/view/components/icon_avatar.dart';
import 'package:xtridelink/view/components/profile_avatar.dart';
import 'package:xtridelink/view/cubit/profile/index.dart';
import 'package:xtridelink/view/ui/dashboard/profile/cubit/profile_cubit.dart';
import '../../../../core/constants/helpers.dart';
import 'components/profile_action.dart';
import 'components/set_biometrics.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.ashBg,
        body: SafeArea(
            bottom: false,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              HelperFunc.sb(10.h),
              Text('Profile', style: AppTextStyles.mediumText(fontSize: 22))
                  .pd(EdgeInsets.only(left: 20.w)),
              HelperFunc.sb(20.h),
              Row(children: [
                HelperFunc.sb(20.w),
                BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                  return ProfileAvatar(
                    radius: 28.r,
                  );
                }),
                HelperFunc.sb(12.w),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('ACCOUNT',
                      style: AppTextStyles.regularText(
                              fontSize: 8, color: AppColors.grey)
                          .copyWith(letterSpacing: 2)),
                  HelperFunc.sb(5.h),
                  BlocBuilder<ProfileCubit, ProfileState>(
                      builder: (context, state) {
                    return Text(
                        '${state.currentUser()?.firstName ?? ''} ${state.currentUser()?.lastName ?? ''}',
                        style: AppTextStyles.mediumText());
                  })
                ]).EXPANDED,
                HelperFunc.sb(10.w),
                GestureDetector(
                    onTap: () => globalNavigateTo(route: Routes.editProfile),
                    child: const IconAvatar(avatar: Assets.edit)),
                HelperFunc.sb(20.w)
              ]),
              HelperFunc.sb(10.h),
              Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(40.r))),
                  child: RefreshIndicator(
                    onRefresh: () async =>
                        context.read<ProfileCubit>().getUserDetails(),
                    child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                            vertical: 35.h, horizontal: 20.w),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('General',
                                  style: AppTextStyles.mediumText(
                                      color: AppColors.grey.withOpacity(.7))),
                              HelperFunc.sb(10.h),
                              ProfileAction(
                                  onTap: () => globalNavigateTo(
                                      route: Routes.changePassword),
                                  avatar: Assets.lock,
                                  text: 'Change Password'),
                              // SetBiometricsLoginOption(),
                              ProfileAction(
                                  onTap: () => globalNavigateTo(
                                      route: Routes.editAddress),
                                  avatar: Assets.locationSvg,
                                  text: 'Address'),
                              // ProfileAction(
                              //     onTap: () =>
                              //         HelperFunc.showFittedBottomSheet(
                              //             context: context,
                              //             child: const ChooseLanguageSheet()),
                              //     avatar: Assets.internet,
                              //     text: 'Language'),
                              // ProfileAction(
                              //     onTap: () =>
                              //         globalNavigateTo(route: Routes.addCard),
                              //     avatar: Assets.card,
                              //     text: 'Payment'),
                              HelperFunc.sb(20.h),
                              Text('More',
                                  style: AppTextStyles.mediumText(
                                      color: AppColors.grey.withOpacity(.7))),
                              HelperFunc.sb(10.h),
                              ProfileAction(
                                  onTap: () =>
                                      globalNavigateTo(route: Routes.faq),
                                  avatar: Assets.faq,
                                  text: 'Faq',
                                  iconColor: Colors.black),
                              ProfileAction(
                                  onTap: () => globalNavigateTo(
                                      route: Routes.legal,
                                      arguments: XtridelinkDocsType.legal),
                                  avatar: Assets.legal,
                                  text: 'Legal',
                                  iconColor: Colors.black),
                              ProfileAction(
                                  onTap: () =>
                                      globalNavigateTo(route: Routes.support),
                                  avatar: Assets.support,
                                  text: 'Support',
                                  iconColor: Colors.black),
                              ProfileAction(
                                  onTap: () => context
                                      .read<ProfileCubit>()
                                      .signOut(context),
                                  avatar: Assets.logout,
                                  text: 'Sign out',
                                  iconColor: Colors.black),
                              const ProfileAction(
                                  avatar: Assets.logout,
                                  text: 'Delete Account',
                                  fullColor: AppColors.red),
                              HelperFunc.sb(150.h)
                            ])),
                  )).EXPANDED
            ])));
  }
}
