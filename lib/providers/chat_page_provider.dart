// import 'dart:async';
// import 'dart:developer' as developer;

// //Packages
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:get_it/get_it.dart';
// import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

// //Services
// import '../services/database_service.dart';
// import '../services/cloud_storage_service.dart';
// import '../services/media_service.dart';
// import '../services/navigation_service.dart';

// //Providers
// import '../providers/authentication_provider.dart';

// //Models
// import '../models/chat_message.dart';

// class ChatPageProvider extends ChangeNotifier {
//   late DatabaseService _db;
//   late CloudStorageService _storage;
//   late MediaService _media;
//   late NavigationService _navigation;

//   final AuthenticationProvider _auth;
//   final ScrollController _messagesListViewController;

//   final String _chatId;
//   List<ChatMessage>? messages;

//   late StreamSubscription _messagesStream;
//   late StreamSubscription _keyboardVisibilityStream;
//   late KeyboardVisibilityController _keyboardVisibilityController;

//   String? _message;

//   String get message {
//     return message;
//   }

//   set message(String value) {
//     _message = value;
//   }

//   ChatPageProvider(this._chatId, this._auth, this._messagesListViewController) {
//     _db = GetIt.instance.get<DatabaseService>();
//     _storage = GetIt.instance.get<CloudStorageService>();
//     _media = GetIt.instance.get<MediaService>();
//     _navigation = GetIt.instance.get<NavigationService>();
//     _keyboardVisibilityController = KeyboardVisibilityController();
//     listenToMessages();
//     listenToKeyboardChanges();
//   }

//   @override
//   void dispose() {
//     _messagesStream.cancel();
//     super.dispose();
//   }

//   void listenToMessages() {
//     developer.log(
//         "\x1B[32m messages in chat_page_provider line 75 $messages \x1B[0m");

//     try {
//       _messagesStream = _db.streamMessagesForChat(_chatId).listen(
//         (snapshot) {
//           List<ChatMessage> messages = snapshot.docs.map(
//             (m) {
//               Map<String, dynamic> messageData =
//                   m.data() as Map<String, dynamic>;
//               return ChatMessage.fromJSON(messageData);
//             },
//           ).toList();
//           messages = messages;
//           notifyListeners();
//           WidgetsBinding.instance.addPostFrameCallback(
//             (_) {
//               if (_messagesListViewController.hasClients) {
//                 _messagesListViewController.jumpTo(
//                     _messagesListViewController.position.maxScrollExtent);
//               }
//             },
//           );
//         },
//       );
//     } catch (e) {
//       print("Error getting messages.");
//       print(e);
//     }
//   }

//   void listenToKeyboardChanges() {
//     _keyboardVisibilityStream = _keyboardVisibilityController.onChange.listen(
//       (event) {
//         _db.updateChatData(_chatId, {"is_activity": event});
//       },
//     );
//   }

//   void sendTextMessage() {
//     if (_message != null) {
//       ChatMessage messageToSend = ChatMessage(
//         content: _message!,
//         type: MessageType.TEXT,
//         senderID: _auth.user.uid,
//         sentTime: DateTime.now(),
//       );
//       _db.addMessageToChat(_chatId, messageToSend);
//     }
//   }

//   void sendImageMessage() async {
//     try {
//       PlatformFile? file = await _media.pickImageFromLibrary();
//       if (file != null) {
//         String? downloadURL = await _storage.saveChatImageToStorage(
//             _chatId, _auth.user.uid, file);
//         ChatMessage messageToSend = ChatMessage(
//           content: downloadURL!,
//           type: MessageType.IMAGE,
//           senderID: _auth.user.uid,
//           sentTime: DateTime.now(),
//         );
//         _db.addMessageToChat(_chatId, messageToSend);
//       }
//     } catch (e) {
//       print("Error sending image message.");
//       print(e);
//     }
//   }

//   void deleteChat() {
//     goBack();
//     _db.deleteChat(_chatId);
//   }

//   void goBack() {
//     _navigation.goBack();
//   }
// }

import 'dart:async';
import 'dart:developer' as developer;

// Packages
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

// Services
import '../services/database_service.dart';
import '../services/cloud_storage_service.dart';
import '../services/media_service.dart';
import '../services/navigation_service.dart';

// Providers
import '../providers/authentication_provider.dart';

// Models
import '../models/chat_message.dart';

class ChatPageProvider extends ChangeNotifier {
  late DatabaseService _db;
  late CloudStorageService _storage;
  late MediaService _media;
  late NavigationService _navigation;

  final AuthenticationProvider _auth;
  final ScrollController _messagesListViewController;

  final String _chatId;
  List<ChatMessage>? messages;

  late StreamSubscription _messagesStream;
  late StreamSubscription _keyboardVisibilityStream;
  late KeyboardVisibilityController _keyboardVisibilityController;

  String? _message;

  String get message => _message ?? ''; // Fixed getter

  set message(String value) {
    _message = value;
  }

  ChatPageProvider(this._chatId, this._auth, this._messagesListViewController) {
    _db = GetIt.instance.get<DatabaseService>();
    _storage = GetIt.instance.get<CloudStorageService>();
    _media = GetIt.instance.get<MediaService>();
    _navigation = GetIt.instance.get<NavigationService>();
    _keyboardVisibilityController = KeyboardVisibilityController();
    listenToMessages();
    listenToKeyboardChanges();
  }

  @override
  void dispose() {
    _messagesStream.cancel();
    _keyboardVisibilityStream.cancel(); // Cancel the keyboard listener
    super.dispose();
  }

  void listenToMessages() {
    developer.log(
        "\x1B[32m messages in chat_page_provider line 75 $messages \x1B[0m");

    try {
      _messagesStream = _db.streamMessagesForChat(_chatId).listen(
        (snapshot) {
          messages = snapshot.docs.map((m) {
            Map<String, dynamic> messageData = m.data() as Map<String, dynamic>;
            return ChatMessage.fromJSON(messageData);
          }).toList();
          notifyListeners();
          WidgetsBinding.instance.addPostFrameCallback(
            (_) {
              if (_messagesListViewController.hasClients) {
                _messagesListViewController.jumpTo(
                    _messagesListViewController.position.maxScrollExtent);
              }
            },
          );
        },
      );
    } catch (e) {
      print("Error getting messages: $e");
      // Optionally, show a user-friendly message
    }
  }

  void listenToKeyboardChanges() {
    _keyboardVisibilityStream = _keyboardVisibilityController.onChange.listen(
      (event) {
        _db.updateChatData(_chatId, {"is_activity": event});
      },
    );
  }

  void sendTextMessage() {
    if (_message != null && _message!.trim().isNotEmpty) {
      // Added check for empty message
      ChatMessage messageToSend = ChatMessage(
        content: _message!,
        type: MessageType.TEXT,
        senderID: _auth.user.uid,
        sentTime: DateTime.now(),
      );
      _db.addMessageToChat(_chatId, messageToSend);
      _message = ''; // Clear the message after sending
      notifyListeners(); // Notify listeners to update the UI if needed
    }
  }

  void sendImageMessage() async {
    try {
      PlatformFile? file = await _media.pickImageFromLibrary();
      if (file != null) {
        String? downloadURL = await _storage.saveChatImageToStorage(
            _chatId, _auth.user.uid, file);
        ChatMessage messageToSend = ChatMessage(
          content: downloadURL!,
          type: MessageType.IMAGE,
          senderID: _auth.user.uid,
          sentTime: DateTime.now(),
        );
        _db.addMessageToChat(_chatId, messageToSend);
      }
    } catch (e) {
      print("Error sending image message: $e");
      // Optionally, show a user-friendly message
    }
  }

  void deleteChat() {
    goBack();
    _db.deleteChat(_chatId);
  }

  void goBack() {
    _navigation.goBack();
  }
}
