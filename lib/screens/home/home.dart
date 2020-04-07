
import 'package:flutter/material.dart';

import 'package:e_doctor/tabs/ChatsTab.dart';

import 'package:e_doctor/constants/colors.dart';

import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Future<SharedPreferences> _sprefs = SharedPreferences.getInstance();
  Color color;

  Future<void> getData() async {
    print('called');
    final SharedPreferences prefs = await _sprefs;
    Color color = prefs.getString('user-type') == 'patient' ? LIGHT_GREEN : PALE_ORANGE;
    setState(() {
      color = color;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      // length specifies the number of tabs 
      length: 2,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'E-Doctor',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: false,
          backgroundColor: color,
          // bottom: TabBar(
          //   indicatorColor: LIGHT_GREY_COLOR,
          //   tabs: <Widget>[
          //     Tab(
          //       text: 'CHATS',
          //     ),
          //     Tab(
          //       text: 'CALLS',
          //     ),
          //   ],
          // ),
          // actions: <Widget>[
          //   IconButton(
          //     onPressed: () {},
          //     icon: Icon(Icons.search),
          //   ),
          //   IconButton(
          //     onPressed: () {},
          //     icon: Icon(Icons.more_vert),
          //   ),
          // ],
        ),
        body: ChatsTab(),
        // body: TabBarView(
        //   children: <Widget>[
        //     ChatsTab(),
        //     CallsTab(),
        //   ],
        // ),
        // floatingActionButton: FloatingActionButton(
        //   child: Icon(
        //     Icons.chat
        //   ),
        //   onPressed: () {
        //       Navigator.push(context,
        //           MaterialPageRoute(builder: (context) => UserListScreen()));
        //     },
        //   backgroundColor: PALE_ORANGE,
        // ),
      ),
    );
  }
}
