import 'package:flutter/material.dart';
import 'package:e_doctor/config/config.dart';
import 'package:e_doctor/state/app_state.dart';

import 'package:e_doctor/screens/auth/auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
// import 'package:firebase_auth/firebase_auth.dart';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  HttpLink httpLink = HttpLink(uri: 'https://chapserver.herokuapp.com/');

  final AuthLink authLink = AuthLink(
    getToken: () async => 'Bearer <YOUR_PERSONAL_ACCESS_TOKEN>',
    // OR
    // getToken: () => 'Bearer <YOUR_PERSONAL_ACCESS_TOKEN>',
  );

  final Link link = authLink.concat(httpLink);

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(cache: InMemoryCache(), link: link),
  );
  runApp(App(auth: token != null, client: client ));
}

class App extends StatelessWidget {
  final bool auth;
  final client;
  App({this.auth = false, this.client});

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
    client: client,
    child: CacheProvider(
        child: ChangeNotifierProvider<AppState>(
          create: (_) => AppState(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: AuthPage(),
            theme: ThemeData(
              brightness: Brightness.light,
              primaryColor: primaryColor,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primaryColor: primaryColor,
            ),
          ),
        ),
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
