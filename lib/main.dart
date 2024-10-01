import 'package:flutter/material.dart';
import 'package:flutter_chat_app/pages/splashPage.dart';

void main() {
  runApp(
    const MyApp(),
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromRGBO(36, 35, 49, 1),
        ),
        useMaterial3: true,
      ),
      home: Splashpage(appInitilation: () {}),
    );
  }
}
