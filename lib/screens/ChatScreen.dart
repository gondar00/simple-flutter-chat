import 'package:e_doctor/constants/colors.dart';
import 'package:flutter/material.dart';

import 'package:e_doctor/models/ChatMessage.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({this.userType, this.title = 'Conversation between 2', this.texts});

  // invoke native method
  // static const MethodChannel platform = MethodChannel('com.video.sdk/opentok');

  final String userType;
  final String title;
  final List<Message> texts;

  // final appState = Provider.of<AppState>(ChatScreen);
  // print("----printing----uuu");
  // print(appState.token);

  // final List<ChatMessage> messages = [
  //   ChatMessage(
  //       date: "9:10 am", isSentByMe: false, message: "Bike Customer CFP Franc"),
  //   ChatMessage(
  //       date: "9:10 am",
  //       isSentByMe: true,
  //       message: "instruction set grey applications"),
  // ];

  // void _openVideoCallPlatformScreen() async {
  //   try {
  //     await platform.invokeMethod<dynamic>('openVideoChat');
  //   } on PlatformException catch (_) {
  //   }
  // }

  Widget renderChatMessage(Message message, bool patient) {
    if(message.text == null) return Container();
    return Column(
      children: <Widget>[
        Align(
          // TODO(patient): fix display based on token
          alignment: patient ? Alignment.centerRight : Alignment.centerLeft,
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
              color: patient ? DARK_GREEN : PALE_ORANGE,
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
              message.text,
              style: TextStyle(
                fontSize: 16,
                color: WHITE_COLOR,
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
            backgroundColor: userType == 'patient' ? DARK_GREEN : PALE_ORANGE,
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
        title: Text(title),
        centerTitle: false,
        backgroundColor: userType == 'patient' ? DARK_GREEN : PALE_ORANGE,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.call),
            onPressed: () {
              // _openVideoCallPlatformScreen();
            },
          ),
          IconButton(
            icon: Icon(Icons.video_call),
            onPressed: () {
              // _openVideoCallPlatformScreen();
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              itemCount: texts.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (BuildContext ctx, int i) => renderChatMessage(texts[i], userType == 'patient'),
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
