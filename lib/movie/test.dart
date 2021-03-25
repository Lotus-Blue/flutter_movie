// // import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
// // import 'package:flutter/material.dart';

// // class HomePage extends StatefulWidget {
// //   @override
// //   HomePageState createState() => HomePageState();
// // }

// // class HomePageState extends State<HomePage> {
// //   IjkMediaController controller = IjkMediaController();

// //   @override
// //   void initState() {
// //     super.initState();
// //   }

// //   @override
// //   void dispose() {
// //     controller.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Plugin example app'),
// //         actions: <Widget>[/*
// //           IconButton(
// //             icon: Icon(Icons.videocam),
// //             onPressed: _pickVideo,
// //           ),*/
// //         ],
// //       ),
// //       body: Container(
// //         // width: MediaQuery.of(context).size.width,
// //         // height: 400,
// //         child: ListView(
// //           children: <Widget>[
// //             buildIjkPlayer(),
// //           ]
// //         ),
// //       ),
// //       floatingActionButton: FloatingActionButton(
// //         child: Icon(Icons.play_arrow),
// //         onPressed: () async {
// //           await controller.setNetworkDataSource(
// //               'http://www.dgua.xyz/webcloud/?url=http://v.qq.com/x/cover/7casb7nes159mrl.html?ptag=douban.movie',
// //               // 'rtmp://172.16.100.245/live1',
// //               // 'https://www.sample-videos.com/video123/flv/720/big_buck_bunny_720p_10mb.flv',
// // //              "https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4",
// //               // 'http://184.72.239.149/vod/smil:BigBuckBunny.smil/playlist.m3u8',
// //               // "file:///sdcard/Download/Sample1.mp4",
// //               autoPlay: true);
// //           print("set data source success");
// //           // controller.playOrPause();
// //         },
// //       ),
// //     );
// //   }

// //   Widget buildIjkPlayer() {
// //     return Container(
// //       // height: 400, // 这里随意
// //       child: IjkPlayer(
// //         mediaController: controller,
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return new MaterialApp(
//       title: 'Flutter Custom Tabs Example',
//       theme: new ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: new Scaffold(
//         appBar: new AppBar(
//           title: const Text('Flutter Custom Tabs Example'),
//         ),
//         body: new Center(
//           child: new FlatButton(
//             child: new Text(
//               'Show Flutter homepage',
//               style: new TextStyle(
//                 fontSize: theme.textTheme.subhead.fontSize,
//                 color: theme.primaryColor,
//               ),
//             ),
//             onPressed: () => _launchURL(context),
//           ),
//         ),
//       ),
//     );
//   }

//   void _launchURL(BuildContext context) async {
//     try {
//       await launch(
//         'https://flutter.io/',
//         option: new CustomTabsOption(
//           toolbarColor: Theme.of(context).primaryColor,
//           enableDefaultShare: true,
//           enableUrlBarHiding: true,
//           showPageTitle: true,
//           animation: new CustomTabsAnimation.slideIn(),
//           extraCustomTabs: <String>[
//             // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
//             'org.mozilla.firefox',
//             // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
//             'com.microsoft.emmx',
//           ],
//         ),
//       );
//     } catch (e) {
//       // An exception is thrown if browser app is not installed on Android device.
//       debugPrint(e.toString());
//     }
//   }
// }

// // import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
// // import 'package:flutter/material.dart';

// // class HomePage extends StatefulWidget {
// //   @override
// //   HomePageState createState() => HomePageState();
// // }

// // class HomePageState extends State<HomePage> {
// //   IjkMediaController controller = IjkMediaController();

// //   @override
// //   void initState() {
// //     super.initState();
// //   }

// //   @override
// //   void dispose() {
// //     controller.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Plugin example app'),
// //         actions: <Widget>[
// //           IconButton(
// //             icon: Icon(Icons.videocam),
// //             onPressed: _pickVideo,
// //           ),
// //         ],
// //       ),
// //       body: Container(
// //         // width: MediaQuery.of(context).size.width,
// //         // height: 400,
// //         child: ListView(
// //           children: <Widget>[
// //             buildIjkPlayer(),
// //           ]
// //         ),
// //       ),
// //       floatingActionButton: FloatingActionButton(
// //         child: Icon(Icons.play_arrow),
// //         onPressed: () async {
// //           await controller.setNetworkDataSource(
// //               'https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4',
// //               // 'rtmp://172.16.100.245/live1',
// //               // 'https://www.sample-videos.com/video123/flv/720/big_buck_bunny_720p_10mb.flv',
// // //              "https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4",
// //               // 'http://184.72.239.149/vod/smil:BigBuckBunny.smil/playlist.m3u8',
// //               // "file:///sdcard/Download/Sample1.mp4",
// //               autoPlay: true);
// //           print("set data source success");
// //           // controller.playOrPause();
// //         },
// //       ),
// //     );
// //   }

// //   Widget buildIjkPlayer() {
// //     return Container(
// //       // height: 400, // 这里随意
// //       child: IjkPlayer(
// //         mediaController: controller,
// //       ),
// //     );
// //   }
// // }
