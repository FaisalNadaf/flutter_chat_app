// import '../models/chat_user.dart';
// import '../models/chat_message.dart';

// class Chat {
//   final String uid;
//   final String currentUserUid;
//   final bool activity;
//   final bool group;
//   final List<ChatUser> members;
//   List<ChatMessage> messages;

//   late final List<ChatUser> _recepients;

//   Chat({
//     required this.uid,
//     required this.currentUserUid,
//     required this.members,
//     required this.messages,
//     required this.activity,
//     required this.group,
//   }) {
//     _recepients = members.where((i) => i.uid != currentUserUid).toList();
//   }

//   List<ChatUser> recepients() {
//     return _recepients;
//   }

//   String title() {
//     return !group
//         ? _recepients.first.name
//         : _recepients.map((user) => user.name).join(", ");
//   }

//   String imageURL() {
//     return !group
//         ? _recepients.first.imageURL
//         : "https://firebasestorage.googleapis.com/v0/b/flutter-chat-app-2c942.appspot.com/o/groupChatIcon.png?alt=media&token=6e42ff52-bd52-45ca-a211-2b6df0ce691d";
//   }
// }
import '../models/chat_user.dart';
import '../models/chat_message.dart';

class Chat {
  final String uid;
  final String currentUserUid;
  final bool activity;
  final bool group;
  final List<ChatUser> members;
  List<ChatMessage> messages;

  late final List<ChatUser> _recipients;

  Chat({
    required this.uid,
    required this.currentUserUid,
    required this.members,
    required this.messages,
    required this.activity,
    required this.group,
  }) {
    _recipients = members.where((i) => i.uid != currentUserUid).toList();
  }

  // Corrected method name to recipients()
  List<ChatUser> recipients() {
    return _recipients;
  }

  String title() {
    return !group
        ? _recipients.first.name
        : _recipients.map((user) => user.name).join(", ");
  }

  String imageURL() {
    return !group
        ? _recipients.first.imageURL
        : "https://firebasestorage.googleapis.com/v0/b/flutter-chat-app-2c942.appspot.com/o/team.png?alt=media&token=cb3cd686-bd1b-4f5f-a9cc-28ce5b850714";
  }
}
