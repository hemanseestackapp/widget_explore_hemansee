import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:widget_explore_hemansee/screen/forget_password/forget_password.dart';
import 'package:widget_explore_hemansee/screen/home_page/home_page.dart';
import 'package:widget_explore_hemansee/screen/signup_page/signup_page.dart';
import 'package:widget_explore_hemansee/service/auth_service.dart';
import 'package:widget_explore_hemansee/service/user_service/user_service.dart';
import 'package:widget_explore_hemansee/service/users_modal/user_modal.dart';

class LoginPages extends StatefulWidget {
  const LoginPages({super.key});

  @override
  State<LoginPages> createState() => _LoginPagesState();
}

class _LoginPagesState extends State<LoginPages> {
  TextEditingController emailTextField = TextEditingController();
  TextEditingController passwordTextField = TextEditingController();
  bool visiblePassword = false;
  bool visiblePasswords = false;
  bool emailValidation = false;
  bool passwordValidation = false;
  bool confirmPasswordValidation = false;
  bool google = false;
  bool passwordMatch = false;
  bool isLoading = false;
  bool toastShow = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            height: double.infinity,
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
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.orange.shade900,
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
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child:
                                // TextFormField(autovalidateMode: AutovalidateMode.onUserInteraction,
                                //   controller: emailTextField,
                                //   validator: (value) {
                                //     if(value == null || value.isEmpty)
                                //       {
                                //           return 'enter valid email';
                                //       }
                                //     return null;
                                //   },
                                //   decoration: const InputDecoration(
                                //     hintText: 'email',
                                //   ),
                                // )
                                TextField(
                              onTapOutside: (event) {
                                FocusManager.instance.primaryFocus!.unfocus();
                              },
                              controller: emailTextField,
                              decoration: InputDecoration(
                                errorText: (emailValidation)
                                    ? 'Enter your Email'
                                    : null,
                                prefixIcon: const Icon(
                                  Icons.note_alt_sharp,
                                  color: Colors.red,
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                                hintText: 'Email',
                                labelText: 'Enter Your Email',
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: TextField(
                              onChanged: (value) {
                                // passwordMatch=true;
                              },
                              obscureText: !visiblePassword,
                              controller: passwordTextField,
                              decoration: InputDecoration(
                                errorText: (passwordValidation)
                                    ? 'Enter your password'
                                    : null,
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
                                labelText: 'Enter Your Password',
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () async {
                            String email = emailTextField.text;
                            String password = passwordTextField.text;
                            if (email.trim() == '' ||
                                !EmailValidator.validate(email.trim())) {
                              emailValidation = true;
                            } else {
                              emailValidation = false;
                            }
                            if (password == '') {
                              passwordValidation = true;
                            } else {
                              passwordValidation = false;
                            }
                            if (passwordValidation == false &&
                                emailValidation == false) {
                              isLoading = true;
                              setState(() {});
                              await AuthService.instance.loginUser(
                                emailTextField.text,
                                passwordTextField.text,
                                context,
                              );
                              isLoading = false;
                              setState(() {});
                            }
                          },
                          child: Container(
                            height: 50,
                            width: 320,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.orange.shade900,
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
                                        return const HomePage();
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
                              color: Colors.orange.shade900,
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
                                  return const PasswordScreen();
                                },
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 180),
                            child: Text(
                              'Forget Password ?',
                              style: TextStyle(
                                color: Colors.orange.shade900,
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
                            child: Row(
                              children: [
                                const Text("Don't have an account   ?"),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: Colors.orange.shade900,
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
                )
              ],
            ),
          ),
          if (isLoading == true)
            Center(
              heightFactor: double.infinity,
              widthFactor: double.infinity,
              child: CircularProgressIndicator(
                color: Colors.red.withOpacity(0.3),
              ),
            ),
        ],
      ),
    );
  }
}
