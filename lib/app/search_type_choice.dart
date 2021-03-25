//选择搜索方案界面

import 'package:flutter/material.dart';

import 'package:movie_recommend/public.dart';

import 'package:flutter/cupertino.dart';

class SearchChoice extends StatefulWidget {
  @override
  _SearchChoiceState createState() => _SearchChoiceState();
}

class _SearchChoiceState extends State<SearchChoice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        brightness: Brightness.light,
        title: Text('选择搜索类型'),
        backgroundColor: AppColor.white,
        leading: GestureDetector(
          onTap: back,
          child: Image.asset('images/icon_arrow_back_black.png'),
        ),
        elevation: 0,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            children: <Widget>[
              SizedBox(height: 50.0), //之前是60，但增加了个菜单，所以调小点
              Text(
                '请选择你要搜索的类型',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 50,
              ),
              new SizedBox(
                width: double.infinity,
                child: new CupertinoButton(
                  pressedOpacity: 0.6,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  color: Colors.teal,
                  child: Text('演员搜索'),
                  onPressed: () => showSearch(
                      context: context,
                      delegate: SearchBarDelegate("actor_name")),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              new SizedBox(
                width: double.infinity,
                child: new CupertinoButton(
                  pressedOpacity: 0.6,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  color: AppColor.secondary,
                  child: Text('电影名搜索'),
                  onPressed: () => showSearch(
                      context: context,
                      delegate: SearchBarDelegate("movie_name")),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              new SizedBox(
                width: double.infinity,
                child: new CupertinoButton(
                  pressedOpacity: 0.6,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  color: Colors.green,
                  child: Text('电影标签搜索'),
                  onPressed: () => showSearch(
                      context: context,
                      delegate: SearchBarDelegate("movie_tag")),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              new SizedBox(
                width: double.infinity,
                child: new CupertinoButton(
                  pressedOpacity: 0.6,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  color: Colors.indigoAccent[100],
                  child: Text('演员电影作品搜索'),
                  onPressed: () => showSearch(
                      context: context,
                      delegate: SearchBarDelegate("actor_movie")),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 返回上个页面
  back() {
    Navigator.pop(context);
  }
}
