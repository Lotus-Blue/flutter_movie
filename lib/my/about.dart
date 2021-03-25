import 'package:flutter/material.dart';
// import '../widget/webview_page.dart';

class AboutMePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AboutMePageState();
  }
}

class AboutMePageState extends State<AboutMePage> {
  TextStyle textStyle = new TextStyle(
      color: Colors.blue,
      decoration: new TextDecoration.combine([TextDecoration.underline]));

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("关于作者"),
        ),
        body: new Container(
          padding: EdgeInsets.fromLTRB(35, 50, 35, 15),
          child: new Column(
            children: <Widget>[
              CircleAvatar(
                minRadius: 60,
                maxRadius: 60,
                backgroundImage: NetworkImage(
                    "http://n.sinaimg.cn/sinacn20113/799/w800h799/20190101/bbd7-hqzxptn0784349.jpg"),
              ),
              Padding(padding: EdgeInsets.only(top: 30)),
              new Text(
                "基于机器学习的电影推荐APP V1.5",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 10)),
              new Text(
                "CS_GZ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0.0, 80.0, 0.0, 0.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                      "邮箱：",
                      style: TextStyle(fontSize: 16),
                    ),
                    new Text(
                      "1349040397@qq.com",
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                      "位置：",
                      style: TextStyle(fontSize: 16),
                    ),
                    new Text(
                      "中国-广东-广州-天河区",
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                  ],
                ),
              ),
              Expanded(child: Container(), flex: 1),
              new Text(
                "本项目仅供学习使用，不得用作商业目的",
                style: new TextStyle(fontSize: 12.0),
              )
            ],
          ),
        ));
  }
}
