import 'dart:math';

import 'package:airelectric/success_page/controller.dart';
import 'package:flutter/material.dart';

class SuccessView extends StatefulWidget {
  final String id;
  final String type;

  SuccessView({Key key, @required this.id, this.type}) : super(key: key);
  @override
  _SuccessViewState createState() => _SuccessViewState();
}

class _SuccessViewState extends SuccessController {
  var rng = new Random();
  int randoms1;
  int randoms2;
  int randoms3;
  int randoms4;

  @override
  void initState() {
    randoms1 = 1000 + rng.nextInt(10000 - 1000);
    randoms2 = 1000 + rng.nextInt(10000 - 1000);
    randoms3 = 1000 + rng.nextInt(10000 - 1000);
    randoms4 = 1000 + rng.nextInt(10000 - 1000);
    widget.type == "Token"
        ? updatePaymentToken(
            widget.id,
            "paid",
            randoms1.toString() +
                randoms2.toString() +
                randoms3.toString() +
                randoms4.toString())
        : updatePaymentBill(widget.id, "paid");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.id + widget.type);
    setState(() {});
    return isLoading()
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            body: Center(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('assets/images/success.png'),
                    Text(
                      "Transaction Successful",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(24.0)),
                    widget.type == "Token"
                        ? Text(
                            "Token Number :",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                            ),
                          )
                        : Container(),
                    widget.type == "Token"
                        ? Text(
                            randoms1.toString() +
                                " " +
                                randoms2.toString() +
                                " " +
                                randoms3.toString() +
                                " " +
                                randoms4.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          );
  }
}
