import 'dart:convert';

import 'package:intl/intl.dart';

class User {
  int id;
  String name;
  String surname;
  String email;
  String password;
  DateTime registrationDate;
  DateTime birthDate;

  User setId(int id)
  {
    this.id = id;
    return this;
  }

  User setName(String name)
  {
    this.name = name;
    return this;
  }

  User setSurname(String surname)
  {
    this.surname = surname;
    return this;
  }

  User setEmail(String email)
  {
    this.email = email;
    return this;
  }

  User setPassword(String password)
  {
    this.password = password;
    return this;
  }

  User setRegistrationDate(DateTime registrationDate)
  {
    this.registrationDate = registrationDate;
    return this;
  }

  User setBirthDate(DateTime birthDate)
  {
    this.birthDate = birthDate;
    return this;
  }

  Map<dynamic, dynamic> toMap()
  {
    Map<dynamic, dynamic> res = {};
    res['name'] = name;
    res['surname'] = surname;
    res['password'] = password;
    res['email'] = email;
    res['registration_date'] = DateFormat('yyyy-MM-dd').format(registrationDate);
    res['id'] = id;
    res['birth_date'] = DateFormat('yyyy-MM-dd').format(birthDate);

    return res;
  }

  String toJson()
  {
    return json.encode(toMap());
  }
}