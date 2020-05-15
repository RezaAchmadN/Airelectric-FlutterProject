import 'package:airelectric/electricity_page/view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

abstract class ElectricityController extends State<ElectricityView>{
  var jsonElectricmeter;
  var jsonPayment;
  var jsonTemp;
  bool _isLoading = false;

  isLoadingTrue() {
    this._isLoading = true;
  }

  isLoadingFalse() {
    this._isLoading = false;
  }

  isLoading() {
    return this._isLoading;
  }

  getElectricmeter() async {
    isLoadingTrue();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String jsonString = prefs.getString('token');
    print(jsonString);
    Map userHeader = {'Authorization': jsonString};
    var response =
        await http.get("https://desolate-shelf-86894.herokuapp.com/api/electricmeter/readall", headers:{"Authorization": "Bearer firsttest"});
    if (response.statusCode == 200) {
      this.jsonElectricmeter = json.decode(response.body);
      setState(() {
        Fluttertoast.showToast(
          msg: response.statusCode.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
      });
      if(jsonElectricmeter[0]['meter_type']=="Token") getPaymentToken(jsonElectricmeter[0]['meter_number']);
      else getPaymentBill(jsonElectricmeter[0]['meter_number']);
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

  addTokenElectricmeter(String meterNumber, String meterInformation) async {
    isLoadingTrue();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String jsonString = prefs.getString('token');
    print(jsonString);
    Map userHeader = {'Authorization': jsonString};
    Map userBody = {'meter_number': meterNumber, 'meter_information': meterInformation};
    var response =
        await http.post("https://desolate-shelf-86894.herokuapp.com/api/electricmeter/createtoken", headers:{"Authorization": "Bearer firsttest","Accept": "application/json"}, body: userBody);
    if (response.statusCode == 201) {
      this.jsonTemp = json.decode(response.body);
      setState(() {
        Fluttertoast.showToast(
          msg: response.statusCode.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
      });
      getElectricmeter();
    } else {
      setState(() {
        isLoadingFalse();
      });
      print(response.body);
      jsonTemp = json.decode(response.body);
      Fluttertoast.showToast(
          msg: jsonTemp['message'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
    }
  }

  addBillElectricmeter(String meterNumber, String meterInformation) async {
    isLoadingTrue();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String jsonString = prefs.getString('token');
    print(jsonString);
    Map userHeader = {'Authorization': jsonString};
    Map userBody = {'meter_number': meterNumber, 'meter_information': meterInformation};
    var response =
        await http.post("https://desolate-shelf-86894.herokuapp.com/api/electricmeter/createbill", headers:{"Authorization": "Bearer firsttest","Accept": "application/json"}, body: userBody);
    if (response.statusCode == 201) {
      this.jsonTemp = json.decode(response.body);
      setState(() {
        Fluttertoast.showToast(
          msg: response.statusCode.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
      });
      getElectricmeter();
    } else {
      setState(() {
        isLoadingFalse();
      });
      print(response.body);
      jsonTemp = json.decode(response.body);
      Fluttertoast.showToast(
          msg: jsonTemp['message'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
    }
  }

  getPaymentToken(String meterNumber) async {
    isLoadingTrue();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String jsonString = prefs.getString('token');
    print(jsonString);
    Map dataHeader = {'Authorization': jsonString};
    Map dataBody = {'meter_number': meterNumber};
    var response =
        await http.post("https://desolate-shelf-86894.herokuapp.com/api/payment/readtoken", headers:{"Authorization": "Bearer firsttest"}, body: dataBody);
    if (response.statusCode == 200) {
      this.jsonPayment = json.decode(response.body);
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
      jsonPayment = json.decode(response.body);
      Fluttertoast.showToast(
          msg: jsonPayment['error'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
    }
  }

  getPaymentBill(String meterNumber) async {
    isLoadingTrue();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String jsonString = prefs.getString('token');
    print(jsonString);
    Map dataHeader = {'Authorization': jsonString};
    Map dataBody = {'meter_number': meterNumber};
    var response =
        await http.post("https://desolate-shelf-86894.herokuapp.com/api/payment/readbill", headers:{"Authorization": "Bearer firsttest"}, body: dataBody);
    if (response.statusCode == 200) {
      this.jsonPayment = json.decode(response.body);
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
      jsonPayment = json.decode(response.body);
      Fluttertoast.showToast(
          msg: jsonPayment['error'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
    }
  }

  addPaymentToken(String meterNumber, String nominal) async {
    isLoadingTrue();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String jsonString = prefs.getString('token');
    print(meterNumber+nominal);
    Map dataHeader = {'Authorization': jsonString};
    Map dataBody = {'meter_number': meterNumber, "nominal": nominal};
    var response =
        await http.post("https://desolate-shelf-86894.herokuapp.com/api/payment/createtoken", headers:{"Authorization": "Bearer firsttest"}, body: dataBody);
    if (response.statusCode == 201) {
      this.jsonPayment = json.decode(response.body);
      setState(() {
        isLoadingFalse();
        Fluttertoast.showToast(
          msg: response.statusCode.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
      });
      getPaymentToken(meterNumber);
    } else {
      setState(() {
        isLoadingFalse();
      });
      jsonPayment = json.decode(response.body);
      print(jsonPayment);
      Fluttertoast.showToast(
          msg: jsonPayment['error'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
    }
  }

  addPaymentBill(String meterNumber, String nominal) async {
    isLoadingTrue();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String jsonString = prefs.getString('token');
    print(jsonString);
    Map dataHeader = {'Authorization': jsonString};
    Map dataBody = {'meter_number': meterNumber, "nominal": nominal};
    var response =
        await http.post("https://desolate-shelf-86894.herokuapp.com/api/payment/createbill", headers:{"Authorization": "Bearer firsttest"}, body: dataBody);
    if (response.statusCode == 200) {
      this.jsonPayment = json.decode(response.body);
      setState(() {
        isLoadingFalse();
        Fluttertoast.showToast(
          msg: response.statusCode.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
      });
      getPaymentBill(meterNumber);
    } else {
      setState(() {
        isLoadingFalse();
      });
      jsonPayment = json.decode(response.body);
      Fluttertoast.showToast(
          msg: jsonPayment['error'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
    }
  }

}