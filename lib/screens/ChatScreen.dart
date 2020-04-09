import 'dart:io';

import 'package:e_doctor/constants/colors.dart';
import 'package:flutter/material.dart';

import 'package:e_doctor/models/ChatMessage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path/path.dart' as Path;

import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:e_doctor/screens/chat_gql.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({this.id, this.userType, this.title = 'Conversation between 2', this.texts});

  // invoke native method
  // static const MethodChannel platform = MethodChannel('com.video.sdk/opentok');

  final String id;
  final String userType;
  final String title;
  final List<Message> texts;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // File _image;
  // String _uploadedFileURL;
  bool isLoading = false;
  Future<void> chooseFile() async {
    setState(() {
      isLoading = true;
    });
    await ImagePicker.pickImage(source: ImageSource.gallery).then((File image) async {
      final StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('images/${Path.basename(image.path)}}');
      final StorageUploadTask uploadTask = storageReference.putFile(image);
      await uploadTask.onComplete;
      storageReference
        .getDownloadURL()
        .then((dynamic fileURL) {
          print('-------File Uploaded--------');
          print(fileURL as String);
          // now send message 
          setState(() {
            isLoading = false;
          });
      });
    });
  }

  static const MethodChannel platform = MethodChannel('com.video.sdk/opentok');

  void _openVideoCallPlatformScreen() async {
    try {
      await platform.invokeMethod<dynamic>('openVideoChat');
    } on PlatformException catch (_) {
    }
  }

  Future<bool> isMe(String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('uid') == uid;
  }

  Widget renderChatMessage(Message message, bool patient) {
    print('--------printing-----message');
    print(message.text);
    if(message.text == null) return Container();
    return Column(
      children: <Widget>[
        Align(
          // TODO(patient): fix display based on token
          alignment: isMe(message.id) != false ? Alignment.centerRight : Alignment.centerLeft,
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

  Widget loader() {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20), 
      child: const Center( child: CupertinoActivityIndicator())
    );
  }

  Widget newChatMutationComponent() {
    return Mutation(
      options: MutationOptions(
        documentNode: gql(sendTextMessageMutation),
        update: (Cache cache, QueryResult result) => cache,
        onCompleted: (dynamic result) {
          print('-----created-----message');
          // print(result);
          // print(result.exception && result.exception);
          // Navigator.pop(context);
        },
      ),
      builder: (RunMutation run, QueryResult result) {
        // return flatButtonComponent(
        //   "START CHAT",
        //   selectionList.length == 0
        //       ? null
        //       : () {
        //             run({'participantIds': selectionList, 'name': 'test'});
        //         },
        //   primary: true,
        // );

        return FloatingActionButton(
          mini: true,
          backgroundColor: widget.userType == 'patient' ? DARK_GREEN : PALE_ORANGE,
          onPressed: (){
            run({'conversationId': widget.id, 'text': _input});
          },
          child: Icon(Icons.message, color: Colors.white),
        );
      },
    );
  }

  String _input;

  void setInputValue(String value) {
    setState(() {
      _input = value;
    });
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
                onChanged: (String value) => setInputValue(value),
                decoration: InputDecoration.collapsed(
                  hintText: 'Your Message Here',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            child: loader(),
            visible: isLoading,
          ),
          Visibility(
            child: IconButton(
              icon: Icon(Icons.attach_file, color: Colors.black),
              onPressed: chooseFile,
            ),
            visible: !isLoading,
          ),
          newChatMutationComponent()
        ],
      ),
    );
  }

  Widget subscriptionComponent() {
    return Subscription<Map<String, dynamic>>(
      'onTextAdded', 
      subscriptionNewText,
      onCompleted: () { print("subscription"); },
      builder: ({
        bool loading,
        Map<String, dynamic> payload,
        dynamic error,
      }) {
      print("----updated----payloadnoo");
      
      if(loading)
       return loader();

      print("----updated----payload");
      print(payload);
      
      return Flexible(
        child: ListView.builder(
          itemCount: widget.texts.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (BuildContext ctx, int i) => renderChatMessage(widget.texts[i], widget.userType == 'patient'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WHITE_COLOR,
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: false,
        backgroundColor: widget.userType == 'patient' ? DARK_GREEN : PALE_ORANGE,
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
              // _openVideoCallPlatformScreen();
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          subscriptionComponent(),
          Divider(),
          Container(
            child: renderTextBox(),
          ),
        ],
      ),
    );
  }
}
