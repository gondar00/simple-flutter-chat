import 'package:e_doctor/constants/colors.dart';
import 'package:e_doctor/constants/gradients.dart';
import 'package:e_doctor/state/app_state.dart';
import 'package:e_doctor/screens/home/home.dart';
// import 'package:e_doctor/screens/auth/auth_gql.dart';
// import 'package:e_doctor/screens/auth/model.dart';
// import 'package:e_doctor/screens/chats/chats.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// import 'package:shared_preferences/shared_preferences.dart';

// import 'package:e_doctor/state/app_state.dart';

// import 'package:firebase_messaging/firebase_messaging.dart';

// import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:provider/provider.dart';

import 'package:firebase_auth/firebase_auth.dart';


class AuthViews extends StatefulWidget {
  final bool signup;

  AuthViews({this.signup = false});
  _AuthViewsState createState() => _AuthViewsState();
}

class _AuthViewsState extends State<AuthViews> {
  Map<String, String> inputValues = {};
  Map<String, bool> boolValues = {};
  String fcmToken = "";
  String errorText = "";

  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  // // _firebaseMessaging.requestNotificationPermissions()
  // @override
  // void initState() {
  //   super.initState();
  //   getToken();
  // }

  // Future<void> getToken() async {
  //   final token = await _firebaseMessaging.getToken();
  //   setState(() {
  //     fcmToken = token;
  //   });
  // }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> _handleSignIn() async {
    final FirebaseUser user = (
      await _auth.createUserWithEmailAndPassword(
        email: inputValues["email"],
        password: inputValues["password"],
      )
    ).user;
    print(user);

    return user;
  }

  @override
  Widget build(BuildContext context) => body(context);

  Widget body(context) {
    return ListView(
      children: <Widget>[
        Container(margin: EdgeInsets.only(top: 60)),
        gradientTextComponent(
          widget.signup ? ORANGE_GRADIENT : BLUE_GRADIENT,
          "Welcome",
        ),
        // Container(margin: EdgeInsets.only(top: 35)),
        // messageTextComponent(),
        Container(margin: EdgeInsets.only(top: 35)),
        // if (widget.signup) ...nameInputComponent(),
        textFieldComponent(type: "email", hintText: "Email Address"),
        Container(margin: EdgeInsets.only(top: 20)),
        textFieldComponent(
          type: "password",
          hintText: "Password",
          obscure: true,
        ),
        Container(margin: EdgeInsets.only(top: 10)),
        errorMessageComponent(),
        Container(margin: EdgeInsets.only(top: widget.signup ? 30 : 30)),
        // mutationComponent(context),
        gradientButtonComponent()
      ],
    );
  }

  List<Widget> nameInputComponent() {
    return [
      textFieldComponent(type: "name", hintText: "Display Name"),
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
          onChanged: (value) => setInputValue(type, value),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText ?? "",
          ),
        ),
      ),
    );
  }

  void setInputValue(String type, String value) {
    setState(() {
      inputValues[type] = value;
    });
    // if (errorText != "")
    //   setState(() {
    //     errorText = "";
    //   });
  }

  Widget errorMessageComponent() {
    return Text(
      "$errorText",
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.red),
    );
  }

  // Widget mutationComponent(context) {
  //   final appState = Provider.of<AppState>(context);

  //   return Mutation(
  //     update: (Cache cache, QueryResult result) => cache,
  //     builder: (run, result) => gradientButtonComponent(run, result),
  //     options: MutationOptions(
  //       document: widget.signup ? signupMutation : signinMutation,
  //     ),
  //     onCompleted: (result) async {
  //       final response = AuthModel.fromJson(
  //         result[widget.signup ? 'register' : 'login'],
  //       );

  //       if (response.error == null && response.token != null) {
  //         SharedPreferences prefs = await SharedPreferences.getInstance();
  //         await prefs.setString("uid", response.id);
  //         await prefs.setString("token", response.token);

  //         appState.setToken(response.token);

  //         // Navigator.pushReplacement(
  //         //   context,
  //         //   MaterialPageRoute(
  //         //     builder: (context) => ChatListScreen(),
  //         //   ),
  //         // );
  //       }
  //       if (response.error != null) {
  //         setState(() {
  //           errorText = response.error.message ?? "";
  //         });
  //       }
  //     },
  //   );
  // }

  Widget gradientButtonComponent() {
    return GestureDetector(
      onTap: () {
        String email = inputValues["email"] ?? "";
        String pass = inputValues["password"] ?? "";
        if (email != "" && pass != "") {
            // runMutation({
            //   "email": email,
            //   "password": pass,
            //   "name": name,
            //   "fcmToken": fcmToken
            // });
          // final appState = Provider.of<AppState>(context, listen: false);
          _handleSignIn()
            .then((FirebaseUser user) => {
              // appState.setToken(user.uid),
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
              )
            })
            .catchError((e) => print(e));            
        }
      },
      child: Container(
        margin: EdgeInsets.only(left: 30, right: 30),
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          gradient: widget.signup ? ORANGE_GRADIENT : BLUE_GRADIENT,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              blurRadius: 24,
              color: widget.signup ? ORANGE_SHADOW : BLUE_SHADOW,
              offset: Offset(0, 16),
            )
          ],
        ),
        child: Center(
          child: Text(
                  "CONTINUE",
                  style: TextStyle(
                    color: widget.signup ? WHITE_COLOR : WHITE_COLOR,
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