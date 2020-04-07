import 'package:e_doctor/screens/auth/components/auth_views.dart';
import 'package:e_doctor/screens/auth/components/TabBarComponent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:e_doctor/constants/colors.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({ this.userType = 'doctor' });

  final String userType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarComponent(
        tabs: ['LOG IN', 'SIGN UP'],
        tabViews: <Widget>[
          AuthViews(userType: userType),
          AuthViews(signup: true, userType: userType),
        ],
        labelColor: userType == 'doctor' ? PALE_ORANGE : LIGHT_GREEN,
      ),
    );
  }
}