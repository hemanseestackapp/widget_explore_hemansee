import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:widget_explore_hemansee/screen/logoutpage/log_outpage.dart';

import 'package:widget_explore_hemansee/service/auth_service.dart';

void main()
{
    runApp(const MaterialApp(debugShowCheckedModeBanner: false,home: LoginAuth(),));
}
class LoginAuth extends StatefulWidget {
  const LoginAuth({super.key});

  @override
  State<LoginAuth> createState() => _LoginAuthState();
}

class _LoginAuthState extends State<LoginAuth> {
  TextEditingController emailTextField=TextEditingController();
  TextEditingController passwordTextField=TextEditingController();
  TextEditingController otpTextField=TextEditingController();
  TextEditingController verifyTextField=TextEditingController();

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
                        bottomRight: Radius.circular(40),),
                    color: Colors.deepPurple,),
              ),),
          Expanded(
              flex: 4,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Create An Account',
                    style: TextStyle(color: Colors.deepPurple, fontSize: 20),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      decoration: const InputDecoration(
                          hintText: 'Enter Your Email',
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.deepPurple,
                          ),),
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
                          ),),
                      controller: passwordTextField,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  InkWell(onTap: () async {
                    User? a = await AuthService.instance.signInWithGoogle();
                    if (a != null) {
                      if (kDebugMode) {
                        print('${a.displayName}');
                      }
                      if (kDebugMode) {
                        print('${a.email}');
                      }
                    }
                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) {
                        return SecPage(a);
                      },
                    ),);
                  },
                    child: Container(
                      height: 60,
                      width: 260,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(40),color: Colors.deepPurple),
                      child: const Text('Sign Up',style: TextStyle(color: Colors.white,fontSize: 15),),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  const Text(('----- Or sign up with -----'),style: TextStyle(color: Colors.deepPurple,fontSize: 15),),

                ],
              ),),
          Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),),
                    color: Colors.deepPurple,),
              ),),
        ],
      ),
    );
  }
}
