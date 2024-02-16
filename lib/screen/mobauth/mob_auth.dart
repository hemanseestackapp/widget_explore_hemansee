import 'dart:developer';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../service/auth_service.dart';
import '../logoutpage/log_outpage.dart';
import '../verifypage/verify_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MobAuth(),
  ));
}

class MobAuth extends StatefulWidget {
  const MobAuth({super.key});

  @override
  State<MobAuth> createState() => _MobAuthState();
}

class _MobAuthState extends State<MobAuth> {
  TextEditingController otpTextField = TextEditingController();
  TextEditingController verifyTextField = TextEditingController();
  TextEditingController emailTextField = TextEditingController();
  TextEditingController passwordTextField = TextEditingController();

  bool veryFyOtp = false;
  dynamic otpSend;

  bool verificationCode = false;
  bool contactValidation = false;
  bool emailValidation = false;

  bool empty = false;
  bool timeOver = false;

  int sec = -1;
  bool isLoading = false;

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 5));
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
              flex: 2,
              child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40)),
                    color: Colors.deepPurple),
              )),
          Expanded(
              flex: 7,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Create An Account",
                    style: TextStyle(color: Colors.deepPurple, fontSize: 20),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus!.unfocus();
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                      ],
                      decoration: InputDecoration(
                          errorText:
                              (contactValidation) ? 'Enter Contact' : null,
                          hintText: 'Enter Your Contact',
                          prefixIcon: const Icon(
                            Icons.contact_mail_rounded,
                            color: Colors.deepPurple,
                          )),
                      controller: otpTextField,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      decoration: InputDecoration(
                          errorText:
                              (emailValidation) ? 'Enter your Email' : null,
                          hintText: 'Enter Your Email',
                          prefixIcon: const Icon(
                            Icons.person,
                            color: Colors.deepPurple,
                          )),
                      controller: emailTextField,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      decoration: const InputDecoration(
                          hintText: 'Enter Your Password',
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.deepPurple,
                          )),
                      controller: passwordTextField,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          String contact = otpTextField.text;
                          String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                          RegExp regExp = RegExp(pattern);
                          if (contact == "" || !regExp.hasMatch(contact)) {
                            contactValidation = true;
                          } else {
                            contactValidation = false;
                          }
                          setState(() {});
                          if (contactValidation == false) {
                            CherryToast.info(
                              title: const Text("Your OTP Is Send.....!",
                                  style: TextStyle(color: Colors.black)),
                              actionHandler: () {
                                if (kDebugMode) {
                                  print("Action button pressed");
                                }
                              },
                              animationType: AnimationType.fromTop,
                            ).show(context);
                          }
                          veryFyOtp = true;
                          AuthService.instance.mobService(otpTextField.text);
                          setState(() {});
                        },
                        child: Container(
                          height: 40,
                          width: 140,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: Colors.deepPurple),
                          child: const Text(
                            "Send OTP",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          AuthService.instance.email(
                              emailTextField.text, passwordTextField.text);
                          log("email=${emailTextField.text}");

                          String email = emailTextField.text;
                          if (email.trim() == "" ||
                              !EmailValidator.validate(email.trim())) {
                            emailValidation = true;
                          } else {
                            emailValidation = false;
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return const SignUp();
                              },
                            ));
                          }
                          setState(() {});
                        },
                        child: Container(
                          height: 40,
                          width: 140,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: Colors.deepPurple),
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () async {
                      User? a = await AuthService.instance.signInWithGoogle();
                      if (a != null) {
                        if (kDebugMode) {
                          print("${a.displayName}");
                        }
                        if (kDebugMode) {
                          print("${a.email}");
                        }
                      }
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) {
                          return SecPage(a);
                        },
                      ));
                    },
                    child: Container(
                      height: 40,
                      width: 200,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.deepPurple),
                      child: const Text(
                        "Sign with google",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                  (AuthService.instance.verifyOtp)
                      ? Container(
                          alignment: Alignment.center,
                          child: TextField(
                            controller: verifyTextField,
                            onTap: () {},
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                              onPressed: () {
                                log("Your otp is verify...");
                              },
                              icon: const Icon(Icons.add_circle),
                              color: Colors.deepPurple,
                            )),
                          ))
                      : const Text(""),
                ],
              )),
          Expanded(
              child: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)),
                color: Colors.deepPurple),
          )),
        ],
      ),
    );
  }
}
