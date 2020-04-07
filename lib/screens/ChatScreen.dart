import 'package:e_doctor/constants/colors.dart';
import 'package:flutter/material.dart';

import 'package:e_doctor/models/ChatListItem.dart';
import 'package:e_doctor/models/ChatMessage.dart';

import 'package:flutter/services.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({this.person});

  static const MethodChannel platform = MethodChannel('com.video.sdk/opentok');

  final ChatListItem person;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final Future<SharedPreferences> _sprefs = SharedPreferences.getInstance();
  Color color;

  Future<void> getData() async {
    final SharedPreferences prefs = await _sprefs;
    print('print------');
    print(prefs.getString('user-type') == 'patient');
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

  final List<ChatMessage> messages = [
    ChatMessage(
        date: "9:10 am", isSentByMe: false, message: "Message not from me"),
    ChatMessage(
        date: "9:10 am",
        isSentByMe: true,
        message: "Message from me"),
  ];

  void _openVideoCallPlatformScreen() async {
    try {
      await ChatScreen.platform.invokeMethod<dynamic>('openVideoChat');
    } on PlatformException catch (_) {
    }
  }

  Widget renderChatMessage(ChatMessage message) {
    return Column(
      children: <Widget>[
        Align(
          alignment:
              message.isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            // margin: EdgeInsets.symmetric(
            //   horizontal: 20,
            //   vertical: 10,
            // ),
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: message.isSentByMe ? color : Colors.grey[200],
              boxShadow: [
                BoxShadow(
                  blurRadius: 2,
                  color: Color(0x22000000),
                  offset: Offset(1, 2),
                ),
              ],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              message.message,
              style: TextStyle(
                fontSize: 16,
                color: message.isSentByMe ? WHITE_COLOR : Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget renderTextBox() {
    return Container(
      margin: EdgeInsets.only(
        bottom: 20,
        left: 10,
        right: 10,
      ),
      child: Row(
        children: <Widget>[
          Flexible(
            child: Container(
              child: TextField(
                decoration: InputDecoration.collapsed(
                  hintText: 'Your Message Here',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.attach_file,color: Colors.black,),
            onPressed: () {},
          ),
          FloatingActionButton(
            mini: true,
            backgroundColor: LIGHT_GREEN,
            onPressed: (){},
            child: Icon(Icons.send,),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WHITE_COLOR,
      appBar: AppBar(
        title: Text('title'),
        centerTitle: false,
        backgroundColor: color,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.call),
            onPressed: () {
              _openVideoCallPlatformScreen();
            },
          ),
          IconButton(
            icon: Icon(Icons.video_call),
            onPressed: () {
              print('print------');
              print(color);
              // _openVideoCallPlatformScreen();
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              itemCount: messages.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (BuildContext ctx, int i) => renderChatMessage(messages[i]),
            ),
          ),
          Divider(),
          Container(
            child: renderTextBox(),
          ),
        ],
      ),
    );
  }
}
