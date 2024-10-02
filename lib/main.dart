import 'package:flutter/material.dart';
import 'package:flutter_chat_app/pages/loginPage.dart';
import 'package:flutter_chat_app/pages/registerPage.dart';
import 'package:flutter_chat_app/pages/splashPage.dart';
import 'package:flutter_chat_app/services/navigatorServices.dart';

void main() {
  runApp(
    Splashpage(
      key: UniqueKey(),
      appInitilation: () {
        runApp(
          MyApp(),
        );
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'chat_app',
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromRGBO(36, 35, 49, 1),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Color.fromRGBO(30, 29, 37, 1),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromRGBO(36, 35, 49, 1),
        ),
        useMaterial3: true,
      ),
      navigatorKey: NavigatorServices.navigatorKey,
      initialRoute: '/login',
      routes: {
        '/login': (BuildContext _cotext) => LoginPage(),
        '/register': (BuildContext _context) => RegisterPage(),
      },
    );
  }
}
