import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/services/database_service.dart';
import 'package:flutter_chat_app/services/navigation_service.dart';
import 'package:get_it/get_it.dart';
import 'dart:developer' as developer;

import '../models/chat_user.dart';

class AuthenticationProvider extends ChangeNotifier {
  late final FirebaseAuth _auth;
  late final NavigationService _navigationService;
  late final DatabaseService _databaseService;

  late ChatUser user;

  // AuthenticationProvider() {
  //   _auth = FirebaseAuth.instance;
  //   _navigationService = GetIt.instance.get<NavigationService>();
  //   _databaseService = GetIt.instance.get<DatabaseService>();

  //   _auth.authStateChanges().listen((_user) {
  //     if (_user != null) {
  //       _databaseService.updateUserLastSeenTime(_user.uid);
  //       _databaseService.getUser(_user.uid).then(
  //         (_snapshot) {
  //           Map<String, dynamic> _userData =
  //               _snapshot.data()! as Map<String, dynamic>;
  //           print('chatUSer in auth controler ::: $_userData');
  //           user = ChatUser.fromJSON(
  //             {
  //               "uid": _user.uid,
  //               "name": _userData["name"],
  //               "email": _userData["email"],
  //               "last_active": _userData["last_active"],
  //               "image": _userData["image"],
  //             },
  //           );
  //           _navigationService.removeAndNavigateToRoute('/home');
  //         },
  //       );
  //     } else {
  //       if (_navigationService.getCurrentRoute() != '/login') {
  //         _navigationService.removeAndNavigateToRoute('/login');
  //       }
  //     }
  //   });
  // }

  AuthenticationProvider() {
    _auth = FirebaseAuth.instance;
    _navigationService = GetIt.instance.get<NavigationService>();
    _databaseService = GetIt.instance.get<DatabaseService>();

    _auth.authStateChanges().listen((_user) {
      if (_user != null) {
        _databaseService.updateUserLastSeenTime(_user.uid);
        _databaseService.getUser(_user.uid).then(
          (_snapshot) {
            if (_snapshot.data() != null) {
              Map<String, dynamic>? _userData =
                  _snapshot.data() as Map<String, dynamic>?;
              if (_userData != null) {
                // developer.log(
                //     "\x1B[32m chatUSer in auth controler ::: $_userData \x1B[0m");
                // print('');
                user = ChatUser.fromJSON({
                  "uid": _user.uid,
                  "name": _userData["name"],
                  "email": _userData["email"],
                  "last_active": _userData["last_active"],
                  "image": _userData["image"],
                });
                _navigationService.removeAndNavigateToRoute('/home');
              }
            } else {
              // Handle null snapshot data case
              print('User data snapshot is null.');
            }
          },
        );
      } else {
        if (_navigationService.getCurrentRoute() != '/login') {
          _navigationService.removeAndNavigateToRoute('/login');
        }
      }
    });
  }

  Future<void> loginUsingEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException {
      print("Error logging user into Firebase");
    } catch (e) {
      print(e);
    }
  }

  Future<String?> registerUserUsingEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credentials = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credentials.user!.uid;
    } on FirebaseAuthException {
      print("Error registering user.");
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e);
    }
  }
}
