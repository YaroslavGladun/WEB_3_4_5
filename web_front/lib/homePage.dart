import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:web/editAccountPage.dart';
import 'package:web/loginPage.dart';
import 'package:web/main.dart';
import 'package:web/models/comment.dart';
import 'package:web/registerPage.dart';
import 'package:http/http.dart' as http;

import 'models/photo.dart';

class HomePage extends StatefulWidget {
  static const route = "/HomePage";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Color _gradientStart =
      Color(0xFFA6A5E8); //Change start gradient color here
  final Color _gradientEnd = Color(0xFFB5E3FF);
  List<Photo> _photos;
  Map<int, List<Comment>> _commentsUnderPhoto = {};
  List<Widget> _photosCards = [];
  int _isShowCommentsUnderPhotoId = -1;

  @override
  void initState() {
    fetchPhotos().then((value) {
      var data = json.decode(value.body)["photos"];
      _photos = [];
      for (var obj in data) {
        _photos.add(Photo()
            .setAuthor(obj['author'])
            .setDescription(obj['description'])
            .setPhotoPath(obj['photo_path'])
            .setPostDateTime(DateTime.parse(obj['post_date_time']))
            .setTitle(obj['title'])
            .setId(obj['id']));

        fetchComment(obj['id']).then((value) {
          _commentsUnderPhoto[obj['id']] = [];
          for (var comment in json.decode(value.body)['comments']) {
            _commentsUnderPhoto[obj['id']].add(Comment()
                .setText(comment['text'])
                .setPhoto(comment['photo'])
                .setAuthor(comment['author'])
                .setPostDateTime(DateTime.parse(comment['post_date_time']))
                .setNameSurname(comment['name'], comment['surname'])
            );
          }
          setState(() {
            _photosCards = _photos.map((e) => _buildPhotoCard(e)).toList();
          });
        });
      }
    });

    super.initState();
  }

  void _resetComments() {
    for (var obj in _photos) {
      fetchComment(obj.toMap()['id']).then((value) {
        _commentsUnderPhoto[obj.toMap()['id']] = [];
        for (var comment in json.decode(value.body)['comments']) {
          _commentsUnderPhoto[obj.toMap()['id']].add(Comment()
              .setText(comment['text'])
              .setPhoto(comment['photo'])
              .setAuthor(comment['author'])
              .setPostDateTime(DateTime.parse(comment['post_date_time']))
              .setNameSurname(comment['name'], comment['surname'])
          );
        }
        setState(() {
          _photosCards = _photos.map((e) => _buildPhotoCard(e)).toList();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Color(0xFFFFC4B3),
        onPressed: () {
          if (MyApp.user == null)
            Navigator.pushNamed(context, LoginPage.route);
          else {
            // TODO: ADD POST
          }
        },
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              child: Column(
//          crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 100.0,
                  ),
                  Column(
                    children: _photosCards,
                  )
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
          ),
          _buildTopBar(),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Center(
                child: FractionallySizedBox(
              child: Text(
                "Gallery AI",
                style: TextStyle(fontFamily: "MainDesignFont", fontSize: 60.0),
              ),
            )),
          ),
          Expanded(child: Container()),
          MyApp.user == null
              ? Row(
                  children: [
                    FlatButton(
                      color: Color(0xFFEB6EA1),
                      child: Text(
                        "Sign in",
                        style: TextStyle(fontSize: 15.0, color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, LoginPage.route);
                      },
                    ),
                    Container(
                      width: 10.0,
                    ),
                    FlatButton(
                      color: Color(0xFFEB6EA1),
                      child: Text(
                        "Sign up",
                        style: TextStyle(fontSize: 15.0, color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, RegisterPage.route);
                      },
                    ),
                    Container(
                      width: 10.0,
                    ),
                  ],
                )
              : GestureDetector(
                  onTap: () {
                    _showPersonalInfo();
                  },
                  child: Row(
                    children: [
                      Text(MyApp.user.toMap()['name']),
                      Container(
                        width: 5.0,
                      ),
                      Text(MyApp.user.toMap()['surname']),
                      Padding(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100.0),
                          child: Image.network(
                            'https://nogivruki.ua/wp-content/uploads/2018/08/default-user-image-300x300.png',
                          ),
                        ),
                        padding: EdgeInsets.only(
                            bottom: 15.0, top: 15.0, right: 15.0, left: 15.0),
                      )
                    ],
                  ),
                ),
        ],
      ),
      height: 70.0,
      color: Colors.white,
      width: double.infinity,
    );
  }

  Widget _buildPhotoCard(Photo photo) {
    var _controller = TextEditingController();
    String _commentText = '';
    if (!_commentsUnderPhoto.containsKey(photo.toMap()['id']))
      return Container();
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 40.0),
      child: Container(
        width: 600.0,
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      photo.toMap()["title"],
                      style: TextStyle(
                          fontFamily: "MainDesignFont", fontSize: 35.0),
                    ),
                    Container(
                      height: 10.0,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3.0),
                      child: Image.network(
                        photo.toMap()["photo_path"],
                      ),
                    ),
                    Container(
                      height: 5.0,
                    ),
                    Text(
                      photo.toMap()["description"],
                    )
                  ],
                ),
              ),
            ),
            Column(
                children: _commentsUnderPhoto[photo.toMap()['id']].map((e) {
              return Container(
                width: 600.0,
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Text("${e.name} ${e.surname}"),
                          Expanded(child: Container(),),
                          Text(DateFormat('yyyy-MM-dd – kk:mm').format(e.getPostDateTime()))
                        ],),
                        Divider(),
                        Text(e.toMap()['text']),
                      ],
                    ),
                  ),
                ),
              );
            }).toList()),
            MyApp.user == null
                ? Container()
                : Card(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextField(
                        controller: _controller,
                        style: TextStyle(fontSize: 14),
                        onChanged: (value) => _commentText = value,
                        decoration: InputDecoration(
                            hintText: "Enter your comment here",
                            hintStyle: TextStyle(fontSize: 14),
                            suffixIcon: IconButton(
                              iconSize: 15.0,
                              color: Color(0xFFEB6EA1),
                              icon: Icon(Icons.arrow_forward_ios),
                              onPressed: () {
                                print(Comment()
                                    .setPostDateTime(DateTime.now())
                                    .setText(_commentText)
                                    .setAuthor(MyApp.user.toMap()['id'])
                                    .setPhoto(photo.toMap()['id'])
                                    .toJson());
                                http
                                    .post(
                                  'http://127.0.0.1:8000/api/comments/',
                                  headers: <String, String>{
                                    'Content-Type':
                                        'application/json; charset=UTF-8',
                                  },
                                  body: Comment()
                                      .setPostDateTime(DateTime.now())
                                      .setText(_commentText)
                                      .setAuthor(MyApp.user.toMap()['id'])
                                      .setPhoto(photo.toMap()['id'])
                                      .toJson(),
                                )
                                    .then((value) {
                                  _controller.clear();
                                  _resetComments();
                                  setState(() {});
                                });
                              },
                            )),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Future<http.Response> fetchPhotos() {
    return http.get(
      'http://127.0.0.1:8000/api/photos/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }

  Future<http.Response> fetchComment(int photoId) {
    return http.post(
      'http://127.0.0.1:8000/api/comment/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({'photo_id': photoId}),
    );
  }

  Future<void> _showPersonalInfo() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('My profile'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Photo:"),
                Container(
                  height: 100.0,
                  width: 100.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: Image.network(
                      'https://nogivruki.ua/wp-content/uploads/2018/08/default-user-image-300x300.png',
                    ),
                  ),
                ),
                Container(
                  height: 20.0,
                ),
                Text("Name:\n${MyApp.user.name}"),
                Container(
                  height: 8.0,
                ),
                Text("Surname:\n${MyApp.user.surname}"),
                Container(
                  height: 8.0,
                ),
                Text("Email:\n${MyApp.user.email}"),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'EXIT',
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  MyApp.user = null;
                  _photosCards =
                      _photos.map((e) => _buildPhotoCard(e)).toList();
                });
              },
            ),
            FlatButton(
              child: Text(
                'EDIT',
                style: TextStyle(color: Color(0xFFFFC4B3)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, EditAccountPage.route);
              },
            ),
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
