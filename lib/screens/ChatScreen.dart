import 'package:e_doctor/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:e_doctor/config/config.dart';

import 'package:e_doctor/models/ChatListItem.dart';
import 'package:e_doctor/models/ChatMessage.dart';

import 'package:e_doctor/screens/VideoScreen.dart';

class ChatScreen extends StatelessWidget {
  final ChatListItem person;

  ChatScreen({this.person});

  final List<ChatMessage> messages = [
    ChatMessage(
        date: "9:10 am", isSentByMe: false, message: "Bike Customer CFP Franc"),
    ChatMessage(
        date: "9:10 am",
        isSentByMe: true,
        message: "instruction set grey applications"),
  ];

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
              color: message.isSentByMe ? PALE_ORANGE : Colors.grey[200],
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
                  hintText: "Your Message Here",
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
        backgroundColor: PALE_ORANGE,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.call),
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => VideoScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.video_call),
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => VideoScreen(),
                ),
              );
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
              itemBuilder: (ctx, i) => renderChatMessage(messages[i]),
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
