import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:movie_recommend/public.dart';
import 'favor_movie_view.dart';
import 'favor_actor_view.dart';

class MyScene extends StatefulWidget {
  _MySceneState createState() => _MySceneState();
}

class _MySceneState extends State<MyScene>
    with RouteAware, SingleTickerProviderStateMixin {
  SharedPrefUtil prefUtil = new SharedPrefUtil();
  String username;

  TabController _tabController;
  ScrollController _scrollViewController;

  List<MovieItem> favorMovies;
  List<MovieActor> favorActors;

  bool isOk = false; //是否已经加载完数据，拿来toast用

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _scrollViewController = ScrollController(initialScrollOffset: 0.0);
    print('init my scene');
    fetchData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollViewController.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    print('deactivate');
    fetchData();
    super.deactivate();
  }

  Future<void> fetchData() async {
    String name = await prefUtil.getUserName();
    MorecApi api = new MorecApi();
    List movieList = await api.getFavorMovieList();
    List actorList = await api.getFavorActorList();

    // debugPrint(movieList.toString());

    if (this.mounted) {
      setState(() {
        username = name;
        favorMovies = list2Movie(movieList ?? []);
        favorActors = list2Actor(actorList ?? []);
        isOk = true;
      });
    }
  }

  List<MovieItem> list2Movie(List list) {
    List<MovieItem> movies = [];
    list.forEach((item) {
      MovieItem movie = new MovieItem(
        id: item['doubanId'],
        title: item['title'],
        images: MovieImage(small: item['poster']),
        year: item["year"],
        directorsString: item["directorsString"],
        genresString: item["genresString"],
        castsString: item["castsString"],
        averageRating: item["averageRating"],
        collectionTime: item["collectionTime"],
      );
      movies.add(movie);
    });
    return movies;
  }

  List<MovieActor> list2Actor(List list) {
    List<MovieActor> actors = [];
    list.forEach((item) {
      MovieActor actor = new MovieActor(
        id: item['actorId'],
        name: item['name'],
        avatars: MovieImage(small: item['avatar']),
        works: item["worksName"],
        enName: item["enName"],
        professions: item["professions"],
        collectionTime: item["collectionTime"],
      );

      actors.add(actor);
    });
    return actors;
  }

  @override
  Widget build(BuildContext context) {
    // print('build_myscene');
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            //最右边的
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search), //一定要写成Icons.  我也是醉了
                tooltip: "Search",
                // onPressed: () =>
                //     showSearch(context: context, delegate: SearchBarDelegate()),
                onPressed: () => AppNavigator.pushSearchChoice(context),
              ),
            ],
            // title: Text('我的收藏', style: TextStyle(color: AppColor.white),),
            // elevation: 0,
            // backgroundColor: AppColor.darkGrey,
            // brightness: Brightness.dark,

            title: Container(
              height: kToolbarHeight,
              width: 256,
              alignment: Alignment.center,
              child: TabBar(
                unselectedLabelColor: Colors.black54, //没有选择时标签的颜色
                indicatorColor: Colors.black54, //指示线颜色
                indicatorSize: TabBarIndicatorSize.label, //将指示线(下滑线)设置为与标签一样的长度
                indicatorWeight: 2.0, //指示线粗细程度
                tabs: <Widget>[
                  // Tab(icon:Icon(Icons.cloud_circle)),
                  // Tab(icon:Icon(Icons.cloud_circle)),
                  Tab(
                    child: Text(
                      "电影收藏",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "演员收藏",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            elevation: 0.0, //顶部栏下滑线阴影大小(朦胧黑),默认值为4.0，0.0代表不要
          ),

          //每个图标对应也就放大显示该图标
          body: TabBarView(
            children: <Widget>[
              FavorMovieSection(favorMovies, isOk),
              FavorActorSection(favorActors, isOk)
            ],
          )
          // body: NestedScrollView(
          //   headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
          //     return <Widget>[
          //       SliverAppBar(
          //         brightness: Brightness.dark,
          //         pinned: true,
          //         backgroundColor: AppColor.darkGrey,
          //         forceElevated: boxIsScrolled,
          //         elevation: 0,
          //         floating: true,
          //         expandedHeight: 200.0,
          //         flexibleSpace: FlexibleSpaceBar(
          //           background: Container(
          //             decoration: BoxDecoration(
          //               color: AppColor.darkGrey
          //             ),
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.center,
          //               mainAxisAlignment: MainAxisAlignment.start,
          //               children: <Widget>[
          //                 Container(
          //                   height: MediaQuery.of(context).padding.top,
          //                 ),
          //                 CircleAvatar(
          //                   radius: 50,
          //                   backgroundImage:
          //                       CachedNetworkImageProvider(myAvatarUrl),
          //                 ),
          //                 Container(
          //                   height: 8.0,
          //                 ),
          //                 Text(
          //                   username ?? '',
          //                   style: TextStyle(color: AppColor.white, fontSize: 18),
          //                 ),
          //                 Container(
          //                   height: 16.0,
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //         bottom: TabBar(
          //           labelColor: AppColor.white,
          //           indicatorColor: AppColor.white,
          //           controller: _tabController,
          //           tabs: <Widget>[
          //             Tab(
          //               text: "电影",
          //               icon: Icon(Icons.movie_filter),
          //             ),
          //             Tab(
          //               text: "演员",
          //               icon: Icon(Icons.recent_actors),
          //             ),
          //           ],
          //         ),
          //       )
          //     ];
          //   },
          //   body: TabBarView(
          //     children: <Widget>[
          //       FavorMovieSection(favorMovies),
          //       FavorActorSection(favorActors)
          //     ],
          //     controller: _tabController,
          //   ),
          // ),
          ),
    );
  }
}

class FavorMovieSection extends StatelessWidget {
  final List<MovieItem> movies;
  final bool isOk;

  FavorMovieSection(this.movies, this.isOk);

  @override
  Widget build(BuildContext context) {
    if (isOk == true && (movies == null || movies.length == 0)) {
      Fluttertoast.showToast(
        msg: "目前没有电影收藏",
        gravity: ToastGravity.CENTER,
      );
      return Center(
        child: Column(
          children: <Widget>[
            Image.asset(
              'images/icon_nothing.png',
              width: 100,
              height: 100,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '空空如也，去首页看看吧！',
              style: TextStyle(color: AppColor.grey, fontSize: 14),
            )
          ],
        ),
      );
    }
    return FavorMovieView(movies);
  }
}

class FavorActorSection extends StatelessWidget {
  final List<MovieActor> actors;
  final bool isOk;
  FavorActorSection(this.actors, this.isOk);

  @override
  Widget build(BuildContext context) {
    if (isOk == true && (actors == null || actors.length == 0)) {
      Fluttertoast.showToast(
        msg: "目前没有演员收藏",
        gravity: ToastGravity.CENTER,
      );
      return Center(
        child: Column(
          children: <Widget>[
            Image.asset(
              'images/icon_nothing.png',
              width: 100,
              height: 100,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '空空如也，去首页看看吧！',
              style: TextStyle(color: AppColor.grey, fontSize: 14),
            )
          ],
        ),
      );
    }
    return FavorActorView(actors);
  }
}
