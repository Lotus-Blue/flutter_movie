import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:movie_recommend/public.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
// import 'favor_movie_view.dart';
// import 'favor_actor_view.dart';
// import 'package:event_bus/event_bus.dart';
import 'package:movie_recommend/my/login_scene.dart';
import 'package:share/share.dart';
import 'about.dart';
import 'package:movie_recommend/my/my_scene.dart';

import 'genre_choice.dart';

class DrawerDemo extends StatefulWidget {
  @override
  _DrawerDemoState createState() => _DrawerDemoState();
}

class _DrawerDemoState extends State<DrawerDemo> {
  String username = '未登录';
  SharedPrefUtil prefUtil = new SharedPrefUtil();

  @override
  void initState() {
    super.initState();

    eventBus.on(EventUserLogin, (arg) {
      // debugPrint("test1");
      setState(() {
        //  debugPrint("test2");
      });
    });

    eventBus.on(EventUserLogout, (arg) {
      setState(() {});
    });
    // if(username!="未登录")
    fetchData();
    // debugPrint("test");
  }

  @override
  void dispose() {
    eventBus.off(EventUserLogin);
    eventBus.off(EventUserLogout);
    //  eventBus.off(EventToggleTabBarIndex);
    super.dispose();
  }

  Future<void> fetchData() async {
    String name = await prefUtil.getUserName();
    debugPrint("test");

    setState(() {
      username = name;
      debugPrint("test11");
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        builder: (context, store) {
          final authed = store.state.authed;
          return Drawer(
            child: ListView(
              //在listview中放着头部与listtitle
              padding: EdgeInsets.zero,
              children: <Widget>[
                //用户信息
                UserAccountsDrawerHeader(
                  accountName: InkWell(
                    //修改注销后还drawer显示名字的bug
                    child: authed
                        ? Text(
                            username,
                            style: TextStyle(
                                fontSize: 23, fontWeight: FontWeight.bold),
                          )
                        : Text(
                            "未登录",
                            style: TextStyle(
                                fontSize: 23, fontWeight: FontWeight.bold),
                          ),
                    onTap: () {
                      if (!authed) {
                        AppNavigator.push(context, LoginPage());
                      }
                    },
                  ),
                  accountEmail: authed
                      ? Text(
                          "  欢迎您的到来",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      : Text(
                          "  点击头像即可注册登录",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                  currentAccountPicture: InkWell(
                    child: CircleAvatar(
                      //用Imange.network会报错
                      backgroundImage: NetworkImage(
                          "http://5b0988e595225.cdn.sohucs.com/images/20170912/080dfe6330b2458489533111d8dc24e4.jpeg"),
                    ),
                    onTap: () {
                      if (!authed) {
                        AppNavigator.push(context, LoginPage());
                      }
                    },
                  ),
                  decoration: BoxDecoration(
                    color: Colors.yellow[400],
                    image: DecorationImage(
                      image: NetworkImage(
                          "https://www.zhongguofeng.com/uploads/allimg/180611/13-1P611155245.jpg"),
                      fit: BoxFit.cover, //填满
                    ),
                  ),
                ),

                //每列内容
                ListTile(
                  title: Text(
                    "消息",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 15),
                  ),
                  trailing:
                      Icon(Icons.message, color: Colors.black12, size: 22.0),
                  // onTap: () => Navigator.pop(context),
                  onTap: () {
                    AppNavigator.pushMessage(context);
                  },
                ),

                ListTile(
                  title: Text(
                    "类型",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 15),
                  ),
                  trailing:
                      Icon(Icons.movie, color: Colors.black12, size: 22.0),
                  onTap: () {
                    if (!authed) {
                      AppNavigator.push(context, LoginPage());
                    } else {
                      AppNavigator.push(context, GenreChoice());
                    }
                  },
                ),

                ListTile(
                  title: Text(
                    "收藏",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 15),
                  ),
                  trailing:
                      Icon(Icons.favorite, color: Colors.black12, size: 22.0),
                  onTap: () {
                    if (!authed) {
                      AppNavigator.push(context, LoginPage());
                    } else {
                      AppNavigator.push(context, MyScene());
                    }
                  },
                ),
                ListTile(
                  title: Text(
                    '分享',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  trailing:
                      Icon(Icons.share, color: Colors.black12, size: 22.0),
                  onTap: () {
                    Share.share('CS_GZ做了个电影推荐app，快来看看吧');
                  },
                ),
                ListTile(
                  title: Text(
                    "关于",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 15),
                  ),
                  trailing: Icon(Icons.info, color: Colors.black12, size: 22.0),
                  onTap: () {
                    AppNavigator.push(context, AboutMePage());
                    // Navigator.of(context)
                    //     .push(new MaterialPageRoute(builder: (context) {
                    //   return new AboutMePage();
                    // }));
                  },
                ),
                ListTile(
                  title: Text(
                    "注销",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 15),
                  ),
                  trailing: Icon(Icons.exit_to_app,
                      color: Colors.black12, size: 22.0),
                  onTap: () {
                    store.dispatch(Action2.logout);
                    username = '您还未登录';
                  },
                ),
                ListTile(
                  title: Text(
                    "退出",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 15),
                  ),
                  trailing: Icon(Icons.power_settings_new,
                      color: Colors.black12, size: 22.0),
                  onTap: () async {
                    await pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  static Future<void> pop() async {
    await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }
}
