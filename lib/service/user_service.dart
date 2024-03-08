import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:widget_explore_hemansee/modal/user_modal.dart';

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
    } on SocketException catch (e) {
      log('This is a SocketException in createUser ----- ${e.message}');
    }
  }

  Future<DocumentSnapshot?> getCurrentDataUser(String uid) async {
    try {
      DocumentSnapshot documentSnapshot = await userCollection.doc(uid).get();

      if (documentSnapshot.exists) {
        return documentSnapshot;
      }
    } on FirebaseException catch (e) {
      log('This is a FirebaseException in getCurrentDataUser ----- ${e.message}');
    } on SocketException catch (e) {
      log('This is a SocketException in getCurrentDataUser ----- ${e.message}');
    }
    return null;
  }

  Future<void> signInUser(UserModel user) async {
    try {
      await userCollection.doc(user.uid).set(user.toJson());
    } on FirebaseException catch (e) {
      log('This is a FirebaseException in signInUser ----- ${e.message}');
    } on SocketException catch (e) {
      log('This is a SocketException in signInUser ----- ${e.message}');
    }
  }

  Future<void> updateImageURL(String userId, String imageURL) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'profilePic': imageURL});
    } on FirebaseException catch (e) {
      log('This is FirebaseFireStore on uploadImageToFirebaseStorage ----- ${e.message}');
    } on SocketException catch (e) {
      log('This is SocketException on uploadImageToFirebaseStorage ---- ${e.message}');
    }
  }

  Future<String?>? imageRef(File file, String uid) async {
    try {
      Reference ref = FirebaseStorage.instance
          .ref('uploadImage/${file.path.split('/').last}');
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrls = await snapshot.ref.getDownloadURL();
      int index = downloadUrls.lastIndexOf('&');
      String imageUrl = downloadUrls.substring(0, index);
      DocumentReference reference = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      await reference.update({'image': imageUrl});

      if (kDebugMode) {
        print(file.path);
      }
      return imageUrl;
    } on FirebaseException catch (e) {
      log('This is FirebaseException on imageRef ---- ${e.message}');
    } on SocketException catch (e) {
      log('This is SocketException on imageRef ------ ${e.message}');
    }
    return null;
  }
}
