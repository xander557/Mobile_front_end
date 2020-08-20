import 'dart:core';
import 'dart:core' as prefix0;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_aws_s3_client/flutter_aws_s3_client.dart';
import './mainPage.dart';
import 'audio.dart';

class TranslateResult extends StatelessWidget {
  final File image;
  final prefix0.String imageName;
  TranslateResult({Key key, @required this.image, @required this.imageName})
      : super(key: key);

  Widget padding() {
    return Padding(padding: EdgeInsets.all(5.0));
  }

  Future<prefix0.String> getTranslateText(key) async {
    const region = "us-west-2";
    const bucketID = "textresultbucket0";
    final AwsS3Client s3client = AwsS3Client(
        region: region,
        host: "s3.$region.amazonaws.com",
        bucketId: bucketID,
        accessKey: "AKIAISLQZNLVMD2WTHDA",
        secretKey: "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");
    final response = await s3client.getObject('$key.txt');
    return response.body;
  }

  Widget rowName(prefix0.String text) {
    return Row(
      children: <Widget>[Text("    " + text, style: TextStyle(fontSize: 20))],
    );
  }

  Widget rowBox(prefix0.String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          width: 300,
          height: 120,
          child: MaterialButton(
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    width: 2, color: Colors.blue, style: BorderStyle.solid)),
            child: Text(
              text,
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            color: Colors.white,
            textColor: Colors.black,
          ),
        ),
        Container(
            width: 100,
            height: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                MaterialButton(
                  height: 120,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                          width: 2,
                          color: Colors.lightBlue,
                          style: BorderStyle.solid)),
                  child: new Audio(
                    imageName: imageName,
                  ),
                  color: Colors.white,
                  textColor: Colors.black,
                  onPressed: () {},
                ),
              ],
            )),
      ],
    );
  }

  Widget oneMoreShot(context) {
    return Container(
        width: 150,
        height: 50,
        child: MaterialButton(
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  width: 2, color: Colors.white, style: BorderStyle.solid)),
          child: Text("再来一拍", style: TextStyle(fontSize: 20)),
          color: Colors.white,
          textColor: Colors.blue,
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                (Route<dynamic> route) => false);
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<prefix0.String>(
        future: getTranslateText(imageName),
        builder: (context, AsyncSnapshot<prefix0.String> snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data.contains("NoSuchKey"));
            print("Nosuchkey");
            return Scaffold(
                appBar: AppBar(
                    title: Text('HAPUE 乐翻'), backgroundColor: Colors.blue),
                body: Column(
                  children: <Widget>[
                    padding(),
                    Container(
                      height: 200,
                      child: Image.file(image),
                    ),
                    padding(),
                    rowName("原文提取"),
                    rowBox("Slow"),
                    padding(),
                    rowName("翻译结果"),
                    rowBox(snapshot.data.toString()),
                    padding(),
                    oneMoreShot(context)
                  ],
                ));
          } else {
            return showLoad();
          }
        });
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
