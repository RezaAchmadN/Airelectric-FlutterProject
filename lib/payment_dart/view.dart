import 'dart:math';

import 'package:airelectric/payment_dart/controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentView extends StatefulWidget {
  final int price;

  const PaymentView({Key key, this.price}) : super(key: key);

  @override
  _PaymentViewState createState() => _PaymentViewState();
}

class _PaymentViewState extends PaymentController {
  final formatter = NumberFormat.currency(locale: 'en_US', name: 'Rp.');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(10, 120, 10, 100),
        title: Row(
          children: <Widget>[
            Text("Total Payment"),
            Spacer(),
            Text(formatter.format(widget.price))
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            header(),
            Padding(padding: EdgeInsets.all(8.0)),
            howToPay(),
          ],
        ),
      ),
    );
  }

  Widget header() {
    var rng = new Random();
    int randoms1 = 1000 + rng.nextInt(10000 - 1000);
    int randoms2 = 1000 + rng.nextInt(10000 - 1000);
    int randoms3 = 1000 + rng.nextInt(10000 - 1000);
    int randoms4 = 1000 + rng.nextInt(10000 - 1000);
    return Card(
      child: Container(
        padding: EdgeInsets.all(16.0),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Bank BCA",
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            Padding(padding: EdgeInsets.all(16.0)),
            Text(
              "Virtual Account Number:",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Padding(padding: EdgeInsets.all(4.0)),
            Text(
                randoms1.toString() +
                    randoms2.toString() +
                    randoms3.toString() +
                    randoms4.toString(),
                style: TextStyle(
                  fontSize: 16,
                )),
          ],
        ),
      ),
    );
  }

  Widget howToPay() {
    String rand =
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis et ex sollicitudin, rutrum ex eu, placerat massa. Ut posuere eleifend mi, at iaculis elit dignissim vitae. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nunc dictum augue in odio tempor eleifend. Nunc nec tempor magna. Maecenas accumsan eu tortor ut efficitur. Pellentesque porta pretium urna, sit amet gravida tortor porta ut.";

    String rand2 =
        "Vestibulum molestie cursus blandit. Vivamus quis mauris mauris. Vivamus placerat, ante nec tempus convallis, massa felis rhoncus est, eget facilisis arcu turpis a quam. Mauris vitae ornare lacus, in lobortis augue. Cras eget ipsum quis ex tempor pulvinar. Nam pretium risus ac sem finibus, eget interdum velit maximus. Quisque ante ante, placerat efficitur turpis ac, pretium gravida odio. Fusce commodo egestas quam, rhoncus porttitor magna rhoncus vitae. Aenean molestie nunc non est commodo, posuere tempor elit accumsan. Sed sapien erat, pretium id massa at, feugiat ultricies sem. Suspendisse commodo lobortis mi, at tempus eros finibus sit amet. Curabitur et purus sit amet nulla maximus ornare id ut nibh. Pellentesque blandit nisi eget ornare pharetra.";
    return Card(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Virtual Account Number:",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
            ),
            Padding(padding: EdgeInsets.all(8.0)),
            Text(
              rand,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
