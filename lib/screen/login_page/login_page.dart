import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:widget_explore_hemansee/screen/logoutpage/log_outpage.dart';
import 'package:widget_explore_hemansee/service/auth_service.dart';

class SplacePage extends StatefulWidget {
  const SplacePage({super.key});


  @override
  State<SplacePage> createState() => _SplacePageState();
}

class _SplacePageState extends State<SplacePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Column(
          children: [
            const SizedBox(height: 100,),
        const Center(
          child: SizedBox(
            height: 80,
            width: 100,
            child: Image(image: AssetImage('myassets/img/google.png'),),
          ),
        ),
        const SizedBox(height: 20,),

            Container(
              margin: const EdgeInsets.all(10),
              height: 60,
              width: 400,
              color: Colors.blue,
                child: Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                            margin: const EdgeInsets.all(5),
                            height: 60,
                            width: 60,
                            color: Colors.white,
                            child: Container(
                              margin: const EdgeInsets.all(5),
                              height: 40,
                              width: 40,
                              child: const Image(image: AssetImage('myassets/img/google.png'),),
                            ),
                        )
                      ],
                    ),
                    InkWell(onTap: () async {
                            User? a = await AuthService.instance.signInWithGoogle();
                            if(a!=null)
                            {
                              if (kDebugMode) {
                                print('${a.displayName}');
                              }
                              if (kDebugMode) {
                                print('${a.email}');
                              }
                            }
                            // ignore: use_build_context_synchronously
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                              return SecPage(a);
                            },),);

                    },
                      child: Container(
                        margin: const EdgeInsets.only(left: 30),
                        child: const Text('Sign In With Google',style: TextStyle(fontSize: 20,color: Colors.white),),
                      ),
                    )
                  ],
                ),
            ),

      ],),
    );
  }
}
