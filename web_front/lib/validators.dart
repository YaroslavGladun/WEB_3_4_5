import 'package:email_validator/email_validator.dart';

class Validators {
  static String nameValidator(String val) {
    if (val.length==0) return "Please enter your name";
    return null;
  }
  static String surnameValidator(String val) {
    if (val.length==0) return "Please enter your surname";
    return null;
  }
  static String emailValidator(String val) {
    if (!EmailValidator.validate(val)) return "Please enter correct email";
    return null;
  }
  static String passwordValidator(String val) {
    if (val.length<6) return "Password must be longer than 6 characters";
    return null;
  }
}