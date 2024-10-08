import 'dart:io';

// Packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

const String USER_COLLECTION = "Users";

class CloudStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  CloudStorageService();

  Future<String?> saveUserImageToStorage(String uid, PlatformFile file) async {
    try {
      Reference ref =
          _storage.ref().child('images/users/$uid/profile.${file.extension}');
      UploadTask task = ref.putFile(
        File(
          file.path!,
        ),
      );
      return await task.then(
        (result) => result.ref.getDownloadURL(),
      );
    } catch (e) {
      print("Error saving user image: $e");
      return null;
    }
  }

  Future<String?> saveChatImageToStorage(
      String chatID, String userID, PlatformFile file) async {
    if (file.path == null) {
      print("File path is null");
      return null; // Handle the error case appropriately
    }

    try {
      Reference ref = _storage.ref().child(
          'images/chats/$chatID/${userID}_${Timestamp.now().millisecondsSinceEpoch}.${file.extension}');
      UploadTask task = ref.putFile(
        File(
          file.path!,
        ),
      ); // Use the non-nullable path

      // Wait for the upload to complete and get the download URL
      return await task.then((result) => result.ref.getDownloadURL());
    } catch (e) {
      print("Error saving chat image: $e");
      return null; // Handle errors appropriately
    }
  }
}
