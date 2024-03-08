import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:widget_explore_hemansee/common/widget/common_text_field.dart';
import 'package:widget_explore_hemansee/service/user_service.dart';

class UserDetailPage extends StatefulWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> user;

  const UserDetailPage(this.user, {super.key});

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
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
              const Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 120, 0, 0),
                  child: SizedBox(
                    height: 120,
                    width: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(60)),
                      child: Image(
                        image: AssetImage('assets/image/user1.jpg'),
                      ),
                      // (imagePicker)
                      //     ? (image != null)
                      //         ? Image.file(
                      //             File(image!.path),
                      //             fit: BoxFit.cover,
                      //           )
                      //         : null
                      //     : const Image(
                      //         image: AssetImage('assets/image/user1.jpg'),
                      //         fit: BoxFit.cover,
                      //       ),
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
              CommonTextFromField(
                controller: t1,
                hintText: '${widget.user['firstName']}',
                prefixIcon: Icons.person,
                color: Colors.red,
                readOnly: true,
              ),
              CommonTextFromField(
                controller: t2,
                hintText: '${widget.user['lastName']}',
                prefixIcon: Icons.person,
                color: Colors.red,
                readOnly: true,
              ),
              CommonTextFromField(
                controller: t3,
                hintText: '${widget.user['mobile']}',
                prefixIcon: Icons.phone_in_talk_outlined,
                color: Colors.red,
              ),
              CommonTextFromField(
                hintText: '${widget.user['email']}',
                prefixIcon: Icons.mail,
                color: Colors.red,
                controller: t4,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
