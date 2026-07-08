import 'dart:developer';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:xtridelink/core/base/process_state.dart';
import 'package:xtridelink/core/constants/helpers.dart';
import 'package:xtridelink/core/helpers/device_helper.dart';
import 'package:xtridelink/core/services/location/index.dart';
import 'package:xtridelink/core/services/navigation/index.dart';
import 'package:xtridelink/core/services/navigation/routes.dart';
import 'package:xtridelink/data/source/remote/model/auth/get_user_details_response.dart';
import 'package:xtridelink/domain/model/api/location_prediction.dart';
import 'package:xtridelink/domain/repository/authentication_repository.dart';
import 'package:xtridelink/injector.dart';
import 'package:xtridelink/view/cubit/settings/index.dart';
import 'package:xtridelink/view/ui/dashboard/notifications/cubit/notifications_cubit.dart';
import 'package:xtridelink/view/ui/dashboard/order/cubit/orders_cubit.dart';

part 'profile_state.dart';

@Injectable()
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._authenticationRepository) : super(ProfileState.initial());

  final AuthenticationRepository _authenticationRepository;

  void getUserDetails() async {
    emit(state.copyWith(fetchUserResponse: ProcessState.loading()));
    final response = await _authenticationRepository.fetchUserAccountDetails();
    response.when(
      success: (data) {
        log(data.data?.toJson().toString() ?? '');
        if (data.data?.location == null || data.data!.location!.isEmpty) {
          globalNavigateTo(route: Routes.setUserLocation);
        }
        emit(state.copyWith(
          fetchUserResponse: ProcessState.success(true),
          currentUser: () => data.data,
        ));
      },
      failure: (error) {
        emit(state.copyWith(
          fetchUserResponse: ProcessState.error(false),
        ));
      },
    );
  }

  void updateUserDetails({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? countryCode,
    String? location,
    num? latitude,
    num? longitude,
    DateTime? dob,
    String? profileImage,
    VoidCallback? onSuccess,
  }) async {
    HelperFunc.showLoader();
    try {
      await _authenticationRepository.updateUserProfile(
        latitude: latitude,
        location: location,
        longitude: longitude,
      );
      getUserDetails();
      globalPop();
      onSuccess?.call();
    } catch (e) {
      print(e);
      globalPop();
    } finally {}
  }

  Future<String?> uploadProfileImage(File file) async {
    return null;
  }

  void searchAddress(String address) async {
    final predictions =
        await getIt<LocationMapService>().getPredictions(address);
    emit(state.copyWith(
        addressPredictions: ProcessState.success(predictions ?? [])));
  }

  void changePassword(
      {required String oldPassword, required String newPassword}) async {}

  void contactSupport(
      {required String message, required String subject}) async {}

  Future<void> updateDeviceToken() async {
    final token = _authenticationRepository.getFCMDeviceToken();
    final deviceId = await DeviceHelper.getDeviceUniqueId();
    if (token != null) {
      await _authenticationRepository.registerDeviceToken(
        deviceToken: token,
        deviceType: Platform.operatingSystem,
        deviceId: deviceId,
      );
    }
  }

  void signOut(BuildContext context) {
    globalPopUntil(Routes.base);
    globalReplaceWith(route: Routes.intro);
    emit(state.copyWith(
        currentUser: () => null, addressPredictions: ProcessState.init([])));
    context.read<OrdersCubit>().clearData();
    context.read<SettingsCubit>().clearSettings();
    context.read<NotificationsCubit>().clearNotifications();
    _authenticationRepository.logout();
  }
}
