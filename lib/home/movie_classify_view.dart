import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:movie_recommend/model/movie_item.dart';

import 'package:movie_recommend/public.dart';

// import 'home_section_view.dart';
import 'movie_classify_item.dart';
// import '../model/movie_tag_spider.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';

class MovieClassifyView extends StatefulWidget {
  final String title;

  const MovieClassifyView({Key key, this.title}) : super(key: key);

  @override
  _MovieClassifyViewState createState() => _MovieClassifyViewState();
}

class _MovieClassifyViewState extends State<MovieClassifyView>
    with AutomaticKeepAliveClientMixin<MovieClassifyView> {
  var classifyMovieList;
  var tagList;

  @override
  Widget build(BuildContext context) {
    if (classifyMovieList == null) {
      return CupertinoActivityIndicator();
    }
    return Container(
      color: Colors.white,
      child: RefreshIndicator(
        color: AppColor.primary,
        onRefresh: fetchData,
        child: ListView(
          addAutomaticKeepAlives: true,
          // 防止 children 被重绘，
          cacheExtent: 10000,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // HomeSectionView(this.widget.title, 'search'),
                Container(
                  // padding: EdgeInsets.fromLTRB(15, 10, 0, 10),
                  child: Column(
                    children: <Widget>[
                      MovieClassiyItem(tagList[0], classifyMovieList[0]),
                      MovieClassiyItem(tagList[1], classifyMovieList[1]),
                      MovieClassiyItem(tagList[2], classifyMovieList[2]),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // 加载数据
  Future<void> fetchData() async {
    ApiClient client = new ApiClient();
    // 获取标签
    List<String> tags = TagUtil.getRandomTag();
    List<List<MovieItem>> classifyMovies = [];
    // debugPrint("hi");
    debugPrint(tags[0].toString() + tags[1].toString() + tags[2].toString());
    List<MovieItem> classifyList = MovieDataUtil.getMovieList(
        await client.getSearchListByTag(tag: tags[0], start: 0, count: 9));
    sleep1(); //一次请求3个，被误判为爬虫几率大
    Fluttertoast.showToast(
      msg: "数据加载中...",
      gravity: ToastGravity.CENTER,
    );
    List<MovieItem> regionList = MovieDataUtil.getMovieList(
        await client.getSearchListByTag(tag: tags[1], start: 0, count: 9));
    sleep1();
    List<MovieItem> featureList = MovieDataUtil.getMovieList(
        await client.getSearchListByTag(tag: tags[2], start: 0, count: 9));
    // List<MovieItem> classifyList = MovieDataUtil.getMovieList(await client.getTop250List(start: 0, count: 9));
    // List<MovieItem> regionList = MovieDataUtil.getMovieList(await client.getTop250List(start: 0, count: 9));
    // List<MovieItem> featureList = MovieDataUtil.getMovieList(await client.getTop250List(start: 0, count: 9));
    // List<MovieItem> classifyList = MovieDataUtil.getMovieList(await getTagMovieData2(tags[0]));
    // List<MovieItem> regionList = MovieDataUtil.getMovieList(await getTagMovieData2(tags[1]));
    // List<MovieItem> featureList = MovieDataUtil.getMovieList(await getTagMovieData2(tags[2]));
    classifyMovies.addAll([classifyList, regionList, featureList]);
    // debugPrint(regionList.toString());
    if (this.mounted) {
      setState(() {
        classifyMovieList = classifyMovies;
        tagList = tags;
      });
    }
  }

  @override
  bool get wantKeepAlive => true;
}

Future sleep1() {
  return new Future.delayed(const Duration(seconds: 1), () => "1");
}
