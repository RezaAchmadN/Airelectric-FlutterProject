import 'package:airelectric/electricity_page/view.dart';
import 'package:airelectric/success_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

abstract class ElectricityController extends State<ElectricityView>{
  List test = List();
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
    Map<String, String> userHeader = {'Authorization': "Bearer "+jsonString};
    var response =
        await http.get("https://desolate-shelf-86894.herokuapp.com/api/electricmeter/readall", headers:userHeader);
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
      test = jsonElectricmeter;
      if(test.isNotEmpty){
        if(jsonElectricmeter[0]['meter_type']=="Token") getPaymentToken(jsonElectricmeter[0]['meter_number']);
        else getPaymentBill(jsonElectricmeter[0]['meter_number']);
      }else {
        setState(() {
          isLoadingFalse();
        });
      }
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
    Map<String, String> userHeader = {'Authorization': "Bearer "+jsonString,"Accept": "application/json"};
    Map userBody = {'meter_number': meterNumber, 'meter_information': meterInformation};
    var response =
        await http.post("https://desolate-shelf-86894.herokuapp.com/api/electricmeter/createtoken", headers:userHeader, body: userBody);
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
    Map<String, String> userHeader = {'Authorization': "Bearer "+jsonString,"Accept": "application/json"};
    Map userBody = {'meter_number': meterNumber, 'meter_information': meterInformation};
    var response =
        await http.post("https://desolate-shelf-86894.herokuapp.com/api/electricmeter/createbill", headers:userHeader, body: userBody);
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

  editTokenElectricmeter(String meterNumber, String meterInformation) async {
    isLoadingTrue();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String jsonString = prefs.getString('token');
    print(jsonString);
    Map<String, String> userHeader = {'Authorization': "Bearer "+jsonString,"Accept": "application/json"};
    Map userBody = {'meter_number': meterNumber, 'meter_information': meterInformation};
    var response =
        await http.post("https://desolate-shelf-86894.herokuapp.com/api/electricmeter/updatetoken", headers:userHeader, body: userBody);
    if (response.statusCode == 200) {
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

  editBillElectricmeter(String meterNumber, String meterInformation) async {
    isLoadingTrue();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String jsonString = prefs.getString('token');
    print(jsonString);
    Map<String, String> userHeader = {'Authorization': "Bearer "+jsonString,"Accept": "application/json"};
    Map userBody = {'meter_number': meterNumber, 'meter_information': meterInformation};
    var response =
        await http.post("https://desolate-shelf-86894.herokuapp.com/api/electricmeter/updatebill", headers:userHeader, body: userBody);
    if (response.statusCode == 200) {
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
    Map<String, String> userHeader = {'Authorization': "Bearer "+jsonString};
    Map dataBody = {'meter_number': meterNumber};
    var response =
        await http.post("https://desolate-shelf-86894.herokuapp.com/api/payment/readtoken", headers:userHeader, body: dataBody);
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
    Map<String, String> userHeader = {'Authorization': "Bearer "+jsonString};
    Map dataBody = {'meter_number': meterNumber};
    var response =
        await http.post("https://desolate-shelf-86894.herokuapp.com/api/payment/readbill", headers:userHeader, body: dataBody);
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
    Map<String, String> userHeader = {'Authorization': "Bearer "+jsonString};
    Map dataBody = {'meter_number': meterNumber, "nominal": nominal};
    var response =
        await http.post("https://desolate-shelf-86894.herokuapp.com/api/payment/createtoken", headers:userHeader, body: dataBody);
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

  updatePaymentBill(String id, String status, String meterNumber) async {
    isLoadingTrue();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String jsonString = prefs.getString('token');
    print(jsonString);
    Map<String, String> dataHeader = {'Authorization': "Bearer "+jsonString};
    Map dataBody = {'id': id, "status": status};
    var response =
        await http.post("https://desolate-shelf-86894.herokuapp.com/api/payment/updatebill", headers:dataHeader, body: dataBody);
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

  navigateToSuccess(String id, String type){
    Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => SuccessPage(id: id,type: type,),
    ));
  }
}