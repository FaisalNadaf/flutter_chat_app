import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/services/firebase_dervices.dart';
import 'package:flutter_chat_app/widgets/customInputFields.dart';
import 'package:flutter_chat_app/widgets/rounded_button.dart';
import 'package:get_it/get_it.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
String? _email;
String? _password;
String? _name;
File? _image;
late double deviceHeight, deviceWidth;

FireBaseService? _fireBaseService;

class _RegisterPageState extends State<RegisterPage> {
  @override
  void initState() {
    super.initState();
    _fireBaseService = GetIt.instance.get<FireBaseService>();
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.1),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              _titleText(),
              _imageField(),
              _registerFormField(),
              _registerBtn(),
              _loginPageLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageField() {
    return GestureDetector(
      onTap: () async {
        FilePickerResult? result =
            await FilePicker.platform.pickFiles(type: FileType.image);
        if (result != null && result.files.isNotEmpty) {
          setState(() {
            _image = File(result.files.first.path!);
          });
        }
      },
      child: Container(
        height: deviceHeight * 0.16,
        width: deviceWidth * 0.325,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: _image != null
                ? FileImage(_image!)
                : const NetworkImage("https://avatar.iran.liara.run/public/boy")
                    as ImageProvider,
          ),
        ),
      ),
    );
  }

  Widget _registerFormField() {
    return SizedBox(
      height: deviceHeight * 0.3,
      child: Form(
        key: _registerFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomInputField(
              onSaved: (value) => _name = value.trim(),
              regEx: '',
              hintText: 'name...',
              obscureText: false,
            ),
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
        color: Colors.black,
        fontSize: 35,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _registerBtn() {
    return RoundedButton(
      name: 'Login',
      height: deviceHeight * 0.065,
      width: deviceWidth * 0.65,
      onPressed: _registerUser,
    );
  }

  void _registerUser() async {
    if (_registerFormKey.currentState!.validate() && _image != null) {
      _registerFormKey.currentState!.save();
      bool result = await _fireBaseService!.registerUser(
        name: _name!,
        email: _email!,
        password: _password!,
        image: _image!,
      );
      print(result);
      print('Registered');
      if (result) {
        Navigator.popAndPushNamed(context, 'home');
      }
    }
  }

  // bool _isLoading = false; // Add a loading state variable

  // Widget _registerBtn() {
  //   return MaterialButton(
  //     color: Colors.red,
  //     onPressed: _isLoading ? null : _registerUser, // Disable if loading
  //     child: _isLoading
  // ? CircularProgressIndicator(
  //             valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
  //           )
  //         : const Text(
  //             'Register',
  //             style: TextStyle(
  //               color: Colors.white,
  //               fontSize: 20,
  //             ),
  //           ),
  //   );
  // }

  // void _registerUser() async {
  //   if (_registerFormKey.currentState!.validate() && _image != null) {
  //     setState(() {
  //       _isLoading = true; // Show loading spinner
  //     });

  //     _registerFormKey.currentState!.save();

  //     try {
  //       bool _result = await _fireBaseService!.registerUser(
  //         name: _name!,
  //         email: _email!,
  //         password: _password!,
  //         image: _image!,
  //       );

  //       if (_result) {
  //         Navigator.pop(context); // Navigate back after successful registration
  //       } else {
  //         _showErrorDialog("Registration failed. Please try again.");
  //       }
  //     } catch (e) {
  //       _showErrorDialog("An error occurred: $e");
  //     } finally {
  //       setState(() {
  //         _isLoading = false; // Hide loading spinner
  //       });
  //     }
  //   } else if (_image == null) {
  //     _showErrorDialog("Please upload a profile image.");
  //   }
  // }

  // void _showErrorDialog(String message) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text("Error"),
  //       content: Text(message),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text("OK"),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _loginPageLink() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: const Text(
        'Already have an account?',
        style: TextStyle(
          color: Colors.blue,
        ),
      ),
    );
  }
}
