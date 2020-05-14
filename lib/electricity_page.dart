import 'package:airelectric/electricity_page/view.dart';
import 'package:flutter/material.dart';

class ElectricityPage extends StatefulWidget {
  @override
  _ElectricityPageState createState() => _ElectricityPageState();
}

class _ElectricityPageState extends State<ElectricityPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ElectricityView(),
    );
  }
}