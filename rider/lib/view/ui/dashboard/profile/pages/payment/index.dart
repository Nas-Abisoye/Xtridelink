import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xtridelink_driver/core/constants/extensions.dart';
import 'package:xtridelink_driver/core/services/navigation/index.dart';
import 'package:xtridelink_driver/core/services/navigation/routes.dart';
import 'package:xtridelink_driver/view/cubit/profile/index.dart';
import '../../../../../../core/constants/assets.dart';
import '../../../../../../core/constants/colors.dart';
import '../../../../../../core/constants/helpers.dart';
import '../../../../../../core/constants/text_styles.dart';
import '../../../../../components/back_button.dart';
import '../../../../../components/button.dart';

class AddPaymentCardPage extends StatefulWidget {
  const AddPaymentCardPage({super.key});

  @override
  State<AddPaymentCardPage> createState() => _AddPaymentCardPageState();
}

class _AddPaymentCardPageState extends State<AddPaymentCardPage> {
  @override
  void initState() {
    context.read<ProfileCubit>().getUserBankAccounts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          const AppBackButton().align(Alignment.centerLeft),
          RefreshIndicator(
                  onRefresh: () =>
                      context.read<ProfileCubit>().getUserBankAccounts(),
                  child: Column(children: [
                    Text('Payments',
                            style: AppTextStyles.mediumText(fontSize: 22))
                        .align(Alignment.centerLeft),
                    HelperFunc.sb(5.h),
                    Text('Add account to receive payment',
                            style: AppTextStyles.regularText(
                                fontSize: 13, color: AppColors.grey))
                        .pd(EdgeInsets.only(right: 50.w))
                        .align(Alignment.centerLeft),
                    HelperFunc.sb(25.h),
                    Text('Saved Banks',
                            style: AppTextStyles.semiBold(
                                color: AppColors.secColor, fontSize: 13))
                        .align(Alignment.centerLeft),
                    HelperFunc.sb(8.h),
                    BlocBuilder<ProfileCubit, ProfileState>(
                        builder: (context, state) {
                      return (state.userBankAccounts ?? []).isNotEmpty
                          ? Column(
                              children: state.userBankAccounts!
                                  .map((e) => Row(children: [
                                        CircleAvatar(
                                            backgroundColor:
                                                AppColors.grey.withOpacity(.1),
                                            radius: 19.r,
                                            child: Image.asset(Assets.bank,
                                                height: 25.h, width: 25.w)),
                                        HelperFunc.sb(10.w),
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(e.bankName,
                                                  style:
                                                      AppTextStyles.mediumText(
                                                          fontSize: 14)),
                                              HelperFunc.sb(5.h),
                                              Text(
                                                  '${e.bankAccountNo} . ${e.name}',
                                                  style:
                                                      AppTextStyles.regularText(
                                                          color: AppColors.grey,
                                                          fontSize: 10))
                                            ]).EXPANDED,
                                        GestureDetector(
                                          onTap: () => context
                                              .read<ProfileCubit>()
                                              .deleteBankAccount(e.id),
                                          child: CircleAvatar(
                                              backgroundColor:
                                                  AppColors.red.withOpacity(.1),
                                              radius: 15.r,
                                              child: SvgPicture.asset(
                                                  Assets.delete,
                                                  height: 14.h,
                                                  width: 14.w)),
                                        )
                                      ]).pd(
                                          EdgeInsets.symmetric(vertical: 10.h)))
                                  .toList(),
                            )
                          : state.isLoading
                              ? Center(
                                  child: const CircularProgressIndicator()
                                      .pd(EdgeInsets.only(top: 100.h)))
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                      HelperFunc.sb(70.h),
                                      Image.asset(Assets.bank, height: 70.h),
                                      HelperFunc.sb(10.h),
                                      Text('No account added',
                                          style: AppTextStyles.semiBold(
                                              color: AppColors.grey
                                                  .withOpacity(.7))),
                                      HelperFunc.sb(5.h),
                                      Text(
                                          'There is no bank account\nadded yet',
                                          textAlign: TextAlign.center,
                                          style: AppTextStyles.regularText(
                                              color: AppColors.grey
                                                  .withOpacity(.5))),
                                      HelperFunc.sb(30.h)
                                    ]);
                    }),
                    SizedBox(height: MediaQuery.of(context).size.height)
                  ])
                      .pd(EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 10.h))
                      .SINGLECHILDSCROLLVIEW)
              .EXPANDED,
          AppButton(
                  onTap: () => globalNavigateTo(route: Routes.addBankAccount),
                  btnText: 'Add Account')
              .pd(EdgeInsets.fromLTRB(20.w, 0, 20.w, 10.h)),
        ],
      )),
    );
  }
}
