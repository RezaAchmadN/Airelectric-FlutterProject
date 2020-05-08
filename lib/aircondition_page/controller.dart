import 'dart:convert';

import 'package:airelectric/aircondition_page/view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

abstract class AirConditionController extends State<AirConditionView> {
  bool _isLoading1 = false;
  bool _isLoading2 = false;
  bool _isLoading3 = false;
  bool _isLoading4 = false;
  var jsonAirConditionNearest;
  var jsonCountry;
  var jsonState;
  var jsonCity;
  var jsonUpdateOrCreateAirCondition;
  var jsonWeather;

  isLoading1True() {
    this._isLoading1 = true;
  }

  isLoading1False() {
    this._isLoading1 = false;
  }

  isLoading1() {
    return this._isLoading1;
  }

  isLoading2() {
    return this._isLoading2;
  }

  isLoading3() {
    return this._isLoading3;
  }

  isLoading4() {
    return this._isLoading4;
  }

  getJsonAirConditionNearest() {
    return this.jsonAirConditionNearest;
  }

  getJsonCountry() {
    return this.jsonCountry;
  }

  getJsonState() {
    return this.jsonState;
  }

  getJsonWeather() {
    return this.jsonWeather;
  }

  getAirConditionNearest() async {
    isLoading1True();
    var response = await http.get(
        "http://api.airvisual.com/v2/nearest_city?key=cbb879ce-6937-4bab-8701-f34e1057932b");
    if (response.statusCode == 200) {
      this.jsonAirConditionNearest = json.decode(response.body);
      setState(() {
        Fluttertoast.showToast(
            msg: jsonAirConditionNearest['status'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      });
      updateOrCreateAirCondition(
          jsonAirConditionNearest['data']['city'],
          jsonAirConditionNearest['data']['current']['weather']['ic'],
          jsonAirConditionNearest['data']['current']['weather']['tp'].toString(),
          jsonAirConditionNearest['data']['current']['pollution']['aqius'].toString(),
          jsonAirConditionNearest['data']['current']['weather']['hu'].toString(),
          jsonAirConditionNearest['data']['current']['weather']['ws'].toString(),
          jsonAirConditionNearest['data']['current']['pollution']['ts'].toString(),
          );
      print("object");
    } else {
      jsonAirConditionNearest = json.decode(response.body);
      Fluttertoast.showToast(
          msg: jsonAirConditionNearest['code'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
    }
  }

  getCountry() async {
    _isLoading2 = true;
    var response = await http
        .get("http://desolate-shelf-86894.herokuapp.com/api/weather/country");
    if (response.statusCode == 200) {
      this.jsonCountry = json.decode(response.body);
      setState(() {
        Fluttertoast.showToast(
            msg: response.statusCode.toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        _isLoading2 = false;
      });
    } else {
      setState(() {});
      jsonCountry = json.decode(response.body);
      Fluttertoast.showToast(
          msg: response.statusCode.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
      _isLoading2 = false;
    }
  }

  getState(String countryName) async {
    _isLoading3 = true;
    Map data = {
      'country_name': countryName,
    };
    var response = await http.post(
        "http://desolate-shelf-86894.herokuapp.com/api/weather/country/state",
        body: data);
    if (response.statusCode == 200) {
      this.jsonState = json.decode(response.body);
      setState(() {
        // isLoading2False();
        Fluttertoast.showToast(
            msg: response.statusCode.toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        _isLoading3 = false;
      });
    } else {
      setState(() {
        // isLoading2False();
      });
      jsonState = json.decode(response.body);
      Fluttertoast.showToast(
          msg: response.statusCode.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
      _isLoading3 = false;
    }
  }

  getCity(String stateName) async {
    _isLoading4 = true;
    Map data = {
      'state_name': stateName,
    };
    var response = await http.post(
        "http://desolate-shelf-86894.herokuapp.com/api/weather/country/state/city",
        body: data);
    if (response.statusCode == 200) {
      this.jsonCity = json.decode(response.body);
      setState(() {
        // isLoading2False();
        Fluttertoast.showToast(
            msg: response.statusCode.toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        _isLoading4 = false;
      });
    } else {
      setState(() {
        // isLoading2False();
      });
      jsonCity = json.decode(response.body);
      Fluttertoast.showToast(
          msg: response.statusCode.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
      _isLoading4 = false;
    }
  }

  getAirConditionCity(String country, String state, String city) async {
    isLoading1True();
    var response = await http.get("http://api.airvisual.com/v2/city?city=" +
        city +
        "&state=" +
        state +
        "&country=" +
        country +
        "&key=cbb879ce-6937-4bab-8701-f34e1057932b");
    if (response.statusCode == 200) {
      this.jsonAirConditionNearest = json.decode(response.body);
      setState(() {
        Fluttertoast.showToast(
            msg: jsonAirConditionNearest['status'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      });
      print("object");
      updateOrCreateAirCondition(
          city, 
          jsonAirConditionNearest['data']['current']['weather']['ic'],
          jsonAirConditionNearest['data']['current']['weather']['tp'].toString(),
          jsonAirConditionNearest['data']['current']['pollution']['aqius'].toString(),
          jsonAirConditionNearest['data']['current']['weather']['hu'].toString(),
          jsonAirConditionNearest['data']['current']['weather']['ws'].toString(),
          jsonAirConditionNearest['data']['current']['pollution']['ts'].toString(),
          );
    } else {
      jsonAirConditionNearest = json.decode(response.body);
      Fluttertoast.showToast(
          msg: jsonAirConditionNearest['code'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
    }
  }

  updateOrCreateAirCondition(
      String cityName,
      String weather,
      String temperature,
      String pollution,
      String humidity,
      String windVelocity,
      String timestamp) async {
    Map data = {
      'city_name': cityName,
      'weather': weather,
      'temperature': temperature,
      'pollution': pollution,
      'humidity': humidity,
      'wind_velocity': windVelocity,
      'timestamp': timestamp,
    };
    print(cityName+" "+weather+" "+temperature+" "+pollution+" "+humidity+" "+windVelocity+" "+timestamp);
    var response = await http.post(
        "http://desolate-shelf-86894.herokuapp.com/api/weather/updateorcreate",
        body: data);
    if (response.statusCode == 200) {
      this.jsonUpdateOrCreateAirCondition = json.decode(response.body);
      setState(() {
        // isLoading2False();
        Fluttertoast.showToast(
            msg: response.statusCode.toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      });
      getWeather(cityName);
    } else {
      setState(() {
        // isLoading2False();
      });
      print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
      //jsonCity = json.decode(response.body);
      Fluttertoast.showToast(
          msg: response.statusCode.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
    }
  }

  getWeather(String cityName) async {
    Map data = {
      'city_name': cityName,
    };
    var response = await http.post(
        "http://desolate-shelf-86894.herokuapp.com/api/weather",
        body: data);
    if (response.statusCode == 200) {
      this.jsonWeather = json.decode(response.body);
      setState(() {
        isLoading1False();
        Fluttertoast.showToast(
            msg: response.statusCode.toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      });
      print(jsonWeather);
    } else {
      setState(() {
        isLoading1False();
      });
      jsonCity = json.decode(response.body);
      Fluttertoast.showToast(
          msg: response.statusCode.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
    }
  }
}
