import 'dart:convert';
import 'dart:html';
import 'package:intl/intl.dart';

class Comment {
  String _text;
  int _author;
  int _photo;
  DateTime _postDateTime;
  String name;
  String surname;

  Comment setNameSurname(String name, String surname)
  {
    this.name = name;
    this.surname = surname;
    return this;
  }
  
  Comment setText(String text)
  {
    _text = text;
    return this;
  }
  
  Comment setAuthor(int author)
  {
    _author = author;
    return this;
  }

  Comment setPhoto(int photo)
  {
    _photo = photo;
    return this;
  }

  Comment setPostDateTime(DateTime postDateTime)
  {
    _postDateTime = postDateTime;
    return this;
  }

  DateTime getPostDateTime()=>_postDateTime;


  Map<dynamic, dynamic> toMap()
  {
    Map<dynamic, dynamic> res = {};
    res['author'] = _author;
    res['post_date_time'] = _postDateTime.toIso8601String();
    res['photo'] = _photo;
    res['text'] = _text;

    return res;
  }

  String toJson()
  {
    return json.encode(toMap());
  }
}