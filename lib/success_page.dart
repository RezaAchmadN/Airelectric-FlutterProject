import 'package:airelectric/success_page/view.dart';
import 'package:flutter/material.dart';

class SuccessPage extends StatefulWidget {
  final String id;
  final String type;

  SuccessPage({Key key, @required this.id, this.type}) : super(key: key);
  @override
  _SuccessPageState createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SuccessView(id: widget.id,type: widget.type),
    );
  }
}