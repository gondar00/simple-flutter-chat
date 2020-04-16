import 'dart:async';
import 'dart:io';
import 'package:jiffy/jiffy.dart';

import 'package:e_doctor/constants/colors.dart';
import 'package:flutter/material.dart';

import 'package:e_doctor/models/ChatMessage.dart';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:path/path.dart' as path;

import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:e_doctor/screens/chat_gql.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:jitsi_meet/jitsi_meet.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:location/location.dart' as geo_location;

import 'package:file_picker/file_picker.dart';

import 'package:flutter_email_sender/flutter_email_sender.dart';

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
  List<Message> stateTexts;
  Future<void> _chooseFile() async {
    setState(() {
      isLoading = true;
    });
    File file = await FilePicker.getFile();

    // await ImagePicker.pickImage(source: ImageSource.gallery).then((File image) async {
      final StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('images/${path.basename(file.path)}}');
      final StorageUploadTask uploadTask = storageReference.putFile(file);
      await uploadTask.onComplete;
      storageReference
        .getDownloadURL()
        .then((dynamic fileURL) {
          print('-------File Uploaded--------');
          // print(fileURL as String);\
          print(stateTexts.length);
          setState(() {
            stateTexts.add(Message(
              id: 'image',
              text: fileURL as String,
              createdAt: Jiffy().format(),
              author: Author(
                id: 'author',
                username: 'author'
              )
            ));
          });
          print(stateTexts.length);
          // now send message 
          setState(() {
            isLoading = false;
          });
      });
    // });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      stateTexts = widget.texts;
    });
  }
    final _recipientController = TextEditingController(
      text: 'doctor@gmail.com',
    );

    final _subjectController = TextEditingController(text: 'Dear doctor please check ');

    final _bodyController = TextEditingController(
      text: 'The email body.',
    );

    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _sendEmail() async {
    final Email email = Email(
      body: _bodyController.text,
      subject: _subjectController.text,
      recipients: [_recipientController.text],
      attachmentPaths: [],
      isHTML: false,
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      platformResponse = error.toString();
    }

    if (!mounted) return;

    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(platformResponse),
    ));
  }

  _launchMap({String lat, String long}) async{
    var mapSchema = 'geo:$lat,$long';
    if (await canLaunch(mapSchema)) {
      await launch(mapSchema);
    } else {
      throw 'Could not launch $mapSchema';
    }
  }

  _joinMeeting() async {
    try {
      final JitsiMeetingOptions options = JitsiMeetingOptions()
        ..room = 'corona-case-10101-99'
        ..serverURL = null
        ..subject = 'Patient name'
        ..userDisplayName = 'Patient'
        ..userEmail = ''
        ..audioOnly = true
        ..audioMuted = true
        ..videoMuted = true;

      await JitsiMeet.joinMeeting(options);
    } catch (error) {
      debugPrint('error: $error');
    }
  }

  Future<String> isMe(String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('------printing----prfs');
    print(prefs.getString('uid'));
    return prefs.getString('uid');
  }

  Widget renderChatMessage(Message message, bool patient) {
    // print('--------printing-----isMe(message.id)');
    // print(isMe(message.id));
    // print(isMe(message.id) == message.id);
    if(message.text == null)
      return Container();

    if(message.id == 'image')
      return ClipRRect(
        child: FlatButton(
          onPressed: () {
            
          },
          child: Text(
            "Multimedia shared.",
          ),
        ),
      );
      // return ClipRRect(
      //   child: Image.network(message.text),
      // );

    
    if(message.id == 'location')
      return ClipRRect(
        child: FlatButton(
          onPressed: () {
            
          },
          child: Text(
            "Locations shared.",
          ),
        ),
      );

    return Column(
      children: <Widget>[
        Align(
          // TODO(patient): fix display based on token
          alignment: isMe(message.id) == message.id ? Alignment.centerRight : Alignment.centerLeft,
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

  Widget newFileMutationComponent() {
    return Mutation(
      options: MutationOptions(
        documentNode: gql(sendTextMessageMutation),
        update: (Cache cache, QueryResult result) => cache,
        onCompleted: (dynamic result) {
          // print('-----created-----message');
          // print(result['sendTextMessage']['text']);
          // print(result);
          // print(result.exception && result.exception);
          // Navigator.pop(context);
        },
      ),
      builder: (RunMutation run, QueryResult result) {
        return IconButton(
          icon: Icon(Icons.attach_file, color: Colors.black),
          onPressed: () async {
            // setState(() {
            //   isLoading = true;
            // });
            File file = await FilePicker.getFile();

            // await ImagePicker.pickImage(source: ImageSource.gallery).then((File image) async {
              final StorageReference storageReference = FirebaseStorage.instance
                .ref()
                .child('images/${path.basename(file.path)}}');
              final StorageUploadTask uploadTask = storageReference.putFile(file);
              await uploadTask.onComplete;
              storageReference
                .getDownloadURL()
                .then((dynamic fileURL) {
                  print('-------File Uploaded--------');
                  // print(fileURL as String);\
                  print(stateTexts.length);
                  setState(() {
                    stateTexts.add(Message(
                      id: 'image',
                      text: fileURL as String,
                      createdAt: Jiffy().format(),
                      author: Author(
                        id: 'author',
                        username: 'author'
                      )
                    ));
                  });
                  print(stateTexts.length);
                  // now send message 
                  run({'conversationId': widget.id, 'text': fileURL });
                  setState(() {
                    isLoading = false;
                  });
              });
          },
        );
      },
    );
  }

  Widget newChatMutationComponent() {
    return Mutation(
      options: MutationOptions(
        documentNode: gql(sendTextMessageMutation),
        update: (Cache cache, QueryResult result) => cache,
        onCompleted: (dynamic result) {
          // print('-----created-----message');
          // print(result['sendTextMessage']['text']);
          // print(result);
          // print(result.exception && result.exception);
          // Navigator.pop(context);
        },
      ),
      builder: (RunMutation run, QueryResult result) {
        return FloatingActionButton(
          mini: true,
          backgroundColor: widget.userType == 'patient' ? DARK_GREEN : PALE_ORANGE,
          onPressed: (){
            run({'conversationId': widget.id, 'text': _input});
            setState(() {
              _textController.text = '';
              stateTexts.add(Message(
                id: 'message',
                text: _input,
                createdAt: Jiffy().format(),
                author: Author(
                  id: 'author',
                  username: 'author'
                )
              ));
            });
          },
          child: Icon(Icons.message, color: Colors.white),
        );
      },
    );
  }

  Widget locationComponent() {
    return Mutation(
      options: MutationOptions(
        documentNode: gql(sendTextMessageMutation),
        update: (Cache cache, QueryResult result) => cache,
        onCompleted: (dynamic result) {
          // print('-----created-----message');
          // print(result['sendTextMessage']['text']);
          // print(result);
          // print(result.exception && result.exception);
          // Navigator.pop(context);
        },
      ),
      builder: (RunMutation run, QueryResult result) {
        return IconButton(
          icon: Icon(Icons.add_location),
          onPressed: () async {
            final geo_location.Location location = geo_location.Location();
            bool _serviceEnabled;
            geo_location.PermissionStatus _permissionGranted;
            geo_location.LocationData _locationData;

            _serviceEnabled = await location.serviceEnabled();
            if (!_serviceEnabled) {
              _serviceEnabled = await location.requestService();
              if (!_serviceEnabled) {
                return;
              }
            }

            _permissionGranted = await location.hasPermission();
            if (_permissionGranted == geo_location.PermissionStatus.denied) {
              _permissionGranted = await location.requestPermission();
              if (_permissionGranted != geo_location.PermissionStatus.granted) {
                return;
              }
            }

            _locationData = await location.getLocation();
            run({'conversationId': widget.id, 'text': '$_locationData[latitude]:$_locationData[longitude]'});
            setState(() {
              stateTexts.add(Message(
                id: 'location',
                text: _input,
                createdAt: Jiffy().format(),
                author: Author(
                  id: 'author',
                  username: 'author'
                )
              ));
            });
          },
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
  final _textController = TextEditingController(text: '');

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
                controller: _textController,
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
            child: newFileMutationComponent(),
            visible: !isLoading,
          ),
          IconButton(
            icon: Icon(Icons.email, color: Colors.black),
            onPressed: _sendEmail,
          ),
          newChatMutationComponent()
        ],
      ),
    );
  }

  ScrollController _controller = ScrollController();

  Widget subscriptionComponent() {
    // return Subscription<Map<String, dynamic>>(
    //   'onTextAdded', 
    //   subscriptionNewText,
    //   onCompleted: () { print("subscription"); },
    //   builder: ({
    //     bool loading,
    //     Map<String, dynamic> payload,
    //     dynamic error,
    //   }) {
    //   print("----updated----payloadnoo");
      
    //   if(loading)
    //    return loader();

    //   print("----updated----payload");
    //   print(payload);

      Timer(Duration(milliseconds: 1000), () => _controller.jumpTo(_controller.position.maxScrollExtent));

      return Flexible(
        child: ListView.builder(
          controller: _controller,
          itemCount: widget.texts.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (BuildContext ctx, int i) => renderChatMessage(stateTexts[i], widget.userType == 'patient'),
        ),
      );
    // });
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
          locationComponent(),
          IconButton(
            icon: Icon(Icons.call),
            onPressed: () {
              _joinMeeting();
            },
          ),
          IconButton(
            icon: Icon(Icons.video_call),
            onPressed: () {
              _joinMeeting();
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
