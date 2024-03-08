import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:widget_explore_hemansee/common/widget/common_text_field.dart';
import 'package:widget_explore_hemansee/service/auth_service.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController email = TextEditingController();
  bool isLoading = false;
  bool emailSent = false;

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
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            Container(
              height: double.infinity,
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
                  Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'Forget Your Password',
                      style: TextStyle(fontSize: 20, color: Colors.white),
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
                          CommonTextFromField(
                            onChange: (value) {
                              emailSent = true;
                            },
                            controller: email,
                            prefixIcon: Icons.note_alt_sharp,
                            color: Colors.deepPurple,
                            hintText: 'Enter your email',
                            labelText: 'Enter your email',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter Your firstname';
                              }
                              if (!RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",)
                                  .hasMatch(value)) {
                                return 'Enter your valid email address';
                              }
                              return null;
                            },
                          ),
                          // Container(
                          //   margin: const EdgeInsets.all(10),
                          //   child: Padding(
                          //     padding: const EdgeInsets.symmetric(horizontal: 10),
                          //     child: TextField(
                          //       onTap: () {
                          //         emailSent = true;
                          //       },
                          //       controller: email,
                          //       decoration: const InputDecoration(
                          //         prefixIcon: Icon(
                          //           Icons.note_alt_sharp,
                          //           color: Colors.red,
                          //         ),
                          //         focusedBorder: OutlineInputBorder(
                          //           borderSide: BorderSide(color: Colors.red),
                          //         ),
                          //         hintText: 'Enter Your Email',
                          //         labelText: 'Enter Your Email',
                          //         border: OutlineInputBorder(),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          const SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () async {
                              emailSent = true;
                              // setState(() {});
                              // if (email.text == '') {
                              //   CherryToast.info(
                              //     title: const Text(
                              //       'Enter your valid email..!',
                              //       style: TextStyle(color: Colors.black),
                              //     ),
                              //     actionHandler: () {},
                              //     animationType: AnimationType.fromTop,
                              //   ).show(context);
                              // }
                              // if (email.text != '') {
                              //   isLoading = true;
                              //   setState(() {});
                              //   CherryToast.info(
                              //     title: const Text(
                              //       'sent your verification mail...!',
                              //       style: TextStyle(color: Colors.black),
                              //     ),
                              //     actionHandler: () {},
                              //     animationType: AnimationType.fromTop,
                              //   ).show(context);
                              // }
                              AuthService.instance
                                  .sendPasswordResetEmail(email.text);
                              isLoading = false;
                              fromValidation();
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
                                'Set Verification Mail',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20,),
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
      ),
    );
  }
}
