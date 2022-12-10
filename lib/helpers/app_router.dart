import 'package:flutter/material.dart';

class AppRouter {
  AppRouter._();
  static AppRouter route = AppRouter._();
  GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

  void pushNamed(String routeName, Map<String, dynamic>? arguments) {
    navKey.currentState!.pushNamed(routeName, arguments: arguments!);
  }

  void replacmentRoute(String routeName) {
    navKey.currentState!.pushReplacementNamed(routeName);
  }

  void replacmentRouteWithArgs(String routeName, Object args) {
    navKey.currentState!.pushReplacementNamed(routeName, arguments: args);
  }

  void back() {
    navKey.currentState!.pop();
  }

  void removeUntilNamed(String routeName) {
    navKey.currentState!
        .pushNamedAndRemoveUntil(routeName, (Route<dynamic> route) => false);
  }

  void removeUntilScreen(Widget screen) {
    navKey.currentState!.pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (BuildContext _) => screen),
        (Route<dynamic> route) => false);
  }
}
