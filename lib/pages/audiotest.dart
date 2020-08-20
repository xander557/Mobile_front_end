// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';

// class Audio extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<Audio> {
//   AudioPlayer _player;

//   @override
//   void initState() {
//     super.initState();
//     AudioPlayer.setIosCategory(IosCategory.playback);
//     _player = AudioPlayer();
//     _player
//         .setUrl(
//             "https://translateaudiooutput.s3-us-west-2.amazonaws.com/no+passing.png.txt.mp3")
//         .catchError((error) {
//       // catch audio error ex: 404 url, wrong url ...
//       print(error);
//     });
//   }

//   @override
//   void dispose() {
//     _player.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Audio Player Demo'),
//         ),
//         body: Center(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               StreamBuilder<FullAudioPlaybackState>(
//                 stream: _player.fullPlaybackStateStream,
//                 builder: (context, snapshot) {
//                   final fullState = snapshot.data;
//                   final state = fullState?.state;
//                   final buffering = fullState?.buffering;
//                   return Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       if (state == AudioPlaybackState.connecting ||
//                           buffering == true)
//                         Container(
//                           margin: EdgeInsets.all(8.0),
//                           width: 64.0,
//                           height: 64.0,
//                           child: CircularProgressIndicator(),
//                         )
//                       else if (state == AudioPlaybackState.playing)
//                         IconButton(
//                           icon: Icon(Icons.pause),
//                           iconSize: 64.0,
//                           onPressed: _player.pause,
//                         )
//                       else
//                         IconButton(
//                           icon: Icon(Icons.play_arrow),
//                           iconSize: 64.0,
//                           onPressed: _player.play,
//                         ),
//                     ],
//                   );
//                 },
//               ),
//               // Container(
//               //   width: 150,
//               //   height: 50,
//               //   child: MaterialButton(
//               //     shape: RoundedRectangleBorder(
//               //         side: BorderSide(
//               //             width: 2,
//               //             color: Colors.white,
//               //             style: BorderStyle.solid)),
//               //     child: Text("再来一拍", style: TextStyle(fontSize: 20)),
//               //     color: Colors.white,
//               //     textColor: Colors.blue,
//               //     onPressed: () {
//               //       Navigator.pushAndRemoveUntil(
//               //           context,
//               //           MaterialPageRoute(builder: (context) => MyApp()),
//               //           (Route<dynamic> route) => false);
//               //     },
//               //   ),
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
