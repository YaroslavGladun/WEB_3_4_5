import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:web/homePage.dart';
import 'package:web/loginPage.dart';
import 'package:web/main.dart';
import 'package:web/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:web/validators.dart';

class EditAccountPage extends StatefulWidget {
  static const route = "/EditAccountPage";

  @override
  _EditAccountPageState createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  final Color _gradientStart = Color(0xFFFFC4B3);
  final Color _gradientEnd = Color(0xFFEB6EA1);
  final _formKey = GlobalKey<FormState>();

  // TODO: BIRTH DATE MUST BE HERE
  DateTime _birthDate = MyApp.user.birthDate;
  String _birthDateText = DateFormat('yyyy-MM-dd').format(MyApp.user.birthDate);
  String _name = MyApp.user.name;
  String _surname = MyApp.user.surname;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
            _buildLoginCard(),
            Container(
              height: 100.0,
            ),
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
                  "Edit account",
                  style: TextStyle(fontSize: 25.0),
                ),
                Container(
                  height: 30.0,
                ),
                Row(
                  children: [
                    Text(
                      "Name:",
                      style: TextStyle(fontSize: 15.0),
                    )
                  ],
                ),
                TextFormField(
                  validator: Validators.nameValidator,
                  onSaved: (value) => _name = value,
                  initialValue: _name,
                ),
                Container(
                  height: 20.0,
                ),
                Row(
                  children: [
                    Text(
                      "Surname:",
                      style: TextStyle(fontSize: 15.0),
                    )
                  ],
                ),
                TextFormField(
                  validator: Validators.surnameValidator,
                  onSaved: (value) => _surname = value,
                  initialValue: _surname,
                ),
                Container(
                  height: 20.0,
                ),
                Row(
                  children: [
                    Text(
                      "Birth date:",
                      style: TextStyle(fontSize: 15.0),
                    )
                  ],
                ),
                Row(
                  children: [
                    FlatButton(
                      child: Text(
                        _birthDateText,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        _selectDate(context);
                      },
                    )
                  ],
                ),
                Container(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 150.0,
                      child: FlatButton(
                        color: Color(0xFFEB6EA1),
                        child: Text(
                          "Change password",
                          style: TextStyle(fontSize: 15.0, color: Colors.white),
                        ),
                        onPressed: () {
                          // TODO: EDIT REQEST
                          if (_formKey.currentState.validate()) {}
//                      Navigator.pushNamed(context, '/HomePage');
                        },
                      ),
                    ),
                    Container(
                      width: 20.0,
                    ),
                    Container(
                      width: 150.0,
                      child: FlatButton(
                        color: Color(0xFFA6A5E8),
                        child: Text(
                          "Edit",
                          style: TextStyle(fontSize: 15.0, color: Colors.white),
                        ),
                        onPressed: () {
                          // TODO: EDIT REQEST
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            http
                                .post("http://127.0.0.1:8000/api/user/update",
                                    headers: <String, String>{
                                      'Content-Type':
                                          'application/json; charset=UTF-8',
                                    },
                                    body: json.encode({
                                      "name": _name,
                                      "surname": _surname,
                                      "birth_date": _birthDateText,
                                      "id": MyApp.user.id
                                    }))
                                .then((value){
                                  if (value.statusCode==200)
                                    {
                                      MyApp.user.name = _name;
                                      MyApp.user.surname = _surname;
                                      MyApp.user.birthDate = _birthDate;
                                    }
                                  Navigator.pop(context);
                                Navigator.pushNamed(context, HomePage.route);});
                          }
//                      Navigator.pushNamed(context, '/HomePage');
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//  Future<http.Response> createUser() {
//    return http.post(
//      'http://127.0.0.1:8000/api/users/',
//      headers: <String, String>{
//        'Content-Type': 'application/json; charset=UTF-8',
//      },
//      body: _user.toJson(),
//    );
//  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _birthDate,
        firstDate: DateTime(1930, 8),
        lastDate: DateTime.now());
    if (picked != null && picked != _birthDate)
      setState(() {
        _birthDate = picked;
        _birthDateText = DateFormat('yyyy-MM-dd').format(picked);
      });
  }
}
