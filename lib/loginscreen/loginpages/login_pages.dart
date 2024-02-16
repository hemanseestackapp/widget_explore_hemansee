import 'package:flutter/material.dart';

void main()
{
      runApp(MaterialApp(debugShowCheckedModeBanner: false,home: LoginPages(),));
}
class LoginPages extends StatefulWidget {
  const LoginPages({super.key});

  @override
  State<LoginPages> createState() => _LoginPagesState();
}

class _LoginPagesState extends State<LoginPages> {
  TextEditingController emailTextField=TextEditingController();
  TextEditingController passwordTextField=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Container(
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
                            borderRadius: BorderRadius.circular(80),color: Colors.white
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(25),
                          child: const Image(image: AssetImage("myassets/img/user1.jpg"),fit: BoxFit.fill,),
                        )
                    ),
              ],
            ),
          Container(
                  alignment: Alignment.center,
                  child: Text("Create An Account",style: TextStyle(fontSize: 20,color: Colors.orange.shade900),),
                ),
            SizedBox(height: 40,),
            Expanded(child: Container(
                decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
                color: Colors.white),
              child: Column(children: [
                SizedBox(height: 40,),
                Container(
                  child: TextField(
                            controller: emailTextField,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.note_alt_sharp,
                                color: Colors.red,
                              ),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)),
                              hintText: "Email",
                              labelText: 'Enter Your Email',
                              border: const OutlineInputBorder(),
                            ),
                          ),
                )
              ]),
            ))
          ],
        ),
      )
    );
  }
}
