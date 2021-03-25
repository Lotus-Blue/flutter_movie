import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:share/share.dart';
import 'package:flutter/services.dart';

//视频我用这个了

class WebViewScene extends StatefulWidget {
  final String url;
  final String title;
  final String action;

  WebViewScene({@required this.url, this.title, this.action});

  _WebViewSceneState createState() => _WebViewSceneState();
}

class _WebViewSceneState extends State<WebViewScene> {
  @override
  Widget build(BuildContext context) {
    this.widget.action == "news"
        ? SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top])
        : SystemChrome.setEnabledSystemUIOverlays([]);
    return WebviewScaffold(
      url: this.widget.url,
      appBar: this.widget.action == "news"
          ? new AppBar(
              elevation: 0,
              title: Text(this.widget.title ?? ''),
              leading: GestureDetector(
                onTap: back,
                child: Image.asset('images/icon_arrow_back_black.png'),
              ),
              actions: <Widget>[
                GestureDetector(
                  onTap: () {
                    Share.share(this.widget.url);
                  },
                  child: Image.asset('images/icon_menu_share.png'),
                ),
              ],
            )
          : null,
      withZoom: true,
      withLocalStorage: true,
      // withJavascript: false,
      hidden: true,
      initialChild: Container(
        child: const Center(child: CupertinoActivityIndicator()),
      ),
    );
  }

  // 返回上个页面
  back() {
    Navigator.pop(context);
  }
}
