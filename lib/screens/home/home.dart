
import 'package:flutter/material.dart';

import 'package:e_doctor/tabs/CallsTab.dart';
import 'package:e_doctor/tabs/ChatsTab.dart';

import 'package:e_doctor/constants/colors.dart';
// import 'package:e_doctor/constants/gradients.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      // length specifies the number of tabs 
      length: 2,
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
          backgroundColor: PALE_ORANGE,
          bottom: TabBar(
            indicatorColor: LIGHT_GREY_COLOR,
            tabs: <Widget>[
              Tab(
                text: "CHATS",
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
            ChatsTab(),
            CallsTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.chat
          ),
          onPressed: () async {
            // final FirebaseUser user = await FirebaseAuth.instance.currentUser();
          },
          backgroundColor: PALE_ORANGE,
        ),
      ),
    );
  }
}
