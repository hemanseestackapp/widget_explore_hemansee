import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:widget_explore_hemansee/modal/post_modal.dart';

class PostService {
  PostService._privateConstructore();

  static final PostService instance = PostService._privateConstructore();
  final CollectionReference postCollection =
      FirebaseFirestore.instance.collection('post');


  Stream<QuerySnapshot> postUser() {

    return FirebaseFirestore.instance.collection('post')
        .orderBy('postId', descending: true)
        .snapshots();
  }


  Stream<DocumentSnapshot<Map<String, dynamic>>> createPostUser(String userId) {
    return FirebaseFirestore.instance.collection('users').doc(userId).snapshots();
  }


  Future<void> createPost(PostModal post, BuildContext context) async {
    try {
      await postCollection.doc(post.postId).set(post.toJson());
    } on FirebaseException catch (e) {
      log('FirebaseException createPost ---------- ${e.message}');
    } on SocketException catch (e) {
      log('SocketException in createPost --------- ${e.message}');
    }
  }

  Future<void> draftPost(PostModal post, BuildContext context) async {
    try {
      await postCollection.doc(post.postId).set(post.toJson());
    } on FirebaseException catch (e) {
      log('FirebaseException createPost ---------- ${e.message}');
    } on SocketException catch (e) {
      log('SocketException in createPost --------- ${e.message}');
    }
  }

  Future<String?> uploadPost(XFile? image, String uid, String postId) async {
    try {
      if (image == null) {
        log('select your image');
        Fluttertoast.showToast(
            msg: 'select your image',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        ,);
        return null;
      }

      String path = image.path;
      Uint8List data = await XFile(path).readAsBytes();
      FirebaseStorage storage = FirebaseStorage.instance;
      log('uid ===> $uid');

      String fileName =
          image.path.split('/').last; // Extracting just the file name
      log('filename ==> $fileName');

      var storageRef = storage.ref().child('users/$uid/$fileName');

      TaskSnapshot uploadTask = await storageRef.putData(data);
      String downloadUrl = await uploadTask.ref.getDownloadURL();
      int endIndex = downloadUrl.lastIndexOf('&');
      String substring = downloadUrl.substring(0, endIndex);
      log('url ==> $substring');
      log('===> successfully added');
      return substring;
    } on FirebaseException catch (e) {
      log('FirebaseException uploadPost ---------- ${e.message}');
    } on SocketException catch (e) {
      log('SocketException in uploadPost --------- ${e.message}');
    }
    return null;
  }

  Future<void> postLikes(String postId, List<String> likes) async {
    try {
      if(likes.contains(postId)){
        likes.remove(postId);
      }else{
        likes.add(postId);
      }
      await postCollection.doc(postId).update({'like': likes});
    } on FirebaseException catch (e) {
      log('FirebaseException postLikes ---------- ${e.message}');
    } on SocketException catch (e) {
      log('SocketException in postLikes --------- ${e.message}');
    }
  }

  List<String> updateLike(List<dynamic> currentLikes, String currentUserId) {
    List<String> updatedLikes;
    if (currentLikes.contains(currentUserId)) {
        updatedLikes = currentLikes.map((dynamic item) => item.toString()).toList();
    } else {
      updatedLikes =List.from(currentLikes)..add(currentUserId);
    }

    return updatedLikes;
  }

  Stream<QuerySnapshot> getUsersStream() {
    return postCollection.snapshots();
  }


  // Future<List<String>> updateLike(List<String> currentLikes, String currentUserId,) async {
  //   if (currentLikes.contains(currentUserId)) {
  //     return currentLikes.where((userId) => userId != currentUserId).toList();
  //   } else {
  //     return List.from(currentLikes)..add(currentUserId);
  //   }
  // }
}
