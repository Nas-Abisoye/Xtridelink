import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xtridelink/core/constants/old_assets.dart';
import 'package:xtridelink/core/constants/extensions.dart';
import 'package:xtridelink/domain/model/api/location_prediction.dart';
import 'package:xtridelink/core/services/navigation/index.dart';
import 'package:xtridelink/view/components/icon_avatar.dart';
import 'package:xtridelink/view/components/search_overlay.dart';
import 'package:xtridelink/view/cubit/settings/index.dart';
import 'package:xtridelink/view/ui/dashboard/profile/cubit/profile_cubit.dart';
import '../../../../../../core/constants/colors.dart';
import '../../../../../../core/constants/debouncer.dart';
import '../../../../../../core/constants/helpers.dart';
import '../../../../../../core/constants/text_styles.dart';
import '../../../../../../domain/model/local/settings.dart';
import '../../../../../../core/services/location/index.dart';
import '../../../../../../../injector.dart';
import '../../../../../components/back_button.dart';
import '../../../../../components/button.dart';
import '../../../../../cubit/profile/index.dart';

class EditAddressPage extends StatefulWidget {
  const EditAddressPage({super.key});

  @override
  State<EditAddressPage> createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  late ValueNotifier<LocationData?> location;
  late TextEditingController locationController;
  final _debouncer = Debouncer();

  @override
  void initState() {
    final user = context.read<ProfileCubit>().state.currentUser();
    location = ValueNotifier(LocationData(
        placeId: 'placeId',
        address: user?.location ?? '',
        latitude: num.tryParse(user?.latitude ?? '') ?? 0,
        longitude: num.tryParse(user?.longitude ?? '') ?? 0));
    locationController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    location.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppBackButton(),
          Expanded(
              child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                Text('Address', style: AppTextStyles.mediumText(fontSize: 22)),
                HelperFunc.sb(10.h),
                Text('View all your locations used',
                        style: AppTextStyles.regularText(
                            fontSize: 13, color: AppColors.grey))
                    .pd(EdgeInsets.only(right: 50.w)),
                HelperFunc.sb(25.h),
                BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                  return SearchField(
                      hintText: 'Search location',
                      controller: locationController,
                      inputType: TextInputType.text,
                      suffixIcon: Assets.locationSvg,
                      onMapLocationPicked: (v) => location.value = v,
                      onChanged: (v) => _debouncer(() => _debouncer(
                          () => context.read<ProfileCubit>().searchAddress(v))),
                      suggestions: state.addressPredictions.data!
                          .map((e) => SearchFieldListItem(e.description,
                              searchKey: e.placeId,
                              child: Row(
                                children: [
                                  SvgPicture.asset(Assets.locationSvg2),
                                  HelperFunc.sb(10.w),
                                  Text(e.description).EXPANDED,
                                ],
                              ).pd(EdgeInsets.symmetric(horizontal: 20.w))))
                          .toList(),
                      onSuggestionTap: (e) async {
                        HelperFunc.showLoader();
                        location.value = await getIt<LocationMapService>()
                            .getLocationDetails(e.searchKey);
                        globalPop();
                        location.value =
                            location.value?.copyWith(address: e.searchText);
                      },
                      itemHeight: 50.h);
                }),
                BlocBuilder<SettingsCubit, SettingsState>(
                    builder: (context, state) {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (location.value?.address != null) ...[
                          Text('Current Location',
                                  style: AppTextStyles.semiBold(
                                      color: AppColors.secColor, fontSize: 14))
                              .pd(EdgeInsets.only(top: 30.h, bottom: 5.h)),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border(
                                  bottom: BorderSide(
                                      color: AppColors.grey.withOpacity(0.05))),
                            ),
                            child: Row(
                              children: [
                                Text(location.value!.address,
                                        style: AppTextStyles.mediumText(
                                            fontSize: 13))
                                    .EXPANDED,
                              ],
                            ),
                          ),
                        ],
                        if (state.recentLocations.isNotEmpty)
                          Text('Recent Locations',
                                  style: AppTextStyles.semiBold(
                                      color: AppColors.secColor, fontSize: 14))
                              .pd(EdgeInsets.only(top: 30.h, bottom: 5.h)),
                        ...List.generate(
                            state.recentLocations.length,
                            (idx) => GestureDetector(
                                  onTap: () {
                                    context
                                        .read<ProfileCubit>()
                                        .updateUserDetails(
                                            onSuccess: () {
                                              context
                                                  .read<SettingsCubit>()
                                                  .addRecentLocation(
                                                      RecentLocationData(
                                                          address:
                                                              state
                                                                  .recentLocations[
                                                                      idx]
                                                                  .address,
                                                          longitude: state
                                                              .recentLocations[
                                                                  idx]
                                                              .longitude,
                                                          latitude: state
                                                              .recentLocations[
                                                                  idx]
                                                              .latitude));
                                              globalPop();
                                            },
                                            location: state
                                                .recentLocations[idx].address,
                                            latitude: state
                                                .recentLocations[idx].latitude,
                                            longitude: state
                                                .recentLocations[idx]
                                                .longitude);
                                  },
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 12.h),
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border(
                                          bottom: BorderSide(
                                              color: AppColors.grey
                                                  .withOpacity(0.05))),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(state.recentLocations[idx].address,
                                                style: AppTextStyles.mediumText(
                                                    fontSize: 13))
                                            .EXPANDED,
                                        IconAvatar(
                                          color: AppColors.red,
                                          avatar: Assets.delete,
                                          radius: 15.r,
                                          iconSize: 15.h,
                                          onTap: () => context
                                              .read<SettingsCubit>()
                                              .deleteRecentLocation(idx),
                                        )
                                      ],
                                    ),
                                  ),
                                ))
                      ]);
                }),
              ]).pd(EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h)))),
          ValueListenableBuilder(
              valueListenable: location,
              builder: (context, value, _) {
                return value != null
                    ? AppButton(
                            onTap: () => context
                                .read<ProfileCubit>()
                                .updateUserDetails(
                                    onSuccess: () => context
                                        .read<SettingsCubit>()
                                        .addRecentLocation(RecentLocationData(
                                            address: value.address,
                                            longitude: value.longitude,
                                            latitude: value.latitude)),
                                    location: value.address,
                                    latitude: value.latitude,
                                    longitude: value.longitude),
                            btnText: 'Add Location')
                        .pd(EdgeInsets.fromLTRB(20.w, 0, 20.w, 10.h))
                    : const SizedBox();
              }),
        ],
      )),
    );
  }
}
