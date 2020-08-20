import 'dart:core';
import 'dart:core' as prefix0;
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_aws_s3_client/flutter_aws_s3_client.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

class Audio extends StatefulWidget {
  final prefix0.String imageName;
  Audio({Key key, @required this.imageName});

  @override
  _MyAppState createState() => _MyAppState(imageName: imageName);
}

class _MyAppState extends State<Audio> {
  final prefix0.String imageName;

  _MyAppState({Key key, @required this.imageName});

  AudioPlayer _player;
  Future<Uint8List> audioFileData(key) async {
    const region = "us-west-2";
    const bucketID = "audioresultbucket0";
    final AwsS3Client s3client = AwsS3Client(
        region: region,
        host: "s3.$region.amazonaws.com",
        bucketId: bucketID,
        accessKey: "AKIAISLQZNLVMD2WTHDA",
        secretKey: "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");
    final response = await s3client.getObject('$key.txt.mp3');
    return response.bodyBytes;
  }

  Future<File> getFileName() async {
    Uint8List haha;
    await audioFileData(imageName).then((Uint8List data) {
      setState(() {
        haha = data;
      });
    });
    final tempDir = await getTemporaryDirectory();
    prefix0.String path = tempDir.path;
    final file = new File('$path/music.mp3');
    await file.writeAsBytes(haha, flush: true, mode: FileMode.write);
    return file;
  }

  @override
  void initState() {
    super.initState();
    AudioPlayer.setIosCategory(IosCategory.playback);
    _player = AudioPlayer();
    getFileName().then((File file) {
      _player.setFilePath(file.path).catchError((error) {
        // catch audio error ex: 404 url, wrong url ...
        print(error);
      });
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<FullAudioPlaybackState>(
          stream: _player.fullPlaybackStateStream,
          builder: (context, snapshot) {
            final fullState = snapshot.data;
            final state = fullState?.state;
            final buffering = fullState?.buffering;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (state == AudioPlaybackState.connecting || buffering == true)
                  Container(
                    margin: EdgeInsets.all(8.0),
                    width: 50.0,
                    height: 50.0,
                    child: CircularProgressIndicator(),
                  )
                else if (state == AudioPlaybackState.playing)
                  IconButton(
                    icon: Icon(Icons.pause),
                    iconSize: 50.0,
                    onPressed: _player.pause,
                  )
                else
                  IconButton(
                    icon: Icon(Icons.play_arrow),
                    iconSize: 50.0,
                    onPressed: _player.play,
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
