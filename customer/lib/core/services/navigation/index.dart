import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../injector.dart';

abstract class NavigationService {
  Future<dynamic> navigateTo(String routeName, {dynamic arguments});
  Future<dynamic> replaceWith(String routeName, {dynamic arguments});
  void pop({dynamic v});
  void maybePop({dynamic v});
  void popUntil(String routeName);
  Future<dynamic> replaceUntil(
      {required String routeName,
      required String lastRouteName,
      dynamic arguments});
}

@LazySingleton()
class NavigationServiceImpl extends NavigationService {
  final GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigationKey => _navigationKey;
  @override
  void pop({dynamic v = false}) {
    return _navigationKey.currentState!.pop(v);
  }

  @override
  Future<bool> maybePop({dynamic v = false}) async {
    return _navigationKey.currentState!.maybePop(v);
  }

  @override
  Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
    return _navigationKey.currentState!
        .pushNamed(routeName, arguments: arguments);
  }

  @override
  Future<dynamic> replaceWith(String routeName, {dynamic arguments}) {
    return _navigationKey.currentState!
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  @override
  Future replaceUntil(
      {required String routeName, String? lastRouteName, dynamic arguments}) {
    return Navigator.of(_navigationKey.currentContext!).pushNamedAndRemoveUntil(
        routeName, (Route<dynamic> route) => false,
        arguments: arguments);
  }

  @override
  void popUntil(String routeName) {
    return _navigationKey.currentState!
        .popUntil(ModalRoute.withName(routeName));
  }
}

BuildContext get buildContext =>
    getIt<NavigationServiceImpl>().navigationKey.currentContext!;

void globalNavigateTo({required String route, dynamic arguments}) =>
    getIt<NavigationServiceImpl>().navigateTo(route, arguments: arguments);

void globalReplaceWith({required String route, dynamic arguments}) =>
    getIt<NavigationServiceImpl>().replaceWith(route, arguments: arguments);

void globalReplaceUntil({required route, dynamic arguments}) =>
    getIt<NavigationServiceImpl>()
        .replaceUntil(routeName: route, arguments: arguments);

void globalPopUntil(route) => getIt<NavigationServiceImpl>().popUntil(route);

void globalPop() => getIt<NavigationServiceImpl>().pop();

void globalMaybePop() => getIt<NavigationServiceImpl>().maybePop();
