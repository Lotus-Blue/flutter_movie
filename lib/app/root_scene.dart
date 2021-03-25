import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:movie_recommend/my/drawer.dart';
// import 'package:movie_recommend/my/my_scene.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:movie_recommend/public.dart';
// import 'package:movie_recommend/home/home_scene.dart';
// import 'package:movie_recommend/my/my_scene.dart';
// import 'app_state.dart';
// import 'package:movie_recommend/my/login_scene.dart';
import '../home/home_list_view.dart';
import '../home/movie_top_scroll_view.dart';
// import '../my/drawer.dart';
// import '../home/home_movie_recommendation.dart';
// import 'package:movie_recommend/my/login_scene.dart';
// import 'package:share/share.dart';
// import '../my/about.dart';
import 'package:flutter/services.dart';
import 'dart:async';
// import '../home/movie_classify_view.dart';
import '../home/movie_classify_page.dart';

import '../home/movie_recommend_page.dart';

import 'package:fluttertoast/fluttertoast.dart';

class RootScene extends StatefulWidget {
  final Widget child;

  RootScene({Key key, this.child}) : super(key: key);

  _RootSceneState createState() => _RootSceneState();
}

class _RootSceneState extends State<RootScene> {
  String username = '未登录';
  SharedPrefUtil prefUtil = new SharedPrefUtil();
  // int _tabIndex = 0;

  // 定义 tab icon
  /*
  List<Image> _tabImages = [
    Image.asset('images/tab_home.png'),
    Image.asset('images/tab_my.png'),
  ];
  List<Image> _tabSelectedImages = [
    Image.asset('images/tab_home_selected.png'),
    Image.asset('images/tab_my_selected.png'),
  ];
*/
  @override
  void initState() {
    super.initState();

    eventBus.on(EventUserLogin, (arg) {
      // debugPrint("test1");
      setState(() {
        // debugPrint("test2");
      });
    });

    eventBus.on(EventUserLogout, (arg) {
      setState(() {});
    });

/*
    eventBus.on(EventToggleTabBarIndex, (arg) {
      setState(() {
        // _tabIndex = arg;
      });
    });
    */
    // debugPrint("test");
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

    // debugPrint("test");

    setState(() {
      username = name;
      // debugPrint("test11");
    });
    if (username != "未登录") {
      await recommendTasteMovie();
    }
  }

  recommendTasteMovie() async {
    MorecApi api = new MorecApi();
    ApiClient client = new ApiClient();
    Fluttertoast.showToast(
      msg: username + ",欢迎回来!" + "正在计算你的观影口味,完毕会有信息提示",
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 6,
      // textColor: Colors.black87,
      // backgroundColor: Colors.white,
    );
    // debugPrint("1");
    var data = await api.getUserTaste(username);
    // debugPrint("2");
    // debugPrint(data.toString());
    List tags;
    List genres;
    String recTags = "";
    String recGenres = "";

    if (data != null) {
      // debugPrint("3");
      tags = data["tasteTags"].split(',');
      recTags = tags[tags.length - 3] +
          ',' +
          tags[tags.length - 2] +
          ',' +
          tags[tags.length - 1];
      // debugPrint("1111"+recTags);
      var recommendTagsData = await client.getSearchListByTag(
          tag: recTags, start: 0, count: 6, action: "recommend");

      // debugPrint("recTags:"+recTags);

      if (recommendTagsData.length == 0) {
        // debugPrint("no1");
        recTags = tags[tags.length - 2] + ',' + tags[tags.length - 1];
        recommendTagsData = await client.getSearchListByTag(
            tag: recTags, start: 0, count: 20, action: "recommend");
        if (recommendTagsData.length == 0) {
          recTags = tags[tags.length - 3] + ',' + tags[tags.length - 1];
          recommendTagsData = await client.getSearchListByTag(
              tag: recTags, start: 0, count: 20, action: "recommend");
        }
      } else {
        // debugPrint("ok1");
        List<MovieItem> newTagsMovies = getMovieList(recommendTagsData);
        //写入后台
        String description = "根据你历史喜欢的电影推荐";
        for (int i = 0; i < newTagsMovies.length; i++) {
          await api.addRecommendation(newTagsMovies[i].id, description);
        }
      }

      genres = data["tasteGenres"].split(',');
      recGenres = genres[genres.length - 3] +
          ',' +
          genres[genres.length - 2] +
          ',' +
          genres[genres.length - 1];

      // debugPrint("recGenres"+recGenres);

      var recommendGenresData = await client.getSearchListByTag(
          tag: recGenres, start: 0, count: 6, action: "recommend");

      if (recommendGenresData.length == 0) {
        // debugPrint("no2");
        recTags = genres[genres.length - 2] + ',' + genres[genres.length - 1];
        recommendGenresData = await client.getSearchListByTag(
            tag: recGenres, start: 0, count: 20, action: "recommend");
        if (recommendGenresData.length == 0) {
          recGenres =
              genres[genres.length - 3] + ',' + genres[genres.length - 1];
          recommendGenresData = await client.getSearchListByTag(
              tag: recGenres, start: 0, count: 20, action: "recommend");
        }
      } else {
        // debugPrint("ok2");
        List<MovieItem> newGenresMovies = getMovieList(recommendGenresData);
        String description = "根据你历史喜欢的电影推荐";
        for (int i = 0; i < newGenresMovies.length; i++) {
          await api.addRecommendation(newGenresMovies[i].id, description);
        }
      }
      Fluttertoast.showToast(
        msg: "已生成推荐内容,快去推荐页面看下吧",
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 3,
        // textColor: Colors.black87,
        // backgroundColor: Colors.white,
      );
    } else {
      Fluttertoast.showToast(
        msg: username + ",欢迎回来!" + "快去收藏点电影吧",
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 3,
        // textColor: Colors.black87,
        // backgroundColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    //只显示状态栏，隐藏按键
    // initState();
    debugPrint(username);
    return StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        builder: (context, store) {
          final authed = store.state.authed;
          // debugPrint(store.state.authed.toString());
          // debugPrint(authed.toString());
          return WillPopScope(
            onWillPop: _onWillPop,
            child: DefaultTabController(
              length: 4,
              child: Scaffold(
                //包含material顶部，顶部，一些部件
                appBar: AppBar(
                  //顶部栏

                  //最右边的
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.search), //一定要写成Icons.  我也是醉了
                      tooltip: "Search",
                      // onPressed: () => showSearch(
                      //     context: context, delegate: SearchBarDelegate()),
                      onPressed: () => AppNavigator.pushSearchChoice(context),
                    ),
                    // onPressed:() => AppNavigator.pushSearchChoice(context),
                  ],

                  title: Container(
                    height: kToolbarHeight,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: TabBar(
                      // isScrollable: true,
                      unselectedLabelColor: Colors.black54, //没有选择时标签的颜色
                      indicatorColor: Colors.black54, //指示线颜色
                      indicatorSize:
                          TabBarIndicatorSize.label, //将指示线(下滑线)设置为与标签一样的长度
                      indicatorWeight: 2.0, //指示线粗细程度
                      tabs: <Widget>[
                        // Tab(icon:Icon(Icons.cloud_circle)),
                        // Tab(icon:Icon(Icons.cloud_circle)),
                        Tab(
                            child: Container(
                              width: double.infinity,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                "热映",
                                style: TextStyle(
                                  // fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )),
                        Tab(
                            child: Container(
                              width: double.infinity,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                "分类",
                                style: TextStyle(
                                  // fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )),
                        Tab(
                            child: Container(
                              width: double.infinity,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                "榜单",
                                style: TextStyle(
                                  // fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )),
                        Tab(
                            child: Container(
                              width: double.infinity,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                "推荐",
                                style: TextStyle(
                                  // fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                  elevation: 0.0, //顶部栏下滑线阴影大小(朦胧黑),默认值为4.0，0.0代表不要
                ),

                //每个图标对应也就放大显示该图标
                body: TabBarView(
                  children: <Widget>[
                    //  Icon(Icons.cloud_circle,size:128.0,color:Colors.black12),//真是奇怪，为什么这里就乐意省略了icon:

                    //点击该图标换成第二个demo
                    // ListViewDemo(),
                    // Icon(Icons.access_alarm,size:128.0,color:Colors.black12),
                    HomeListView(),
                    // HomeListView(),
                    // MovieClassifyView(title: '分类浏览'),
                    MovieTagPageView(),
                    //  Icon(Icons.access_time,size:128.0,color:Colors.black12),
                    MovieTopScrollView(title: '电影榜单'),
                    // Icon(Icons.access_time,size:128.0,color:Colors.black12),
                    // MovieRecommendationView(
                    //   title: '猜你喜欢',
                    // ),

                    //分页显示
                    MovieRecommendPageView(),

                    // Test(),
                    // SliverDemo(),
                  ],
                ),

//drawer会自动生成那个图标，所以没必要再写
                drawer: DrawerDemo(),
                //  endDrawer:Text("This is a draw"),//屏幕右边
                // bottomNavigationBar: ButtomNavigationBarDemo(),
              ),
            ),
          );
        });
  }

// static Future<void> pop() async {
//     await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
//   }
// }

  int last = 0;
  Future<bool> _onWillPop() {
    int now = DateTime.now().millisecond;
    if (now - last > 800) {
      return showDialog(
            context: context,
            builder: (context) => new AlertDialog(
                  title: new Text('提示'),
                  content: new Text('确定退出应用吗？'),
                  actions: <Widget>[
                    new FlatButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: new Text('再看一会'),
                    ),
                    new FlatButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: new Text('退出'),
                    ),
                  ],
                ),
          ) ??
          false;
    }
  }

  /*
  Image getTabIcon(int index) {
  if (index == _tabIndex) {
      return _tabSelectedImages[index];
    } else {
      return _tabImages[index];
    }
  }
}
*/
  static Future<void> pop() async {
    await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }
}
