import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class Storage {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  Future<String> downloadURL(String imageName) async {
    String downloadURL =
        await storage.ref('petImages/$imageName').getDownloadURL();
    return downloadURL;
  }
}
