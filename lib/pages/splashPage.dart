import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/services/navigatorServices.dart';
import 'package:get_it/get_it.dart';

class Splashpage extends StatefulWidget {
  final VoidCallback appInitilation;
  // ignore: use_super_parameters
  const Splashpage({super.key, required this.appInitilation});

  @override
  State<Splashpage> createState() => _SplashpageState();
}

class _SplashpageState extends State<Splashpage> {
  @override
  void initState() {
    super.initState();
    _setUpInitilation().then(
      (_) => widget.appInitilation(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat-App',
      theme: ThemeData(
        colorSchemeSeed: Color.fromRGBO(36, 35, 49, 1),
        dialogBackgroundColor: Color.fromRGBO(36, 35, 49, 1),
        scaffoldBackgroundColor: Color.fromRGBO(36, 35, 49, 1),
      ),
      home: Scaffold(
        body: Center(
          child: Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.contain,
                image: AssetImage(
                  'assets/images/logo.png',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _setUpInitilation() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    _registerAppServices();
  }

  void _registerAppServices() {
    GetIt.instance.registerSingleton<NavigatorServices>(
      NavigatorServices(),
    );
  }
}
