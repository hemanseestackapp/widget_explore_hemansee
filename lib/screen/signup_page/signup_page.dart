import 'dart:developer' as developer;
import 'dart:math';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:widget_explore_hemansee/common/widget/common_text_field.dart';
import 'package:widget_explore_hemansee/modal/user_modal.dart';
import 'package:widget_explore_hemansee/screen/dashboard_page/dashboard_page.dart';
import 'package:widget_explore_hemansee/service/auth_service.dart';
import 'package:widget_explore_hemansee/service/user_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String gender = 'Female';
  String item = 'UserType';
  bool username = false;
  bool emailValidation = false;
  bool passwordValidation = false;
  bool confirmPasswordValidation = false;
  bool firstNameValidation = false;
  bool lastNameValidation = false;
  bool visiblePassword = false;
  bool confirmVisiblePassword = false;
  bool mobileNumber = false;
  bool dropdown = false;
  bool isLoading = false;

  TextEditingController firstNameTextField = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController passwordTextField = TextEditingController();
  TextEditingController confirmPasswordTextField = TextEditingController();
  int random = Random().nextInt(1000);

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
      backgroundColor: Colors.deepPurple,
      resizeToAvoidBottomInset: true,
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  color: Colors.deepPurple,
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
                      const Text(
                        'Be A User',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      color: Colors.white,
                    ),
                    child: ListView(
                      children: [
                        Column(
                          children: [
                            CommonTextFromField(
                              onChange: (value) {
                                username = true;
                                setState(() {});
                              },
                              controller: firstNameTextField,
                              hintText: 'FirstName',
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[a-zA-Z]'),
                                ),
                              ],
                              prefixIcon: Icons.note_alt_sharp,
                              color: Colors.deepPurple,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter Your firstname';
                                }
                                if (!RegExp(r'^[a-zA-Z]+').hasMatch(value)) {
                                  return 'Enter a valid first name.!';
                                }

                                return null;
                              },
                            ),
                            CommonTextFromField(
                              controller: lastName,
                              hintText: 'LastName',
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[a-zA-Z]'),
                                ),
                              ],
                              prefixIcon: Icons.note_alt_sharp,
                              color: Colors.deepPurple,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter Your lastname';
                                }
                                if (!RegExp(r'^[a-zA-Z]+').hasMatch(value)) {
                                  return 'Enter a valid last name.!';
                                }

                                return null;
                              },
                            ),
                            CommonTextFromField(
                              readOnly: true,
                              hintText: (username)
                                  ? '${firstNameTextField.text}${Random().nextInt(1000)}'
                                  : 'UserName',
                              prefixIcon: Icons.note_alt_sharp,
                              color: Colors.deepPurple,
                            ),
                            CommonTextFromField(
                              controller: email,
                              hintText: 'Email',
                              prefixIcon: Icons.note_alt_sharp,
                              color: Colors.deepPurple,
                            ),
                            CommonTextFromField(
                              controller: number,
                              hintText: 'Mobile Number',
                              prefixIcon: Icons.note_alt_sharp,
                              color: Colors.deepPurple,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10),
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter Your mobileNumber';
                                }
                                return null;
                              },
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const Text('Gender :-'),
                                  Radio(
                                    value: 'Male',
                                    groupValue: gender,
                                    onChanged: (value) {
                                      gender = value!;
                                      setState(() {});
                                    },
                                  ),
                                  const Text('Male'),
                                  Radio(
                                    value: 'Female',
                                    groupValue: gender,
                                    onChanged: (value) {
                                      gender = value!;
                                      setState(() {});
                                    },
                                  ),
                                  const Text('Female'),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text('Usertype :-'),
                                  const SizedBox(
                                    width: 40,
                                  ),
                                  DropdownButton(
                                    onTap: () {
                                      dropdown = true;
                                    },
                                    value: item,
                                    items: const [
                                      DropdownMenuItem(
                                        value: 'UserType',
                                        child: Text('UserType'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Admin',
                                        child: Text('Admin'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'User',
                                        child: Text('User'),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      item = value!;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter Your password';
                                }
                                return null;
                              },
                            ),
                            CommonTextFromField(
                              controller: confirmPasswordTextField,
                              hintText: 'Confirm Password',
                              obSecureText: !confirmVisiblePassword,
                              prefixIcon: Icons.note_alt_sharp,
                              color: Colors.deepPurple,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  confirmVisiblePassword =
                                      !confirmVisiblePassword;
                                  setState(() {});
                                },
                                icon: (confirmVisiblePassword)
                                    ? const Icon(Icons.visibility)
                                    : const Icon(Icons.visibility_off),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter Your firstname';
                                }
                                return null;
                              },
                            ),
                            InkWell(
                              onTap: () async {
                                fromValidation();
                                if (passwordTextField.text ==
                                    confirmPasswordTextField.text) {
                                  developer.log('password Match');
                                } else {
                                  CherryToast.info(
                                    title: const Text(
                                      'Password is not match',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    actionHandler: () {},
                                    animationType: AnimationType.fromTop,
                                  ).show(context);
                                }
                                if (emailValidation == false &&
                                    passwordValidation == false &&
                                    confirmPasswordValidation == false &&
                                    firstNameValidation == false &&
                                    lastNameValidation == false &&
                                    passwordTextField.text ==
                                        confirmPasswordTextField.text) {
                                  isLoading = true;
                                  setState(() {});
                                  UserCredential? userCredential =
                                      await AuthService.instance.email(
                                          email.text, passwordTextField.text,);
                                  isLoading = false;
                                  setState(() {});
                                  if (userCredential != null) {
                                    UserModel userModal = UserModel(
                                      userType: item,
                                      uid: userCredential.user!.uid,
                                      firstName: firstNameTextField.text,
                                      lastName: lastName.text,
                                      userName: firstNameTextField.text,
                                      email: email.text,
                                      mobile: number.text,
                                      password: passwordTextField.text,
                                      confirmPassword:
                                          confirmPasswordTextField.text,
                                      profile: '',
                                    );
                                    Future.delayed(
                                      const Duration(microseconds: 1),
                                      () async {
                                        await UserService.instance
                                            .createUser(userModal, context);
                                      },
                                    );
                                  }
                                  Future.delayed(
                                    const Duration(microseconds: 1),
                                    () {
                                      Navigator.push(
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
                                if (dropdown == false) {
                                  Future.delayed(
                                    const Duration(microseconds: 1),
                                    () {
                                      CherryToast.info(
                                        title: const Text(
                                          'Select Your UserType...!',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        actionHandler: () {},
                                        animationType: AnimationType.fromTop,
                                      ).show(context);
                                    },
                                  );
                                }
                                setState(() {});
                              },
                              child: Container(
                                height: 50,
                                width: 320,
                                margin:
                                    const EdgeInsets.fromLTRB(10, 5, 10, 10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.deepPurple,
                                ),
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
      ),
    );
  }
}
