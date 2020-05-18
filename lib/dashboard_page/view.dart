import 'package:airelectric/dashboard_page/controller.dart';
import 'package:bezier_chart/bezier_chart.dart';
import 'package:flutter/material.dart';

class DashboardView extends StatefulWidget {
  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends DashboardController {
  var jsonData;
  List dataElectricmeter = List();
  List dataPayment = List();

  @override
  void initState() {
    getAirConditionNearest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    jsonData = getJsonData();
    if (jsonData != null) print(jsonData['data']);
    return isLoading()
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            body: Container(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          navigateToAirConditionPage();
                        },
                        child: _buildAirCondition(),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(child: _buildTemperature()),
                          Expanded(child: _buildHumidity()),
                          Expanded(child: _buildWindVelocity()),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 16.0, 0.0, 0.0),
                        width: double.infinity,
                        child: Text(
                          "Electricity",
                          style: new TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Stack(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              navigateToElectricityPage();
                            },
                            child: Container(
                              height: 250,
                              width: double.infinity,
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 8.0),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              navigateToElectricityPage();
                            },
                            child: Card(
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                          height: 250,
                                          width: double.infinity,
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 8.0),
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    8.0, 0.0, 0.0, 0.0),
                                                child: Row(
                                                  // mainAxisAlignment: MainAxisAlignment.start,
                                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    jsonElectricmeter.isNotEmpty? Text(
                                                      jsonElectricmeter
                                                                  [0]
                                                              ['meter_number'] +
                                                          ' - ' +
                                                          jsonElectricmeter[0][
                                                              'meter_information'] +
                                                          ' - ' +
                                                          jsonElectricmeter[0]
                                                              ['meter_type'],
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                      ),
                                                    ): Container(),
                                                    new Spacer(),
                                                    Container(
                                                      child: IconButton(
                                                          icon: Icon(Icons
                                                              .arrow_forward),
                                                          onPressed: null),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              dataPayment.isNotEmpty
                                                  ? sample1(context)
                                                  : Container()
                                            ],
                                          )),
                                      Text(
                                        "Grafik History Pemakaian Listrik",
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  Widget _buildAirCondition() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 48.0, 0, 4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Air Condition",
            style: new TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Card(
            child: Container(
              margin: EdgeInsets.fromLTRB(16.0, 0, 0.0, 16.0),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        jsonData['data']['country'] +
                            ", " +
                            jsonData['data']['state'] +
                            ", " +
                            jsonData['data']['city'],
                        style: TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                      new Spacer(),
                      Container(
                        child: IconButton(
                            icon: Icon(Icons.arrow_forward), onPressed: null),
                      )
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    child: Row(
                      children: <Widget>[
                        Image.asset('assets/images/man2.png'),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 170,
                              margin: EdgeInsets.fromLTRB(0.0, 0, 16.0, 16.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      "Indeks kualitas udara (AQI)",
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        "• " +
                                            jsonData['data']['current']
                                                    ['pollution']['aqius']
                                                .toString(),
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 170,
                              margin: EdgeInsets.fromLTRB(0.0, 0, 16.0, 16.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      "Kondisi",
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        "• Sedang",
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 170,
                              margin: EdgeInsets.fromLTRB(0.0, 0, 16.0, 16.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      "Kesimpulan",
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        "• Tidak Sehat",
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemperature() {
    return Card(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/temperature.png',
              width: 50,
              height: 50,
            ),
            Text(
              jsonData['data']['current']['weather']['tp'].toString() + "°C",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHumidity() {
    return Card(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/humidity.png',
              width: 50,
              height: 50,
            ),
            Text(
              jsonData['data']['current']['weather']['hu'].toString() + "%",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildWindVelocity() {
    setState(() {
      if (jsonElectricmeter != null)
        dataElectricmeter  = jsonElectricmeter;
        if(jsonPayment != null)
        dataPayment =
            jsonPayment['data'];
    });
    return Card(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/wind_velocity.png',
              width: 50,
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  jsonData['data']['current']['weather']['ws'].toString(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "m/s",
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget sample1(BuildContext context) {
    setState(() {
      if (jsonPayment['data'] != null)
        dataPayment =
            jsonPayment['data'];
    });
    print(dataPayment);
    var parsedDate =
        DateTime.parse(dataPayment[dataPayment.length - 1]['created_at'].toString());
    var parsedDatefrom = new DateTime(
        parsedDate.year,
        parsedDate.month,
        parsedDate.day,
        parsedDate.hour,
        parsedDate.minute,
        parsedDate.second,
        parsedDate.millisecond,
        parsedDate.microsecond);
    final fromDate = parsedDatefrom;
    print(dataElectricmeter.length);

    var parsedDate2 = DateTime.parse(
        dataPayment[dataPayment.length - 1]['created_at'].toString());
    var parsedDateto = new DateTime(
        parsedDate2.year,
        parsedDate2.month,
        parsedDate2.day,
        parsedDate2.hour,
        parsedDate2.minute,
        parsedDate2.second,
        parsedDate2.millisecond,
        parsedDate2.microsecond + 1);
    final toDate = parsedDateto;

    return Center(
      child: Container(
        child: Column(
          children: <Widget>[
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height / 4,
                width: MediaQuery.of(context).size.width,
                child: BezierChart(
                  fromDate: fromDate,
                  bezierChartScale: BezierChartScale.WEEKLY,
                  toDate: toDate,
                  selectedDate: toDate,
                  series: [
                    BezierLine(
                        lineColor: Colors.black,
                        label: "AQI",
                        onMissingValue: (dateTime) {
                          return 0;
                        },
                        data: List.generate(dataPayment.length, (index) {
                          return DataPoint<DateTime>(
                              value: double.parse(dataPayment[index]
                                      ['nominal']
                                  .toString()),
                              xAxis: DateTime.now()
                                  .subtract(Duration(days: index)));
                        })),
                  ],
                  config: BezierChartConfig(
                    xAxisTextStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      //color: Color.fromRGBO(10, 120, 10, 100),
                    ),
                    verticalIndicatorStrokeWidth: 3.0,
                    verticalIndicatorColor: Colors.black26,
                    showVerticalIndicator: true,
                    verticalIndicatorFixedPosition: false,
                    footerHeight: 50.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget sample1(BuildContext context) {
  //   setState(() {
  //     if (jsonElectricmeter != null)
  //       dataElectricmeter =
  //           jsonElectricmeter['data'][0]['tokenpayments']['data'];
  //   });

  //   List x = new List<double>.generate(6, (i) => i + 1 * 1.0);
  //   print(dataElectricmeter.length);
  //   return Center(
  //     child: Container(
  //       child: Column(
  //         children: <Widget>[
  //           Container(
  //             padding: EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
  //             child: Row(
  //               // mainAxisAlignment: MainAxisAlignment.start,
  //               // crossAxisAlignment: CrossAxisAlignment.start,
  //               children: <Widget>[
  //                 Text(
  //                   jsonElectricmeter['data'][0]['meter_number'] +
  //                       ' - ' +
  //                       jsonElectricmeter['data'][0]['meter_information'] +
  //                       ' - ' +
  //                       jsonElectricmeter['data'][0]['meter_type'],
  //                   style: TextStyle(
  //                     fontSize: 12.0,
  //                   ),
  //                 ),
  //                 new Spacer(),
  //                 Container(
  //                   child: IconButton(
  //                       icon: Icon(Icons.arrow_forward), onPressed: null),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           Center(
  //             child: Container(
  //               //color: Colors.red,
  //               height: MediaQuery.of(context).size.height / 4,
  //               width: MediaQuery.of(context).size.width,
  //               child: BezierChart(
  //                 bezierChartScale: BezierChartScale.CUSTOM,
  //                 xAxisCustomValues: x,
  //                 series: [
  //                   BezierLine(
  //                       lineColor: Colors.black,
  //                       label: "Duty",
  //                       data: List.generate(6, (index) {
  //                         return DataPoint<double>(
  //                             value: double.parse(dataElectricmeter[index]
  //                                     ['nominal']
  //                                 .toString()),
  //                             xAxis: index * 1.0);
  //                       })),
  //                 ],
  //                 config: BezierChartConfig(
  //                   xAxisTextStyle: TextStyle(
  //                     color: Colors.black,
  //                     fontSize: 12,
  //                     //color: Color.fromRGBO(10, 120, 10, 100),
  //                   ),
  //                   verticalIndicatorStrokeWidth: 3.0,
  //                   verticalIndicatorColor: Colors.black26,
  //                   showVerticalIndicator: true,
  //                   verticalIndicatorFixedPosition: false,
  //                   //physics: const AlwaysScrollableScrollPhysics(),
  //                   //contentWidth: 400,
  //                   //backgroundColor: Colors.red,
  //                   //snap: false,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
