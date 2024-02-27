import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:widget_explore_hemansee/service/user_service/user_service.dart';

class UserDetail extends StatefulWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> user;
  const UserDetail(this.user, {super.key});

  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  Map<String, dynamic> currentUser = {};

  dynamic getDataUser() async {
    DocumentSnapshot? getUser = await UserService.instance
        .getCurrentDataUser(FirebaseAuth.instance.currentUser!.uid);
    if (getUser != null) {
      currentUser = getUser.data() as Map<String, dynamic>;
    }
    setState(() {});
  }

  bool images = false;

  final ImagePicker picker = ImagePicker();

  XFile? image;
  bool imagePicker = false;

  String uId = FirebaseAuth.instance.currentUser!.uid;
  String? imgPath;

  @override
  void initState() {
    super.initState();
    getDataUser();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController t1 = TextEditingController();
    TextEditingController t2 = TextEditingController();
    TextEditingController t3 = TextEditingController();
    TextEditingController t4 = TextEditingController();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.orange.shade100,
        title: Text(
          '${widget.user['firstName']}',
          style: const TextStyle(color: Colors.red),
        ),
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 180,
                  width: double.infinity,
                  color: Colors.orange.shade100,
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 155, 0, 0),
                child: Divider(
                  // color: Colors.green,
                  height: 50,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 120, 0, 0),
                  child: SizedBox(
                    height: 120,
                    width: 120,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(60)),
                      child: (imagePicker)
                          ? (image != null)
                              ? Image.file(
                                  File(image!.path),
                                  fit: BoxFit.cover,
                                )
                              : null
                          : const Image(
                              image: AssetImage('myassets/img/user1.jpg'),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '${widget.user['firstName']}',
                    prefixIcon: const Icon(
                      Icons.person,
                      color: Colors.red,
                    ),
                  ),
                  controller: t1,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '${widget.user['lastName']}',
                    prefixIcon: const Icon(
                      Icons.person,
                      color: Colors.red,
                    ),
                  ),
                  controller: t2,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '${widget.user['mobile']}',
                    prefixIcon: const Icon(
                      Icons.phone_in_talk_outlined,
                      color: Colors.red,
                    ),
                  ),
                  controller: t3,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '${widget.user['email']}',
                    prefixIcon: const Icon(
                      Icons.mail,
                      color: Colors.red,
                    ),
                  ),
                  controller: t4,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
