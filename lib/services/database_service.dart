//Packages
import 'package:cloud_firestore/cloud_firestore.dart';

//Models
import '../models/chat_message.dart';

const String USER_COLLECTION = "Users";
const String CHAT_COLLECTION = "Chats";
const String MESSAGES_COLLECTION = "messages";

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DatabaseService();

  Future<void> createUser(
      String uid, String email, String name, String imageURL) async {
    try {
      await _db.collection(USER_COLLECTION).doc(uid).set(
        {
          "email": email,
          "image": imageURL,
          "last_active": DateTime.now().toUtc(),
          "name": name,
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future<DocumentSnapshot> getUser(String uid) {
    return _db.collection(USER_COLLECTION).doc(uid).get();
  }

  Future<QuerySnapshot> getUsers({String? name}) {
    Query query = _db.collection(USER_COLLECTION);
    if (name != null) {
      query = query
          .where("name", isGreaterThanOrEqualTo: name)
          .where("name", isLessThanOrEqualTo: "${name}z");
    }
    return query.get();
  }

  Stream<QuerySnapshot> getChatsForUser(String uid) {
    return _db
        .collection(CHAT_COLLECTION)
        .where('members', arrayContains: uid)
        .snapshots();
  }

  Future<QuerySnapshot> getLastMessageForChat(String chatID) {
    return _db
        .collection(CHAT_COLLECTION)
        .doc(chatID)
        .collection(MESSAGES_COLLECTION)
        .orderBy("sent_time", descending: true)
        .limit(1)
        .get();
  }

  Stream<QuerySnapshot> streamMessagesForChat(String chatID) {
    return _db
        .collection(CHAT_COLLECTION)
        .doc(chatID)
        .collection(MESSAGES_COLLECTION)
        .orderBy("sent_time", descending: false)
        .snapshots();
  }

  Future<void> addMessageToChat(String chatID, ChatMessage message) async {
    try {
      await _db
          .collection(CHAT_COLLECTION)
          .doc(chatID)
          .collection(MESSAGES_COLLECTION)
          .add(
            message.toJson(),
          );
    } catch (e) {
      print(e);
    }
  }

  // Future<void> updateChatData(
  //     String _chatID, Map<String, dynamic> _data) async {
  //   try {
  //     await _db.collection(CHAT_COLLECTION).doc(_chatID).update(_data);
  //   } catch (e) {
  //     print(e);
  //   }
  // }


Future<void> updateChatData(String chatID, Map<String, dynamic> data) async {
  try {
    // Check if the document exists
    DocumentSnapshot chatDoc = await _db.collection(CHAT_COLLECTION).doc(chatID).get();

    if (chatDoc.exists) {
      // Document exists, perform the update
      await _db.collection(CHAT_COLLECTION).doc(chatID).update(data);
      print('Updated chat data for chat ID $chatID');
    } else {
      // Document doesn't exist, handle it (create or log)
      print('Document with chat ID $chatID does not exist. Consider creating it.');
      // Optionally, create the document if it doesn’t exist
      await _db.collection(CHAT_COLLECTION).doc(chatID).set(data);
      print('Created new chat document for chat ID $chatID');
    }
  } catch (e) {
    print('Error updating chat data for chat ID $chatID: $e');
  }
}

Future<void> updateUserLastSeenTime(String uid) async {
  try {
    // Check if the document exists
    DocumentSnapshot userDoc = await _db.collection(USER_COLLECTION).doc(uid).get();

    if (userDoc.exists) {
      // Document exists, perform the update
      await _db.collection(USER_COLLECTION).doc(uid).update({
        "last_active": DateTime.now().toUtc(),
      });
    } else {
      // Document doesn't exist, handle it (create or log)
      print('Document with ID $uid does not exist. Consider creating it.');
      // Optionally, create the document if it doesn’t exist
      await _db.collection(USER_COLLECTION).doc(uid).set({
        "last_active": DateTime.now().toUtc(),
      });
    }
  } catch (e) {
    print(e);
  }
}
                     
  // Future<void> updateUserLastSeenTime(String _uid) async {
  //   try {
  //     await _db.collection(USER_COLLECTION).doc(_uid).update(
  //       {
  //         "last_active": DateTime.now().toUtc(),
  //       },
  //     );
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future<void> deleteChat(String chatID) async {
    try {
      await _db.collection(CHAT_COLLECTION).doc(chatID).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<DocumentReference?> createChat(Map<String, dynamic> data) async {
    try {
      DocumentReference chat =
          await _db.collection(CHAT_COLLECTION).add(data);
      return chat;
    } catch (e) {
      print(e);
    }
    return null;
  }
}
