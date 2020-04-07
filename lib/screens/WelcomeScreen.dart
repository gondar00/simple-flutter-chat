import 'package:flutter/material.dart';
import 'package:e_doctor/constants/colors.dart';
import 'package:e_doctor/screens/auth/auth.dart';

class Example {
  Example({
    this.header,
    this.description,
    this.image
  });

  final String header;
  final String description;
  final String image;
}

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
static List<Example> items = [
  Example(
    header: 'E-DOCTOR',
    description:
        'Where your health is our priority',
    image: 'assets/images/welcome-illustration-1.png',
  ),
  Example(
    header: '',
    description: 'Start your journey with one click',
    image: 'assets/images/welcome-illustration-2.png',
  )
];
  List<Widget> slides = items
      .map((Example item) => Container(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: <Widget>[
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Image.asset(
                  item.image,
                  fit: BoxFit.fitWidth,
                  width: 300.0,
                  alignment: Alignment.bottomCenter,
                ),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: <Widget>[
                      Text(item.header,
                        style: TextStyle(
                          fontSize: 40.0,
                          fontWeight: FontWeight.w300,
                          color: Color(0XFF3F3D56),
                          height: 1.5
                        )
                      ),
                      Text(
                        item.description,
                        style: TextStyle(
                            color: Colors.grey,
                            letterSpacing: 1.2,
                            fontSize: 16.0,
                            height: 1.5),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              )
            ],
          )))
      .toList();

  List<Widget> indicator() => List<Widget>.generate(
      slides.length,
      (index) => Container(
            margin: EdgeInsets.symmetric(horizontal: 3.0),
            height: 10.0,
            width: 10.0,
            decoration: BoxDecoration(
                color: currentPage.round() == index
                    ? Color(0XFF256075)
                    : Color(0XFF256075).withOpacity(0.2),
                borderRadius: BorderRadius.circular(10.0)),
          ));

  double currentPage = 0.0;
  final PageController _pageViewController = PageController();

   // Toolbar layout
  Widget _toolbar() {
    return Container(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.symmetric(vertical: 120.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RawMaterialButton(
              onPressed: () => {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => AuthScreen(),
                  ),
                )
              },
              child: Text(
                'Doctor',
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1.2,
                  fontSize: 16.0,
                  height: 1.5
                ),
                textAlign: TextAlign.center,
              ),
              elevation: 2.0,
              fillColor: PALE_ORANGE,
              padding: const EdgeInsets.all(18.0),
            ),
            RawMaterialButton(
              onPressed: () => {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => AuthScreen(userType: 'patient'),
                  ),
                )
              },
              child: Text(
                'Patient',
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1.2,
                  fontSize: 16.0,
                  height: 1.5
                ),
                textAlign: TextAlign.center,
              ),
              elevation: 2.0,
              fillColor: DARK_GREEN,
              padding: const EdgeInsets.all(18.0),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            PageView.builder(
              controller: _pageViewController,
              itemCount: slides.length,
              itemBuilder: (BuildContext context, int index) {
                _pageViewController.addListener(() {
                  setState(() {
                    currentPage = _pageViewController.page;
                  });
                });
                return slides[index];
              },
            ),
            Visibility(
              child: _toolbar(),
              visible: currentPage == 1.0,
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(top: 70.0),
                  padding: EdgeInsets.symmetric(vertical: 40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: indicator(),
                  ),
                )
                //  ),
            )
            // )
          ],
        ),
      ),
    );
  }
}