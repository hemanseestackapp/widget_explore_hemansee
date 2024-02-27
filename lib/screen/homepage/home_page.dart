import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:widget_explore_hemansee/screen/loginpages/login_pages.dart';
import 'package:widget_explore_hemansee/screen/particular_data/particular_data.dart';
import 'package:widget_explore_hemansee/screen/profilepage/profile_page.dart';
import 'package:widget_explore_hemansee/service/userservice/user_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool admin = false;
  Map<String, dynamic> currentUser = {};

  dynamic getDataUser() async {
    DocumentSnapshot? getUser = await UserService.instance
        .getCurrentDataUser(FirebaseAuth.instance.currentUser!.uid);
    if (getUser != null) {
      currentUser = getUser.data() as Map<String, dynamic>;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getDataUser();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange.shade100,
          actions: [
            InkWell(
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const ProfilePage();
                    },
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.all(10),
                height: 40,
                width: 40,
                child: const CircleAvatar(
                  backgroundImage: AssetImage('myassets/img/user1.jpg'),
                ),
              ),
            ),
          ],
        ),
        drawer: Drawer(
          // surfaceTintColor: Colors.red,
          backgroundColor: Colors.white,
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage('${currentUser['image']}'),
                ),
                accountName: Text(
                  ' ${currentUser['firstName']}',
                  style: const TextStyle(color: Colors.black),
                ),
                accountEmail: Text(
                  ' ${currentUser['email']}',
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(
                height: 500,
              ),
              InkWell(
                onTap: () {
                  GoogleSignIn().signOut();
                  FirebaseAuth.instance.signOut();
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
                  alignment: Alignment.center,
                  height: 40,
                  width: 240,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.red,),
                  child: const Text(
                    'Sign Out',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: (currentUser['userType'] == 'Admin')
            ?
            // (AuthService.instance.userType)?
            StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Text('Error - ${snapshot.error}');
                  }
                  var users = snapshot.data!.docs;
                  return ListView(
                    children: users.map((user) {
                      return Card(
                        color: Colors.orange.shade100,
                        child: (user['userType'] == 'User')
                            ? ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return ParticularData(user);
                                      },
                                    ),
                                  );
                                },
                                title: Text(user['firstName']),
                                subtitle: Text(user['email']),
                                leading: const CircleAvatar(
                                  backgroundImage:
                                      AssetImage('myassets/img/user1.jpg'),
                                ),
                              )
                            : Container(),
                      );
                    }).toList(),
                  );
                },
              )
            : const Text(''),
      ),
      onWillPop: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Are you can exit in app..!'),
              actions: [
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                      child: const Text('Yes'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('No'),
                    ),
                  ],
                )
              ],
            );
          },
        );
        return Future.value(true);
      },
    );
  }
}
