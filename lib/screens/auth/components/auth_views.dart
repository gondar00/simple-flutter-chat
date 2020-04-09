import 'package:e_doctor/constants/colors.dart';
import 'package:e_doctor/constants/gradients.dart';

import 'package:e_doctor/state/app_state.dart';
import 'package:e_doctor/screens/HomeScreen.dart';
// import 'package:e_doctor/screens/ChatScreen.dart';

import 'package:e_doctor/screens/auth/auth_gql.dart';
import 'package:e_doctor/screens/auth/model.dart';
// import 'package:e_doctor/screens/chats/chats.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

// import 'package:e_doctor/state/app_state.dart';

// import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:provider/provider.dart';

import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class AuthViews extends StatefulWidget {
  AuthViews({this.signup = false, this.userType = 'doctor'});

  final bool signup;
  final String userType;

  @override
  _AuthViewsState createState() => _AuthViewsState();
}

class _AuthViewsState extends State<AuthViews> {
  Map<String, String> inputValues = {};
  Map<String, bool> boolValues = {};
  String errorText = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> _handleSignIn() async {
    final FirebaseUser user = (await _auth.signInWithEmailAndPassword(
      email: inputValues['email'],
      password: inputValues['password'],
    )).user;

    return user;
  }

  Future<FirebaseUser> _handleSignUp() async {
    final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
      email: inputValues['email'],
      password: inputValues['password'],
    )).user;

    return user;
  }

  @override
  Widget build(BuildContext context) => body(context);

  Widget body(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(margin: EdgeInsets.only(top: 60)),
        gradientTextComponent(
          widget.userType == 'doctor' ? ORANGE_GRADIENT : GREEN_GRADIENT,
          'Welcome',
        ),
        // Container(margin: EdgeInsets.only(top: 35)),
        // messageTextComponent(),
        Container(margin: EdgeInsets.only(top: 35)),
        // if (widget.signup) ...nameInputComponent(),
        textFieldComponent(type: 'email', hintText: 'Email Address'),
        Container(margin: EdgeInsets.only(top: 20)),
        textFieldComponent(
          type: 'password',
          hintText: 'Password',
          obscure: true,
        ),
        Container(margin: EdgeInsets.only(top: 10)),
        errorMessageComponent(),
        Container(margin: EdgeInsets.only(top: widget.signup ? 30 : 30)),
        mutationComponent(context),
        // gradientButtonComponent()
      ],
    );
  }

  List<Widget> nameInputComponent() {
    return [
      textFieldComponent(type: 'name', hintText: 'Display Name'),
      Container(margin: EdgeInsets.only(top: 20)),
    ];
  }

  Widget messageTextComponent() {
    return Text(
      '${widget.signup ? 'Sign up' : 'Log in'} to continue',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 18,
        color: Colors.grey[700],
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget textFieldComponent({ String hintText, @required String type, bool obscure = false }) {
    return Container(
      height: 55,
      margin: EdgeInsets.only(left: 30, right: 30),
      padding: EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: LIGHT_GREY_COLOR,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: TextField(
          obscureText: obscure,
          onChanged: (String value) => setInputValue(type, value),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText ?? '',
          ),
        ),
      ),
    );
  }

  void setInputValue(String type, String value) {
    setState(() {
      inputValues[type] = value;
    });
    // if (errorText != '')
    //   setState(() {
    //     errorText = '';
    //   });
  }

  Widget errorMessageComponent() {
    return Text(
      errorText,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.red),
    );
  }

  Widget mutationComponent(BuildContext context) {
    final AppState appState = Provider.of<AppState>(context);

    return Mutation(
      builder: (RunMutation run, QueryResult result) => gradientButtonComponent(run, result),
      options: MutationOptions(
      documentNode: gql(signupMutation),
      update: (Cache cache, QueryResult result) => cache,
      onCompleted: (dynamic result) async {
        print('----printing----result');
        print(result);

        final AuthModel response = AuthModel.fromJson(
          result['signup'],
        );

        if (response.error == null) {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('uid', response.id);
          await prefs.setString('token', response.token);
          await prefs.setString('user-type', widget.userType);

          appState.setToken(response.token);
          print('----printing----token');
          print(response.token);
        }
        if (response.error != null) {
          setState(() {
            errorText = response.error.message ?? '';
          });
        }
      },
    ),
  );
}

Widget gradientButtonComponent(RunMutation runMutation, QueryResult result) {
  return GestureDetector(
    onTap: () {
      final String email = inputValues['email'] ?? '';
      final String pass = inputValues['password'] ?? '';
      if (email != '' && pass != '') {
        if(widget.signup) {
          _handleSignUp().then((FirebaseUser user) => {
            runMutation({
              'username': email,
            }),
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => HomeScreen(userType: widget.userType),
              ),
            )
          })
          .catchError((ArgumentError e) => 
            setState(() {
              errorText = e.name;
            })
          );  
        } else {
            _handleSignIn().then((FirebaseUser user) => {
              runMutation({
                'username': email,
              }),
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => HomeScreen(userType: widget.userType),
                ),
              )
            })
            .catchError((ArgumentError e) => 
              setState(() {
                errorText = e.name;
              })
            ); 
          }
        }
      },
      child: Container(
        margin: EdgeInsets.only(left: 30, right: 30),
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          gradient: widget.userType == 'patient' ? GREEN_GRADIENT : ORANGE_GRADIENT,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              blurRadius: 24,
              color: widget.userType == 'patient' ? GREEN_SHADOW : ORANGE_SHADOW,
              offset: Offset(0, 16),
            )
          ],
        ),
        child: Center(
          child: result.loading
              ? CupertinoActivityIndicator() : Text(
            'CONTINUE',
            style: TextStyle(
              color: WHITE_COLOR,
              fontSize: 18,
              fontFamily: 'Roboto',
            ),
          ),
        ),
      ),
    );
  }
}

Widget gradientTextComponent(Gradient gradient, String text, {
  double size = 48,
  FontWeight weight = FontWeight.w300,
  TextAlign align = TextAlign.center
}) {
  final rect = Rect.fromLTWH(0.0, 0.0, 200.0, 70.0);
  final Shader linearGradient = gradient.createShader(rect);

  return Text(
    text,
    textAlign: align,
    style: TextStyle(
      fontSize: size,
      fontWeight: weight,
      foreground: Paint()..shader = linearGradient),
    );
}