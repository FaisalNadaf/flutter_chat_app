import 'dart:async';

//Packages
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Services
import '../services/database_service.dart';

//Providers
import '../providers/authentication_provider.dart';

//Models
import '../models/chat.dart';
import '../models/chat_message.dart';
import '../models/chat_user.dart';

class ChatsPageProvider extends ChangeNotifier {
  final AuthenticationProvider _auth;

  late DatabaseService _db;

  List<Chat>? chats;

  late StreamSubscription _chatsStream;

  ChatsPageProvider(this._auth) {
    _db = GetIt.instance.get<DatabaseService>();
    getChats();
  }

  @override
  void dispose() {
    _chatsStream.cancel();
    super.dispose();
  }

  void getChats() async {
    try {
      _chatsStream =
          _db.getChatsForUser(_auth.user.uid).listen((snapshot) async {
        chats = await Future.wait(
          snapshot.docs.map(
            (d) async {
              Map<String, dynamic> chatData =
                  d.data() as Map<String, dynamic>;
              //Get Users In Chat
              List<ChatUser> members = [];
              for (var _uid in chatData["members"]) {
                DocumentSnapshot userSnapshot = await _db.getUser(_uid);
                Map<String, dynamic> userData =
                    userSnapshot.data() as Map<String, dynamic>;
                userData["uid"] = userSnapshot.id;
                members.add(
                  ChatUser.fromJSON(userData),
                );
              }
              //Get Last Message For Chat
              List<ChatMessage> messages = [];
              QuerySnapshot chatMessage =
                  await _db.getLastMessageForChat(d.id);
              if (chatMessage.docs.isNotEmpty) {
                Map<String, dynamic> messageData =
                    chatMessage.docs.first.data()! as Map<String, dynamic>;
                ChatMessage message = ChatMessage.fromJSON(messageData);
                messages.add(message);
              }
              //Return Chat Instance
              return Chat(
                uid: d.id,
                currentUserUid: _auth.user.uid,
                members: members,
                messages: messages,
                activity: chatData["is_activity"],
                group: chatData["is_group"],
              );
            },
          ).toList(),
        );
        notifyListeners();
      });
    } catch (e) {
      print("Error getting chats.");
      print(e);
    }
  }
}
