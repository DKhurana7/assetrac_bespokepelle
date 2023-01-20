// ignore_for_file: avoid_print

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'package:firebase_core/firebase_core.dart' as firebase_core;




class Storage {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> uploadFile(
      String filePath,
      String fileName,
      ) async {
    File file = File(filePath);

    try {
      await storage.ref("icons/$fileName").putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }

  }

  Future<firebase_storage.ListResult> listFiles() async {
    firebase_storage.ListResult results =
    await firebase_storage.FirebaseStorage.instance.ref("icons").listAll();

    for (var ref in results.items) {
      print("Found File: $ref"); }
    return results;
  }

  Future<String> downloadURL(String imageName) async{
    String downloadURL =
    await firebase_storage.FirebaseStorage.instance.ref("icons/$imageName").getDownloadURL();

    return downloadURL;
  }

}