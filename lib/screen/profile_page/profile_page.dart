import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:widget_explore_hemansee/service/user_service/user_service.dart';

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
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.red),
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
                    // color: Colors.blueGrey,
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
              Container(
                height: 40,
                width: 40,
                margin: const EdgeInsets.fromLTRB(207, 205, 20, 0),
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
                                        source: ImageSource.camera,);
                                    imagePicker = true;
                                    log('path = $image');
                                    File file = File(image!.path);
                                    Future.delayed(
                                      const Duration(microseconds: 1),
                                      () {
                                        Navigator.pop(context);
                                      },
                                    );
                                    UserService.instance.imageRef(file, uId);
                                    setState(() {});
                                  },
                                  child: const Text('Camera'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    image = await picker.pickImage(
                                        source: ImageSource.gallery,);
                                    imagePicker = true;
                                    log('path = $image');
                                    File file = File(image!.path);
                                    Future.delayed(
                                      const Duration(microseconds: 1),
                                      () {
                                        Navigator.pop(context);
                                      },
                                    );
                                    UserService.instance.imageRef(file, uId);
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
                    setState(() {});
                  },
                  icon: const Icon(Icons.camera_alt),
                ),
              )
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
                    hintText: '${currentUser['firstName']}',
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
                    hintText: '${currentUser['lastName']}',
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
                    hintText: '${currentUser['mobile']}',
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
                    hintText: '${currentUser['email']}',
                    prefixIcon: const Icon(
                      Icons.mail,
                      color: Colors.red,
                    ),
                  ),
                  controller: t4,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              InkWell(
                onTap: () async {
                  // String? pickedImagePath = await UserService.instance.pickImage();
                  //
                  // if (pickedImagePath != null) {
                  //   setState(() {
                  //     imgPath = pickedImagePath;
                  //   });
                  //
                  //   String? downloadLink = await UserService.instance.uploadImageToFirebaseStorage(pickedImagePath);
                  //
                  //   if (downloadLink != null) {
                  //     await UserService.instance.updateImageURL(uId, downloadLink);
                  //   } else {
                  //     // Handle the case where downloadLink is null (upload failed)
                  //     print('Error uploading image to Firebase Storage.');
                  //   }
                  // } else {
                  //   // Handle the case where pickedImagePath is null (user canceled image picking)
                  //   print('Image picking canceled.');
                  // }

                  String downloadLink =
                      '$imgPath'; // Replace with the actual download link
                  UserService.instance.updateImageURL(uId, downloadLink);
                  imagePicker = true;

                  // String? pickedImagePath = await UserService.instance.pickImage();
                  // if (pickedImagePath != null) {
                  //   setState(() {
                  //     imgPath = pickedImagePath;
                  //   });
                  //   String? downloadLink = await UserService.instance.uploadImageToFirebaseStorage(pickedImagePath);
                  //   await UserService.instance.updateImageURL(uId, downloadLink!);
                  // }
                  // Navigator.push(context, MaterialPageRoute(builder: (context) {
                  //     return const LoginPages();
                  // },),);
                },
                child: Container(
                  height: 50,
                  width: 320,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.red,),
                  alignment: Alignment.center,
                  child: const Text(
                    'Update',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
