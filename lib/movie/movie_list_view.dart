import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:movie_recommend/public.dart';
import 'movie_list_item.dart';
// import '../model/movie_tag_spider.dart';

class MovieListView extends StatefulWidget {
  final String title;
  final String action;

  const MovieListView({Key key, this.title, this.action}) : super(key: key);

  @override
  _MovieListViewState createState() => _MovieListViewState(title, action);
}

class _MovieListViewState extends State<MovieListView> {
  String title;
  String action;
  List<MovieItem> movieList;

  // 默认加载 10 条数据
  int start = 0, count = 10;

  bool _loaded = false;

  ScrollController _scrollController = ScrollController(); //listview的控制器

  _MovieListViewState(this.title, this.action);

  @override
  void initState() {
    super.initState();
    fetchData();
    // 滚动监听注册
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // print('滑动到了最底部');
        fetchData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          title: action != "actor_movie_search"
              ? Text(title + '电影')
              : Text(title + '所有参演电影'),
          backgroundColor: AppColor.white,
          leading: GestureDetector(
            onTap: back,
            child: Image.asset('images/icon_arrow_back_black.png'),
          ),
          elevation: 0,
        ),
        body: _buildBody());
  }

  // 返回上个页面
  back() {
    Navigator.pop(context);
  }

  Widget _buildBody() {
    if (movieList == null) {
      return Center(
        child: CupertinoActivityIndicator(),
      );
    }
    return Container(
      child: ListView.builder(
        itemCount: movieList.length,
        itemBuilder: (BuildContext context, int index) {
          if (index + 1 == movieList.length) {
            return Container(
              padding: EdgeInsets.all(10),
              child: Center(
                child: Offstage(
                  offstage: _loaded,
                  child: CupertinoActivityIndicator(),
                ),
              ),
            );
          }
          return MovieListItem(movieList[index], action);
        },
        controller: _scrollController,
      ),
    );
  }

  Future<void> fetchData() async {
    if (_loaded) {
      return;
    }
    ApiClient client = new ApiClient();
    var data;
    switch (action) {
      case 'in_theaters':
        data = await client.getNowPlayingList(start: start, count: count);
        break;
      case 'coming_soon':
        data = await client.getComingList(start: start, count: count);
        break;
      case 'search':
        data = await client.getSearchListByTag(
            tag: title, start: start, count: count);

        // data = await getTagMovieData(start,count,title);
        break;
      case 'actor_movie_search':
        data = await client.getSearchListByTag(
            tag: title, start: start, count: count);
        break;
    }
    if (this.mounted) {
      setState(() {
        if (movieList == null) {
          movieList = [];
        }
        List<MovieItem> newMovies = getMovieList(data);
        if (newMovies.length == 0) {
          _loaded = true;
          return;
        }
        newMovies.forEach((movie) {
          movieList.add(movie);
        });

        start = start + count;
      });
    }
  }

  List<MovieItem> getMovieList(var list) {
    List content = list;
    List<MovieItem> movies = [];
    content.forEach((data) {
      movies.add(MovieItem.fromJson(data));
    });
    return movies;
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}
