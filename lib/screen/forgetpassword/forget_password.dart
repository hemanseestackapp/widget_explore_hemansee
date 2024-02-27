import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:widget_explore_hemansee/screen/loginpages/login_pages.dart';
import 'package:widget_explore_hemansee/service/auth_service.dart';

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({super.key});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  TextEditingController email = TextEditingController();
  bool isLoading = false;
  bool emailSent = false;

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
                      // color: Colors.white,
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
                    'Forget Your Password',
                    style:
                        TextStyle(fontSize: 20, color: Colors.orange.shade900),
                  ),
                ),
                const SizedBox(
                  height: 40,
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
                          height: 40,
                        ),
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextField(
                              onTap: () {
                                emailSent = true;
                              },
                              controller: email,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  Icons.note_alt_sharp,
                                  color: Colors.red,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                                hintText: 'Enter Your Email',
                                labelText: 'Enter Your Email',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () async {
                            emailSent = true;
                            // setState(() {});
                            if (email.text == '') {
                              CherryToast.info(
                                title: const Text(
                                  'Enter your valid email..!',
                                  style: TextStyle(color: Colors.black),
                                ),
                                actionHandler: () {},
                                animationType: AnimationType.fromTop,
                              ).show(context);
                            }
                            if (email.text != '') {
                              isLoading = true;
                              setState(() {});
                              CherryToast.info(
                                title: const Text(
                                  'sent your verification mail...!',
                                  style: TextStyle(color: Colors.black),
                                ),
                                actionHandler: () {},
                                animationType: AnimationType.fromTop,
                              ).show(context);
                            }
                            AuthService.instance
                                .sendPasswordResetEmail(email.text);
                            isLoading = false;
                            setState(() {});
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
                              'Set Verification Mail',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
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

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                color: Colors.orange.shade100,
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(100, 100, 100, 60),
                        height: 160,
                        width: 160,
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
                    // child: Text( 'Create An Account',
                    //   style: TextStyle(
                    //     color: Colors.orange.shade900, fontSize: 25,),),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.white,
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                    'You Are Login....!',
                    style:
                        TextStyle(fontSize: 20, color: Colors.orange.shade900),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  InkWell(
                    onTap: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context) {
                      //   return const MobAuth();
                      // },),);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const LoginPages();
                          },
                        ),
                      );
                    },
                    child: Container(
                      height: 40,
                      width: 140,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.orange.shade900,
                      ),
                      child: const Text(
                        'Sign Out',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
