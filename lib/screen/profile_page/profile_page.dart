import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:widget_explore_hemansee/common/widget/common_text_field.dart';
import 'package:widget_explore_hemansee/screen/archivepost_page/archievpost_page.dart';
import 'package:widget_explore_hemansee/service/user_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> currentUser = {};

  dynamic getDataUser() async {
    DocumentSnapshot? getUser = await UserService.instance
        .getCurrentDataUser(FirebaseAuth.instance.currentUser!.uid);
    setState(() {});
    if (getUser != null) {
      currentUser = getUser.data() as Map<String, dynamic>;
      setState(() {});
    }
  }

  final ImagePicker picker = ImagePicker();
  XFile? image;
  bool imagePicker = false;
  bool images = false;

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
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const ArchivePostPage();
            },),);
          }, icon: const Icon(Icons.archive),color: Colors.white,),
        ],
      ),
      // ignore: unnecessary_null_comparison
      body: (currentUser != null)
          ? Column(
              children: [
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 120,
                        width: double.infinity,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 95, 0, 0),
                      child: Divider(
                        height: 50,
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
                        child: SizedBox(
                          height: 120,
                          width: 120,
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(60)),
                            child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(currentUser['uid'])
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Container();
                                }
                                if (snapshot.hasError) {
                                  return const Text(
                                    'error--------------------',
                                  );
                                }
                                return (currentUser['image'] != null &&
                                            currentUser['image'] != '' ||
                                        image != null)
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(80),
                                        child: (currentUser['image'] != null &&
                                                currentUser['image'] != '' &&
                                                !imagePicker)
                                            ? CachedNetworkImage(
                                                imageUrl:
                                                    '${currentUser['image']}',
                                                fit: BoxFit.cover,
                                              )
                                            : (image != null)
                                                ? Image.file(
                                                    File(image!.path),
                                                    fit: BoxFit.cover,
                                                  )
                                                : const Image(
                                                    image: AssetImage(
                                                      'assets/image/user1.jpg',
                                                    ),
                                                    fit: BoxFit.cover,
                                                  ),
                                      )
                                    : const Image(
                                        image: AssetImage(
                                          'assets/image/user1.jpg',
                                        ),
                                        fit: BoxFit.cover,
                                      );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 40,
                      margin: const EdgeInsets.fromLTRB(207, 140, 20, 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Choose image'),
                                actions: [
                                  Row(
                                    children: [
                                      TextButton(
                                        onPressed: () async {
                                          image = await picker.pickImage(
                                            source: ImageSource.camera,
                                          );
                                          imagePicker = true;
                                          File file = File(image!.path);
                                          Future.delayed(
                                            const Duration(microseconds: 1),
                                            () {
                                              Navigator.pop(context);
                                            },
                                          );
                                          if (image != null) {
                                            await UserService.instance.imageRef(
                                              file,
                                              currentUser['uid'],
                                            );
                                            getDataUser();
                                          }

                                          setState(() {});
                                        },
                                        child: const Text('camera'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          image = await picker.pickImage(
                                            source: ImageSource.gallery,
                                          );
                                          imagePicker = true;
                                          File file = File(image!.path);
                                          Future.delayed(
                                            const Duration(microseconds: 1),
                                            () {
                                              Navigator.pop(context);
                                            },
                                          );
                                          await UserService.instance.imageRef(
                                            file,
                                            currentUser['uid'],
                                          );
                                          getDataUser();
                                          setState(() {});
                                        },
                                        child: const Text('Gallery'),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          );
                          // setState(() {});
                        },
                        icon: const Icon(Icons.camera_alt),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    CommonTextFromField(
                      hintText: '${currentUser['firstName']}',
                      prefixIcon: Icons.person,
                      color: Colors.deepPurple,
                      readOnly: true,
                      controller: t1,
                    ),
                    CommonTextFromField(
                      hintText: '${currentUser['lastName']}',
                      prefixIcon: Icons.person,
                      color: Colors.deepPurple,
                      readOnly: true,
                      controller: t2,
                    ),
                    CommonTextFromField(
                      hintText: '${currentUser['mobile']}',
                      prefixIcon: Icons.phone_in_talk_outlined,
                      color: Colors.deepPurple,
                      readOnly: true,
                      controller: t3,
                    ),
                    CommonTextFromField(
                      hintText: '${currentUser['email']}',
                      prefixIcon: Icons.email,
                      color: Colors.deepPurple,
                      readOnly: true,
                      controller: t4,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () async {
                        String downloadLink =
                            '$imgPath'; // Replace with the actual download link
                        UserService.instance.updateImageURL(uId, downloadLink);
                        imagePicker = true;
                      },
                      child: Container(
                        height: 50,
                        width: 320,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.deepPurple,
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Update',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
