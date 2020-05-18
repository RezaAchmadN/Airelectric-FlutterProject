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
  String meterTypeDialog;
  List<DynamicHistory> listHistory = List();

  String _selectedId;
  String _selectedMeterNumber;
  String _selectedMeterInformation;

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
                title: Text("Electricity"),
                backgroundColor: Color.fromRGBO(10, 120, 10, 100),
                actions: <Widget>[
                  _meterNumber != null
                      ? IconButton(
                          icon: Icon(
                            Icons.settings,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                child: new MyEditDialog(
                                  meterNumber: _meterNumber,
                                  onInfoChange: _onInfoChange,
                                  status: _meterType,
                                  initialInfo: _selectedMeterInformation,
                                  edit: _runEdit,
                                ));
                          },
                        )
                      : Container()
                ],
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
                                  child: dataPayment.isNotEmpty
                                      ? sample1(context)
                                      : Container()),
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
                      _meterType == "Token"
                          ? GridSelector<int>(
                              title: "Electricity Top Up (Rp)",
                              items: _getTails(),
                              onSelectionChanged: (option) {
                                price = option.toString();
                                print(price+"AA");
                                //print("AAAB" + price);
                                setState(() {});
                              },
                              itemSize: 70,
                            )
                          : _buildPayBill(),
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
      if (jsonElectricmeter != null) dataElectricmeter = jsonElectricmeter;
      if (_meterNumber == null && dataElectricmeter.isNotEmpty)
        _meterNumber = dataElectricmeter[0]['meter_number'];
      if (_meterType == null && dataElectricmeter.isNotEmpty)
        _meterType = dataElectricmeter[0]['meter_type'];
      if (jsonPayment != null) dataPayment = jsonPayment['data'];
      //dataPayment.add(dataPayment.length);
      print("AAA" + dataPayment.toString());
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
      hint: dataElectricmeter.isNotEmpty
          ? Text(dataElectricmeter[0]['meter_number'] +
              ' - ' +
              dataElectricmeter[0]['meter_information'] +
              ' - ' +
              dataElectricmeter[0]['meter_type'])
          : Text(""),
      onChanged: (String newVal) {
        setState(() {
          _myElectricitySelection = newVal;
          var arr = newVal.split(',');
          print(arr[1]);
          _meterNumber = arr[0];
          _meterType = arr[1];
          price = null;
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
    return IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              child: new MyDialog(
                onValueChange: _onValueChange,
                initialValue: _selectedId,
                onInfoChange: _onInfoChange,
                initialInfo: _selectedMeterInformation,
                onNumberChange: _onNumberChange,
                initialMeter: _selectedMeterNumber,
                add: _runAdd,
              ));
        });
  }

  Widget sample1(BuildContext context) {
    setState(() {
      if (jsonPayment != null) dataPayment = jsonPayment['data'];
    });

    print("aaa" + dataPayment.toString());
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

  Widget _buildPayBill() {
    final formatter = NumberFormat.currency(locale: 'en_US', name: 'Rp.');
    print(dataPayment.toString());
    return Card(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.0),
        child: dataPayment.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Electricity Pay Bill",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  Text("Power/rates  : " +
                      dataPayment[0]["power"] +
                      "/" +
                      dataPayment[0]["rates"]),
                  Padding(padding: EdgeInsets.all(4.0)),
                  Text("Stand Meter  : " +
                      dataPayment[0]["initial_meter"].toString() +
                      "-" +
                      dataPayment[0]["final_meter"].toString()),
                  Padding(padding: EdgeInsets.all(4.0)),
                  Text("Bill Date         : " + dataPayment[0]["bill_date"]),
                  Padding(padding: EdgeInsets.all(4.0)),
                  Text("Status            : " + dataPayment[0]["status"]),
                  Padding(padding: EdgeInsets.all(4.0)),
                  Text("Total Price    : " +
                      formatter.format(dataPayment[0]["nominal"])),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Power/rates  : "),
                  Padding(padding: EdgeInsets.all(4.0)),
                  Text("Stand Meter  : "),
                  Padding(padding: EdgeInsets.all(4.0)),
                  Text("Bill Date         : "),
                  Padding(padding: EdgeInsets.all(4.0)),
                  Text("Status            : "),
                  Padding(padding: EdgeInsets.all(4.0)),
                  Text("Total Price    : "),
                ],
              ),
      ),
    );
  }

  Widget _buildButtonTopUp() {
    print(price.toString()+"BB");
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: 60.0,
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
      child: RaisedButton(
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),
            side: BorderSide(color: Color.fromARGB(100, 10, 120, 10))),
        onPressed:
            (_meterNumber != null && price != null && _meterType == "Token") ||
                    (_meterNumber != null &&
                        dataPayment.isNotEmpty &&
                        _meterType == "Bill" &&
                        dataPayment[0]["status"] == "unpaid")
                ? () {
                    if (_meterType == "Token") {
                      addPaymentToken(_meterNumber, price);
                      navigateToPayment(int.parse(price));
                    } else
                      navigateToPayment(dataPayment[0]["nominal"]);
                  }
                : null,
        color: Color.fromARGB(100, 10, 120, 10),
        textColor: Colors.white,
        child: Text("Pay".toUpperCase(), style: TextStyle(fontSize: 18)),
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
          dataPayment[index]['status'],
          dataPayment[index]['id'].toString(),
          _navigateToSuccess,
          dataPayment[index]['token_number']);
    });

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

  void _onValueChange(String value) {
    setState(() {
      _selectedId = value;
    });
  }

  void _onNumberChange(String value) {
    setState(() {
      _selectedMeterNumber = value;
    });
  }

  void _onInfoChange(String value) {
    setState(() {
      _selectedMeterInformation = value;
    });
  }

  void _runAdd(String status, String meterNumber, String meterInformation) {
    setState(() {
      if (status == "Token") {
        addTokenElectricmeter(meterNumber, meterInformation);
      } else
        addBillElectricmeter(meterNumber, meterInformation);
    });
  }

  void _runEdit(String status, String meterNumber, String meterInformation) {
    setState(() {
      if (status == "Token") {
        editTokenElectricmeter(meterNumber, meterInformation);
      } else
        editBillElectricmeter(meterNumber, meterInformation);
    });
  }

  void _navigateToSuccess(String id) {
    setState(() {
      navigateToSuccess(id, _meterType);
    });
  }
}

class DynamicHistory extends StatelessWidget {
  final String date;
  final String nominal;
  final String status;
  final String id;
  final String tokenNumber;
  final void Function(String) success;
  DynamicHistory(this.date, this.nominal, this.status, this.id, this.success,
      this.tokenNumber);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        success(id);
      },
      child: Container(
        height: 105,
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
                      Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0)),
                      tokenNumber != null
                          ? Text("Token Number : " + tokenNumber)
                          : Container(),
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
      ),
    );
  }
}

class MyDialog extends StatefulWidget {
  const MyDialog(
      {this.onValueChange,
      this.initialValue,
      this.initialMeter,
      this.onNumberChange,
      this.initialInfo,
      this.onInfoChange,
      this.add});

  final String initialValue;
  final void Function(String) onValueChange;
  final String initialMeter;
  final void Function(String) onNumberChange;
  final String initialInfo;
  final void Function(String) onInfoChange;
  final void Function(String, String, String) add;

  @override
  State createState() => new MyDialogState();
}

class MyDialogState extends State<MyDialog> {
  String _selectedId;
  String _selectedMeterNumber;
  String _selectedMeterInformation;

  TextEditingController numberController = new TextEditingController();
  TextEditingController infoController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedId = widget.initialValue;
  }

  Widget build(BuildContext context) {
    return new SimpleDialog(
      backgroundColor: Colors.transparent,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Color.fromARGB(55, 10, 120, 10),
                width: 3,
              ),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          height: 350,
          padding: EdgeInsets.all(16.0),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Add Electricmeter",
                style:
                    new TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 16.0)),
              Text(
                "Meter Number",
                style: new TextStyle(
                  fontSize: 16.0,
                ),
              ),
              Container(
                height: 45.0,
                child: TextField(
                  controller: numberController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(55, 10, 120, 10), width: 3.0),
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(55, 10, 120, 10), width: 3.0),
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 8.0)),
              Text(
                "Meter Information",
                style: new TextStyle(
                  fontSize: 16.0,
                ),
              ),
              Container(
                height: 45.0,
                child: TextField(
                  controller: infoController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(55, 10, 120, 10), width: 3.0),
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(55, 10, 120, 10), width: 3.0),
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 8.0)),
              Text(
                "Meter Type",
                style: new TextStyle(
                  fontSize: 16.0,
                ),
              ),
              new Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Color.fromARGB(55, 10, 120, 10),
                      width: 3,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                width: double.infinity,
                height: 45,
                padding: const EdgeInsets.all(10.0),
                child: DropdownButtonHideUnderline(
                  child: new DropdownButton<String>(
                    hint: const Text("Pick a thing"),
                    value: _selectedId,
                    onChanged: (String value) {
                      setState(() {
                        _selectedId = value;
                      });
                      widget.onValueChange(value);
                    },
                    items: <String>['Token', 'Bill'].map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 8.0, 0, 0),
                child: new RaisedButton(
                  child: Container(
                    width: double.infinity,
                    child: Center(child: new Text("Save")),
                  ),
                  onPressed: () {
                    setState(() {
                      print(numberController.text);
                      print(_selectedId);
                      widget.add(_selectedId, numberController.text,
                          infoController.text);
                    });
                    Navigator.of(context, rootNavigator: true).pop(context);
                  },
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class MyEditDialog extends StatefulWidget {
  const MyEditDialog(
      {this.meterNumber,
      this.status,
      this.initialInfo,
      this.onInfoChange,
      this.edit});

  final String meterNumber;
  final String status;
  final String initialInfo;
  final void Function(String) onInfoChange;
  final void Function(String, String, String) edit;

  @override
  State createState() => new MyEditDialogState();
}

class MyEditDialogState extends State<MyEditDialog> {
  String _selectedMeterNumber;
  String _selectedMeterInformation;
  String _selectedMeterType;

  TextEditingController infoController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedMeterNumber = widget.meterNumber;
    _selectedMeterType = widget.status;
  }

  Widget build(BuildContext context) {
    return new SimpleDialog(
      backgroundColor: Colors.transparent,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Color.fromARGB(55, 10, 120, 10),
                width: 3,
              ),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          height: 350,
          padding: EdgeInsets.all(16.0),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Edit Electricmeter",
                style:
                    new TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 16.0)),
              Text(
                "Meter Number",
                style: new TextStyle(
                  fontSize: 16.0,
                ),
              ),
              Text(
                _selectedMeterNumber,
                style:
                    new TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 8.0)),
              Text(
                "Meter Information",
                style: new TextStyle(
                  fontSize: 16.0,
                ),
              ),
              Container(
                height: 45.0,
                child: TextField(
                  controller: infoController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(55, 10, 120, 10), width: 3.0),
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(55, 10, 120, 10), width: 3.0),
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 8.0)),
              Text(
                "Meter Type",
                style: new TextStyle(
                  fontSize: 16.0,
                ),
              ),
              Text(
                _selectedMeterType,
                style:
                    new TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 8.0, 0, 0),
                child: new RaisedButton(
                  child: Container(
                    width: double.infinity,
                    child: Center(child: new Text("Save")),
                  ),
                  onPressed: () {
                    setState(() {
                      widget.edit(_selectedMeterType, _selectedMeterNumber,
                          infoController.text);
                    });
                    Navigator.of(context, rootNavigator: true).pop(context);
                  },
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
