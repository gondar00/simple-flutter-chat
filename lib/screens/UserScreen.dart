import 'package:e_doctor/constants/colors.dart';
import 'package:flutter/material.dart';

class UserScreen extends StatefulWidget {
  UserScreen({this.userType});
  final String userType;

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        ClipPath(
          child: Container(color: widget.userType == 'doctor' ? DARK_ORANGE.withOpacity(0.8) : DARK_GREEN.withOpacity(0.8)),
          clipper: getClipper(),
        ),
        Positioned(
            width: 350.0,
            top: MediaQuery.of(context).size.height / 5,
            child: Column(
              children: <Widget>[
                Container(
                    width: 150.0,
                    height: 150.0,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        image: DecorationImage(
                            image: NetworkImage(
                              widget.userType != 'doctor' ? 
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSoRqm_HSRlAVe5buJshCZtI4txn6DcvckOabl6d0iTYoUTlJBD&s'
                                : 'https://lh3.googleusercontent.com/proxy/ISmJvmTNeAIN4bF_rjpeiRdUNDwxSKzluy_QOKw8kruji3XndmP-r-P4yYYtIqqCMsk_JjTATG3luqb5Q-HfY0gGvzKu9_jERFvTrq6kYAIVD0uXNMTHq7RcVuSaTUImERieDQepMhPAxg'
                              ),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.all(Radius.circular(75.0)),
                        boxShadow: [
                          BoxShadow(blurRadius: 7.0, color: Colors.black)
                        ])),
                SizedBox(height: 50.0),
                Text(
                  widget.userType != 'doctor' ? 'Doctor name' : 'Patient name',
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat'),
                ),
                SizedBox(height: 15.0),
                Text(
                  'Email',
                  style: TextStyle(
                      fontSize: 17.0,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Montserrat'),
                ),
                SizedBox(height: 25.0)
              ],
            ))
      ],
    ));
  }
}

class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 1.9);
    path.lineTo(size.width + 125, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}