// import 'package:flutter/cupertino.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:palette_generator/palette_generator.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:movie_recommend/public.dart';

import 'movie_detail_header.dart';
import 'movie_detail_tag.dart';
import 'movie_summary_view.dart';
import 'movie_detail_cast_view.dart';
import 'movie_detail_photots.dart';
import 'movie_detail_comment.dart';

import 'movie_detail_recomend_view.dart';

import "dart:math";

// import 'dart:io';
/*
import "dart:math";

import 'dart:io';
*/

import 'package:fluttertoast/fluttertoast.dart';

//导入评分插件
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

//本文件有两种推荐方式，一个是nlp，一个是流行标签，nlp代码我全部用/** /圈起来了，如果想要解锁就行

class MovieDetailView extends StatefulWidget {
  // 电影 id
  final String id;

  const MovieDetailView({Key key, this.id}) : super(key: key);

  @override
  _MovieDetailViewState createState() => _MovieDetailViewState();
}

class _MovieDetailViewState extends State<MovieDetailView> {
  MovieDetail movieDetail;
  double navAlpha = 0;
  ScrollController scrollController = ScrollController();
  Color pageColor = AppColor.white;
  bool isSummaryUnfold = false;
  bool initialfavor = false; //刚开始进入页面时的favor情况，防止多次reconmmend上传
  bool isFavor = false; //是否按下了收藏按钮
  bool isMovieRated = false;
  bool isDisplay = false; //推荐电影是否已经加载完，要展示了
  bool isHasGottonData = false; //就怕有的用户很骚，那颗心点了有点，我们只请求一次数据即可
  String vipVideoUrl = "https://jiexi.bm6ig.cn/?url=";

  //相关电影
  List<MovieItem> recommendMovies = [];

  /*
  int tagTotal = 0;
  Map tag2Num = {};
  Set<int> tagKey = new Set<int>();
  List<String> recomendTag = [];
*/

  //为电影热评给上情感指数，0-1，1表示正面
  List<double> postiveEmotionIndex = [];
  List<double> negativeEmotionIndex = [];

/*

  //与电影标题最相似的前top个词
  List<dynamic> similarWord = [];

*/

  //评分
  double rate1 = 0;

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

    if (movieDetail == null) {
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
                      MovieDetailHeader(movieDetail, pageColor, vipVideoUrl),
                      Container(
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "评价:",
                              style: TextStyle(
                                color: AppColor.white,
                                fontSize: fixedFontSize(17),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            RatingBar(
                              itemSize: 25,
                              initialRating: rate1,
                              direction: Axis.horizontal,
                              allowHalfRating: false, //只允许整数评分
                              itemCount: 5,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 0.2),
                              itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    size: 13,
                                    color: new Color(0xffFF962E),
                                  ),
                              onRatingUpdate: (rating) {
                                print(rating);
                                setState(() {
                                  this.rate1 = rating;
                                  isMovieRated = true;
                                  rateMovie();
                                });
                              },
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            isMovieRated
                                ? Text("")
                                : Text(
                                    "未评分",
                                    style: TextStyle(
                                      color: AppColor.white,
                                      fontSize: fixedFontSize(17),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      MovieDetailTag(movieDetail.tags),
                      MovieSummaryView(movieDetail.summary, isSummaryUnfold,
                          changeSummaryMaxLines),
                      MovieDetailCastView(
                          movieDetail.directors, movieDetail.casts),
                      isFavor && isDisplay
                          ? MovieDetailRecommendView(recommendMovies)
                          : Container(),
                      MovieDetailPhotots(movieDetail.trailers,
                          movieDetail.photos, movieDetail.id),
                      MovieDetailComment(movieDetail.comments,
                          postiveEmotionIndex, negativeEmotionIndex)
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
                onTap: isFavor ? cancelFavor : favorMovie,
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
                    movieDetail.title,
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
                      onTap: isFavor ? cancelFavor : favorMovie,
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

  // 收藏电影
  favorMovie() async {
    MorecApi api = new MorecApi();
    isFavor = true;
    var data = await api.favorMovie(movieDetail);
    if (data != null) {
      setState(() {
        isFavor = true;
        recommendMovie2();
        isDisplay = true;
      });
    }
    // print(recommendMovies==null);
    // if(recommendMovies==null){
    //   sleep(const Duration(seconds: 3));
    // }
    // debugPrint(recommendMovies[0].genres.toString()+"jjjjj");
  }

  //上传电影推荐内容
  addRecommend() async {
    MorecApi api = new MorecApi();
    List recommendId = [];
    var random = new Random();
    int dataLen;
    if (recommendMovies.length <= 5) {
      dataLen = recommendMovies.length;
    } else {
      dataLen = (recommendMovies.length * (1 / 3)).toInt();
    }
    for (int i = 0; i < dataLen; i++) {
      // debugPrint("hh"+recommendMovies[random.nextInt(recommendMovies.length)-1].id);
      int dataId;
      if (recommendMovies.length <= 5) {
        dataId = i + 1;
      } else {
        dataId = random.nextInt(recommendMovies.length);
        if (dataId == 0) {
          dataId = 1;
        }
      }
      recommendId.add(recommendMovies[dataId - 1].id);
    }
    await api.recommendMovieTagSimMovie(recommendId, movieDetail.title);
    await api.recommendMovieTitleSimMovie(movieDetail);
    Fluttertoast.showToast(
      msg: "推荐内容已生成,快去首页看下吧",
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 3,
      // textColor: Colors.black87,
      // backgroundColor: Colors.white,
    );
  }

  //对电影评分
  rateMovie() async {
    MorecApi api = new MorecApi();
    var data = await api.rateMovie(movieDetail.id.toString(), rate1.toString());
    if (data != null) {
      Fluttertoast.showToast(
        msg: "评分成功",
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 3,
        // textColor: Colors.black87,
        // backgroundColor: Colors.white,
      );
    }
  }

  recommendMovie2() async {
    //根据热门标签请求数据
    Fluttertoast.showToast(
      msg: "正在计算并加载推荐电影,请耐心稍等,加载完毕会有信息提示",
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 3,
      // textColor: Colors.black87,
      // backgroundColor: Colors.white,
    );
    if (isHasGottonData == false) {
      ApiClient client = new ApiClient();
      List tags = movieDetail.tags;
      String recommendTags = "";
      for (int i = 0; i < (tags.length * (1 / 3)).toInt(); i++) {
        recommendTags = recommendTags + tags[i] + ',';
      }
      // debugPrint(recommendTags);
      bool isDataHard = false; //推荐影片少，就不用挑剔了,设为true，然后让这几部通过
      var recommendData = await client.getSearchListByTag(
          tag: recommendTags, start: 0, count: 20, action: "recommend");
      // debugPrint(recommendData.length.toString());
      if (recommendData.length == 0) {
        //  isDataHard = true;
        recommendTags = "";
        for (int i = 0; i < (tags.length * (1 / 5)).toInt(); i++) {
          recommendTags = recommendTags + tags[i] + ',';
        }
        // debugPrint(recommendTags);
        recommendData = await client.getSearchListByTag(
            tag: recommendTags, start: 0, count: 20, action: "recommend");
        if (recommendData.length == 0) {
          // isDataHard = true;
          recommendData = await client.getSearchListByTag(
              tag: tags[0], start: 0, count: 20, action: "recommend");
        }
      }
      List<MovieItem> newMovies = getMovieList(recommendData);
      if (newMovies.length <= 3) {
        isDataHard = true; //推荐影片少，就不用挑剔了
      }
      debugPrint(newMovies[0].averageRating);
      newMovies.forEach((movie) {
        if (movie.averageRating != null &&
            (double.parse(movie.averageRating) > 7.0 || isDataHard == true) &&
            movie.id != movieDetail.id) {
          //只推荐7.0以上的，7.0以下的都不用想，一般是烂片；还有不要推荐本影片进去
          recommendMovies.add(movie);
        }
      });
      if (this.mounted) {
        setState(() {
          recommendMovies = recommendMovies;
          isHasGottonData = true;
          // isDisplay = true;
        });
      }
      Fluttertoast.showToast(
        msg: "全部加载完毕",
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 3,
        // textColor: Colors.black87,
        // backgroundColor: Colors.white,
      );
      // debugPrint(recommendMovies.length.toString());
      if (initialfavor == false && isFavor == true) {
        addRecommend(); //防止骚用户同一页面短时间多次收藏
      }
    } else {
      Fluttertoast.showToast(
        msg: "全部加载完毕",
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 3,
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

//下面的代码暂时用不上

/*

  // 加载推荐电影信息
  recommendMovie() async {
    Fluttertoast.showToast(
      msg: "正在计算并加载推荐电影,请耐心稍等,加载完毕会有信息提示",
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 3,
      // textColor: Colors.black87,
      // backgroundColor: Colors.white,
    );
    if (isHasGottonData == false) {
      // var recommendData;
      // Random random = new Random();
      // for(int i=0;i<tagKey.length;i++){
      //     recomendTag.add(tag2Num[tagKey.elementAt(i)]);
      //     recommendData = await client.getSearchListByTag(tag: tag2Num[tagKey.elementAt(i)], start: random.nextInt(5), count: 3);
      //     List<MovieItem> newMovies = getMovieList(recommendData);
      //     newMovies.forEach((movie) {
      //       recommendMovies.add(movie);
      //   });
      // }
      ApiClient client = new ApiClient();
      MorecApi api = new MorecApi();
      if (similarWord[0] == "null") {
        // debugPrint("hi");
        // recommendMovie();
        Random random = new Random();
        for (int i = 0; i < (tagTotal * (1 / 3)).toInt(); i++) {
          var recommendData = await client.getSearchListByTag(
              tag: tag2Num[i],
              start: random.nextInt(5),
              count: 2,
              action: "recommend");
          List<MovieItem> newMovies = getMovieList(recommendData);
          newMovies.forEach((movie) {
            if (movie.averageRating != null &&
                double.parse(movie.averageRating) > 6.0) {
              //只推荐6.0以上的，6.0以下的都不用想，肯定是烂片
              recommendMovies.add(movie);
            }
          });
          // debugPrint(recommendMovies[0].toString());
        }
      } else {
        Random random = new Random();
        int cnt = 0; //推荐7部就行可,以免极端情况

        //标签的也给一点，避免极端情况
        for (int i = 0; i < (tagTotal * (1 / 3)).toInt(); i++) {
          var recommendData = await client.getSearchListByTag(
              tag: tag2Num[i],
              start: random.nextInt(5),
              count: 2,
              action: "recommend");
          List<MovieItem> newMovies = getMovieList(recommendData);
          newMovies.forEach((movie) {
            if (movie.averageRating != null &&
                double.parse(movie.averageRating) > 6.0) {
              //只推荐6.0以上的，6.0以下的都不用想，肯定是烂片
              recommendMovies.add(movie);
            }
          });
        }

        for (int i = 0; i < similarWord.length; i++) {
          int choice = random.nextInt(30);
          var recommendData = await client.getSearchListByName(
              name: similarWord[choice],
              start: 0,
              count: 1,
              action: "recommend");
          // var recommendData =await client.getSearchListByTag(tag:similarWord[choice],start:0,count:1);
          if (recommendData != null) {
            List<MovieItem> newMovies = getMovieList(recommendData);
            // debugPrint(newMovies.toString());
            newMovies.forEach((movie) {
              // if (movie.averageRating != null &&
              //     int.parse(movie.averageRating) > 6.0) {
              //只推荐6.0以上的，6.0以下的都不用想，肯定是烂片
              recommendMovies.add(movie);
              cnt++;
              // }
            });
          } else if (recommendData == null) {
            var recommendData = await client.getSearchListByTag(
                tag: similarWord[choice],
                start: 0,
                count: 1,
                action: "recommend");
            if (recommendData != null) {
              List<MovieItem> newMovies = getMovieList(recommendData);
              newMovies.forEach((movie) {
                if (movie.averageRating != null &&
                    double.parse(movie.averageRating) > 6.0) {
                  //只推荐6.0以上的，6.0以下的都不用想，肯定是烂片
                  recommendMovies.add(movie);
                  cnt++;
                }
              });
            }
          }
          if (cnt == 7) {
            break;
          }
          if (i > 16 && cnt < 7) {
            //如果检索了16个tag还没有7部，就stop
            break;
          }
          sleep(const Duration(seconds: 1));
        }

        //debugPrint("总共有" + recommendMovies.length.toString() + "部推荐");

        //剔除跟该电影重复的推荐电影
        for (int i = 0; i < recommendMovies.length; i++) {
          if (recommendMovies[i].id == movieDetail.id) {
            recommendMovies.removeAt(i);
            i--;
          }
          if (i == recommendMovies.length - 1) {
            break; //防止越界
          }
          for (int j = i + 1; j < recommendMovies.length; j++) {
            if (j == recommendMovies.length) {
              break;
            }
            if (recommendMovies[i].id == recommendMovies[j].id) {
              recommendMovies.removeAt(j);
              i--;
              break;
            }
          }
        }
        //debugPrint("总共有" + recommendMovies.length.toString() + "部推荐");
      }
      Fluttertoast.showToast(
        msg: "全部加载完毕",
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 3,
        // textColor: Colors.black87,
        // backgroundColor: Colors.white,
      );

      String recommendMovieId = "";
      String recommendMoviePhoto = "";
      String recommendMovieScore = "";
      for (int i = 0; i < recommendMovies.length; i++) {
        recommendMovieId += recommendMovies[i].id.toString() + ',';
        recommendMoviePhoto += recommendMovies[i].images.small.toString() + ',';
        recommendMovieScore +=
            recommendMovies[i].averageRating.toString() + ',';
      }

      // 将该结果推至后台保存
      var data = await api.postRecommendMovie(movieDetail.id, movieDetail.title,
          recommendMovieId, recommendMoviePhoto, recommendMovieScore);
      if (data != null) {
        Fluttertoast.showToast(
          msg: "上传数据完毕",
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 3,
          // toastLength: prefix0.Toast.LENGTH_SHORT,
          // textColor: Colors.black87,
          // backgroundColor: Colors.white,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: "全部加载完毕",
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 3,
        // textColor: Colors.black87,
        // backgroundColor: Colors.white,
      );
    }
    setState(() {
      recommendMovies = recommendMovies;
      // isDisplay = true;
    });
  }

*/

  //加载热评情感指数，0-1，越接近1越正面
  emotionIndex() async {
    // ApiClient client = new ApiClient();
    // //获取每条评论情感指数
    // for(int i=0;i<movieDetail.comments.length;i++){
    //   // //debugPrint(movieDetail.comments[i].content);
    //   var data = await client.getSentimentIndex(text:movieDetail.comments[i].content);
    //   // //debugPrint("start");
    //   //debugPrint(movieDetail.comments[i].content+data.toString());
    //   // //debugPrint("end");
    //   postiveEmotionIndex.add(data["Positive"]);
    //   negativeEmotionIndex.add(data["Negative"]);//这里不要用[]=，会报错，用add即可
    // }
    // setState(() {
    //   isOk = true;
    // });
  }

  // 取消收藏
  cancelFavor() async {
    MorecApi api = new MorecApi();
    api.cancelFavorMovie(movieDetail.id);
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
    MovieDetail data =
        MovieDetail.fromJson(await client.getMovieDetail(this.widget.id));
    PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      CachedNetworkImageProvider(data.images.small),
    );
    var isFavorData = await api.isMovieFavor(this.widget.id);
    var isMovieRatedData = await api.isMovieRated(this.widget.id);
    var playUrlData = await client.getMovieAcessUrl();

//获取每条评论情感指数
    for (int i = 0; i < data.comments.length; i++) {
      // //debugPrint(movieDetail.comments[i].content);
      var indexData =
          await client.getSentimentIndex(text: data.comments[i].content);
      // //debugPrint("start");
      // //debugPrint(data.comments[i].content+indexData.toString());
      // //debugPrint("end");
      postiveEmotionIndex.add(indexData["Positive"]);
      negativeEmotionIndex.add(indexData["Negative"]); //这里不要用[]=，会报错，用add即可
    }

/*
    //获取与电影标题最相似的前top个词
    similarWord = await client.getSimilarWord(text: data.title, top: 50);

*/

    if (this.mounted) {
      setState(() {
        movieDetail = data;
        vipVideoUrl = playUrlData["url"];

/*
        similarWord = similarWord;
*/
        postiveEmotionIndex = postiveEmotionIndex;
        negativeEmotionIndex = negativeEmotionIndex;

/*
        List<int> keys = [];
        List<String> values = movieDetail.tags + movieDetail.genres;

        */

        if (paletteGenerator.darkVibrantColor != null) {
          pageColor = paletteGenerator.darkVibrantColor.color;
        } else {
          pageColor = Color(0xff35374c);
        }
        if (isFavorData != null) {
          initialfavor = true;
          isFavor = true;
          recommendMovie2();
          isDisplay = true;
        }
        if (isMovieRatedData != null) {
          isMovieRated = true;
          rate1 = double.parse(isMovieRatedData["rating"]);
        }

/*
        tagTotal = movieDetail.tags.length + movieDetail.genres.length;
        for (int i = 0; i < tagTotal; i++) {
          keys.add(i);
        }
        tag2Num = Map.fromIterables(keys, values); //根据list所提供的key value来创建map；
        Random random = new Random();

        // generate a random index based on the list length
        // and use it to retrieve the element

        while (true) {
          tagKey.add(random.nextInt(tagTotal));
          if (tagKey.length == 3 || tagKey.length == tagTotal) {
            break;
          }
        }

*/

        // pageColor =paletteGenerator.dominantColor?.color;
      });
      // if(isFavor == true){
      // emotionIndex();

      // if(isFavor == true){
      // if(similarWord[0] =="null"){
      //   recommendMovie();
      // }
      // else{
      //   Random random = new Random();
      //   int cnt = 0;//推荐7部就行可,以免极端情况

      //   //标签的也给一点，避免极端情况
      //   for(int i=0;i<(tagTotal*(1/3)).toInt();i++){
      //     var recommendData =await client.getSearchListByTag(tag:tag2Num[i],start:random.nextInt(5),count:2);
      //       List<MovieItem> newMovies = getMovieList(recommendData);
      //       newMovies.forEach((movie) {
      //         if(movie.rating.average>6.0){//只推荐6.0以上的，6.0以下的都不用想，肯定是烂片
      //           recommendMovies.add(movie);
      //         }
      //       });
      //   }

      //   for(int i=0;i<similarWord.length;i++){
      //     int choice = random.nextInt(30);
      //     var recommendData =await client.getSearchListByName(name:similarWord[choice], start:0, count:1);
      //     // var recommendData =await client.getSearchListByTag(tag:similarWord[choice],start:0,count:1);
      //     if(recommendData!=null){
      //       List<MovieItem> newMovies = getMovieList(recommendData);
      //       newMovies.forEach((movie) {
      //         if(movie.averageRating!=null&&int.parse(movie.averageRating)>6.0){//只推荐6.0以上的，6.0以下的都不用想，肯定是烂片
      //           recommendMovies.add(movie);
      //           cnt++;
      //         }
      //       });
      //     }
      //     else if(recommendData==null){
      //       var recommendData =await client.getSearchListByTag(tag:similarWord[choice],start:0,count:1);
      //       if(recommendData!=null){
      //         List<MovieItem> newMovies = getMovieList(recommendData);
      //         newMovies.forEach((movie) {
      //           if(movie.averageRating!=null&&int.parse(movie.averageRating)>6.0){//只推荐6.0以上的，6.0以下的都不用想，肯定是烂片
      //             recommendMovies.add(movie);
      //             cnt++;
      //           }
      //         });
      //       }
      //     }
      //     if(cnt==7){
      //       break;
      //     }
      //     if(i>16&&cnt<7){//如果检索了16个tag还没有7部，就stop
      //       break;
      //     }
      //     sleep(const Duration(seconds: 1));
      //   }

      //   //debugPrint("总共有"+recommendMovies.length.toString()+"部推荐");

      //   //剔除跟该电影重复的推荐电影
      //   for(int i=0;i<recommendMovies.length;i++){
      //     if(recommendMovies[i].id==movieDetail.id){
      //       recommendMovies.removeAt(i);
      //       i--;
      //     }
      //     if(i==recommendMovies.length-1){
      //       break;//防止越界
      //     }
      //     for(int j=i+1;j<recommendMovies.length;j++){
      //       if(j==recommendMovies.length){
      //         break;
      //       }
      //       if(recommendMovies[i].id==recommendMovies[j].id){
      //         recommendMovies.removeAt(j);
      //         i--;
      //         break;
      //       }
      //     }
      //   }
      //   //debugPrint("总共有"+recommendMovies.length.toString()+"部推荐");
      // }
      // }
      // recommendMovie();
      //  }
    }
  }
}

List<MovieItem> getMovieList(var list) {
  List content = list;
  List<MovieItem> movies = [];
  content.forEach((data) {
    MovieItem movie = new MovieItem(
      title: data['title'],
      id: data['id'],
      images: MovieImage(small: data['img'] ?? data['cover']),
      averageRating: data["rate"].toString(),
    );
    // //debugPrint(actor.avatars.small.toString());
    movies.add(movie);
    // movies.add(MovieItem.fromJson(data));
  });
  return movies;
}
