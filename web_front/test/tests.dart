import 'package:test/test.dart';
import 'package:web/counter.dart';
import 'package:web/validators.dart';

void main() {
  var _badEmails = [
    'gladi41414gmail.com',
    'qwerty@gmail',
    '228@228',
    'k@k@k.k',
    'qwe*qwe*',
    'www/---[[@gmail.com'
  ];
  var _goodEmails = [
    'gladi41414@gmail.com',
    'Yaroslav@gmail.com',
    'TEST@TEST.TEST',
    'kkk@rotrezal.com',
    'helloWorld@gmail.com',
    'Hladun@gmail.com'
  ];

  for (var goodEmail in _goodEmails) {
    test('Email validator on "$goodEmail" should return null', () {
      expect(Validators.emailValidator(goodEmail)==null, true);
    });
  }

  for (var badEmail in _badEmails) {
    test('Email validator on "$badEmail" should return NOT null', () {
      expect(Validators.emailValidator(badEmail)!=null, true);
    });
  }

  var _badPasswords = [
    '***',
    '----',
    '=====',
    'kfkhj',
    'ookj',
    '7878'
  ];
  var _goodPasswords = [
    'Rhjftygh',
    'gfhvhjhg6HH',
    'oijhgchi77QQQ',
    'iuoiu67ggG',
    'Rryjkh77gh',
    'oijijkl99n'
  ];

  for (var goodPassword in _goodPasswords) {
    test('Password validator on "$goodPassword" should return null', () {
      expect(Validators.passwordValidator(goodPassword)==null, true);
    });
  }

  for (var badPassword in _badPasswords) {
    test('Email validator on "$badPassword" should return NOT null', () {
      expect(Validators.passwordValidator(badPassword)!=null, true);
    });
  }

}
