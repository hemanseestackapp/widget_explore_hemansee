import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:widget_explore_hemansee/service/users_modal/user_modal.dart';

class UserService {

  UserService._privateConstructore();
  static final UserService instance = UserService._privateConstructore();

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> createUser(UserModel user, BuildContext context) async {
    try {
      await userCollection.doc(user.uid).set(user.toJson());
    } on FirebaseException catch (e) {
      log('Catch error in Create User : ${e.message}');
      // showMessage(context, e.message);
    }
  }

  Future<DocumentSnapshot?> getCurrentDataUser(String uid) async {
    try {
      DocumentSnapshot documentSnapshot = await userCollection.doc(uid).get();

      if (documentSnapshot.exists) {
        return documentSnapshot;
      }
    } on FirebaseException catch (e) {
      log('Catch error in Get Current User : ${e.message}');
      // return null;
    }
    return null;
  }

  Future<void> signInUser(UserModel user) async {
    try {
      await userCollection.doc(user.uid).set(user.toJson());
    } on FirebaseException catch (e) {
      log('Catch error in Create User : ${e.message}');
    }
  }


  Future<void> updateImageURL(String userId, String imageURL) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'profilePic': imageURL});
    } on FirebaseException catch (e) {
      log('$e - this is FirebaseFireStore on uploadImageToFirebaseStorage');
    } on SocketException catch (e) {
      log('$e - this is SocketException on uploadImageToFirebaseStorage');
    }
  }


  Future<String?>? imageRef(File file, String uid) async {
    try {
      Reference ref = FirebaseStorage.instance
          .ref('uploadImage/${file.path.split('/').last}');
      UploadTask uploadTask = ref.putFile(file);
      String downloadUrl = await ref.getDownloadURL();

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrls = await snapshot.ref.getDownloadURL();
      int index = downloadUrls.lastIndexOf('&');
      String endIndex = downloadUrls.substring(0, index);
      DocumentReference reference =
          FirebaseFirestore.instance.collection('users').doc(uid);
      reference.update({'image': endIndex});

      if (kDebugMode) {
        print(file.path);
      }
      return downloadUrl;
    } on FirebaseException catch (e) {
      log('$e -- FirebaseException on imageRef');
    } on SocketException catch (e) {
      log('$e -- SocketException on imageRef');
    }
    return null;
  }
}
