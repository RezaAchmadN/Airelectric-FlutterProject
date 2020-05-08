import 'package:airelectric/login_page.dart';
import 'package:airelectric/register_dart/view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';



abstract class RegisterController extends State<RegisterView> {
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

  signUp(String email, String password, String name, String phoneNumber) async {
    Map data = {
      'email': email,
      'password': password,
      'name': name,
      'phone_number': phoneNumber,
    };
    var body = jsonEncode(data);
    var jsonData;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var response =
        await http.post("https://desolate-shelf-86894.herokuapp.com/api/auth/register", headers: {"Content-Type": "application/json", "Accept": "application/json"},body: body);
    if (response.statusCode == 201) {
      jsonData = json.decode(response.body);
      setState(() {
        isLoadingFalse();
        sharedPreferences.setString("token", jsonData['token']);
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
        Fluttertoast.showToast(
          msg: "Register Succses",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
      });
    } else {
      setState(() {
        isLoadingFalse();
      });
      jsonData = json.decode(response.body);
      Fluttertoast.showToast(
          msg: jsonData['message'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
    }
  }
}