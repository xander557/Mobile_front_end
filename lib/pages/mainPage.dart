import 'dart:convert';
import 'dart:core' as prefix0;
import 'dart:io';
import 'package:flutter/material.dart';
import './translatepage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

prefix0.Future<prefix0.bool> uploadFile(
    context, prefix0.String url, File image) async {
  try {
    UploadFile uploadFile = UploadFile();
    await uploadFile.call(url, image);

    if (uploadFile.isUploaded != null && uploadFile.isUploaded) {
      return true;
    } else {
      throw uploadFile.message;
    }
  } catch (e) {
    throw e;
  }
}

class UploadFile {
  prefix0.bool success;
  prefix0.String message;

  prefix0.bool isUploaded;

  prefix0.Future<void> call(prefix0.String url, File image) async {
    try {
      var response = await http.put(url, body: image.readAsBytesSync());
      if (response.statusCode == 200) {
        isUploaded = true;
      }
    } catch (e) {
      throw ('Error uploading photo');
    }
  }
}

class GenerateImageUrl {
  prefix0.bool success;
  prefix0.String message;

  prefix0.bool isGenerated;
  prefix0.String uploadUrl;
  prefix0.String downloadUrl;

  prefix0.Future<void> call(prefix0.String fileType) async {
    try {
      prefix0.Map body = {"fileType": fileType};
      var response = await http.post(
        //For IOS
        // 'http://localhost:5000/generatePresignedUrl',
        //For Android
        'http://10.0.2.2:5000/generatePresignedUrl',
        body: body,
      );
      var result = jsonDecode(response.body);
      prefix0.print(result);

      if (result['success'] != null) {
        success = result['success'];
        message = result['message'];
        if (response.statusCode == 201) {
          isGenerated = true;
          uploadUrl = result["uploadUrl"];
          downloadUrl = result["downloadUrl"];
        }
      }
    } catch (e) {
      throw ('Error getting url');
    }
  }
}

class HomePage extends StatefulWidget {
  @prefix0.override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<HomePage> {
  File _imageFile;
  prefix0.String _fileName;

  final _picker = ImagePicker();
  _openGallary(BuildContext context) async {
    PickedFile image = await _picker.getImage(source: ImageSource.gallery);
    prefix0.String fileExtension;
    if (image != null) {
      fileExtension = path.extension(image.path);
    }
    setState(() {
      _imageFile = File(image.path);
    });

    Navigator.of(context).pop();
    // change start
    GenerateImageUrl generateImageUrl = GenerateImageUrl();
    await generateImageUrl.call(fileExtension);
    prefix0.String uploadUrl;
    _fileName =
        "no passing.png"; // generateImageUrl.downloadUrl.toString().split("/")[3];
    if (generateImageUrl.isGenerated != null && generateImageUrl.isGenerated) {
      uploadUrl = generateImageUrl.uploadUrl;
    } else {
      throw generateImageUrl.message;
    }
    prefix0.bool isUploaded = await uploadFile(context, uploadUrl, _imageFile);
  }

  _openCamera(BuildContext context) async {
    PickedFile image = await _picker.getImage(source: ImageSource.camera);
    Navigator.of(context).pop();
    prefix0.String fileExtension;
    if (image != null) {
      fileExtension = path.extension(image.path);
    }
    setState(() {
      _imageFile = File(image.path);
    });
    GenerateImageUrl generateImageUrl = GenerateImageUrl();
    await generateImageUrl.call(fileExtension);
    prefix0.String uploadUrl;
    prefix0.print(generateImageUrl);
    _fileName = generateImageUrl.downloadUrl.toString().split("/")[3];
    if (generateImageUrl.isGenerated != null && generateImageUrl.isGenerated) {
      uploadUrl = generateImageUrl.uploadUrl;
    } else {
      throw generateImageUrl.message;
    }
  }

  prefix0.Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Upload a photo"),
            content: SingleChildScrollView(
                child: ListBody(
              children: <Widget>[
                GestureDetector(
                    child: Text("Album"),
                    onTap: () {
                      _openGallary(context);
                    }),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                GestureDetector(
                    child: Text("Camera"),
                    onTap: () {
                      _openCamera(context);
                    })
              ],
            )),
          );
        });
  }

  Widget _decideImageView(fileName) {
    prefix0.print(fileName);
    return Container(
        child: _imageFile == null
            ? Text("No image selected. ")
            : RaisedButton(
                padding: EdgeInsets.all(5.0),
                color: Colors.grey[200],
                // child:
                child: new Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(0.0),
                    ),
                    Container(
                      child: Image.file(_imageFile),
                      height: 200,
                    ),
                    Text("点我确认", style: TextStyle(fontSize: 20))
                  ],
                ),
                onPressed: () => Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new TranslatePage(
                                image: _imageFile,
                                imageName: _fileName,
                              )),
                    )));
  }

  Widget padding(height) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: height,
      ),
    );
  }

  Widget textLine(text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.black,
        fontSize: 20.0,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  @prefix0.override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
            title: Text('HAPUE 乐翻'), backgroundColor: Colors.lightBlue),
        body: Container(
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              textLine("HelP U be HAPpy in the New Place"),
              padding(10.0),
              textLine("你好小明，助你快乐"),
              padding(10.0),
              RaisedButton(
                child:
                    Icon(Icons.camera_alt, size: 120, color: Colors.lightBlue),
                onPressed: () {
                  _showChoiceDialog(context);
                },
                color: Colors.white,
              ),
              padding(10.0),
              _decideImageView(_fileName),
              padding(10.0),
              textLine("Take a photo and konw it!"),
              padding(10.0),
              textLine("拍张照片，你将更懂你的世界"),
            ]),
          ),
        ));
  }
}
