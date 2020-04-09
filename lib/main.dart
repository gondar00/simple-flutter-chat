import 'package:flutter/material.dart';
import 'package:e_doctor/config/config.dart';
import 'package:e_doctor/state/app_state.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
// import 'package:firebase_auth/firebase_auth.dart';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:e_doctor/screens/WelcomeScreen.dart';

import 'package:e_doctor/screens/HomeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  // HttpLink httpLink = HttpLink(uri: 'https://infinite-plateau-74257.herokuapp.com');

  // final AuthLink authLink = AuthLink(
  //   getToken: () => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJjazhtdWhpbjc4bTM2MGE4NzV0djMzYnJwIiwiaWF0IjoxNTg2MDc5MDEwfQ._-hMf0VE6tkQV1tR-vU4EBRM4OQPs18IP54e3KlVy_w',
  // );

  // final Link link = authLink.concat(httpLink);

  // ValueNotifier<GraphQLClient> client = ValueNotifier(
  //   GraphQLClient(cache: InMemoryCache(), link: link),
  // );
  runApp(App(auth: token != null ));
}

class App extends StatelessWidget {
  App({this.auth = false});

  final bool auth;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>(
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
    );
  }
}


class AuthPage extends StatelessWidget {
  final bool auth;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  AuthPage({ this.auth = false }) {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
      },
    );

    _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: true)
    );

    _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
        print('Settings registered: $settings');
    });

    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      print('Push Messaging token: $token');
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = Provider.of<AppState>(context);

    final HttpLink httpLink = HttpLink(uri: 'https://infinite-plateau-74257.herokuapp.com');

    final AuthLink authLink = AuthLink(
      getToken: () => 'Bearer ${appState.token}',
    );

    final Map<String, String> initPayload = {'token': 'Bearer ${appState.token}'};
    // final WebSocketLink websocketLink = WebSocketLink(
    //   url: 'ws://infinite-plateau-74257.herokuapp.com',
    //   config: SocketClientConfig(
    //     autoReconnect: true,
    //     inactivityTimeout: const Duration(seconds: 30),
    //     initPayload: () => initPayload,
    //   ),
    // );

    final Link link = authLink.concat(httpLink);
    // final Link link = authLink.concat(httpLink).concat(websocketLink);

    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(cache: InMemoryCache(), link: link),
    );

    print('-----printing---token change'); 
    print(appState.token);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light
            // appState.currentTheme.brightness == Brightness.dark
            //     ? Brightness.light
            //     : Brightness.dark,
      ),
    );

    return GraphQLProvider(
      client: client,
      child: CacheProvider(
        child: MaterialApp(
          // theme: Brightness.light,
          title: 'E - Doctor',
          home: WelcomeScreen(),
          // hides the debug tag on the build app.
          debugShowCheckedModeBanner: false,
        )
      )
    );
  }
}
