import 'package:flutter/material.dart';

import '../../../di/get_it.dart';
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

class NavigationServiceImpl extends NavigationService {
  final GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigationKey => _navigationKey;
  @override
  void pop({dynamic v = false}) {
    return _navigationKey.currentState!.pop(v);
  }

  @override
  Future<bool> maybePop({dynamic v = false}) async{
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
      {required String routeName,
        String? lastRouteName,
        dynamic arguments}) {
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
      getItInst<NavigationServiceImpl>().navigationKey.currentContext!;

  void globalNavigateTo({required String route, dynamic arguments}) =>
      getItInst<NavigationServiceImpl>()
          .navigateTo(route, arguments: arguments);

  void globalReplaceWith({required String route, dynamic arguments}) =>
      getItInst<NavigationServiceImpl>()
          .replaceWith(route, arguments: arguments);

  void globalReplaceUntil({required route, dynamic arguments}) =>
      getItInst<NavigationServiceImpl>().replaceUntil(routeName: route, arguments: arguments);

  void globalPopUntil(route) =>
      getItInst<NavigationServiceImpl>().popUntil(route);

  void globalPop() =>
      getItInst<NavigationServiceImpl>().pop();

  void globalMaybePop() =>
      getItInst<NavigationServiceImpl>().maybePop();