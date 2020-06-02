import 'package:flutter/material.dart';
import 'package:web/editAccountPage.dart';
import 'package:web/homePage.dart';
import 'package:web/registerPage.dart';

import 'loginPage.dart';
import 'models/user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  static User user;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: HomePage.route,
      routes: {
        LoginPage.route: (context) => LoginPage(),
        RegisterPage.route: (context) => RegisterPage(),
        HomePage.route: (context) => HomePage(),
        EditAccountPage.route: (context) => EditAccountPage()
      },
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
    );
  }
}