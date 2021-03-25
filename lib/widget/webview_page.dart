import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter/services.dart';

class WebViewPage extends StatefulWidget {
  String title;
  String url;
  String action;

  WebViewPage({
    Key key,
    @required this.title,
    @required this.url,
    @required this.action, //设置这个action是因为我除了新闻页，还有一个视频播放页，视频播放页我不要appbar
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new WebViewPageState();
  }
}

class WebViewPageState extends State<WebViewPage> {
  bool isLoad = true;
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  @override
  void initState() {
    flutterWebviewPlugin.onStateChanged.listen((state) {
      debugPrint("state:_" + state.type.toString());
      if (state.type == WebViewState.finishLoad) {
        setState(() {
          isLoad = false;
        });
      } else if (state.type == WebViewState.startLoad) {
        setState(() {
          isLoad = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    this.widget.action == "news"
        ? SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top])
        : SystemChrome.setEnabledSystemUIOverlays([]);
    return WebviewScaffold(
      url: widget.url,
      appBar: this.widget.action == "news"
          ? new AppBar(
              centerTitle: true,
              elevation: 0.4,
              title: new Text(widget.title),
              bottom: new PreferredSize(
                child: isLoad
                    ? new LinearProgressIndicator()
                    : new Divider(
                        height: 1.0, color: Theme.of(context).primaryColor),
                preferredSize: const Size.fromHeight(1.0),
              ),
            )
          : null,
      withJavascript: true,
      withZoom: false,
      withLocalStorage: true,
    );
  }
}
