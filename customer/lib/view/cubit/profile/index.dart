// import 'dart:io';
// import 'dart:ui';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:injectable/injectable.dart';
// import 'package:xtridelink/core/constants/helpers.dart';
// import 'package:xtridelink/domain/model/api/location_prediction.dart';
// import 'package:xtridelink/domain/model/api/user.dart';
// import 'package:xtridelink/core/services/api/profile/index.dart';
// import 'package:xtridelink/view/cubit/notifications/index.dart';
// import '../../../core/constants/enumerations.dart';
// import '../../../core/services/api/file_upload.dart';
// import '../../../core/services/location/index.dart';
// import '../../../core/services/navigation/index.dart';
// import '../../../core/services/navigation/routes.dart';
// import '../../../core/services/storage/index.dart';
// import '../order/index.dart';

// class ProfileState {
//   bool isLoading;
//   UserData? user;
//   String? newPassword;
//   List<LocationPrediction> addressPredictions;
//   ProfileState(
//       {required this.isLoading,
//       required this.user,
//       required this.newPassword,
//       required this.addressPredictions});
// }

// @Injectable()
// class ProfileCubit extends Cubit<ProfileState> {
//   ProfileApiServiceImpl profileApiServiceImpl;
//   NavigationServiceImpl navigationServiceImpl;
//   LocationMapService locationMapService;
//   FileUploadServiceImpl fileUploadServiceImpl;
//   // AuthApiServiceImpl authApiServiceImpl;
//   StorageServiceImpl storageServiceImpl;

//   ProfileCubit(
//       {required this.profileApiServiceImpl,
//       required this.navigationServiceImpl,
//       required this.fileUploadServiceImpl,
//       // required this.authApiServiceImpl,
//       required this.storageServiceImpl,
//       required this.locationMapService})
//       : super(ProfileState(
//             isLoading: false,
//             newPassword: null,
//             user: null,
//             addressPredictions: []));

//   void _emitState() {
//     emit(ProfileState(
//         isLoading: state.isLoading,
//         user: state.user,
//         newPassword: state.newPassword,
//         addressPredictions: state.addressPredictions));
//   }

//   void getUserDetails() async {
//     state.user = await profileApiServiceImpl.getUserDetails() ?? state.user;
//     _emitState();
//   }

//   void setUserDetails(UserData user) {
//     state.user = user;
//     _emitState();
//   }

//   void updateUserDetails(
//       {String? firstName,
//       String? lastName,
//       String? phoneNumber,
//       String? countryCode,
//       String? location,
//       num? latitude,
//       num? longitude,
//       DateTime? dob,
//       String? profileImage,
//       VoidCallback? onSuccess}) async {
//     HelperFunc.showLoader();
//     UserData? userData = await profileApiServiceImpl.updateUserDetails(map: {
//       ...(firstName != null ? {'firstName': firstName} : {}),
//       ...(lastName != null ? {'lastName': lastName} : {}),
//       ...(phoneNumber != null
//           ? {'phone': '${countryCode ?? '+234'}$phoneNumber'}
//           : {}),
//       ...(location != null ? {'location': location} : {}),
//       ...(latitude != null ? {'latitude': latitude.toString()} : {}),
//       ...(longitude != null ? {'longitude': longitude.toString()} : {}),
//       ...(countryCode != null ? {'countryCode': countryCode} : {}),
//       ...(dob != null ? {'DOB': dob.toIso8601String()} : {}),
//       ...(profileImage != null ? {'profileImg': profileImage} : {})
//     });
//     navigationServiceImpl.pop();
//     if (userData != null) {
//       onSuccess != null ? onSuccess() : null;
//       state.user = userData;
//       _emitState();
//     }
//   }

//   Future<String?> uploadProfileImage(File file) async {
//     HelperFunc.showLoader();
//     String? url = await fileUploadServiceImpl.uploadImage(image: file);
//     navigationServiceImpl.pop();
//     return url;
//   }

//   void searchAddress(String address) async {
//     state.addressPredictions =
//         await locationMapService.getPredictions(address) ?? [];
//     _emitState();
//   }

//   void changePassword(
//       {required String oldPassword, required String newPassword}) async {
//     HelperFunc.showLoader();
//     await profileApiServiceImpl.changePassword(
//         oldPassword: oldPassword,
//         newPassword: newPassword,
//         email: state.user?.email ?? '');
//     navigationServiceImpl.pop();
//   }

//   void contactSupport(
//       {required String message, required String subject}) async {
//     HelperFunc.showLoader();
//     bool success = await profileApiServiceImpl.contactSupport(
//         subject: subject, message: message);
//     navigationServiceImpl.pop();
//     if (success) {
//       navigationServiceImpl.popUntil(Routes.base);
//     }
//   }

//   Future<void> updateDeviceToken() async {
//     // await authApiServiceImpl.updateDeviceToken(
//     //     token: await storageServiceImpl.getDeviceToken());
//   }

//   void signOut() {
//     navigationServiceImpl.popUntil(Routes.base);
//     navigationServiceImpl.replaceWith(Routes.intro);
//     state.user = null;
//     navigationServiceImpl.navigationKey.currentContext!
//         .read<OrdersCubit>()
//         .clearData();
//     // navigationServiceImpl.navigationKey.currentContext!
//     //     .read<NotificationsCubit>()
//     //     .clearData();
//     storageServiceImpl.clearUserData();
//     emit(ProfileState(
//         user: null,
//         newPassword: null,
//         isLoading: false,
//         addressPredictions: []));
//   }
// }
