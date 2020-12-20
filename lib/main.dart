import 'package:airelectric/aircondition_page.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'dart:async';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AirConditionPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 200.0),
            child: Center(
              child: Image.asset('assets/images/logo.png'),
            ),
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset('assets/images/splashscreen_bottom.png'),
            ),
          ),
        ],
      ),
    );
  }
}
