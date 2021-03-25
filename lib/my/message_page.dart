import 'package:flutter/material.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  TextStyle textStyle = new TextStyle(
      color: Colors.blue,
      decoration: new TextDecoration.combine([TextDecoration.underline]));

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("加入Q群"),
        ),
        body: new Container(
          padding: EdgeInsets.fromLTRB(35, 40, 35, 15),
          child: new Column(
            children: <Widget>[
              CircleAvatar(
                minRadius: 60,
                maxRadius: 60,
                backgroundImage: NetworkImage(
                    "http://d18.lxyes.cn/18xd/act/20200315/18/e24fad8babb6b83177ce9e11724828d8.png"),
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
              Padding(padding: EdgeInsets.only(top: 30)),
              new Text(
                "很开心您使用这款APP,作者本来像设计一个消息机制的,但想想这不是本APP的重点,所以就放弃了,希望能理解,我也希望您可以牺牲宝贵的时间来改善此APP,任何意见或者建议我都欢迎!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 30)),
              new Text(
                "欢迎您加入交流QQ群:",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 5)),
              new Text(
                "948777057",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.green,
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 13)),
              new Text(
                "任何技术交流我们都欢迎!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
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
