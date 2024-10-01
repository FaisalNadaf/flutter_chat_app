import 'package:flutter/material.dart';

class NavigatorServices {
  static GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  void removeAndNavigateToRoute(String _route) {
    navigatorKey.currentState?.popAndPushNamed(_route);
  }

  void navigateToRoute(String _route) {
    navigatorKey.currentState?.pushNamed(_route);
  }

  void navigateToPagee(Widget _page) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (BuildContext _context) {
          return _page;
        },
      ),
    );
  }

  void goBack(String _route) {
    navigatorKey.currentState?.pop();
  }
}
