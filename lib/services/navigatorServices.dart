import 'package:flutter/material.dart';

class NavigatorServices {
  static GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  void removeAndNavigateToRoute(String route) {
    navigatorKey.currentState?.popAndPushNamed(route);
  }

  void navigateToRoute(String route) {
    navigatorKey.currentState?.pushNamed(route);
  }

  void navigateToPagee(Widget page) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return page;
        },
      ),
    );
  }

  void goBack(String route) {
    navigatorKey.currentState?.pop();
  }
}
