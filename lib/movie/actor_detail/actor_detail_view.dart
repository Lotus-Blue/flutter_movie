import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart' as prefix0;

import 'package:palette_generator/palette_generator.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:movie_recommend/public.dart';

import 'actor_detail_header.dart';
import 'actor_detail_summary.dart';
import 'actor_detail_works.dart';
import 'actor_detail_photos.dart';

import 'package:movie_recommend/movie/actor_detail/actor_detail_recommend_view.dart';

// import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';

class ActorDetailView extends StatefulWidget {
  // 影人 id
  final String id;
  const ActorDetailView({Key key, this.id}) : super(key: key);

  @override
  _ActorDetailViewState createState() => _ActorDetailViewState();
}

class _ActorDetailViewState extends State<ActorDetailView> {
  MovieActorDetail actorDetail;
  double navAlpha = 0;
  ScrollController scrollController = ScrollController();
  Color pageColor = AppColor.white;
  bool isSummaryUnfold = false;
  bool isFavor = false;
  bool isDisplay = false; //推荐演员是否已经加载完，要展示了
  bool isHasGottonData = false; //就怕有的用户很骚，那颗心点了有点，我们只请求一次数据即可

  //相关演员
  List<MovieActor> recommendActors = [];

  //与演员名字最相似的前top个词
  List<dynamic> similarWord = [];

  //演员高分电影
  List<MovieItem> recommendActorMovie = [];

  @override
  void initState() {
    super.initState();
    fetchData();

    scrollController.addListener(() {
      var offset = scrollController.offset;
      if (offset < 0) {
        if (navAlpha != 0) {
          setState(() {
            navAlpha = 0;
          });
        }
      } else if (offset < 50) {
        setState(() {
          navAlpha = 1 - (50 - offset) / 50;
        });
      } else if (navAlpha != 1) {
        setState(() {
          navAlpha = 1;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Screen.updateStatusBarStyle(SystemUiOverlayStyle.light);

    if (actorDetail == null) {
      return Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: GestureDetector(
              onTap: back,
              child: Image.asset('images/icon_arrow_back_black.png'),
            ),
          ),
          body: Center(
            child: CupertinoActivityIndicator(),
          ));
    }
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            color: pageColor,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: EdgeInsets.only(top: 0),
                    children: <Widget>[
                      ActorDetailHeader(actorDetail, pageColor),
                      ActorDetailSummary(actorDetail.summary, isSummaryUnfold,
                          changeSummaryMaxLines),
                      ActorDetailWorks(actorDetail.works, actorDetail.name),
                      isFavor && isDisplay
                          ? ActorDetailRecommendView(recommendActors)
                          : Container(), //气死我了！这里不要写出null，会报错的，害我白白debug10分钟
                      ActorDetailPhoto(actorDetail.photos, actorDetail.id),
                      // MovieDetailTag(movieDetail.tags),
                      // MovieSummaryView(movieDetail.summary, isSummaryUnfold, changeSummaryMaxLines),
                      // MovieDetailCastView(movieDetail.directors, movieDetail.casts),
                      // MovieDetailPhotots(movieDetail.trailers, movieDetail.photos),
                      // MovieDetailComment(movieDetail.comments)
                    ],
                  ),
                )
              ],
            ),
          ),
          // Container(color: pageColor,padding: EdgeInsets.symmetric(vertical: 300),),
          buildNavigationBar(),
        ],
      ),
    );
  }

  Widget buildNavigationBar() {
    return Stack(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: 50,
              height: Screen.navigationBarHeight,
              padding: EdgeInsets.fromLTRB(5, Screen.topSafeHeight, 0, 0),
              child: GestureDetector(
                  onTap: back,
                  child: Image.asset('images/icon_arrow_back_white.png')),
            ),
            Container(
              width: 50,
              height: Screen.navigationBarHeight,
              padding: EdgeInsets.fromLTRB(5, Screen.topSafeHeight, 0, 0),
              child: GestureDetector(
                onTap: isFavor ? cancelFavor : favorActor,
                child: isFavor
                    ? Icon(
                        Icons.favorite,
                        color: AppColor.red,
                      )
                    : Icon(
                        Icons.favorite_border,
                        color: AppColor.white,
                      ),
              ),
            ),
          ],
        ),
        Opacity(
          opacity: navAlpha,
          child: Container(
            decoration: BoxDecoration(color: pageColor),
            padding: EdgeInsets.fromLTRB(5, Screen.topSafeHeight, 0, 0),
            height: Screen.navigationBarHeight,
            child: Row(
              children: <Widget>[
                Container(
                  width: 44,
                  child: GestureDetector(
                      onTap: back,
                      child: Image.asset('images/icon_arrow_back_white.png')),
                ),
                Expanded(
                  child: Text(
                    actorDetail.name,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColor.white),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  width: 44,
                  child: GestureDetector(
                      onTap: isFavor ? cancelFavor : favorActor,
                      child: isFavor
                          ? Icon(
                              Icons.favorite,
                              color: AppColor.red,
                            )
                          : Icon(
                              Icons.favorite_border,
                              color: AppColor.white,
                            )),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  // 返回上个页面
  back() {
    Navigator.pop(context);
  }

  // 收藏演员
  favorActor() async {
    MorecApi api = new MorecApi();
    var data = await api.favorActor(actorDetail);
    if (data != null) {
      setState(() {
        isFavor = true;
        recommendActor();
        isDisplay = true;
        // addRecommend();
      });
    }
  }

  //上传电影推荐内容
  addRecommend() async {
    MorecApi api = new MorecApi();
    // await api.writeFavorActorGenreTagOperation(actorDetail);//已挪动位置
    // await api.recommendActorSimMovie(actorDetail);//这个好像效果不好，因为计算源头都出错了，先留着
    List recActorId = [];
    List recActorName = [];
    for (int i = 0; i < recommendActors.length; i++) {
      // debugPrint("开始");
      recActorId.add(recommendActors[i].id);
      // debugPrint("id:"+recommendActors[i].id);
      recActorName.add(recommendActors[i].name);
      // debugPrint("name:"+recommendActors[i].name);
      // debugPrint("结束");
    }
    Fluttertoast.showToast(
      msg: "正在生成推荐内容,请耐心稍等,加载完毕会有信息提示",
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 3,
      // textColor: Colors.black87,
      // backgroundColor: Colors.white,
    );
    await api.recommendActorSimActor(actorDetail, recActorId, recActorName);

    Fluttertoast.showToast(
      msg: "推荐内容已生成,快去首页看下吧",
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 3,
      // textColor: Colors.black87,
      // backgroundColor: Colors.white,
    );
  }

  // 加载推荐演员信息
  recommendActor() async {
    Fluttertoast.showToast(
      msg: "正在计算并加载推荐演员,请耐心稍等,加载完毕会有信息提示",
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 3,
      toastLength: prefix0.Toast.LENGTH_SHORT,
      // textColor: Colors.black87,
      // backgroundColor: Colors.white,
    );

    if (isHasGottonData == false) {
      ApiClient client = new ApiClient();
      MorecApi api = new MorecApi();
      for (int i = 0; i < similarWord.length; i++) {
        var recommendData =
            await client.getCelebritySearchByApi(name: similarWord[i]);
        if (recommendData == null) {
          continue;
        }
        MovieActor actor = new MovieActor(
          id: recommendData['id'],
          name: recommendData['name'],
          avatars: MovieImage(small: recommendData['avatars']["small"]),
        );
        recommendActors.add(actor);
        // List<MovieActor> newActors = getActorList(recommendData);
        // newActors.forEach((actor) {
        //   if (actor.id != actorDetail.id) {
        //     // //debugPrint(actor.toString());
        //     recommendActors.add(actor);
        //   }
        // });
        // sleep(const Duration(seconds: 1));
      }
      //debugPrint("总共有" + recommendActors.length.toString() + "个演员推荐;他们分别是");
      for (int i = 0; i < recommendActors.length; i++) {
        //debugPrint(recommendActors[i].name + "  ");
      }
      var recommendActorMovieData = await client.getSearchListByTag(
          tag: actorDetail.name,
          start: 0,
          count: 6,
          action: "recommend",
          tagWay: "S");
      List<MovieItem> newMovies = getMovieList(recommendActorMovieData);
      newMovies.forEach((movie) {
        if (movie.averageRating != null &&
            double.parse(movie.averageRating) > 7.0) {
          //只推荐7.0以上的，7.0以下的都不用想，一般是烂片；还有不要推荐本影片进去
          recommendActorMovie.add(movie);
        }
      });

      if (this.mounted) {
        setState(() {
          recommendActors = recommendActors;
          recommendActorMovie = recommendActorMovie;
          isHasGottonData = true;
        });
      }

      Fluttertoast.showToast(
        msg: "全部加载完毕",
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 3,
        toastLength: prefix0.Toast.LENGTH_SHORT,
        // textColor: Colors.black87,
        // backgroundColor: Colors.white,
      );

      if (recommendActorMovie.length != 0) {
        List recActorMovieId = [];
        for (int i = 0; i < recommendActorMovie.length; i++) {
          recActorMovieId.add(recommendActorMovie[i].id);
        }
        await api.recommendActorTopMovie(actorDetail, recActorMovieId);
      }

      Fluttertoast.showToast(
        msg: "正在后台计算,请耐心稍等,计算完毕会有信息提示",
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 3,
        toastLength: prefix0.Toast.LENGTH_SHORT,
        // textColor: Colors.black87,
        // backgroundColor: Colors.white,
      );

      var responseData =
          await api.writeFavorActorGenreTagOperation(actorDetail);
      if (responseData != null) {
        Fluttertoast.showToast(
          msg: "后台已成功计算",
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 3,
          toastLength: prefix0.Toast.LENGTH_SHORT,
          // textColor: Colors.black87,
          // backgroundColor: Colors.white,
        );
        await addRecommend();
      }

      // String recommendActorId = "";
      // String recommendActorPhoto = "";
      // for (int i = 0; i < recommendActors.length; i++) {
      //   recommendActorId += recommendActors[i].id.toString() + ',';
      //   recommendActorPhoto +=
      //       recommendActors[i].avatars.small.toString() + ',';
      // }

      // debugPrint(actorDetail.id);

      //将该结果推至后台保存
      // var data = await api.postRecommendActor(actorDetail.id, actorDetail.name,
      //     recommendActorId, recommendActorPhoto);
      // if (data != null) {
      //   Fluttertoast.showToast(
      //     msg: "上传数据完毕",
      //     gravity: ToastGravity.CENTER,
      //     timeInSecForIos: 3,
      //     toastLength: prefix0.Toast.LENGTH_SHORT,
      //     // textColor: Colors.black87,
      //     // backgroundColor: Colors.white,
      //   );
      // }
    } else {
      Fluttertoast.showToast(
        msg: "全部加载完毕",
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 3,
        toastLength: prefix0.Toast.LENGTH_SHORT,
        // textColor: Colors.black87,
        // backgroundColor: Colors.white,
      );
      Fluttertoast.showToast(
        msg: "推荐内容已生成,快去首页看下吧",
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 3,
        // textColor: Colors.black87,
        // backgroundColor: Colors.white,
      );
    }
  }

  // 取消收藏
  cancelFavor() async {
    MorecApi api = new MorecApi();
    api.cancelFavorActor(actorDetail.id);
    setState(() {
      isFavor = false;
      isDisplay = false;
      isHasGottonData = true; //已经请求过数据，不用再请求了
    });
  }

  // 展开 or 收起
  changeSummaryMaxLines() {
    setState(() {
      isSummaryUnfold = !isSummaryUnfold;
    });
  }

  Future<void> fetchData() async {
    ApiClient client = new ApiClient();
    MorecApi api = new MorecApi();
    MovieActorDetail data =
        MovieActorDetail.fromJson(await client.getActorDetail(this.widget.id));
    PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      CachedNetworkImageProvider(data.avatars.small),
    );
    var isFavorData = await api.isActorFavor(this.widget.id);

    //计算相似演员
    similarWord = await client.getSimilarWord(text: data.name, top: 15);

    if (this.mounted) {
      setState(() {
        // recommendActors = recommendActors;
        actorDetail = data;
        similarWord = similarWord;
        if (paletteGenerator.darkMutedColor != null) {
          pageColor = paletteGenerator.darkMutedColor.color;
        } else {
          pageColor = Color(0xff35374c);
        }
        if (isFavorData != null) {
          isFavor = true;
          // isHasGottonData = true;
          recommendActor();
          isDisplay = true;
        }
        // pageColor =paletteGenerator.dominantColor?.color;
      });
    }

    // for(int i=0;i<similarWord.length;i++){
    //   var recommendData = await client.getAllSearchListByName(name:similarWord[i]);
    //   if(recommendData==null){
    //     continue;
    //   }
    //   List<MovieActor> newActors = getActorList(recommendData);
    //   newActors.forEach((actor) {
    //     if(actor.id!=data.id){
    //       // //debugPrint(actor.toString());
    //       recommendActors.add(actor);
    //     }
    //   });
    //   sleep(const Duration(seconds: 1));
    // }
    //   //debugPrint("总共有"+recommendActors.length.toString()+"个演员推荐;他们分别是");
    //   for(int i=0;i<recommendActors.length;i++){
    //     //debugPrint(recommendActors[i].name+"  ");
    //   }
  }
}

// List<MovieActor> getActorList(var list) {
//   List content = list;
//   List<MovieActor> actors = [];
//   content.forEach((data) {
//     MovieActor actor = new MovieActor(
//       id: data['id'],
//       name: data['name'],
//       avatars: MovieImage(small: data['avatars']["small"]),
//     );
//     // //debugPrint(actor.avatars.small.toString());
//     actors.add(actor);
//   });
//   return actors;
// }
