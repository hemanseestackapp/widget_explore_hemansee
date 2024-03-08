import 'dart:developer';
import 'dart:io';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:widget_explore_hemansee/common/widget/common_text_field.dart';
import 'package:widget_explore_hemansee/modal/post_modal.dart';
import 'package:widget_explore_hemansee/screen/dashboard_page/dashboard_page.dart';
import 'package:widget_explore_hemansee/service/post_service.dart';
import 'package:widget_explore_hemansee/service/user_service.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  TextEditingController captionTextField = TextEditingController();
  TextEditingController locationTextField = TextEditingController();
  final ImagePicker picker = ImagePicker();
  XFile? image;
  bool imagePicker = false;
  String location = '';
  bool isLoading = false;
  bool imageValidate = false;
  bool captionValidate = false;
  bool locationValidate = false;
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.transparent),
        title: const Text(
          'Add Post',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.all(10),
            height: 40,
            width: 40,
            child:  CircleAvatar(
              backgroundImage: NetworkImage('${currentUser['image']}'),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(40, 40, 40, 10),
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.deepPurple.shade400.withOpacity(0.10),
                ),
                child: Stack(
                  children: [
                    InkWell(
                      onTap: () async {
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
                                        imageValidate = true;
                                        Future.delayed(
                                          const Duration(microseconds: 1),
                                          () {
                                            Navigator.pop(context);
                                          },
                                        );
                                        setState(() {});
                                      },
                                      child: const Text('Camera'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        image = await picker.pickImage(
                                          source: ImageSource.gallery,
                                        );
                                        imagePicker = true;
                                        imageValidate = true;
                                        Future.delayed(
                                          const Duration(microseconds: 1),
                                          () {
                                            Navigator.pop(context);
                                          },
                                        );
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
                      },
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        height: 180,
                        width: 180,
                        child: (image != null)
                            ? Image.file(
                                File(image!.path),
                                fit: BoxFit.cover,
                              )
                            : Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.fromLTRB(
                                      70,
                                      70,
                                      70,
                                      70,
                                    ),
                                    height: 40,
                                    width: 40,
                                    child: const Image(
                                      image: NetworkImage(
                                        'https://cdn-icons-png.flaticon.com/128/685/685655.png',
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
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: TextField(
                  controller: captionTextField,
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple),
                    ),
                    hintText: 'Add a caption....',
                    prefixIcon: Icon(
                      Icons.closed_caption,
                      color: Colors.deepPurple,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10, top: 30, right: 10),
                child: TextField(
                  readOnly: true,
                  onTap: () async {
                    locationTextField.text = location;
                    setState(() {});
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            CommonTextFromField(
                              controller: locationTextField,
                              hintText: 'Enter your location',
                              prefixIcon: Icons.location_on,
                              color: Colors.deepPurple,
                            ),
                            const SizedBox(
                              height: 200,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    location = locationTextField.text;
                                    Navigator.pop(context);
                                    setState(() {});
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 100,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.deepPurple,
                                    ),
                                    child: const Text(
                                      'Add',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 50,
                                ),
                                InkWell(
                                  onTap: () {
                                    locationTextField.text = '';
                                    location = '';
                                    Navigator.pop(context);
                                    setState(() {});
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 100,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.deepPurple,
                                    ),
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                  controller: locationTextField,
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple),
                    ),
                    hintText: 'Add Location...',
                    prefixIcon: Icon(
                      Icons.location_on,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 70,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      if (imageValidate == true) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              title: Container(
                                alignment: Alignment.center,
                                child: const Text(
                                  'Discard edits ?',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              content: const Text(
                                'If you go back now, you will lose all of the edits you have made',
                              ),
                              actions: [
                                const Divider(),
                                InkWell(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return const DashboardPage();
                                        },
                                      ),
                                    );
                                    setState(() {});
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.all(5),
                                    child: const Text(
                                      'Discard',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ),
                                const Divider(),
                                Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.all(5),
                                  child: const Text('Save Draft'),
                                ),
                                const Divider(),
                                Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.all(5),
                                  child: const Text('Keep Editing'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        log('select any other...');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Container(
                              alignment: Alignment.center,
                              child: const Text(
                                'Select any other...',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            backgroundColor: Colors.white,
                            duration: const Duration(seconds: 1),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      height: 40,
                      width: 100,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepPurple,
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      if (image != null) {
                        log('perfect condition.......');
                        imageValidate = true;
                        isLoading = true;
                        setState(() {});

                        var timestamp = Timestamp.now();
                        var postId = '${timestamp.seconds}';
                        String uid = FirebaseAuth.instance.currentUser!.uid;

                        String? imageUrl = await PostService.instance
                            .uploadPost(image, uid, postId);
                        if (imageUrl != null) {
                          PostModal postModal = PostModal(
                            postId: postId,
                            postImage: imageUrl,
                            caption: captionTextField.text,
                            location: locationTextField.text,
                            createBy: FirebaseAuth.instance.currentUser!.uid,
                            isArchived: false,
                            isHidden: false,
                            like: [],
                            share: ['share'],
                            comment: [],
                            save: ['save'],
                            time: DateTime.now().toIso8601String(),
                          );
                          await PostService.instance
                              // ignore: use_build_context_synchronously
                              .createPost(postModal, context);
                          Future.delayed(
                            const Duration(microseconds: 1),
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const DashboardPage();
                                  },
                                ),
                              );
                            },
                          );
                        } else {
                          log('image upload failed');
                        }
                        isLoading = false;
                        setState(() {});
                      } else {
                        log('image upload failed');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Container(
                              alignment: Alignment.center,
                              child: const Text(
                                'Select any other...',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            backgroundColor: Colors.white,
                            duration: const Duration(seconds: 1),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      height: 40,
                      width: 100,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepPurple,
                      ),
                      child: const Text(
                        'Add',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  InkWell(onTap: () {

                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          title: Container(
                            alignment: Alignment.center,
                            child: const Text(
                              'Discard edits ?',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          content: const Text(
                            'If you go back now, you will lose all of the edits you have made',
                          ),
                          actions: [
                            const Divider(),
                            InkWell(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const DashboardPage();
                                    },
                                  ),
                                );
                                setState(() {});
                              },
                              child: Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.all(5),
                                child: const Text(
                                  'Discard',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ),
                            const Divider(),
                            InkWell(onTap: () async {

                              isLoading = true;
                              setState(() {});
                              var timestamp = Timestamp.now();
                              var postId = '${timestamp.seconds}';
                              String uid = FirebaseAuth.instance.currentUser!.uid;

                              String? imageUrl = await PostService.instance
                                  .uploadPost(image, uid, postId);

                              PostModal postModal = PostModal(
                                postId: postId,
                                postImage: imageUrl,
                                caption: captionTextField.text,
                                location: locationTextField.text,
                                createBy: FirebaseAuth.instance.currentUser!.uid,
                                isArchived: false,
                                isHidden: false,
                                isDraft: true,
                                like: [],
                                share: ['share'],
                                comment: [],
                                save: ['save'],
                                time: DateTime.now().toIso8601String(),
                              );

                              await PostService.instance
                                  // ignore: use_build_context_synchronously
                                  .draftPost(postModal, context);

                              CherryToast.info(
                                title: const Text(
                                  'Post saved is draft..',
                                  style: TextStyle(color: Colors.black),
                                ),
                                actionHandler: () {},
                                animationType: AnimationType.fromTop,
                              // ignore: use_build_context_synchronously
                              ).show(context);
                              isLoading = false;
                              setState(() {});

                              Future.delayed(
                                const Duration(microseconds: 1),
                                    () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return const DashboardPage();
                                      },
                                    ),
                                  );
                                },
                              );

                            },
                              child: Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.all(5),
                                child: const Text('Save Draft'),
                              ),
                            ),
                            const Divider(),
                            Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.all(5),
                              child: const Text('Keep Editing'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                    child: Container(
                      height: 40,
                      width: 100,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepPurple,
                      ),
                      child: const Text(
                        'Draft',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (isLoading == true)
            Center(
              heightFactor: double.infinity,
              widthFactor: double.infinity,
              child: CircularProgressIndicator(
                color: Colors.deepPurple.withOpacity(0.3),
              ),
            ),
        ],
      ),
    );
  }
}
