// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:xtridelink/core/constants/helpers.dart';
// import 'package:xtridelink/domain/model/api/user.dart';
// import 'package:xtridelink/view/cubit/profile/index.dart';
// import 'package:xtridelink/view/cubit/settings/index.dart';
// import '../../../core/constants/enumerations.dart';
// // import '../../../core/services/api/auth/index.dart';
// import '../../../core/services/biometrics/index.dart';
// import '../../../core/services/navigation/index.dart';
// import '../../../core/services/navigation/routes.dart';
// import '../../../../../../../injector.dart';

// class AuthState {
//   bool isLoading;
//   String? email, otp;
//   AuthState({required this.isLoading, required this.email, required this.otp});
// }

// class AuthCubit extends Cubit<AuthState> {
//   // AuthApiServiceImpl authApiServiceImpl;
//   NavigationServiceImpl navigationServiceImpl;

//   AuthCubit(
//       {required this.authApiServiceImpl, required this.navigationServiceImpl})
//       : super(AuthState(isLoading: false, email: null, otp: null));

//   void signIn({required String email, required String password}) async {
//     HelperFunc.showLoader();
//     UserData? userData =
//         await authApiServiceImpl.signIn(email: email, password: password);
//     navigationServiceImpl.pop();
//     if (userData != null) {
//       navigationServiceImpl.replaceWith(
//           userData.location.isEmpty ? Routes.setUserLocation : Routes.base);
//       _setAuthDetails(email: email, password: password, userData: userData);
//     }
//   }

//   void signUp(
//       {required String password,
//       required String firstName,
//       required String lastName,
//       required String referralCode,
//       required String phoneNumber,
//       required String countryCode}) async {
//     HelperFunc.showLoader();
//     UserData? userData = await authApiServiceImpl.signUp(
//         email: state.email ?? '',
//         password: password,
//         firstName: firstName,
//         lastName: lastName,
//         referralCode: referralCode,
//         phoneNumber: '$countryCode$phoneNumber',
//         countryCode: countryCode);
//     navigationServiceImpl.pop();
//     if (userData != null) {
//       navigationServiceImpl.replaceWith(
//           getIt<BiometricsService>().canAuthenticate.value
//               ? Routes.enableBiometrics
//               : Routes.setUserLocation);
//       _setAuthDetails(
//           email: state.email ?? '', password: password, userData: userData);
//     }
//   }

//   void _setAuthDetails(
//       {required String email,
//       required String password,
//       required UserData userData}) {
//     navigationServiceImpl.navigationKey.currentContext!
//         .read<SettingsCubit>()
//         .saveLoginDet(email: email, password: password);
//     navigationServiceImpl.navigationKey.currentContext!
//         .read<ProfileCubit>()
//         .setUserDetails(userData);
//   }

//   void forgotPassword({required String email}) async {
//     HelperFunc.showLoader();
//     bool success = await authApiServiceImpl.forgotPassword(email: email);
//     navigationServiceImpl.pop();
//     if (success) {
//       state.email = email;
//       navigationServiceImpl.replaceWith(Routes.signUpVerifyPhone,
//           arguments: VerifyType.resetPwd);
//     }
//   }

//   void savePasswordResetOtp(String otp) {
//     state.otp = otp;
//     navigationServiceImpl.replaceWith(Routes.createNewPwd);
//   }

//   void resetPassword({required String newPassword}) async {
//     HelperFunc.showLoader();
//     UserData? userData = await authApiServiceImpl.resetPassword(
//         email: state.email ?? '',
//         code: state.otp ?? '',
//         newPassword: newPassword);
//     navigationServiceImpl.pop();
//     if (userData != null) {
//       navigationServiceImpl.replaceWith(Routes.login);
//       _setAuthDetails(
//           email: state.email ?? '', password: newPassword, userData: userData);
//     }
//   }

//   void verifyEmail({required String otp}) async {
//     HelperFunc.showLoader();
//     bool success = await authApiServiceImpl.verifyEmail(
//         email: state.email ?? '', otp: otp);
//     navigationServiceImpl.pop();
//     if (success) {
//       navigationServiceImpl.replaceWith(Routes.signUp);
//     }
//   }

//   void sendOtp({required String phoneNumber}) async {
//     HelperFunc.showLoader();
//     bool success = await authApiServiceImpl.sendOtp(email: phoneNumber);
//     navigationServiceImpl.pop();
//     if (success) {
//       navigationServiceImpl.replaceWith(Routes.signUpVerifyPhone,
//           arguments: VerifyType.signup);
//       state.email = phoneNumber;
//     }
//   }

//   Future<bool> resendOtp() async {
//     HelperFunc.showLoader();
//     bool success = await authApiServiceImpl.sendOtp(email: state.email ?? '');
//     navigationServiceImpl.pop();
//     return success;
//   }
// }
