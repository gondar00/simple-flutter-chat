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
import 'package:e_doctor/screens/UserScreen.dart';
import 'package:e_doctor/screens/AudioPlayer.dart';
import 'package:e_doctor/screens/VideoPlayer.dart';
import 'package:video_player/video_player.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:jitsi_meet/jitsi_meet.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:location/location.dart' as geo_location;

import 'package:file_picker/file_picker.dart';

import 'package:flutter_email_sender/flutter_email_sender.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({this.id, this.userType, this.title, this.texts, this.participants});

  // invoke native method
  // static const MethodChannel platform = MethodChannel('com.video.sdk/opentok');

  final String id;
  final String userType;
  final String title;
  final List<Participant> participants;
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

    final _subjectController = TextEditingController(text: 'Dear doctor, ...');

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

  _launchMap(String message) async{
    var data = message.split(':');
    data.removeAt(0);
    var lat = data.first;
    var long = data.last;
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

  _launchURL(String message) async {
    if (await canLaunch(message)) {
      await launch(message);
    } else {
      throw 'Could not launch $message';
    }
  }

  Widget _getText(String message) {
    if(message == null)
      return Container();
    
    if(message.contains('aac') || message.contains('mp3'))
      // return GestureDetector(
      //   child: Text('audio shared', style: TextStyle(decoration: TextDecoration.underline, color: Colors.white)),
      //   onTap: () => _launchURL(message)
      // );
      return AudioApp(url: message);

    if(message.contains('mov') || message.contains('mp4'))
      // return GestureDetector(
      //   child: Text('video shared', style: TextStyle(decoration: TextDecoration.underline, color: Colors.white)),
      //   onTap: () => _launchURL(message)
      // );
      return ChewieListItem(
        videoPlayerController: VideoPlayerController.network(
          message,
        ),
      );

    if(message.contains('location'))
      return GestureDetector(
        child: Text('location shared', style: TextStyle(decoration: TextDecoration.underline, color: Colors.white)),
        onTap: () => _launchMap(message)
      );
  
    if(message.contains('png') || message.contains('jpg') || message.contains('jpeg'))
      try {
        return ClipRRect(
          child: Image.network(message),
        );
      } catch (e) {

      }

      return Text(
        message,
        style: TextStyle(
          fontSize: 16,
          color: WHITE_COLOR,
        ),
      );
  }

  Future<String> isMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('uid');
  }

  Widget renderChatMessage(Message message, bool patient) {
    if(message.text == null)
      return Container();

    return Column(
      children: <Widget>[
        Align(
          // TODO(patient): fix display based on token
          alignment: isMe() == message.id ? Alignment.centerRight : Alignment.centerLeft,
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
            child: _getText(message.text)
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
            final File file = await FilePicker.getFile();

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
        onCompleted: (dynamic result) {},
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
        onCompleted: (dynamic result) {},
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

            /// Latitude in degrees
            final double latitude = _locationData.latitude;

            /// Longitude, in degrees
            final double longitude = _locationData.longitude;
            
            final String _text = 'location:$latitude:$longitude';
            run({'conversationId': widget.id, 'text': _text});
            setState(() {
              stateTexts.add(Message(
                id: 'location',
                text: _text,
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


      // scroll to bottom
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

  bool _accept = false;
   Widget _toolbar() {
    return Container(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: ButtonBar(
            children: <Widget>[
              RawMaterialButton(
                onPressed: () => {
                  setState(() {
                    _accept = true;
                  })
                },
                child: Text(
                  'Accept',
                  style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 1.2,
                    fontSize: 16.0,
                    height: 1.5
                  ),
                  textAlign: TextAlign.center,
                ),
                elevation: 2.0,
                fillColor: PALE_ORANGE,
                padding: const EdgeInsets.all(18.0),
              ),
              RawMaterialButton(
                onPressed: () => {
                  Navigator.pop(context)
                },
                child: Text(
                  'Reject',
                  style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 1.2,
                    fontSize: 16.0,
                    height: 1.5
                  ),
                  textAlign: TextAlign.center,
                ),
                elevation: 2.0,
                fillColor: Colors.red,
                padding: const EdgeInsets.all(18.0),
              ),
            ],
          )
      );
  }

  @override
  Widget build(BuildContext context) {
    print('id');
    print(widget.id);
    return Scaffold(
      backgroundColor: WHITE_COLOR,
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: false,
        backgroundColor: widget.userType == 'patient' ? DARK_GREEN : PALE_ORANGE,
        actions: <Widget>[
          locationComponent(),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () async {
               final String id = await isMe();
               final List<Participant> participants = widget.participants;
               Participant participant = widget.userType != 'doctor' ? participants.first : participants.last;
               Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) => UserScreen(userType: widget.userType, id: participant.id)));
            },
          ),
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
            child: widget.userType == 'doctor' ? _accept ? renderTextBox() : _toolbar() : renderTextBox(),
          ),
        ],
      ),
    );
  }
}
