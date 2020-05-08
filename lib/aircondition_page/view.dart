import 'package:airelectric/aircondition_page/controller.dart';
import 'package:bezier_chart/bezier_chart.dart';
import 'package:flutter/material.dart';

class AirConditionView extends StatefulWidget {
  @override
  _AirConditionViewState createState() => _AirConditionViewState();
}

class _AirConditionViewState extends AirConditionController {
  var jsonAirConditionNearest;
  var jsonCountry;
  var jsonState;
  var jsonCity;
  List dataCountry = List();
  List dataState = List();
  List dataCity = List();
  List dataWeather = List();
  String _myCountrySelection;
  String _myStateSelection;
  String _myCitySelection;

  @override
  void initState() {
    getAirConditionNearest();
    getCountry();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    jsonAirConditionNearest = getJsonAirConditionNearest();
    jsonCountry = getJsonCountry();
    //dataCountry = jsonCountry['data'];
    if (jsonAirConditionNearest != null &&
        _myCountrySelection == null &&
        _myStateSelection == null &&
        _myCitySelection == null) {
      _myCountrySelection = jsonAirConditionNearest['data']['country'];
      _myStateSelection = jsonAirConditionNearest['data']['state'];
      _myCitySelection = jsonAirConditionNearest['data']['city'];
    }
    return isLoading1()
        ? Center(child: CircularProgressIndicator())
        : MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                title: Text("Air Condition"),
                backgroundColor: Color.fromRGBO(10, 120, 10, 100),
              ),
              body: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Card(
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    height: 30,
                                    padding: EdgeInsets.all(4.0),
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            width: 0.2,
                                            style: BorderStyle.solid),
                                      ),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                        child: isLoading2()
                                            ? Center(
                                                child:
                                                    CircularProgressIndicator())
                                            : _buildDropDownCountry()),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 30,
                                    padding: EdgeInsets.all(4.0),
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            width: 0.2,
                                            style: BorderStyle.solid),
                                      ),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                        child: isLoading3()
                                            ? Center(
                                                child:
                                                    CircularProgressIndicator())
                                            : _buildDropDownState()),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 30,
                                    padding: EdgeInsets.all(4.0),
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            width: 0.2,
                                            style: BorderStyle.solid),
                                      ),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                        child: isLoading4()
                                            ? Center(
                                                child:
                                                    CircularProgressIndicator())
                                            : _buildDropDownCity()),
                                  ),
                                ),
                              ],
                            ),
                            _buildAirCondition(),
                          ],
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(child: _buildTemperature()),
                          Expanded(child: _buildHumidity()),
                          Expanded(child: _buildWindVelocity()),
                        ],
                      ),
                      Card(
                        child: _buildWeather(),
                      ),
                      Card(
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Container(
                                  height: 150,
                                  width: double.infinity,
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 8.0),
                                  child: sample1(context)),
                              Text(
                                "Grafik Polusi",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  Widget _buildDropDownCountry() {
    setState(() {
      if (jsonCountry != null) dataCountry = jsonCountry['data'];
    });
    return DropdownButton(
      isExpanded: true,
      items: dataCountry.map((item) {
        return new DropdownMenuItem(
          child: new Text(
            item['name'],
            overflow: TextOverflow.ellipsis,
          ),
          value: item['name'].toString(),
        );
      }).toList(),
      hint: Text(_myCountrySelection != null ? _myCountrySelection : "Country"),
      onChanged: (String newVal) {
        setState(() {
          _myCountrySelection = newVal;
          _myStateSelection = null;
          print(newVal);
          getState(newVal);
        });
      },
      value: _myCountrySelection,
    );
  }

  Widget _buildDropDownState() {
    setState(() {
      if (jsonState != null) dataState = jsonState['data'];
    });
    return DropdownButton(
      isExpanded: true,
      items: dataState.map((item) {
        return new DropdownMenuItem(
          child: new Text(
            item['name'],
            overflow: TextOverflow.ellipsis,
          ),
          value: item['name'].toString(),
        );
      }).toList(),
      hint: Text(_myStateSelection != null ? _myStateSelection : "State"),
      onChanged: (String newVal) {
        setState(() {
          _myStateSelection = newVal;
          _myCitySelection = null;
          print(newVal);
          getCity(newVal);
        });
      },
      value: _myStateSelection,
    );
  }

  Widget _buildDropDownCity() {
    setState(() {
      if (jsonCity != null) dataCity = jsonCity['data'];
    });
    return DropdownButton(
      isExpanded: true,
      items: dataCity.map((item) {
        return new DropdownMenuItem(
          child: new Text(
            item['name'],
            overflow: TextOverflow.ellipsis,
          ),
          value: item['name'].toString(),
        );
      }).toList(),
      hint: Text(_myCitySelection != null ? _myCitySelection : "City"),
      onChanged: (String newVal) {
        setState(() {
          _myCitySelection = newVal;
          print(newVal);
          getAirConditionCity(
              _myCountrySelection, _myStateSelection, _myCitySelection);
        });
      },
      value: _myCitySelection,
    );
  }

  Widget _buildAirCondition() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 8.0, 0, 4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 16.0),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        'assets/images/man2.png',
                        width: 100,
                        height: 100,
                      ),
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
                                          jsonAirConditionNearest['data']
                                                      ['current']['pollution']
                                                  ['aqius']
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
              jsonAirConditionNearest['data']['current']['weather']['tp']
                      .toString() +
                  "°C",
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
              jsonAirConditionNearest['data']['current']['weather']['hu']
                      .toString() +
                  "%",
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
                  jsonAirConditionNearest['data']['current']['weather']['ws']
                      .toString(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "m/s",
                  style: TextStyle(
                    fontSize: 12,
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

  Widget _buildWeather() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 8.0, 0, 4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Cuaca Saat Ini",
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.all(16.0),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        'assets/images/' +
                            jsonAirConditionNearest['data']['current']
                                ['weather']['ic'] +
                            '.png',
                        width: 100,
                        height: 100,
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            jsonAirConditionNearest['data']['current']['weather']['ic'] == "01d"
                                ? "Siang Cerah"
                                : jsonAirConditionNearest['data']['current']['weather']['ic'] == "01n"
                                    ? "Malam Cerah"
                                    : jsonAirConditionNearest['data']['current']['weather']['ic'] == "02d"
                                        ? "Sedikit Berawan"
                                        : jsonAirConditionNearest['data']['current']['weather']['ic'] == "02n"
                                            ? "Sedikit Berawan"
                                            : jsonAirConditionNearest['data']['current']['weather']['ic'] == "03d"
                                                ? "Berawan"
                                                : jsonAirConditionNearest['data']
                                                                ['current']
                                                            ['weather']['ic'] ==
                                                        "04d"
                                                    ? "Sangat Berawan"
                                                    : jsonAirConditionNearest['data']['current']['weather']['ic'] == "04n"
                                                        ? "Sangat Berawan"
                                                        : jsonAirConditionNearest['data']['current']['weather']['ic'] == "09d"
                                                            ? "Hujan Lebat"
                                                            : jsonAirConditionNearest['data']['current']['weather']['ic'] == "09n"
                                                                ? "Hujan Lebat"
                                                                : jsonAirConditionNearest['data']['current']['weather']['ic'] == "10d"
                                                                    ? "Hujan"
                                                                    : jsonAirConditionNearest['data']['current']['weather']['ic'] == "10n"
                                                                        ? "Hujan"
                                                                        : jsonAirConditionNearest['data']['current']['weather']['ic'] == "11d" ? "Badai Petir" : jsonAirConditionNearest['data']['current']['weather']['ic'] == "13d" ? "Salju" : jsonAirConditionNearest['data']['current']['weather']['ic'] == "50d" ? "Berkabut" : jsonAirConditionNearest['data']['current']['weather']['ic'] == "50n" ? "Berkabut" : "",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 32,
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
          ),
        ],
      ),
    );
  }

  Widget sample1(BuildContext context) {
    setState(() {
      if (jsonWeather != null) dataWeather = jsonWeather['data'];
    });
  var parsedDate = DateTime.parse(jsonWeather['data'][dataWeather.length-1]['created_at'].toString());
  var parsedDatefrom = new DateTime(parsedDate.year, parsedDate.month, parsedDate.day, parsedDate.hour, parsedDate.minute, parsedDate.second, parsedDate.millisecond, parsedDate.microsecond);
  final fromDate = parsedDatefrom;

  var parsedDate2 = DateTime.parse(jsonWeather['data'][0]['created_at'].toString());
  var parsedDateto = new DateTime(parsedDate2.year, parsedDate2.month, parsedDate2.day, parsedDate2.hour, parsedDate2.minute, parsedDate2.second, parsedDate2.millisecond, parsedDate2.microsecond+1);
  final toDate = parsedDateto;

  return Center(
    child: Container(
      height: MediaQuery.of(context).size.height / 2,
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
            data: List.generate(dataWeather.length, (index){
              return DataPoint<DateTime>(value: double.parse(jsonWeather['data'][index]['pollution'].toString()), xAxis: DateTime.now().subtract(Duration(days: index)));
            })
          ),
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
          footerHeight: 70.0,
        ),
      ),
    ),
  );
}
}
