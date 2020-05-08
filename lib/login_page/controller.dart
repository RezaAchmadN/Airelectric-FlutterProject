import 'package:airelectric/login_page/view.dart';
import 'package:airelectric/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

abstract class LoginController extends State<LoginView> {
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

  signIn(String email, String password) async {
    Map data = {
      'email': email,
      'password': password,
    };
    var jsonData;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var response =
        await http.post("https://desolate-shelf-86894.herokuapp.com/api/auth/login", body: data);
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      setState(() {
        isLoadingFalse();
        sharedPreferences.setString("token", jsonData['token']);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardPage(),
          ),
        );
      });
    } else {
      setState(() {
        isLoadingFalse();
      });
      jsonData = json.decode(response.body);
      Fluttertoast.showToast(
          msg: jsonData['error'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
    }
  }
}
