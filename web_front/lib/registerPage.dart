import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:web/loginPage.dart';
import 'package:web/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:web/validators.dart';

class RegisterPage extends StatefulWidget {
  static const route = "/RegisterPage";

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  DateTime _birthDate = DateTime(2000);
  String _birthDateText = 'Select birth date';
  final Color _gradientStart =
      Color(0xFFFFC4B3); //Change start gradient color here
  final Color _gradientEnd = Color(0xFFEB6EA1);
  final User _user = User();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
//          crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.all(50.0),
                child: Center(
                    child: Text(
                  "Gallery AI",
                  style:
                      TextStyle(fontFamily: "MainDesignFont", fontSize: 100.0),
                )),
              ),
              _buildLoginCard(),
              Container(
                height: 100.0,
              ),
            ],
          ),
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
                  "Sign up",
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
                  onSaved: (value) => _user.setName(value),
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
                  onSaved: (value) => _user.setSurname(value),
                ),
                Container(
                  height: 20.0,
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
                  validator: Validators.emailValidator,
                  onSaved: (value) => _user.setEmail(value),
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
                  validator: Validators.passwordValidator,
                  onSaved: (value) => _user.setPassword(value),
                ),
                Container(
                  height: 20.0,
                ),
                Row(
                  children: [
                    Text(
                      "Password again:",
                      style: TextStyle(fontSize: 15.0),
                    )
                  ],
                ),
                TextFormField(
                  obscureText: true,
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
                Container(
                  width: 150.0,
                  child: FlatButton(
                    color: Color(0xFFEB6EA1),
                    child: Text(
                      "Sign up",
                      style: TextStyle(fontSize: 15.0, color: Colors.white),
                    ),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        print(_user
                            .setRegistrationDate(DateTime.now())
                            .setBirthDate(_birthDate)
                            .toMap());
                        createUser().then((value) => Navigator.pushNamed(context, LoginPage.route));
                      }
//                      Navigator.pushNamed(context, '/HomePage');
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
                      "Already have an account? ",
                      style: TextStyle(fontSize: 15.0),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.pushNamed(context, LoginPage.route);
                      },
                      child: Text(
                        "Sign in!",
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

  Future<http.Response> createUser() {
    return http.post(
      'http://127.0.0.1:8000/api/users/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: _user.toJson(),
    );
  }

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
