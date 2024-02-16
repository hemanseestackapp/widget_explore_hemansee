import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {

  AuthService._privateConstructore();
  static final AuthService instance = AuthService._privateConstructore();

  String verificationIid = "";
  FirebaseAuth auth = FirebaseAuth.instance;
  bool verifyOtp = false;

  Future<User?> signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        GoogleSignInAuthentication? googleAuth =
            await googleUser.authentication;
        OAuthCredential oAuthCredential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(oAuthCredential);
        User? user = userCredential.user;
        return user;
      }
    } on FirebaseAuthException catch (e) {
        log(
          "This is a signInWithGoogle in FirebaseAuthException = ${e.message}");
    } on SocketException catch (e) {
        log("This is a signInWithGoogle in SocketException = ${e.message}");
    }
    return null;
  }

  void mobService(String num)  async {
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
            log("hyy $verificationIid");
          verifyOtp = true;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
            log("Your otp is verify...");
        },
      );
    } on FirebaseAuthException catch (e) {
        log("This is a FirebaseAuthException in mobService - ${e.message}");
    } on SocketException catch (e) {
        log("This is a SocketException in mobService - ${e.message}");
    }
  }

  void verify(otp) async {
    try {
      String smsCode = '$otp';
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationIid, smsCode: smsCode);
      await auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
        log(
            "This is a FirebaseAuthException in mobService ----- ${e.message}");

    } on SocketException catch (e) {
        log("This is a SocketException in mobService ----- ${e.message}");

    }
  }

     email(email,password)
    async {
            try {
              final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: email,
                password: password,
              );
              log("Email verify : $credential");

            } on FirebaseAuthException catch (e) {
              if (e.code == 'weak-password') {
                  log('The password provided is too weak.');
              } else if (e.code == 'email-already-in-use') {
                  log('The account already exists for that email.');
              }
            } catch (e) {
                log('$e');
            }
    }
}
