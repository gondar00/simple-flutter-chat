import 'package:e_doctor/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:e_doctor/graphql/query/get_user.dart';
import 'package:flutter/cupertino.dart';

class UserScreen extends StatefulWidget {
  UserScreen({this.userType, this.id});
  final String userType;
  final String id;

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  List<Widget> doctor(String hospital, String medicalLicense) {
    return [
      Text(
        hospital,
        style: TextStyle(
            fontSize: 17.0,
            fontStyle: FontStyle.italic,
            fontFamily: 'Montserrat'),
      ),
      SizedBox(height: 15.0),
      Text(
        medicalLicense,
        style: TextStyle(
            fontSize: 17.0,
            fontStyle: FontStyle.italic,
            fontFamily: 'Montserrat'),
      ),
      SizedBox(height: 15.0),
    ];
  }
  List<Widget> patient(String emirateId, String medicalRecord) {
    return [
      Text(
        emirateId,
        style: TextStyle(
            fontSize: 17.0,
            fontStyle: FontStyle.italic,
            fontFamily: 'Montserrat'),
      ),
      SizedBox(height: 15.0),
      Text(
        medicalRecord,
        style: TextStyle(
            fontSize: 17.0,
            fontStyle: FontStyle.italic,
            fontFamily: 'Montserrat'),
      ),
      SizedBox(height: 15.0),
    ];
  }
  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        documentNode: gql(getUserQuery),
        variables: {
          'id': widget.id,
        },
        pollInterval: 10000,
      ),
      builder: (QueryResult result, { VoidCallback refetch, FetchMore fetchMore }) {
        print('userrrr');
        print(result.data);

        if(result.loading || result.data == null) 
          return const CupertinoActivityIndicator();
        if(result.data == null && !result.loading) 
          return Container();

          print('aafea');
          print(result.data['user']);
      Map<String, dynamic> user = result.data['user'] as Map<String, dynamic>;
      final String email = (user['username'] ?? '') as String;
      final String name = (user['name'] ?? '') as String;
      final String address = (user['address'] ?? '') as String;
      final String mobile = (user['mobile'] ?? '') as String;
      //patient 
      final String emirateId = (user['emirateId'] ?? '') as String;
      final String medicalRecord = (user['medicalRecord'] ?? '') as String;
      //doctor
      final String medicalLicense = (user['medicalLicense'] ?? '') as String;
      final String hospital = (user['hospital'] ?? '') as String;
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
                        'https://cdn2.iconfinder.com/data/icons/medical-flat-icons-part-1/513/46-512.png'
                        : 'https://cdn2.iconfinder.com/data/icons/medical-flat-icons-part-1/513/30-512.png'
                      ),
                    fit: BoxFit.cover),
                  borderRadius: BorderRadius.all(Radius.circular(75.0)),
                  boxShadow: [
                    BoxShadow(blurRadius: 7.0, color: Colors.black)
                  ])
                ),
                SizedBox(height: 50.0),
                Text(
                  name,
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat'),
                ),
                SizedBox(height: 15.0),
                Text(
                  email,
                  style: TextStyle(
                      fontSize: 17.0,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Montserrat'),
                ),
                SizedBox(height: 15.0),
                Text(
                  address,
                  style: TextStyle(
                      fontSize: 17.0,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Montserrat'),
                ),
                SizedBox(height: 15.0),
                Text(
                  mobile,
                  style: TextStyle(
                      fontSize: 17.0,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Montserrat'),
                ),
                SizedBox(height: 15.0),
                if(widget.userType == 'doctor') ...patient(emirateId, medicalRecord),
                if(widget.userType != 'doctor') ...doctor(hospital, medicalLicense)
              ],
            ))
      ],
    ));
      }
    );
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