import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink_driver/core/constants/debouncer.dart';
import 'package:xtridelink_driver/core/constants/extensions.dart';
import 'package:xtridelink_driver/view/components/card.dart';
import 'package:xtridelink_driver/view/components/form_field.dart';
import 'package:xtridelink_driver/view/cubit/profile/index.dart';

import '../../../../../../../core/constants/colors.dart';
import '../../../../../../../core/constants/helpers.dart';
import '../../../../../../../core/constants/text_styles.dart';
import '../../../../../../../core/services/navigation/index.dart';
import '../../../../../../components/back_button.dart';
import '../../../../../../components/button.dart';

class AddBankAccountPage extends StatefulWidget {
  const AddBankAccountPage({super.key});

  @override
  State<AddBankAccountPage> createState() => _AddBankAccountPageState();
}

class _AddBankAccountPageState extends State<AddBankAccountPage> {
  late TextEditingController accountNoController;
  final _debouncer = Debouncer();
  @override
  void initState() {
    context.read<ProfileCubit>().getBankList();
    accountNoController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    accountNoController.dispose();
    _debouncer.reset();
    super.dispose();
  }

  @override
  void deactivate() {
    context.read<ProfileCubit>().selectBank(null);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppBackButton(),
          SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                Text('Add Bank', style: AppTextStyles.mediumText(fontSize: 22)),
                HelperFunc.sb(5.h),
                Text('Provide the details to your bank account',
                        style: AppTextStyles.regularText(
                            fontSize: 13, color: AppColors.grey))
                    .pd(EdgeInsets.only(right: 50.w)),
                HelperFunc.sb(25.h),
                BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                  return GlobalCard(
                      onTap: () => HelperFunc.showCustomBottomSheet(
                          context: context,
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: SelectBankBottomSheet(
                              accountController: accountNoController)),
                      nullText: 'Select Bank',
                      text: state.bankAccount?.bankName);
                }),
                HelperFunc.sb(15.h),
                AppFormField(
                    maxLength: 10,
                    hintText: 'Account number',
                    labelText: 'Account number',
                    validator: (v) => null,
                    onChanged: (v) => _debouncer(() {
                          if (v.length == 10) {
                            context
                                .read<ProfileCubit>()
                                .verifyAccount(accountNumber: v);
                          } else {
                            context.read<ProfileCubit>().clearBankName();
                          }
                        }),
                    keyBoardType: TextInputType.phone,
                    controller: accountNoController),
                HelperFunc.sb(15.h),
                BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                  return state.isLoading
                      ? const CircularProgressIndicator()
                          .align(Alignment.center)
                      : (state.bankAccount?.accountName ?? '').isEmpty
                          ? const SizedBox()
                          : Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(
                                  vertical: 14.h, horizontal: 12.w),
                              decoration: BoxDecoration(
                                  color: AppColors.grey.withOpacity(.1),
                                  borderRadius: BorderRadius.circular(10.r)),
                              child: Text(state.bankAccount?.accountName ?? '',
                                  style:
                                      AppTextStyles.mediumText(fontSize: 12)));
                }),
              ]).pd(EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h)))
              .EXPANDED,
          BlocBuilder<ProfileCubit, ProfileState>(builder: (context, state) {
            return AppButton(
                    color: (state.bankAccount?.accountNumber ?? '').isEmpty
                        ? AppColors.grey.withOpacity(.5)
                        : null,
                    onTap: (state.bankAccount?.accountNumber ?? '').isEmpty
                        ? null
                        : () => context
                            .read<ProfileCubit>()
                            .addBankAccount()
                            .then((value) =>
                                value ? accountNoController.clear() : null),
                    btnText: 'Save Account')
                .pd(EdgeInsets.fromLTRB(20.w, 0, 20.w, 10.h));
          }),
        ],
      )),
    );
  }
}

class SelectBankBottomSheet extends StatefulWidget {
  final TextEditingController accountController;

  const SelectBankBottomSheet({Key? key, required this.accountController})
      : super(key: key);

  @override
  State<SelectBankBottomSheet> createState() => _SelectBankBottomSheetState();
}

class _SelectBankBottomSheetState extends State<SelectBankBottomSheet> {
  late TextEditingController searchController;
  final _debouncer = Debouncer();

  @override
  void initState() {
    context.read<ProfileCubit>().searchBanks('');
    searchController = TextEditingController();
    context.read<ProfileCubit>().getBankList();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    _debouncer.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(builder: (context, state) {
      return state.isLoading && state.filterBanks.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                AppFormField(
                    onChanged: (v) => _debouncer(
                        () => context.read<ProfileCubit>().searchBanks(v)),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 4.h, horizontal: 6.w),
                    hintText: 'Search',
                    keyBoardType: TextInputType.text,
                    validator: (v) => null,
                    controller: searchController),
                SizedBox(height: 20.h),
                ListView.builder(
                    itemCount: state.filterBanks.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => TextButton(
                          onPressed: () {
                            context
                                .read<ProfileCubit>()
                                .selectBank(state.filterBanks[index]);
                            context.read<ProfileCubit>().verifyAccount(
                                accountNumber: widget.accountController.text);
                            globalPop();
                          },
                          child: SizedBox(
                              width: double.infinity,
                              child: Text(state.filterBanks[index].bankName,
                                  style: AppTextStyles.regularText(
                                      color: Colors.black))),
                        )).EXPANDED
              ],
            );
    });
  }
}
