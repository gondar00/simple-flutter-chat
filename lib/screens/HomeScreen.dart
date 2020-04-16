
import 'package:e_doctor/screens/DoctorHomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:e_doctor/constants/colors.dart';

import 'package:e_doctor/screens/PatientHomeScreen.dart';
import 'package:e_doctor/screens/ChatListScreen.dart';

// import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({this.userType});
  final String userType;

  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
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
          backgroundColor: widget.userType == 'patient' ? DARK_GREEN : PALE_ORANGE,
          actions: <Widget>[
            Visibility(
                child: IconButton(
                  onPressed: () {
                    Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) => ChatListScreen(userType: widget.userType)));
                  },
                  icon: Icon(Icons.chat_bubble_outline),
                ),
                visible: widget.userType == 'patient' ,
            )

          ],
        ),
        body: widget.userType == 'patient' ?  PatientHomeScreen(userType: widget.userType) : DoctorHomeScreen(userType: widget.userType),
      ),
    );
  }
}
