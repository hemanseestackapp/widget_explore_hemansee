import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../mobauth/mob_auth.dart';
// ignore: must_be_immutable
class SecPage extends StatefulWidget {
  User? a;

  SecPage(this.a, {super.key});

  @override
  State<SecPage> createState() => _SecPageState();
}

class _SecPageState extends State<SecPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Expanded(
            child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40),bottomRight: Radius.circular(40)),
              color: Colors.deepPurple),
              child: Column(
                children: [Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(100, 100, 100, 60),
                      height: 160,
                      width: 160,
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
                  // SizedBox(height: 10,),
                  Container(
                    alignment: Alignment.center,
                    child: const Text( "Create An Account",
                      style: TextStyle(
                          color: Colors.white, fontSize: 25),),
                  )
                ]
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
                  const SizedBox(height: 40,),
                  Text("${widget.a?.displayName}",style: const TextStyle(fontSize: 20,color: Colors.deepPurple),),
                  Text("${widget.a?.email}",style: const TextStyle(fontSize: 20,color: Colors.deepPurple),),
                  const SizedBox(height: 60,),
                  InkWell(onTap: () {
                      GoogleSignIn().signOut();
                      FirebaseAuth.instance.signOut();

                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                        return const MobAuth();
                      },));
                  },
                    child: Container(
                      height: 40,
                      width: 140,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(40),color: Colors.deepPurple),
                      child: const Text("Sign Out",style: TextStyle(color: Colors.white,fontSize: 15),),
                    ),
                  ),
                ],
              ),
        )),
      ]),
    );
  }
}
