import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web/homePage.dart';
import 'package:web/main.dart';
import 'package:web/models/user.dart';
import 'package:web/registerPage.dart';
import 'package:http/http.dart' as http;
import 'package:web/validators.dart';

class LoginPage extends StatefulWidget {
  static const route = "/LoginPage";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Color _gradientStart =
      Color(0xFFB5E3FF); //Change start gradient color here
  final Color _gradientEnd = Color(0xFFA6A5E8); //Change end gradient color here
  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Container(
        child: Column(
//          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(50.0),
              child: Center(
                  child: Text(
                "Gallery AI",
                style: TextStyle(fontFamily: "MainDesignFont", fontSize: 100.0),
              )),
            ),
            _buildLoginCard()
          ],
        ),
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
              colors: [_gradientStart, _gradientEnd],
              begin: const FractionalOffset(0.5, 0.0),
              end: const FractionalOffset(0.0, 0.5),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
      ),
    );
  }

  Widget _buildLoginCard() {
    return Container(
      width: 500.0,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  "Sign in",
                  style: TextStyle(fontSize: 25.0),
                ),
                Container(
                  height: 30.0,
                ),
                Row(
                  children: [
                    Text(
                      "Email:",
                      style: TextStyle(fontSize: 15.0),
                    )
                  ],
                ),
                TextFormField(
                  onSaved: (value) => _email = value,
                  validator: Validators.emailValidator,
                ),
                Container(
                  height: 20.0,
                ),
                Row(children: [
                  Text(
                    "Password:",
                    style: TextStyle(fontSize: 15.0),
                  )
                ]),
                TextFormField(
                  obscureText: true,
                  onSaved: (value) => _password = value,
                ),
                Container(
                  height: 20.0,
                ),
                Container(
                  width: 150.0,
                  child: FlatButton(
                    color: Color(0xFFEB6EA1),
                    child: Text(
                      "Sign in",
                      style: TextStyle(fontSize: 15.0, color: Colors.white),
                    ),
                    onPressed: () {
                      // TODO: LOGIN REQEST
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        _loginUser().then((value) {
                          if (value.statusCode != 200) {
                            _showDialogAboutBadAuth();
                          } else {
                            var data = json.decode(value.body);
                            MyApp.user = User()
                                .setEmail(data['email'])
                                .setRegistrationDate(
                                    DateTime.parse(data['registration_date']))
                                .setSurname(data['name'])
                                .setName(data['surname'])
                                .setId(data['id'])
                                .setBirthDate(DateTime.parse(data['birth_date']));
                            Navigator.pushNamed(context, HomePage.route);
                          }
                        });
                      }
//                      Navigator.pushNamed(context, HomePage.route);
                    },
                  ),
                ),
                Container(
                  height: 20.0,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(fontSize: 15.0),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.pushNamed(context, RegisterPage.route);
                      },
                      child: Text(
                        "Sign up!",
                        style: TextStyle(fontSize: 15.0, color: Colors.blue),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<http.Response> _loginUser() {
    return http.post(
      'http://127.0.0.1:8000/api/user/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({'email': _email, 'password': _password}),
    );
  }

  Future<void> _showDialogAboutBadAuth() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Try again'),
          content: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ Text('Wrong email or password'),
              FlatButton(
                onPressed: () {
                  // TODO: FORGOT PASSWORD PAGE
                },
                child: Text(
                  "Forgot password?",
                  style: TextStyle(fontSize: 15.0, color: Colors.blue),
                ),
              )
            ],),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
