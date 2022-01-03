import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sellout_team/src/constants/constants.dart';

class StorageServices {
  Future<String?> uploadImages({required File image}) async {
    final String today = ('${DateTime.now().month}-${DateTime.now().day}');
    UploadTask uploadTask = FirebaseStorage.instance
        .ref()
        .child('images')
        .child(today)
        .child('${DateTime.now().toString()}')
        .putFile(image);

    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    String url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }

  Future<String?> uploadVideo({required File video}) async {
    final String storageId =
        (DateTime.now().millisecondsSinceEpoch.toString() + kUid!);
    final String today = ('${DateTime.now().month}-${DateTime.now().day}');

    Reference ref = FirebaseStorage.instance
        .ref()
        .child("video")
        .child(today)
        .child(storageId);

    UploadTask uploadTask =
        ref.putFile(video, SettableMetadata(contentType: 'video/mp4'));

    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }

  Future<String?> uploadDocs({required File doc}) async {
    final String today = ('${DateTime.now().month}-${DateTime.now().day}');
    UploadTask uploadTask = FirebaseStorage.instance
        .ref()
        .child('docs')
        .child(today)
        .child('${DateTime.now().toString()}')
        .putFile(doc);

    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    String url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }
}
