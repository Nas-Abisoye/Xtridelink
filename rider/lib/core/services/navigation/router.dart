import 'package:flutter/material.dart';
import 'package:xtridelink_driver/core/constants/enumerations.dart';
import 'package:xtridelink_driver/core/services/navigation/routes.dart';
import 'package:xtridelink_driver/view/ui/auth/forgot_pwd/create_password.dart';
import 'package:xtridelink_driver/view/ui/auth/forgot_pwd/forgot_password.dart';
import 'package:xtridelink_driver/view/ui/auth/intro/index.dart';
import 'package:xtridelink_driver/view/ui/auth/login/index.dart';
import 'package:xtridelink_driver/view/ui/auth/post_signup/biometrics.dart';
import 'package:xtridelink_driver/view/ui/auth/post_signup/choose_location.dart';
import 'package:xtridelink_driver/view/ui/auth/post_signup/kyc/address_verification.dart';
import 'package:xtridelink_driver/view/ui/auth/post_signup/kyc/bvn_verification.dart';
import 'package:xtridelink_driver/view/ui/auth/post_signup/kyc/id_verification.dart';
import 'package:xtridelink_driver/view/ui/auth/post_signup/kyc/kyc.dart';
import 'package:xtridelink_driver/view/ui/auth/post_signup/kyc/kyc_submitted.dart';
import 'package:xtridelink_driver/view/ui/auth/post_signup/kyc/vehicle_details.dart';
import 'package:xtridelink_driver/view/ui/auth/post_signup/location.dart';
import 'package:xtridelink_driver/view/ui/auth/post_signup/kyc/verify_kyc.dart';
import 'package:xtridelink_driver/view/ui/auth/signup/choose_type.dart';
import 'package:xtridelink_driver/view/ui/auth/signup/merchant/add_mail.dart';
import 'package:xtridelink_driver/view/ui/auth/signup/merchant/create_password.dart';
import 'package:xtridelink_driver/view/ui/auth/signup/standalone/add_mail.dart';
import 'package:xtridelink_driver/view/ui/dashboard/home/components/order_success.dart';
import 'package:xtridelink_driver/view/ui/dashboard/index.dart';
import 'package:xtridelink_driver/view/ui/dashboard/profile/pages/address/index.dart';
import 'package:xtridelink_driver/view/ui/dashboard/profile/pages/change_password/index.dart';
import 'package:xtridelink_driver/view/ui/dashboard/profile/pages/edit_profile/index.dart';
import 'package:xtridelink_driver/view/ui/dashboard/profile/pages/faq/index.dart';
import 'package:xtridelink_driver/view/ui/dashboard/profile/pages/legal/index.dart';
import 'package:xtridelink_driver/view/ui/dashboard/profile/pages/payment/index.dart';
import 'package:xtridelink_driver/view/ui/dashboard/profile/pages/payment/pages/add_account.dart';
import 'package:xtridelink_driver/view/ui/dashboard/profile/pages/support/index.dart';
import 'package:xtridelink_driver/view/ui/dashboard/wallet/pages/settle_outstanding_success.dart';
import 'package:xtridelink_driver/view/ui/dashboard/wallet/pages/withdrawal_password.dart';
import 'package:xtridelink_driver/view/ui/dashboard/wallet/pages/withdrawal_success.dart';
import '../../../view/ui/auth/signup/standalone/index.dart';
import '../../../view/ui/auth/signup/standalone/verify_mail.dart';
import '../../../view/ui/dashboard/notifications/index.dart';

class CustomRouter {
  CustomRouter._();

  static generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      // AUTH
      case Routes.intro:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const IntroPage());

      case Routes.login:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const LoginPage());

      case Routes.chooseDriverType:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const ChooseDriverTypePage());

      case Routes.signUpAddPhone:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const AddPhoneSignupPage());

      case Routes.verifyMail:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) =>
                VerifyMailPage(verifyType: settings.arguments as VerifyType));

      case Routes.signUp:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const SignupUserFormPage());

      case Routes.forgotPassword:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const ForgotPwdPage());

      case Routes.createNewPwd:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const CreateNewPwdPage());

      case Routes.changePassword:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const ChangePasswordPage());

      case Routes.addMerchantMail:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const AddMerchantMailPage());

      case Routes.createMerchantPwd:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const CreateMerchantPwdPage());

      case Routes.enableBiometrics:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const EnableBiometrics());

      case Routes.completeKYC:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const CompleteKYC());

      case Routes.verifyKYC:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => VerifyKYCPage(
                fromSignUp: (settings.arguments as bool?) ?? false));

      case Routes.addVehicleDetails:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => VehicleDetailsPage(
                fromSignUp: (settings.arguments as bool?) ?? false));

      case Routes.addIdVerification:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => IdVerificationPage(
                fromSignUp: (settings.arguments as bool?) ?? false));

      case Routes.bvnVerification:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => BVNVerificationPage(
                fromSignUp: (settings.arguments as bool?) ?? false));
      case Routes.addressVerification:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => AddressVerificationPage(
                fromSignUp: (settings.arguments as bool?) ?? false));

      case Routes.kycDocumentSubmitted:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => KycDocumentSubmittedPage(
                fromSignUp: (settings.arguments as bool?) ?? false));

      case Routes.setUserLocation:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const SetupUserLocation());

      case Routes.chooseLocation:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const ChooseLocationForSetup());

      //DASHBOARD

      case Routes.base:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const DashboardPage());

      case Routes.orderCompletedSuccess:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => const OrderCompletedSuccessPage());

      case Routes.withdrawalPassword:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => WithdrawalPasswordPage(
                withdrawDet: settings.arguments as WithdrawalDet));

      case Routes.withdrawalSuccess:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) =>
                WithdrawalSuccessPage(amount: settings.arguments as num));

      case Routes.settleOutstandingSuccess:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) =>
                SettleOutstandingSuccess(amount: settings.arguments as num));

      case Routes.editProfile:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const EditProfilePage());

      case Routes.editAddress:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const EditAddressPage());

      case Routes.addCard:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const AddPaymentCardPage());

      case Routes.faq:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const FaqPage());

      case Routes.legal:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) =>
                LegalPage(docsType: settings.arguments as XtridelinkDocsType));

      case Routes.support:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const SupportPage());

      case Routes.addBankAccount:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const AddBankAccountPage());

      case Routes.notifications:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const NotificationsPage());
    }
  }
}
