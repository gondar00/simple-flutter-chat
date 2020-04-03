
import 'package:flutter/material.dart';

import 'package:e_doctor/tabs/CallsTab.dart';
import 'package:e_doctor/tabs/CameraTab.dart';
import 'package:e_doctor/tabs/ChatsTab.dart';
import 'package:e_doctor/tabs/StatusTab.dart';

import 'package:e_doctor/constants/colors.dart';
// import 'package:e_doctor/constants/gradients.dart';

import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  HomePage() {
    print(getCurrentUser());
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "E-Doctor",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: false,
          backgroundColor: LIGHT_GREEN,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.camera_alt),
              ),
              Tab(
                text: "CHATS",
              ),
              Tab(
                text: "STATUS",
              ),
              Tab(
                text: "CALLS",
              ),
            ],
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.search),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.more_vert),
            ),
          ],
        ),
        body: TabBarView(
          children: <Widget>[
            CameraTab(),
            ChatsTab(),
            StatusTab(),
            CallsTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.chat
          ),
          onPressed: (){},
          backgroundColor: PALE_ORANGE,
        ),
      ),
    );
  }
}
