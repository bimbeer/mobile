import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageRepository {
  StorageRepository({FirebaseStorage? firebaseStorage})
      : _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  final FirebaseStorage _firebaseStorage;

  Future<String?> addFile(
      {required File file,
      required String fileName,
      required String storagePath}) async {
    final fileRef = _firebaseStorage.ref().child('$storagePath/$fileName');

    try {
      await fileRef.putFile(file);
      return fileRef.getDownloadURL();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<String>> getAllFiles({required String storagePath}) async {
    final storageRef = FirebaseStorage.instance.ref().child(storagePath);
    final listResult = await storageRef.listAll();
    List<String> downloadURLs = [];

    for (var item in listResult.items) {
      var itemURL = await item.getDownloadURL();
      downloadURLs.add(itemURL);
    }
    return downloadURLs;
  }
}
