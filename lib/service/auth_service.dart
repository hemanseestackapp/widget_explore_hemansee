import 'dart:developer';
import 'dart:io';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:widget_explore_hemansee/screen/homepage/home_page.dart';

class AuthService {
  AuthService._privateConstructore();

  static final AuthService instance = AuthService._privateConstructore();

  String verificationIid = '';
  FirebaseAuth auth = FirebaseAuth.instance;
  bool verifyOtp = false;
  bool passwordMatch = false;
  bool emailMatch = false;
  bool userType = false;

  Future<User?> signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        GoogleSignInAuthentication? googleAuth =
            await googleUser.authentication;
        OAuthCredential oAuthCredential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        UserCredential? userCredential =
            await FirebaseAuth.instance.signInWithCredential(oAuthCredential);
        // User? user = userCredential.user;
        return userCredential.user;
      }
    } on FirebaseAuthException catch (e) {
      log(
        'This is a signInWithGoogle in FirebaseAuthException = ${e.message}',
      );
    } on SocketException catch (e) {
      log('This is a signInWithGoogle in SocketException = ${e.message}');
    }
    return null;
  }

  void mobService(String num) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91$num',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid - phone - number') {
            log('The provided phone number is not valid.');
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          verificationIid = verificationId;
          log('hyy $verificationIid');
          verifyOtp = true;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          log('Your otp is verify...');
        },
      );
    } on FirebaseAuthException catch (e) {
      log('This is a FirebaseAuthException in mobService - ${e.message}');
    } on SocketException catch (e) {
      log('This is a SocketException in mobService - ${e.message}');
    }
  }

  Future<void> verify(otp) async {
    try {
      String smsCode = '$otp';
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationIid,
        smsCode: smsCode,
      );
      await auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      log(
        'This is a FirebaseAuthException in mobService ----- ${e.message}',
      );
    } on SocketException catch (e) {
      log('This is a SocketException in mobService ----- ${e.message}');
    }
  }

  Future<UserCredential?> email(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');
      }
    } on SocketException catch (e) {
      log('$e');
    }
    return null;
  }

  void user(String firstname, String lastname, String username, String email) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    try {
      users
          .add({
            'firstname': firstname,
            'lastname': lastname,
            'username': username,
            'email': email,
          })
          .then((value) => log('User Added'))
          .catchError((error) => log('Failed to add user: $error'));
    } on FirebaseAuthException catch (e) {
      log('This is a FirebaseAuthException in mobService - ${e.message}');
    } on SocketException catch (e) {
      log('This is a SocketException in mobService - ${e.message}');
    }
  }

  void sendPasswordResetEmail(String emailSend) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailSend,
      );
      log('email - $emailSend');
      log('Successfully verified mail');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');
      }
    } on SocketException catch (e) {
      log('$e');
    }
  }

  Future<void> fetchDataBasedOnEmail(
      String userEmail, String userPassword,) async {
    try {
      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('users');
      QuerySnapshot querySnapshot =
          await usersCollection.where('email', isEqualTo: userEmail).get();
      await usersCollection.where('password', isEqualTo: userPassword).get();
      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot document in querySnapshot.docs) {
          Map<String, dynamic> userData =
              document.data() as Map<String, dynamic>;
          String email = userData['email'];
          String password = userData['password'];
          log('User email: $email, password: $password');
        }
      } else {
        log('No matching documents.');
      }
    } on FirebaseAuthException catch (e) {
      log('Error fetching data: $e');
    }
  }

  Future<bool?> loginUser(
      String email, String password, BuildContext context,) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Future.delayed(
        const Duration(microseconds: 1),
        () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const HomePage();
              },
            ),
          );
        },
      );

      String uid = userCredential.user!.uid;
      var userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userSnapshot.exists && userSnapshot.data()?['users'] == 'User') {
        userType = true;
        Future.delayed(
          const Duration(microseconds: 1),
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const HomePage();
                },
              ),
            );
          },
        );
      } else {
        userType = false;
      }

      if (kDebugMode) {
        print(userCredential);
      }
      passwordMatch = true;
      return passwordMatch;
    } on FirebaseAuthException catch (e) {
      CherryToast.info(
        title: const Text(
          'The supplied auth credential is incorrect',
          style: TextStyle(color: Colors.black),
        ),
        actionHandler: () {},
        animationType: AnimationType.fromTop,
      ).show(context);
      passwordMatch = false;
      // emailMatch=false;
      log('Failed to log in: $e');
    }
    return null;
  }
}
