import 'dart:convert';

import 'package:intl/intl.dart';

class Photo {
  int _id;
  String _photoPath;
  String _title;
  String _description;
  int _author;
  DateTime _postDateTime;

  Photo setId(int id)
  {
    _id = id;
    return this;
  }

  Photo setPhotoPath(String photoPath)
  {
    _photoPath = photoPath;
    return this;
  }

  Photo setTitle(String title)
  {
    _title = title;
    return this;
  }

  Photo setDescription(String description)
  {
    _description = description;
    return this;
  }

  Photo setAuthor(int author)
  {
    _author = author;
    return this;
  }

  Photo setPostDateTime(DateTime postDateTime)
  {
    _postDateTime = postDateTime;
    return this;
  }

  Map<dynamic, dynamic> toMap()
  {
    Map<dynamic, dynamic> res = {};
    res['id'] = _id;
    res['photo_path'] = _photoPath;
    res['title'] = _title;
    res['description'] = _description;
    res['author'] = _author;
    res['post_date_time'] = DateFormat('yyyy-MM-dd – kk:mm').format(_postDateTime);

    return res;
  }

  String toJson()
  {
    return json.encode(toMap());
  }
}