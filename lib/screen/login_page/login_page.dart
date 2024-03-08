import 'dart:developer';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:widget_explore_hemansee/common/widget/common_text_field.dart';
import 'package:widget_explore_hemansee/modal/user_modal.dart';
import 'package:widget_explore_hemansee/screen/dashboard_page/dashboard_page.dart';
import 'package:widget_explore_hemansee/screen/forget_password_page/forget_password_page.dart';
import 'package:widget_explore_hemansee/screen/signup_page/signup_page.dart';
import 'package:widget_explore_hemansee/service/auth_service.dart';
import 'package:widget_explore_hemansee/service/user_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailTextField = TextEditingController();
  TextEditingController passwordTextField = TextEditingController();
  bool visiblePassword = false;
  bool visiblePasswords = false;
  bool google = false;
  bool passwordMatch = false;
  bool isLoading = false;
  bool toastShow = false;

  final _formKey = GlobalKey<FormState>();

  void fromValidation() {
    if (_formKey.currentState!.validate()) {
      if (kDebugMode) {
        print('Enter your email');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.deepPurple,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(100, 80, 100, 30),
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(80),
                          color: Colors.white,
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(25),
                          child: const Image(
                            image: AssetImage('assets/image/user1.jpg'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          CommonTextFromField(
                            controller: emailTextField,
                            onTapOutSide: (event) {
                              FocusManager.instance.primaryFocus!.unfocus();
                            },
                            prefixIcon: Icons.note_alt_sharp,
                            color: Colors.deepPurple,
                            // labelText: 'Enter your Email',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter Your email';
                              }
                              if (!RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",)
                                  .hasMatch(value)) {
                                return 'Enter your valid email address';
                              }
                              return null;
                            },
                            hintText: 'Email',
                          ),
                          CommonTextFromField(
                            controller: passwordTextField,
                            hintText: 'Password',
                            obSecureText: !visiblePassword,
                            prefixIcon: Icons.note_alt_sharp,
                            color: Colors.deepPurple,
                            suffixIcon: IconButton(
                              onPressed: () {
                                visiblePassword = !visiblePassword;
                                setState(() {});
                              },
                              icon: (visiblePassword)
                                  ? const Icon(Icons.visibility)
                                  : const Icon(Icons.visibility_off),
                            ),
                            // labelText: 'Enter Your Password',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter Your Password';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () async {
                              fromValidation();
                              if (_formKey.currentState!.validate()) {
                                isLoading = true;
                                setState(() {});
                                log('message');
                                await AuthService.instance.loginUser(
                                  emailTextField.text,
                                  passwordTextField.text,
                                  context,
                                );
                                setState(() {});
                              }
                              isLoading = false;
                              setState(() {});
                            },
                            child: Container(
                              height: 50,
                              width: 320,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.deepPurple,
                              ),
                              child: const Text(
                                'Log In',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () async {
                              isLoading = true;
                              setState(() {});
                              User? data =
                                  await AuthService.instance.signInWithGoogle();
                              if (data == null) {
                                Future.delayed(
                                  const Duration(microseconds: 1),
                                  () {
                                    CherryToast.info(
                                      title: const Text(
                                        'select your email..!',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      actionHandler: () {},
                                      animationType: AnimationType.fromTop,
                                    ).show(context);
                                  },
                                );
                              }
                              User? userCredential =
                                  await AuthService.instance.signInWithGoogle();
                              if (userCredential != null) {
                                isLoading = true;
                                setState(() {});
                                UserModel userModal = UserModel(
                                  uid: FirebaseAuth.instance.currentUser?.uid ??
                                      '',
                                  firstName: '${data?.displayName}',
                                  lastName: '-',
                                  userName: '',
                                  email: '${data?.email}',
                                  mobile: '-',
                                  password: '',
                                  confirmPassword: '',
                                  profile: data!.photoURL ?? '',
                                  userType: '',
                                );
                                Future.delayed(
                                  const Duration(microseconds: 1),
                                  () async {
                                    await UserService.instance
                                        .createUser(userModal, context);
                                  },
                                );
                                isLoading = false;
                                setState(() {});
                                Future.delayed(
                                  const Duration(microseconds: 1),
                                  () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return const DashboardPage();
                                        },
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                            child: Container(
                              height: 50,
                              width: 320,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.deepPurple,
                              ),
                              child: const Text(
                                'Sign in with google',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const ForgetPassword();
                                  },
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 180),
                              child: const Text(
                                'Forget Password ?',
                                style: TextStyle(
                                  color: Colors.deepPurple,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const SignUpPage();
                                  },
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 80),
                              child: const Row(
                                children: [
                                  Text("Don't have an account   ?"),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading == true)
            Center(
              heightFactor: double.infinity,
              widthFactor: double.infinity,
              child: CircularProgressIndicator(
                color: Colors.deepPurple.withOpacity(0.3),
              ),
            ),
        ],
      ),
    );
  }
}
