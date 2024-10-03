import 'package:flutter/material.dart';
import 'package:flutter_chat_app/services/firebase_dervices.dart';
import 'package:flutter_chat_app/services/navigatorServices.dart';
import 'package:flutter_chat_app/widgets/customInputFields.dart';
import 'package:flutter_chat_app/widgets/rounded_button.dart';
import 'package:get_it/get_it.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _loginPage();
  }
}

final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

String? _email;
String? _password;
late double deviceHeight, deviceWidth;
NavigatorServices _navagation = GetIt.instance.get<NavigatorServices>();
// FireBaseService? _fireBaseService;

class _loginPage extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    // _fireBaseService = GetIt.instance.get<FireBaseService>();
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Container(
          height: deviceHeight * 0.7,
          padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.1),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                _titleText(),
                _loginFormField(),
                _loginBtn(),
                _registerPageLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginFormField() {
    return SizedBox(
      height: deviceHeight * 0.2,
      child: Form(
        key: _loginFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomInputField(
              onSaved: (value) {
                setState(
                  () {
                    _email = value;
                  },
                );
              },
              regEx:
                  r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$",
              hintText: 'email...',
              obscureText: false,
            ),
            CustomInputField(
              onSaved: (value) {
                setState(
                  () {
                    _password = value;
                  },
                );
              },
              regEx: r'{.8,}',
              hintText: "password...",
              obscureText: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _titleText() {
    return const Text(
      'Chat-App',
      style: TextStyle(
        color: Colors.white,
        fontSize: 35,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _loginBtn() {
    return RoundedButton(
      name: 'Login',
      height: deviceHeight * 0.065,
      width: deviceWidth * 0.65,
      onPressed: _loginUser,
    );
  }

  Widget _registerPageLink() {
    return GestureDetector(
      onTap: () => _navagation.navigateToRoute('register'),
      child: const Text(
        'don\'t have an account ?',
        style: TextStyle(
          color: Colors.blue,
        ),
      ),
    );
  }

  void _loginUser() async {
    // if (_loginFormKey.currentState!.validate()) {
    //   _loginFormKey.currentState!.save();
    //   bool _result = await _fireBaseService!
    //       .LoginUser(email: _email!, password: _password!);
    //   if (_result) Navigator.popAndPushNamed(context, 'home');
    // }
  }
}
