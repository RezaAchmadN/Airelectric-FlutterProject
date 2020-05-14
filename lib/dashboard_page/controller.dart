import 'package:airelectric/aircondition_page.dart';
import 'package:airelectric/dashboard_page/view.dart';
import 'package:airelectric/electricity_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class DashboardController extends State<DashboardView> {
  bool _isLoading = true;
  var jsonData;
  var jsonElectricmeter;
  String stringhome;

  isLoadingTrue() {
    this._isLoading = true;
  }

  isLoadingFalse() {
    this._isLoading = false;
  }

  isLoading() {
    return this._isLoading;
  }

  getJsonData(){
    return this.jsonData;
  }

  getAirConditionNearest() async {
    var response = await http.get(
        "http://api.airvisual.com/v2/nearest_city?key=cbb879ce-6937-4bab-8701-f34e1057932b");
    if (response.statusCode == 200) {
      this.jsonData = json.decode(response.body);
      setState(() {
        Fluttertoast.showToast(
            msg: jsonData['status'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      });
      getElectricmeter();
      return jsonData['status'];
    } else {
      setState(() {
      });
      jsonData = json.decode(response.body);
      Fluttertoast.showToast(
          msg: jsonData['code'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
    }
  }

  getElectricmeter() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String jsonString = prefs.getString('token');
    print(jsonString);
    Map userHeader = {'Authorization': jsonString};
    var response =
        await http.get("https://desolate-shelf-86894.herokuapp.com/api/electricmeter/readtoken", headers:{"Authorization": "Bearer firsttest"});
    if (response.statusCode == 200) {
      this.jsonElectricmeter = json.decode(response.body);
      setState(() {
        isLoadingFalse();
        Fluttertoast.showToast(
          msg: response.statusCode.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
      });
    } else {
      setState(() {
        isLoadingFalse();
      });
      jsonElectricmeter = json.decode(response.body);
      Fluttertoast.showToast(
          msg: jsonElectricmeter['error'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
    }
  }

  navigateToAirConditionPage(){
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AirConditionPage(),
        ),
      );
  }
  navigateToElectricityPage(){
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ElectricityPage(),
        ),
      );
  }
}
