import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xtridelink_driver/view/components/kyc_prompt.dart';
import 'package:xtridelink_driver/view/cubit/wallet/index.dart';
import '../../../domain/model/api/location_prediction.dart';
import '../../../domain/model/local/bank.dart';
import '../../../core/services/api/auth/index.dart';
import '../../../core/services/api/file_upload/index.dart';
import '../../../core/services/api/profile/bank.dart';
import '../../../core/services/location/index.dart';
import '../../../core/services/navigation/index.dart';
import 'dart:io';
import 'package:xtridelink_driver/core/constants/helpers.dart';
import 'package:xtridelink_driver/domain/model/api/user.dart';
import 'package:xtridelink_driver/core/services/api/profile/index.dart';

import '../../../core/services/navigation/routes.dart';
import '../../../core/services/storage/index.dart';
import '../../ui/dashboard/profile/components/negotiation_rate.dart';
import '../notifications/index.dart';
import '../order/index.dart';

class ProfileState {
  bool isLoading;
  UserData? user;
  RiderAnalytics? riderAnalytics;
  List<BankModel> bankList;
  List<BankModel> filterBanks;
  BankModel? bankAccount;
  String? newPassword;
  List<UserBankAccount>? userBankAccounts;
  List<LocationPrediction> addressPredictions;

  ProfileState(
      {required this.filterBanks,
      required this.user,
      required this.bankList,
      required this.newPassword,
      required this.isLoading,
      required this.riderAnalytics,
      required this.addressPredictions,
      required this.userBankAccounts,
      required this.bankAccount});
}

class ProfileCubit extends Cubit<ProfileState> {
  BankServiceImpl bankAccountServiceImpl;
  NavigationServiceImpl navigationServiceImpl;
  ProfileApiServiceImpl profileApiServiceImpl;
  LocationMapService locationMapService;
  FileUploadServiceImpl fileUploadServiceImpl;
  AuthApiServiceImpl authApiServiceImpl;
  StorageServiceImpl storageServiceImpl;

  ProfileCubit(
      {required this.bankAccountServiceImpl,
      required this.profileApiServiceImpl,
      required this.locationMapService,
      required this.fileUploadServiceImpl,
      required this.storageServiceImpl,
      required this.authApiServiceImpl,
      required this.navigationServiceImpl})
      : super(ProfileState(
            filterBanks: [],
            user: null,
            isLoading: false,
            bankList: [],
            newPassword: null,
            riderAnalytics: null,
            userBankAccounts: null,
            addressPredictions: [],
            bankAccount: null));

  void _emitState() {
    emit(ProfileState(
        filterBanks: state.filterBanks,
        isLoading: state.isLoading,
        user: state.user,
        bankList: state.bankList,
        riderAnalytics: state.riderAnalytics,
        newPassword: state.newPassword,
        addressPredictions: state.addressPredictions,
        userBankAccounts: state.userBankAccounts,
        bankAccount: state.bankAccount));
  }

  void _setLoading(bool v) {
    state.isLoading = v;
    _emitState();
  }

  Future<void> getUserDetails() async {
    state.user = await profileApiServiceImpl.getUserDetails() ?? state.user;
    final verificationStatus = state.user?.verificationStatus;
    if (verificationStatus != null) {
      if (verificationStatus.addressStatus == 'not_provided' ||
          verificationStatus.idStatus == 'not_provided' ||
          verificationStatus.vehicleStatus == 'not_provided') {
        HelperFunc.showFittedBottomSheet(
            context: navigationServiceImpl.navigationKey.currentContext!,
            child: const KycPrompt());
      }
    }
    _emitState();

    _setLocationStream(state.user?.isAvailable);
  }

  Future<void> getRiderAnalytics() async {
    state.riderAnalytics =
        await profileApiServiceImpl.getRiderAnalytics() ?? state.riderAnalytics;
    _emitState();
    if (state.riderAnalytics == null) return;
    if (state.riderAnalytics?.kycVerified.toUpperCase() == 'SKIPPED' ||
        state.riderAnalytics?.kycVerified.toUpperCase() == 'FAILED') {
      HelperFunc.showFittedBottomSheet(
          context: navigationServiceImpl.navigationKey.currentContext!,
          child: const KycPrompt());
      return;
    }
    if ((state.riderAnalytics?.downNegotiationRate ?? 0) <= 0 &&
        (state.riderAnalytics?.upNegotiationRate ?? 0) <= 0 &&
        state.riderAnalytics?.businessId == null) {
      HelperFunc.showFittedBottomSheet(
          context: navigationServiceImpl.navigationKey.currentContext!,
          child: const NegotiationRateSheet());
      return;
    }
  }

  Future<RiderAnalytics?> reloadKycStatus() async {
    HelperFunc.showLoader();
    state.riderAnalytics =
        await profileApiServiceImpl.getRiderAnalytics() ?? state.riderAnalytics;
    _emitState();
    navigationServiceImpl.pop();
    return state.riderAnalytics;
  }

  void setUserDetails(UserData user) {
    state.user = user;
    _emitState();
  }

  void updateUserDetails(
      {String? firstName,
      String? lastName,
      String? phoneNumber,
      String? countryCode,
      String? location,
      num? latitude,
      num? longitude,
      DateTime? dob,
      bool? isOnline,
      String? profileImage,
      VoidCallback? onSuccess}) async {
    HelperFunc.showLoader();
    UserData? userData = await profileApiServiceImpl.updateUserDetails(map: {
      ...(isOnline != null ? {'isOnline': isOnline} : {}),
      ...(firstName != null ? {'firstName': firstName} : {}),
      ...(lastName != null ? {'lastName': lastName} : {}),
      ...(phoneNumber != null
          ? {'phone': '${countryCode ?? '+234'}$phoneNumber'}
          : {}),
      ...(location != null ? {'location': location} : {}),
      // ...(latitude != null ? {'latitude': latitude.toString()} : {}),
      // ...(longitude != null ? {'longitude': longitude.toString()} : {}),
      ...(countryCode != null ? {'countryCode': countryCode} : {}),
      ...(dob != null ? {'DOB': dob.toIso8601String()} : {}),
      ...(profileImage != null ? {'profileImg': profileImage} : {})
    });
    navigationServiceImpl.pop();
    if (userData != null) {
      onSuccess != null ? onSuccess() : null;
      state.user = userData;
      _emitState();
      _setLocationStream(isOnline);
    }
  }

  void _setLocationStream(bool? isOnline) {
    if (isOnline == null) return;
    if (isOnline) {
      locationMapService.updateLocationStream(state.user?.id ?? '');
    } else {
      locationMapService.cancelLocationStream();
    }
  }

  void updateRiderAnalytics(
      {String? idVerificationType,
      String? idVerificationNumber,
      String? idVerificationDoc,
      String? profileImg,
      String? latitude,
      String? longitude,
      String? vehicleType,
      String? vehicleName,
      String? vehiclePlateNo,
      String? vehicleParticulars,
      String? addressVerificationType,
      String? addressVerificationNumber,
      String? addressVerificationDoc,
      VoidCallback? onSuccess}) async {
    HelperFunc.showLoader();
    RiderAnalytics? analytics =
        await profileApiServiceImpl.updateRiderAnalytics(map: {
      ...(idVerificationType != null
          ? {'idVerificationType': idVerificationType}
          : {}),
      ...(idVerificationNumber != null
          ? {'idVerificationNumber': idVerificationNumber}
          : {}),
      ...(idVerificationDoc != null
          ? {'idVerificationDoc': idVerificationDoc}
          : {}),
      ...(profileImg != null ? {'profileImg': profileImg} : {}),
      ...(latitude != null ? {'latitude': latitude} : {}),
      ...(longitude != null ? {'longitude': longitude} : {}),
      ...(vehicleType != null ? {'vehicleType': vehicleType} : {}),
      ...(vehicleName != null ? {'vehicleName': vehicleName} : {}),
      ...(vehiclePlateNo != null ? {'vehiclePlateNo': vehiclePlateNo} : {}),
      ...(vehicleParticulars != null
          ? {'vehicleParticulars': vehicleParticulars}
          : {}),
      ...(addressVerificationType != null
          ? {'addressVerificationType': addressVerificationType}
          : {}),
      ...(addressVerificationNumber != null
          ? {'addressVerificationNumber': addressVerificationNumber}
          : {}),
      ...(addressVerificationDoc != null
          ? {'addressVerificationDoc': addressVerificationDoc}
          : {})
    });
    navigationServiceImpl.pop();
    if (analytics != null) {
      onSuccess != null ? onSuccess() : null;
      state.riderAnalytics = analytics;
      _emitState();
    }
  }

  void addVehicleInformation({
    String? vehicleType,
    String? vehicleName,
    String? vehiclePlateNo,
    String? vehicleDocument,
    VoidCallback? onSuccess,
  }) async {
    HelperFunc.showLoader();

    final result = await profileApiServiceImpl.addVehicleInformation(map: {
      'vehicle_type': vehicleType,
      'vehicle_name': vehicleName,
      'registration_number': vehiclePlateNo,
      'vehicle_documents': [vehicleDocument]
    });
    navigationServiceImpl.pop();
    if (result) {
      onSuccess != null ? onSuccess() : null;
    }
  }

  void addIdInformation({
    String? idVerificationType,
    String? idVerificationNumber,
    String? idVerificationDoc,
    VoidCallback? onSuccess,
  }) async {
    HelperFunc.showLoader();

    final result = await profileApiServiceImpl.addIdInformation(map: {
      'id_type': idVerificationType,
      'id_number': idVerificationNumber,
      'id_documents': [idVerificationDoc]
    });
    navigationServiceImpl.pop();

    if (result) onSuccess != null ? onSuccess() : null;
  }

  void addNINInformation({
    String? nin,
    VoidCallback? onSuccess,
  }) async {
    HelperFunc.showLoader();

    final result =
        await profileApiServiceImpl.addNINInformation(map: {'nin': nin});
    navigationServiceImpl.pop();

    if (result) onSuccess != null ? onSuccess() : null;
  }

  void setLocation({
    required double latitude,
    required double longitude,
    required String location,
    VoidCallback? onSuccess,
  }) async {
    HelperFunc.showLoader();

    final result = await profileApiServiceImpl.updateLocation(
        latitude: latitude, longitude: longitude, location: location);
    navigationServiceImpl.pop();
    if (result) onSuccess != null ? onSuccess() : null;
  }

  void addAddressInformation({
    String? addressVerificationType,
    String? addressVerificationNumber,
    String? addressVerificationDoc,
    VoidCallback? onSuccess,
  }) async {
    HelperFunc.showLoader();

    final result = await profileApiServiceImpl.addAddressInformation(map: {
      'document_type':
          addressVerificationType, // utility_bill, bank_statement, lease_agreement
      'address_documents': [addressVerificationDoc]
    });
    navigationServiceImpl.pop();
    if (result) onSuccess != null ? onSuccess() : null;
  }

  Future<String?> uploadProfileImage(File file) async {
    HelperFunc.showLoader();
    String? url = await fileUploadServiceImpl.uploadImage(image: file);
    navigationServiceImpl.pop();
    return url;
  }

  void getBankList() async {
    if (state.bankList.isEmpty) {
      await bankAccountServiceImpl.getBankList().then((value) {
        if (value == null) return;
        state.bankList = value;
        state.filterBanks = value;
        _emitState();
      });
    }
  }

  void verifyAccount({required String accountNumber}) async {
    clearBankName();
    if (state.bankAccount == null) return;
    if (accountNumber.length != 10) return;
    _setLoading(true);
    await bankAccountServiceImpl
        .verifyAccount(
            accountNumber: accountNumber, bankCode: state.bankAccount!.bankCode)
        .then((value) {
      if (value != null) {
        state.bankAccount = BankModel(
            bankName: state.bankAccount!.bankName,
            bankCode: state.bankAccount!.bankCode,
            accountNumber: accountNumber,
            accountName: value);
      }
    });
    _setLoading(false);
  }

  void searchBanks(String query) {
    state.filterBanks = state.bankList
        .where((element) =>
            element.bankName.toLowerCase().contains(query.toLowerCase()))
        .toList();
    _emitState();
  }

  void selectBank(BankModel? bankModel) {
    state.bankAccount = bankModel;
    _emitState();
  }

  void clearBankName() {
    if (state.bankAccount == null) return;
    if (state.bankAccount!.accountName.isEmpty) return;
    state.bankAccount = BankModel(
        bankName: state.bankAccount!.bankName,
        bankCode: state.bankAccount!.bankCode,
        accountNumber: '',
        accountName: '');
    _emitState();
  }

  void searchAddress(String address) async {
    state.addressPredictions =
        await locationMapService.getPredictions(address) ?? [];
    _emitState();
  }

  void changePassword(
      {required String oldPassword, required String newPassword}) async {
    HelperFunc.showLoader();
    await profileApiServiceImpl.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
        email: state.user?.email ?? '');
    navigationServiceImpl.pop();
  }

  Future<bool> addBankAccount() async {
    if (state.bankAccount == null) return false;
    HelperFunc.showLoader();
    UserBankAccount? account = await bankAccountServiceImpl.addAccount(
        accountNumber: state.bankAccount!.accountNumber,
        bankName: state.bankAccount!.bankName,
        bankCode: state.bankAccount!.bankCode,
        accountName: state.bankAccount!.accountName);
    navigationServiceImpl.pop();
    if (account != null) {
      state.userBankAccounts = [account, ...(state.userBankAccounts ?? [])];
      state.bankAccount = null;
      _emitState();
    }
    return account != null;
  }

  Future<List<UserBankAccount>?> getUserBankAccounts() async {
    _setLoading(true);
    state.userBankAccounts =
        await bankAccountServiceImpl.getUserBankAccounts() ??
            state.userBankAccounts;
    _setLoading(false);
    return state.userBankAccounts;
  }

  void reloadBankAccounts() async {
    if (state.userBankAccounts != null) return;
    _setLoading(true);
    state.userBankAccounts =
        await bankAccountServiceImpl.getUserBankAccounts() ??
            state.userBankAccounts;
    _setLoading(false);
  }

  void deleteBankAccount(String id) async {
    HelperFunc.showLoader();
    bool success = await bankAccountServiceImpl.deleteAccount(id: id);
    navigationServiceImpl.pop();
    if (success) {
      state.userBankAccounts?.removeWhere((element) => element.id == id);
      _emitState();
    }
  }

  void setNegotiationRate({required num up, required num down}) async {
    HelperFunc.showLoader();
    RiderAnalytics? riderAnalytics =
        await profileApiServiceImpl.setNegotiationRate(up: up, down: down);
    navigationServiceImpl.pop();
    if (riderAnalytics != null) {
      navigationServiceImpl.pop();
      state.riderAnalytics = riderAnalytics;
      _emitState();
    }
  }

  void contactSupport(
      {required String message, required String subject}) async {
    HelperFunc.showLoader();
    bool success = await profileApiServiceImpl.contactSupport(
        subject: subject, message: message);
    navigationServiceImpl.pop();
    if (success) {
      navigationServiceImpl.popUntil(Routes.base);
    }
  }

  void signOut() {
    navigationServiceImpl.popUntil(Routes.base);
    navigationServiceImpl.replaceWith(Routes.intro);
    state.user = null;
    navigationServiceImpl.navigationKey.currentContext!
        .read<OrderFlowCubit>()
        .clearData();
    navigationServiceImpl.navigationKey.currentContext!
        .read<NotificationsCubit>()
        .clearData();
    navigationServiceImpl.navigationKey.currentContext!
        .read<WalletCubit>()
        .clearData();
    storageServiceImpl.clearUserData();
    emit(ProfileState(
        filterBanks: state.bankList,
        user: null,
        bankList: state.bankList,
        newPassword: null,
        riderAnalytics: null,
        isLoading: false,
        addressPredictions: [],
        userBankAccounts: null,
        bankAccount: null));
  }

  Future<void> updateDeviceToken() async {
    await authApiServiceImpl.updateDeviceToken(
        token: await storageServiceImpl.getDeviceToken());
  }

  void updateAvailability(bool isAvailable) async {
    final verificationStatus = state.user?.verificationStatus;
    if (verificationStatus == null ||
        verificationStatus.fullyVerified == false) {
      HelperFunc.showFittedBottomSheet(
          context: navigationServiceImpl.navigationKey.currentContext!,
          child: const KycPrompt());
    }
    _setLoading(true);
    try {
      final result = await profileApiServiceImpl.changeAvailability(
          isAvailable: isAvailable);
      _setLoading(false);
      if (result) {
        state.user?.isAvailable = isAvailable;
        _emitState();
        _setLocationStream(isAvailable);
      }
    } catch (e) {
      _setLoading(false);
    }
  }
}
