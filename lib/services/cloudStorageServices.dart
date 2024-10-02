import 'package:firebase_storage/firebase_storage.dart';

const String USER_COLLECTION = "Users";

class CloudStorageServices {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  CloudStorageServices();
}
