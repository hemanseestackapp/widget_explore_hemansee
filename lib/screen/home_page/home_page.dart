import 'package:cached_network_image/cached_network_image.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:widget_explore_hemansee/common/widget/common_text_field.dart';
import 'package:widget_explore_hemansee/modal/post_modal.dart';
import 'package:widget_explore_hemansee/screen/login_page/login_page.dart';
import 'package:widget_explore_hemansee/screen/profile_page/profile_page.dart';
import 'package:widget_explore_hemansee/service/post_service.dart';
import 'package:widget_explore_hemansee/service/user_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController commentTextField = TextEditingController();
  bool admin = false;
  bool canPop = false;
  Map<String, dynamic> currentUser = {};
  bool isLike = false;
  bool favourites = false;
  String send='';
  bool save = false;


  List<dynamic> likeList = [];
  String currentUserId = '';
  List<String> comments = [];
  List<dynamic>? commentList = [];


  dynamic getDataUser() async {
    DocumentSnapshot? getUser = await UserService.instance
        .getCurrentDataUser(FirebaseAuth.instance.currentUser!.uid);
    if (getUser != null) {
      currentUser = getUser.data() as Map<String, dynamic>;
    }
    setState(() {});
  }

  String timeDuration(String time) {
    DateTime postDateTime = DateTime.parse(time);
    Duration difference = DateTime.now().difference(postDateTime);

    if (difference.inDays > 0) {
      String formattedDateTime =
          DateFormat('EEEE, dd MMMM, yyyy HH:mm:ss a').format(postDateTime);

      return formattedDateTime;
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else {
      return 'Just now';
    }
  }

  @override
  void initState() {
    super.initState();
    getDataUser();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      onPopInvoked: (value) {
        setState(() {
          canPop = !value;
        });
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Homepage',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.deepPurple,
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
                  backgroundImage: AssetImage('assets/image/user1.jpg'),
                ),
              ),
            ),
          ],
        ),
        drawer: Drawer(
          // surfaceTintColor: Colors.red,
          backgroundColor: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(currentUser['uid'])
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    Map<String, dynamic> userData =
                    snapshot.data!.data() as Map<String, dynamic>;

                    return UserAccountsDrawerHeader(
                      decoration: const BoxDecoration(
                        color: Colors.deepPurple,
                      ),
                      currentAccountPicture: (userData['image'] != null)
                          ? CircleAvatar(
                        backgroundImage:
                        NetworkImage('${userData['image']}'),
                      )
                          : const CircleAvatar(
                        backgroundImage:
                        AssetImage('assets/image/user1.jpg'),
                      ),
                      accountName: Text(
                        ' ${currentUser['firstName']}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      accountEmail: Text(
                        ' ${currentUser['email']}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  },
                ),
                InkWell(
                  onTap: () {
                    GoogleSignIn().signOut();
                    FirebaseAuth.instance.signOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const LoginPage();
                        },
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 400),
                    alignment: Alignment.center,
                    height: 40,
                    width: 240,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.deepPurple,
                    ),
                    child: const Text(
                      'Sign Out',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: StreamBuilder(
          stream: PostService.instance.postUser(),
          builder: (context, snapshotPost) {

            if (snapshotPost.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.builder(
              itemCount: snapshotPost.data!.docs.length,
              itemBuilder: (context, index) {
                if (snapshotPost.data != null && snapshotPost.hasData) {
                  DocumentSnapshot postDocument =
                      snapshotPost.data!.docs[index];

                  String userId = postDocument['createBy'];
                  Map<String, dynamic> data =
                      postDocument.data() as Map<String, dynamic>;

                  return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: PostService.instance.createPostUser(userId),
                    builder: (context, postSnapshot) {

                      if (postSnapshot.hasData && postSnapshot.data != null) {

                        DocumentSnapshot<Map<String, dynamic>>? userDocument =
                            postSnapshot.data;

                        Map<String, dynamic> currentUser =
                        userDocument?.data() as Map<String, dynamic>;

                        if(data['isDraft']!= true && data['isArchived'] != true)
                        {
                          return Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                                height: 480,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color:
                                  Colors.deepPurple.shade100.withOpacity(0.39),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(20),
                                              color: Colors.white,
                                            ),
                                            child: ClipOval(
                                              child: Image.network(
                                                '${currentUser['image']}',
                                                fit: BoxFit.cover,
                                                width: 40,
                                                height: 40,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        (data['location'] != '')
                                            ? Expanded(
                                              child: Text(
                                                '${currentUser['firstName']}\n${data['location']}',
                                              ),
                                            )
                                            : Expanded(
                                              child: Text(
                                                '${currentUser['firstName']}',
                                              ),
                                            ),
                                        IconButton(
                                          padding: const EdgeInsets.only(left: 100),
                                          onPressed: () {
                                            if(currentUser['uid']==FirebaseAuth.instance.currentUser!.uid)
                                              {
                                                    showModalBottomSheet(
                                                  context: context,
                                                  builder: (context) {
                                                    return Column(
                                                      children: [
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Container(
                                                          height: 7,
                                                          width: 80,
                                                          color: Colors.deepPurple,
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Container(
                                                          margin: const EdgeInsets.only(top: 10),
                                                          alignment: Alignment.center,
                                                          child: const Text('Menu',style: TextStyle(fontSize: 15),),
                                                        ),
                                                        const SizedBox(
                                                          height: 8,
                                                        ),
                                                        const Divider(
                                                          height: 50,
                                                          color: Colors.grey,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Container(
                                                              margin: const EdgeInsets.only(left: 20),
                                                              child: const CircleAvatar(
                                                                backgroundImage: NetworkImage('https://cdn-icons-png.flaticon.com/128/4080/4080957.png'),
                                                              ),
                                                            ),
                                                            InkWell(onTap: () async {
                                                              String postId = data['postId'];

                                                              await FirebaseFirestore.instance.collection('post').doc(postId).update({
                                                                'isArchived': true,
                                                              });

                                                              Future.delayed(const Duration(microseconds: 1),() {
                                                                   Navigator.pop(context);
                                                              },);
                                                              setState(() {});
                                                            },
                                                              child: Container(
                                                                margin: const EdgeInsets.only(left: 20),
                                                                child: const Text('Archive'),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              } else
                                                {
                                                  CherryToast.info(
                                                    title: const Text(
                                                      'Only admin can is post are archived..!',
                                                      style: TextStyle(color: Colors.black),
                                                    ),
                                                    actionHandler: () {},
                                                    animationType: AnimationType.fromTop,
                                                  ).show(context);
                                                }

                                        }, icon: const Icon(Icons.more_vert),),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      height: 300,
                                      width: 300,
                                      color: Colors.white,
                                      child: AspectRatio(
                                        aspectRatio: 1 / 1,
                                        child: CachedNetworkImage(
                                          imageUrl: '${data['postImage']}',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            String postId = data['postId'];
                                            currentUserId = FirebaseAuth.instance.currentUser!.uid;

                                            List<String> likeList = List<String>.from(data['like'] ?? []);

                                            if (likeList.contains(currentUserId)) {
                                              likeList.remove(currentUserId);
                                            } else {
                                              likeList.add(currentUserId);
                                            }

                                            await FirebaseFirestore.instance
                                                .collection('post')
                                                .doc(postId)
                                                .update({'like': likeList});
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(left: 15),
                                            height: 20,
                                            width: 20,
                                            child: Image(
                                              image: NetworkImage(
                                                (data['like'] != null && data['like'].contains(currentUserId))
                                                    ? 'https://cdn-icons-png.flaticon.com/128/2589/2589054.png'
                                                    : 'https://cdn-icons-png.flaticon.com/128/535/535285.png',
                                              ),
                                            ),
                                          ),
                                        ),

                                        InkWell(
                                          onTap: () {
                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              builder: (context) {
                                                return SizedBox(
                                                  height: 600,
                                                  child: Column(
                                                    children: [
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Container(
                                                        height: 7,
                                                        width: 80,
                                                        color: Colors.deepPurple,
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Container(
                                                        margin: const EdgeInsets.only(top: 10),
                                                        alignment: Alignment.center,
                                                        child: const Text('Comment',style: TextStyle(fontSize: 15),),
                                                      ),
                                                      const SizedBox(
                                                        height: 8,
                                                      ),
                                                      const Divider(
                                                        height: 50,
                                                        color: Colors.grey,
                                                      ),
                                                      Expanded(
                                                        child: StreamBuilder(
                                                          stream: FirebaseFirestore.instance.collection('post').doc(data['postId']).snapshots(),
                                                          builder: (context, snapshotComment) {
                                                            if(snapshotComment.hasData)
                                                            {
                                                              List<dynamic>? commentList = snapshotComment.data!['comment'];
                                                              if(commentList!=null)
                                                              {
                                                                return ListView.builder(
                                                                  itemCount: commentList.length,
                                                                  itemBuilder: (context, index) {

                                                                    Comment comment = Comment.fromJson(commentList[index]);

                                                                    return ListTile(
                                                                      title: Text('${currentUser['firstName']}'),
                                                                      subtitle: Text(comment.comment),
                                                                      leading: CircleAvatar(
                                                                        backgroundImage: NetworkImage('${currentUser['image']}'),
                                                                      ),
                                                                    );
                                                                  },
                                                                );
                                                              }else
                                                              {
                                                                return const Center(child: Text('no comment available'),);
                                                              }
                                                            }else
                                                            {
                                                              return const Center(child: Text('error'),);
                                                            }

                                                          },
                                                        ),
                                                      ),
                                                      Padding(padding: const EdgeInsets.only(top: 20),
                                                        child: CommonTextFromField(
                                                          controller: commentTextField,
                                                          hintText: (send.isNotEmpty) ?'Add Comment....': send ,
                                                          labelText: 'Add Comments...',
                                                          prefixIcon: Icons.comment,
                                                          color: Colors.deepPurple,
                                                          suffixIcon: IconButton(onPressed: () async {
                                                            send = commentTextField.text;
                                                            DocumentSnapshot postDoc = await FirebaseFirestore.instance.collection('post').doc(data['postId']).get();
                                                            List<dynamic>? existingComments = postDoc['comment'];

                                                            Comment newComment = Comment(
                                                              commentBy: currentUser['uid'],
                                                              time: DateTime.now().toString(),
                                                              comment: commentTextField.text,
                                                              commentLike: [],
                                                            );

                                                            if (existingComments != null) {
                                                              existingComments.add(newComment.toJson());
                                                            } else {
                                                              existingComments = [newComment.toJson()];
                                                            }

                                                            await FirebaseFirestore.instance
                                                                .collection('post')
                                                                .doc(data['postId'])
                                                                .update({'comment': existingComments});

                                                            commentTextField.clear();
                                                            send = '';
                                                            setState(() {});
                                                          }, icon: const Icon(Icons.send),),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(left: 15),
                                            height: 20,
                                            width: 20,
                                            child: const Image(
                                              image: NetworkImage(
                                                'https://cdn-icons-png.flaticon.com/128/2462/2462719.png',
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(left: 10),
                                          height: 20,
                                          width: 20,
                                          child: const Image(
                                            image: NetworkImage(
                                              'https://cdn-icons-png.flaticon.com/128/2099/2099085.png',
                                            ),
                                          ),
                                        ),
                                        InkWell(onTap: () async {

                                          String postId = data['postId'];
                                          String userId = currentUser['uid'];
                                           save = true;
                                          await FirebaseFirestore.instance.collection('post').doc(postId).update({
                                            'uid': userId,
                                          });

                                          if(save == true)
                                            {
                                              // ignore: use_build_context_synchronously
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Container(
                                                    alignment: Alignment.center,
                                                    child: const Text(
                                                      'saved to post',
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
                                            margin: const EdgeInsets.only(left: 190),
                                            height: 20,
                                            width: 20,
                                            child: const Image(
                                              image: NetworkImage(
                                                // (save)?'https://cdn-icons-png.flaticon.com/128/102/102279.png':
                                                'https://cdn-icons-png.flaticon.com/128/9511/9511721.png',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      margin: const EdgeInsets.only(left: 10),
                                      // child: Text(
                                      //   // '${likeList.length} likes',
                                      //   style: const TextStyle(fontSize: 15),
                                      // ),
                                    ),
                                    const SizedBox(
                                      height: 1,
                                    ),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      margin: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        '${data['caption']}',
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ),
                                    // const SizedBox(height: 10,),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      margin: const EdgeInsets.only(left: 10),
                                      child:
                                      Text(timeDuration(data['timeDuration'])),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                        else
                        {
                          return Container();
                        }
                      }
                      else
                        {
                          return Container();
                        }
                    },

                  );
                } else {
                  return Container();
                }
              },
              padding: const EdgeInsets.symmetric(vertical: 25),
            );
          },
        ),
      ),
    );
  }
}
