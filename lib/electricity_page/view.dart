import 'package:airelectric/electricity_page/controller.dart';
import 'package:bezier_chart/bezier_chart.dart';
import 'package:flutter/material.dart';
import 'package:grid_selector/base_grid_selector_item.dart';

import 'package:grid_selector/grid_selector.dart';
import 'package:intl/intl.dart';

class ElectricityView extends StatefulWidget {
  @override
  _ElectricityViewState createState() => _ElectricityViewState();
}

class _ElectricityViewState extends ElectricityController {
  List dataElectricmeter = List();
  List dataPayment = List();
  String _myElectricitySelection;
  String _meterNumber;
  String _meterType;
  String price;
  List<DynamicHistory> listHistory = List();

  addHistory() {
    listHistory.add(DynamicHistory(dataPayment[0]['created_at'],
        dataPayment[0]['nominal'], dataPayment[0]['status']));
    setState(() {});
  }

  @override
  void initState() {
    getElectricmeter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading()
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
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Card(
                              child: Container(
                                height: 35,
                                padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0),
                                child: DropdownButtonHideUnderline(
                                    child: _buildDropDownElectricity()),
                              ),
                            ),
                          ),
                          Card(
                            child: Container(
                              height: 35,
                              child: _buildAddIconButton(),
                            ),
                          ),
                        ],
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
                                "Grafik Pemakaian Listrik",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      _buildDivider(),
                      GridSelector<int>(
                        title: "Electricity Top Up (Rp)",
                        items: _getTails(),
                        onSelectionChanged: (option) {
                          print(option);
                          setState(() {
                            price = option.toString();
                          });
                        },
                        itemSize: 70,
                      ),
                      _buildButtonTopUp(),
                      _buildDivider(),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 8.0),
                        width: double.infinity,
                        child: Text(
                          "History",
                          style: TextStyle(
                            fontSize: 24.0,
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      _buildHistory(),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  Widget _buildDropDownElectricity() {
    setState(() {
      if (jsonElectricmeter != null)
        dataElectricmeter = jsonElectricmeter['data'];
      if(_meterNumber == null)_meterNumber = dataElectricmeter[0]['meter_number'];
      if(_meterType == null)_meterType = dataElectricmeter[0]['meter_type'];
      //dataPayment = dataElectricmeter[0]['tokenpayments']['data'];
    });
    return DropdownButton(
      isExpanded: true,
      items: dataElectricmeter.map((item) {
        return new DropdownMenuItem(
          child: new Text(
            item['meter_number'] +
                ' - ' +
                item['meter_information'] +
                ' - ' +
                item['meter_type'],
            overflow: TextOverflow.ellipsis,
          ),
          value: item['meter_number'].toString() +
              "," +
              item['meter_type'].toString(),
        );
      }).toList(),
      hint: Text(dataElectricmeter[0]['meter_number'] +
          ' - ' +
          dataElectricmeter[0]['meter_information'] +
          ' - ' +
          dataElectricmeter[0]['meter_type']),
      onChanged: (String newVal) {
        setState(() {
          _myElectricitySelection = newVal;
          var arr = newVal.split(',');
          print(arr[1]);
          _meterNumber = arr[0];
          _meterType = arr[1];
          if (arr[1] == 'Token')
            getPaymentToken(arr[0]);
          else
            getPaymentBill(arr[0]);
        });
      },
      value: _myElectricitySelection,
    );
  }

  Widget _buildAddIconButton() {
    return IconButton(icon: Icon(Icons.add), onPressed: addHistory);
  }

  Widget sample1(BuildContext context) {
    setState(() {
      if (jsonElectricmeter != null) dataPayment = jsonPayment['data'];
    });

    print(dataPayment);
    print(dataPayment[0]['created_at'].toString());
    var parsedDate = DateTime.parse(
        dataPayment[dataPayment.length - 1]['created_at'].toString());
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

    var parsedDate2 = DateTime.parse(dataPayment[0]['created_at'].toString());
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
                height: MediaQuery.of(context).size.height / 6,
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
                              value: double.parse(
                                  dataPayment[index]['nominal'].toString()),
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
                    footerHeight: 40.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sample3(BuildContext context) {
    final fromDate = DateTime(2019, 05, 22);
    final toDate = DateTime.now();

    final date1 = DateTime.now().subtract(Duration(days: 2));
    final date2 = DateTime.now().subtract(Duration(days: 3));

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
              label: "Duty",
              onMissingValue: (dateTime) {
                if (dateTime.day.isEven) {
                  return 10.0;
                }
                return 5.0;
              },
              data: [
                DataPoint<DateTime>(value: 10, xAxis: date1),
                DataPoint<DateTime>(value: 50, xAxis: date2),
              ],
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
            footerHeight: 30.0,
          ),
        ),
      ),
    );
  }

  Widget _buildButtonTopUp() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: 60.0,
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
      child: RaisedButton(
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),
            side: BorderSide(color: Color.fromARGB(100, 10, 120, 10))),
        onPressed: _meterNumber != null && price != null
            ? () {
                if (_meterType == "Token")
                  addPaymentToken(_meterNumber, price);
                else
                  addPaymentBill(_meterNumber, price);
              }
            : null,
        color: Color.fromARGB(100, 10, 120, 10),
        textColor: Colors.white,
        child: Text("Masuk".toUpperCase(), style: TextStyle(fontSize: 18)),
      ),
    );
  }

  Padding _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 24.0,
      ),
      child: Divider(
        height: 2,
        color: Colors.grey,
      ),
    );
  }

  List<BaseGridSelectorItem> _getTails() {
    return [
      BaseGridSelectorItem(key: 10000, label: "10.000"),
      BaseGridSelectorItem(key: 20000, label: "20.000"),
      BaseGridSelectorItem(key: 50000, label: "50.000"),
      BaseGridSelectorItem(key: 75000, label: "75.000"),
      BaseGridSelectorItem(key: 100000, label: "100.000"),
      BaseGridSelectorItem(key: 200000, label: "200.000"),
      BaseGridSelectorItem(key: 500000, label: "500.000"),
      BaseGridSelectorItem(key: 750000, label: "750.000"),
    ];
  }

  Widget _buildHistory() {
    listHistory = List.generate(dataPayment.length, (index) {
      var parsedDate2 = DateTime.parse(dataPayment[index]['created_at']);
      var parsedDateto = new DateTime(
          parsedDate2.year,
          parsedDate2.month,
          parsedDate2.day,
          parsedDate2.hour,
          parsedDate2.minute,
          parsedDate2.second,
          parsedDate2.millisecond,
          parsedDate2.microsecond);
      final f = new DateFormat('dd MMM yyyy (hh:mm)');
      final formatter = NumberFormat.currency(locale: 'en_US', name: 'Rp.');

      return DynamicHistory(
          f.format(parsedDateto).toString(),
          formatter.format(dataPayment[index]['nominal']),
          dataPayment[index]['status']);
    });
    print(dataPayment[0]['nominal']);

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 400, minHeight: 0.0),
      child: Scrollbar(
        child: ListView.builder(
            //reverse: true,
            shrinkWrap: true,
            itemCount: listHistory.length,
            itemBuilder: (_, index) => listHistory[index]),
      ),
    );
  }
}

class DynamicHistory extends StatelessWidget {
  final String date;
  final String nominal;
  final String status;
  DynamicHistory(this.date, this.nominal, this.status);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      child: Card(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
                      child: Text("Tanggal : " + date),
                    ),
                    Text("Nominal : " + nominal),
                  ],
                ),
              ),
              Text(
                status.toUpperCase(),
                style: TextStyle(
                  fontSize: 20,
                  color: status == "paid" ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
