import 'package:flutter/material.dart';
import 'package:xtridelink/core/constants/enumerations.dart';
import 'package:xtridelink/core/services/navigation/routes.dart';
import 'package:xtridelink/data/source/remote/model/order/create_order_response.dart';
import 'package:xtridelink/data/source/remote/model/order/payment_account_response/data.dart';
import 'package:xtridelink/domain/model/api/puller_bank.dart';
import 'package:xtridelink/domain/params/order/order_params.dart';
import 'package:xtridelink/view/ui/auth/forgot_pwd/create_password.dart';
import 'package:xtridelink/view/ui/auth/forgot_pwd/forgot_password.dart';
import 'package:xtridelink/view/ui/auth/intro/index.dart';
import 'package:xtridelink/view/ui/auth/login/index.dart';
import 'package:xtridelink/view/ui/auth/post_signup/biometrics.dart';
import 'package:xtridelink/view/ui/auth/post_signup/choose_location.dart';
import 'package:xtridelink/view/ui/auth/post_signup/location.dart';
import 'package:xtridelink/view/ui/auth/signup/initiate_signup_screen.dart';
import 'package:xtridelink/view/ui/auth/signup/signup_screen.dart';
import 'package:xtridelink/view/ui/auth/signup/signup_verify_phone_screen.dart';
import 'package:xtridelink/view/ui/dashboard/index.dart';
import 'package:xtridelink/view/ui/dashboard/notifications/index.dart';
import 'package:xtridelink/view/ui/dashboard/order/pages/awaiting_driver_accept.dart';
import 'package:xtridelink/view/ui/dashboard/order/pages/offer_rejected.dart';
import 'package:xtridelink/view/ui/dashboard/order/pages/order_cancelled.dart';
import 'package:xtridelink/view/ui/dashboard/order/pages/order_details.dart';
import 'package:xtridelink/view/ui/dashboard/order/pages/order_sucess.dart';
import 'package:xtridelink/view/ui/dashboard/order/pages/order_timeline/index.dart';
import 'package:xtridelink/view/ui/dashboard/order/pages/package_delivered.dart';
import 'package:xtridelink/view/ui/dashboard/order/pages/payment/confirm_payment.dart';
import 'package:xtridelink/view/ui/dashboard/order/pages/payment/online_payment.dart';
import 'package:xtridelink/view/ui/dashboard/order/pages/recipient_details.dart';
import 'package:xtridelink/view/ui/dashboard/order/pages/select_driver.dart';
import 'package:xtridelink/view/ui/dashboard/profile/pages/address/index.dart';
import 'package:xtridelink/view/ui/dashboard/profile/pages/change_password/index.dart';
import 'package:xtridelink/view/ui/dashboard/profile/pages/edit_profile/index.dart';
import 'package:xtridelink/view/ui/dashboard/profile/pages/payment/index.dart';

import '../../../domain/model/api/order_det.dart';
import '../../../view/ui/dashboard/profile/pages/faq/index.dart';
import '../../../view/ui/dashboard/profile/pages/legal/index.dart';
import '../../../view/ui/dashboard/profile/pages/support/index.dart';

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

      case Routes.initiateSignUp:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const InitiateSignUpPage());

      case Routes.signUpVerifyPhone:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => SignUpVerifyPhonePage(
                  phoneNumber: settings.arguments as String,
                ));

      case Routes.signUp:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => SignupUserFormPage(
                  phoneNumber: settings.arguments as String,
                ));

      case Routes.forgotPassword:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const ForgotPwdPage());

      case Routes.createNewPwd:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const CreateNewPwdPage());

      case Routes.enableBiometrics:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const EnableBiometrics());

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

      case Routes.provideOrderDet:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => ProvideOrderDetPage(
                orderRouteInfo: settings.arguments as PackageOrderParam));

      case Routes.recipientDet:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) =>
                ProvideRecipientDet(order: settings.arguments as OrderParams));

      case Routes.selectDriver:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const SelectDriverPage());

      case Routes.orderPlacedSuccess:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => const OrderPlacementSuccessPage());

      case Routes.offerPlacedAccepted:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => const OfferPlacementAcceptedPage());

      case Routes.offerPlacedRejected:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => const OfferPlacementRejectedPage());

      case Routes.onlinePayment:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) =>
                OnlinePaymentPage(bank: settings.arguments as PaymentAccount));

      case Routes.confirmPayment:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const ConfirmPaymentPage());

      case Routes.orderCancelled:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const OrderCancelledPage());

      case Routes.awaitingDriverAccept:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => AwaitingDriverAcceptPage(
                createOfferReqData: settings.arguments as CreateOfferReqData));

      case Routes.timeline:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) =>
                OrderTimelinePage(orderId: settings.arguments as String));

      case Routes.packageDelivered:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => OrderPackageDeliveredPage(
                orderTrackData: settings.arguments as OrderTrackData));

      case Routes.editProfile:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const EditProfilePage());

      case Routes.changePassword:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const ChangePasswordPage());

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

      case Routes.notifications:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const NotificationsPage());
    }
  }
}
