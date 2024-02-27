import 'dart:developer' as developer;
import 'dart:math';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:widget_explore_hemansee/screen/homepage/home_page.dart';
import 'package:widget_explore_hemansee/service/auth_service.dart';
import 'package:widget_explore_hemansee/service/userservice/user_service.dart';
import 'package:widget_explore_hemansee/service/usersmodal/user_modal.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
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

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController passwordTextField = TextEditingController();
  TextEditingController confirmPasswordTextField = TextEditingController();
  int random = Random().nextInt(1000);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade100,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 250,
                width: double.infinity,
                color: Colors.orange.shade100,
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
                              image: AssetImage('myassets/img/user1.jpg'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Be A User',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.orange.shade900,
                      ),
                    )
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
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: TextField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z]'),
                                  ),
                                ],
                                onChanged: (value) {
                                  username = true;
                                  setState(() {});
                                },
                                controller: firstName,
                                decoration: InputDecoration(
                                  errorText:
                                  (firstNameValidation) ? 'Enter FirstName' : null,
                                  prefixIcon: const Icon(
                                    Icons.note_alt_sharp,
                                    color: Colors.red,
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  hintText: 'FirstName',
                                  // labelText: 'Enter Your FirstName',
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: TextField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z]'),
                                  ),
                                ],
                                controller: lastName,
                                decoration: InputDecoration(
                                  errorText:
                                  (lastNameValidation) ? 'Enter LastName' : null,
                                  prefixIcon: const Icon(
                                    Icons.note_alt_sharp,
                                    color: Colors.red,
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  hintText: 'Lastname',
                                  // labelText: 'Enter Your LastName',
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: TextField(
                                readOnly: true,
                                // controller: firstName,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.note_alt_sharp,
                                    color: Colors.red,
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  hintText: (username)
                                      ? '${firstName.text.trim()}${Random().nextInt(1000)}'
                                      : 'UserName',
                                  // labelText: 'Enter Your UserName',
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: TextField(
                                controller: email,
                                decoration: InputDecoration(
                                  errorText:
                                  (emailValidation) ? 'Enter your Email' : null,
                                  prefixIcon: const Icon(
                                    Icons.note_alt_sharp,
                                    color: Colors.red,
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  hintText: 'Email',
                                  // labelText: 'Enter Your Email',
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                controller: number,
                                decoration: InputDecoration(
                                  errorText:
                                  (mobileNumber) ? 'Enter Mobile Number' : null,
                                  prefixIcon: const Icon(
                                    Icons.note_alt_sharp,
                                    color: Colors.red,
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  hintText: 'Mobile Number',
                                  // labelText: 'Enter Your Mobile Number',
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                            Row(
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
                                  items:  const [
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
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: TextField(
                                obscureText: !visiblePassword,
                                onTapOutside: (event) {
                                  FocusManager.instance.primaryFocus!.unfocus();
                                },
                                controller: passwordTextField,
                                decoration: InputDecoration(
                                  errorText:
                                  (passwordValidation) ? 'Enter Your Password' : null,
                                  prefixIcon: const Icon(
                                    Icons.note_alt_sharp,
                                    color: Colors.red,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      visiblePassword = !visiblePassword;
                                      setState(() {});
                                    },
                                    icon: (visiblePassword)
                                        ? const Icon(Icons.visibility)
                                        : const Icon(Icons.visibility_off),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  hintText: 'password',
                                  // labelText: 'Enter Your Password',
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: TextField(
                                obscureText: !confirmVisiblePassword,
                                controller: confirmPasswordTextField,
                                decoration: InputDecoration(
                                  errorText: (confirmPasswordValidation)
                                      ? 'Enter Your Password'
                                      : null,
                                  prefixIcon: const Icon(
                                    Icons.note_alt_sharp,
                                    color: Colors.red,
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      confirmVisiblePassword = !confirmVisiblePassword;
                                      setState(() {});
                                    },
                                    icon: (confirmVisiblePassword)
                                        ? const Icon(Icons.visibility)
                                        : const Icon(Icons.visibility_off),
                                  ),
                                  hintText: ' Confirm password',
                                  // labelText: 'Enter confirm Password',
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                if (passwordTextField.text ==
                                    confirmPasswordTextField.text) {
                                  developer.log('password Match');
                                } else {
                                  CherryToast.info(
                                    title: const Text(
                                      'Password is not match',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    actionHandler: () {
                                    },
                                    animationType: AnimationType.fromTop,
                                  ).show(context);
                                }

                                String emailValidate = email.text;
                                String password = passwordTextField.text;
                                String confirmPassword = confirmPasswordTextField.text;
                                String firstname = firstName.text;
                                String lastname = lastName.text;
                                String num = number.text;

                                if (emailValidate.trim() == '' ||
                                    !EmailValidator.validate(
                                      emailValidate.trim(),
                                    )) {
                                  emailValidation = true;
                                } else {
                                  emailValidation = false;
                                }

                                if (password == '' || firstname == '' || lastname == '') {
                                  passwordValidation = true;
                                  firstNameValidation = true;
                                  lastNameValidation = true;
                                } else {
                                  passwordValidation = false;
                                  firstNameValidation = false;
                                  lastNameValidation = false;
                                }
                                if (confirmPassword == '') {
                                  confirmPasswordValidation = true;
                                } else {
                                  confirmPasswordValidation = false;
                                }
                                if (num == '') {
                                  mobileNumber = true;
                                } else {
                                  mobileNumber = false;
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
                                  UserCredential? userCredential = await AuthService
                                      .instance
                                      .email(email.text, passwordTextField.text);
                                  isLoading = false;
                                  setState(() {});
                                  if (userCredential != null) {
                                    UserModel userModal = UserModel(
                                      userType: item,
                                      uid: userCredential.user!.uid,
                                      firstName: firstName.text,
                                      lastName: lastName.text,
                                      userName: firstName.text,
                                      email: email.text,
                                      mobile: number.text,
                                      password: passwordTextField.text,
                                      confirmPassword: confirmPassword,
                                      profile: '',
                                    );

                                    Future.delayed(const Duration(microseconds: 1),() async {
                                      await UserService.instance.createUser(userModal, context);
                                    },);

                                  }
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

                                }
                                if (dropdown == false) {
                                  // ignore: use_build_context_synchronously
                                  CherryToast.info(
                                    title: const Text(
                                      'Select Your UserType...!',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    actionHandler: () {},
                                    animationType: AnimationType.fromTop,
                                  ).show(context);
                                }
                                setState(() {});
                              },
                              child: Container(
                                height: 50,
                                width: 320,
                                margin: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.orange.shade900,
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
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if(isLoading == true)
            Center(
              heightFactor: double.infinity,
              widthFactor: double.infinity,
              child: CircularProgressIndicator(
                color: Colors.red.withOpacity(0.3),
              ),),
        ],
      ),
    );
  }
}
