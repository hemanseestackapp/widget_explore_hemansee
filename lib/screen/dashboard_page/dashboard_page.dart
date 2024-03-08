import 'package:flutter/material.dart';
import 'package:widget_explore_hemansee/screen/addpost_page/addpost_page.dart';
import 'package:widget_explore_hemansee/screen/home_page/home_page.dart';
import 'package:widget_explore_hemansee/screen/profile_page/profile_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int index = 0;
  List page = [
    const HomePage(),
    const PostPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: page[index],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple.shade300,
        onPressed: () {
          index = 1;
          setState(() {});
        },
        shape: const CircleBorder(eccentricity: 0.5),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomAppBar(
        color: Colors.deepPurple,
        shape: const CircularNotchedRectangle(),
        notchMargin: 5.0,
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: kBottomNavigationBarHeight,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  index = 0;
                  setState(() {});
                },
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepPurple,),
                    child: const Image(
                      image: NetworkImage(
                          'https://cdn-icons-png.flaticon.com/128/4175/4175279.png',),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  index = 2;
                  setState(() {});
                },
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepPurple,),
                    child: const Image(
                        image: NetworkImage(
                            'https://cdn-icons-png.flaticon.com/128/9131/9131646.png',),
                        color: Colors.white,),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
