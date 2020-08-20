import 'dart:core';
import 'dart:core' as prefix0;
import 'dart:io';
import 'package:flutter/material.dart';
import './translatedResult.dart';

class TranslatePage extends StatelessWidget {
  // Declare a field that holds the Person data
  final File image;
  final prefix0.String imageName;
  // In the constructor, require a Person
  TranslatePage({Key key, @required this.image, @required this.imageName})
      : super(key: key);
  Widget roundButton(context, prefix0.String text) {
    return Container(
      width: 80,
      height: 80,
      child: MaterialButton(
        shape: CircleBorder(
            side: BorderSide(
                width: 2, color: Colors.lightBlue, style: BorderStyle.solid)),
        child: Text(
          text,
          style: TextStyle(fontSize: 20),
        ),
        color: Colors.lightBlue[100],
        textColor: Colors.black,
        onPressed: () {
          Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) =>
                    new TranslateResult(image: image, imageName: imageName)),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('HAPUE 乐翻'), backgroundColor: Colors.blue),
        body: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              height: 450,
              child: Image.file(image),
            ),
            Padding(padding: EdgeInsets.all(8.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                roundButton(context, "翻译"),
                roundButton(context, "识别"),
              ],
            )
          ],
        ));
  }

  Widget showLoad() {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              child: new CircularProgressIndicator(),
              width: 60.0,
              height: 60.0,
              alignment: Alignment.center,
            )
          ],
        )
      ],
    );
  }
}
