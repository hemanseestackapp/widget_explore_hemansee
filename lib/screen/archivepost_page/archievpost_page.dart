import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:widget_explore_hemansee/service/post_service.dart';
import 'package:widget_explore_hemansee/service/user_service.dart';

class ArchivePostPage extends StatefulWidget {
  const ArchivePostPage({super.key});

  @override
  State<ArchivePostPage> createState() => _ArchivePostPageState();
}

class _ArchivePostPageState extends State<ArchivePostPage> {

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
      appBar: AppBar(
        title: const Text('Archive Post'),
      ),
      body: StreamBuilder(
        stream: PostService.instance.postUser(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting)
            {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

          List<DocumentSnapshot> archivedPosts = snapshot.data!.docs
              .where((post) => post['isArchived'] == true)
              .toList();

              return ListView.builder(
                itemCount: archivedPosts.length,
                itemBuilder: (context, index) {

                  var post = archivedPosts[index];
                  return Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                        height: 440,
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
                                Expanded(
                                  child: (post['location'] != '')
                                      ? Text(
                                    '${currentUser['firstName']}\n${post['location']}',
                                  )
                                      : Center(
                                    child: Text(
                                      '${currentUser['firstName']}',
                                    ),
                                  ),
                                ),
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
                                  imageUrl: '${post['postImage']}',
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
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
                                '${post['caption']}',
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                            // const SizedBox(height: 10,),
                            Container(
                              alignment: Alignment.topLeft,
                              margin: const EdgeInsets.only(left: 10),
                              // child:
                              // Text(timeDuration(data['timeDuration'])),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },);
        },
      ),
    );
  }
}
