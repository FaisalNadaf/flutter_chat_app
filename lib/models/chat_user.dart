import 'dart:developer' as developer;

class ChatUser {
  final String uid;
  final String name;
  final String email;
  final String imageURL;
  late DateTime lastActive;

  ChatUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.imageURL,
    required this.lastActive,
  });

  factory ChatUser.fromJSON(Map<String, dynamic> json) {
    // developer.log("\x1B[32m json data from chat_user.dart: $json \x1B[0m");
    return ChatUser(
      uid: json["uid"],
      name: json["name"],
      email: json["email"],
      imageURL: json["image"],
      lastActive: json["last_active"].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "email": email,
      "name": name,
      "last_active": lastActive,
      "image": imageURL,
    };
  }

  String lastDayActive() {
    return "${lastActive.month}/${lastActive.day}/${lastActive.year}";
  }

  bool wasRecentlyActive() {
    return DateTime.now().difference(lastActive).inMinutes < 5;
  }
}
