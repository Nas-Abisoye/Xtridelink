import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xtridelink/core/constants/old_assets.dart';
import 'package:xtridelink/core/constants/extensions.dart';
import 'package:xtridelink/domain/model/local/settings.dart';
import 'package:xtridelink/injector.dart';
import 'package:xtridelink/view/cubit/settings/index.dart';
import 'package:xtridelink/view/ui/dashboard/profile/cubit/profile_cubit.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/debouncer.dart';
import '../../../../core/constants/helpers.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../domain/model/api/location_prediction.dart';
import '../../../../core/services/location/index.dart';
import '../../../../core/services/navigation/index.dart';
import '../../../../core/services/navigation/routes.dart';
import '../../../components/back_button.dart';
import '../../../components/button.dart';
import '../../../components/search_overlay.dart';

class ChooseLocationForSetup extends StatefulWidget {
  const ChooseLocationForSetup({super.key});

  @override
  State<ChooseLocationForSetup> createState() => _ChooseLocationForSetupState();
}

class _ChooseLocationForSetupState extends State<ChooseLocationForSetup> {
  late TextEditingController locationController;
  late ValueNotifier<LocationData?> location;
  final _debouncer = Debouncer();

  @override
  void initState() {
    location = ValueNotifier(null);
    locationController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    locationController.dispose();
    location.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Row(children: [
            const AppBackButton(),
            const Spacer(),
            TextButton(
                    onPressed: () => globalReplaceWith(route: Routes.base),
                    child: Text('Skip',
                        style: AppTextStyles.semiBold(
                            color: Colors.black, fontSize: 13)))
                .pd(EdgeInsets.only(right: 10.w)),
          ]),
          Expanded(
              child: SingleChildScrollView(
                  child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('What is your location?',
                  style: AppTextStyles.mediumText(fontSize: 20)),
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
              HelperFunc.sb(10.h),
              TextButton(
                  onPressed: () async {
                    HelperFunc.showLoader();
                    final position =
                        await getIt<LocationMapService>().getPosition();
                    final location = await getIt<LocationMapService>()
                        .getLocationFromPosition(
                            longitude: position.longitude,
                            latitude: position.latitude);
                    globalPop();
                    if (location != null && mounted) {
                      context.read<ProfileCubit>().updateUserDetails(
                          location: location,
                          latitude: position.latitude,
                          longitude: position.longitude,
                          onSuccess: () {
                            context.read<SettingsCubit>().addRecentLocation(
                                RecentLocationData(
                                    address: location,
                                    longitude: position.longitude,
                                    latitude: position.latitude));
                            globalReplaceWith(route: Routes.base);
                          });
                    }
                  },
                  child: Text('Use my current location',
                      style: AppTextStyles.mediumText(fontSize: 12.5)))
            ],
          ).pd(EdgeInsets.all(15.w)))),
          ValueListenableBuilder(
              valueListenable: location,
              builder: (context, value, _) {
                return AppButton(
                        btnText: 'Continue',
                        onTap: () => value != null
                            ? context.read<ProfileCubit>().updateUserDetails(
                                // location: locationController.text,
                                location: value.address,
                                latitude: value.latitude,
                                longitude: value.longitude,
                                onSuccess: () {
                                  globalReplaceWith(route: Routes.base);
                                  context
                                      .read<SettingsCubit>()
                                      .addRecentLocation(RecentLocationData(
                                          address: value.address,
                                          longitude: value.longitude,
                                          latitude: value.latitude));
                                })
                            : null,
                        color: value != null
                            ? null
                            : AppColors.grey.withOpacity(.5))
                    .pd(EdgeInsets.fromLTRB(15.w, 0, 15.w, 10.h));
              }),
        ],
      )),
    );
  }
}
