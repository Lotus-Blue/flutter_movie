import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:movie_recommend/public.dart';
import 'movie_actor_list_item.dart';
import 'package:movie_recommend/util/actor_data_util.dart';

class MovieActorSearchListView extends StatefulWidget {
  final String keyWord;
  final String action;

  MovieActorSearchListView(this.keyWord, this.action);

  @override
  _MovieActorSearchListViewState createState() =>
      _MovieActorSearchListViewState(keyWord, action);
}

class _MovieActorSearchListViewState extends State<MovieActorSearchListView> {
  String keyWord;
  String action;
  List<MovieActorDetail> actorList;

  // 默认加载 5 条数据
  int start = 0, count = 5;

  bool _loaded = false;

  ScrollController _scrollController = ScrollController(); //listview的控制器

  _MovieActorSearchListViewState(this.keyWord, this.action);

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
    return _buildBody();
  }

  Widget _buildBody() {
    // debugPrint(actorList.length.toString());
    if (actorList == null) {
      // debugPrint("actorList.length.toString()");
      return Center(
        child: CupertinoActivityIndicator(),
      );
    }
    return Container(
      child: ListView.builder(
        itemCount: actorList.length,
        itemBuilder: (BuildContext context, int index) {
          if (index + 1 == actorList.length && index != 0) {
            //修复之前的不加&&时当只有一个演员时不显示的bug
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
          return MovieActorListItem(actorList[index], action);
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
    var data; //搜索数据
    if (action == "actor_name") {
      data = await client.getAllSearchListByName(
          name: this.widget.keyWord, action: "search");
    }
    // debugPrint(data.toString());
    if (this.mounted) {
      setState(() {
        if (actorList == null) {
          actorList = [];
        }
        List<MovieActorDetail> newActors = ActorDataUtil.getActorList(data);
        if (newActors.length == 0) {
          _loaded = true;
          return;
        }
        newActors.forEach((actor) {
          // debugPrint(actor.name);
          actorList.add(actor);
        });

        start = start + count;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}
