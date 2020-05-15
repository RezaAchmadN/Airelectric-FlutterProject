import 'package:airelectric/success_page/view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

abstract class SuccessController extends State<SuccessView>{
  var jsonPayment;
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

  updatePaymentBill(String id, String status) async {
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
      // getPaymentBill(meterNumber);
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

  updatePaymentToken(String id, String status, String tokenNumber) async {
    isLoadingTrue();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String jsonString = prefs.getString('token');
    print(jsonString);
    Map<String, String> dataHeader = {'Authorization': "Bearer "+jsonString};
    Map dataBody = {'id': id, "status": status, "token_number": tokenNumber};
    var response =
        await http.post("https://desolate-shelf-86894.herokuapp.com/api/payment/updatetoken", headers:dataHeader, body: dataBody);
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
      // getPaymentBill(meterNumber);
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