import 'package:flutter/material.dart';
import 'package:e_doctor/config/config.dart';
import 'package:e_doctor/state/app_state.dart';

import 'package:e_doctor/screens/auth/auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  final bool auth;
  final client;

  // Initialize the above variables
  App({ this.auth = false, this.client }) {
    getCurrentUser();
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(auth: auth),
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: primaryColor,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: primaryColor,
      ),
    );
  }
}


class AuthPage extends StatelessWidget {
  final bool auth;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  AuthPage({ this.auth = false }) {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: true)
    );

    _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
        print("Settings registered: $settings");
    });

    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      print("Push Messaging token: $token");
    });
  }

  @override
  Widget build(BuildContext context) {
    // final appState = Provider.of<AppState>(context);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light
            // appState.currentTheme.brightness == Brightness.dark
            //     ? Brightness.light
            //     : Brightness.dark,
      ),
    );

    return MaterialApp(
      // theme: Brightness.light,
      title: "E - Doctor",
      home: AuthScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
