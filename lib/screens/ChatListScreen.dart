
import 'package:flutter/material.dart';

import 'package:e_doctor/screens/DoctorHomeScreen.dart';

import 'package:e_doctor/constants/colors.dart';

class ChatListScreen extends StatelessWidget {
  ChatListScreen({this.userType});
  final String userType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your chats with doctors',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        backgroundColor: userType == 'patient' ? DARK_GREEN : PALE_ORANGE,
        actions: <Widget>[
            Visibility(
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close),
              ),
              visible: userType == 'patient' ,
          )

        ],
      ),
      body: DoctorHomeScreen(userType: userType),
    );
  }
}
