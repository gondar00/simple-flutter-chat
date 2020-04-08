import 'package:flutter/material.dart';

import 'package:e_doctor/screens/users/users.dart';

class PatientHomeScreen extends StatelessWidget {
  PatientHomeScreen({this.userType});

  final String userType;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 10, 10),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              title: Text('Consult a doctor now'),
              subtitle: Text('Depending on your severiarity please choose on the below options to get started'),
            ),
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: const Text('DOCTOR'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => UserListScreen(covid: false),
                      ),
                    );
                  },
                ),
                FlatButton(
                  child: const Text('URGENT! COVID - 19', style: TextStyle(
                    color: Colors.red
                  )),
                   onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => UserListScreen(covid: true),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}