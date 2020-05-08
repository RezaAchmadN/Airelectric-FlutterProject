import 'package:airelectric/login_page/controller.dart';
import 'package:airelectric/register_page.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends LoginController {
  @override
  Widget build(BuildContext context) {
    return isLoading()
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _buildLogo(),
                      _buildEmailTF(),
                      _buildPasswordTF(),
                      _buildButtonSignIn(),
                      _buildStringDaftar(),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  Widget _buildLogo() {
    return Center(
      child: Image.asset('assets/images/logo.png'),
    );
  }

  TextEditingController emailController = new TextEditingController();
  Widget _buildEmailTF() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Email",
            style: new TextStyle(
              fontSize: 16.0,
            ),
          ),
          Container(
            height: 45.0,
            child: TextField(
              controller: emailController,
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
          )
        ],
      ),
    );
  }

  TextEditingController passwordController = new TextEditingController();
  bool _obscureText = true;
  Widget _buildPasswordTF() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Password",
            style: new TextStyle(
              fontSize: 16.0,
            ),
          ),
          Container(
            height: 45.0,
            child: TextField(
              controller: passwordController,
              obscureText: _obscureText,
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
          )
        ],
      ),
    );
  }

  Widget _buildButtonSignIn() {
    return Container(
      width: double.infinity,
      height: 90.0,
      padding: EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 0),
      child: RaisedButton(
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),
            side: BorderSide(color: Color.fromARGB(100, 10, 120, 10))),
        onPressed: () {
          setState(() {
            isLoadingTrue();
          });
          signIn(emailController.text, passwordController.text);
        },
        color: Color.fromARGB(100, 10, 120, 10),
        textColor: Colors.white,
        child: Text("Masuk".toUpperCase(), style: TextStyle(fontSize: 18)),
      ),
    );
  }

  Widget _buildStringDaftar() {
    return Container(
      padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Belum Punya Akun? ",
            style: new TextStyle(
              fontSize: 14.0,
            ),
          ),
          InkWell(
              child: Text(
                "Daftar",
                style: new TextStyle(
                  fontSize: 14.0,
                  color: Color.fromARGB(100, 10, 120, 10),
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterPage(),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
