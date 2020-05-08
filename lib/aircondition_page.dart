import 'package:airelectric/aircondition_page/view.dart';
import 'package:flutter/material.dart';

class AirConditionPage extends StatefulWidget {
  @override
  _AirConditionPageState createState() => _AirConditionPageState();
}

class _AirConditionPageState extends State<AirConditionPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AirConditionView(),
    );
  }
}