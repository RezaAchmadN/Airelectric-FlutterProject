import 'package:airelectric/payment_dart/view.dart';
import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  final int price;

  const PaymentPage({Key key, this.price}) : super(key: key);
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PaymentView(price:widget.price),
    );
  }
}