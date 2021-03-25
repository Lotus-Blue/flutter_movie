import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:movie_recommend/public.dart';
import '../../app/detail_score.dart';
import '../../app/app_navigator.dart';
// import '../../widget/webview_page.dart';
// import '../test.dart';
import 'package:flutter/services.dart';

// import '../test.dart';

class MovieDetailHeader extends StatelessWidget {
  final MovieDetail movieDetail;
  final Color coverColor;
  final String vipVideoUrl;

  const MovieDetailHeader(this.movieDetail, this.coverColor, this.vipVideoUrl);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    //把状态栏显示出来,虚拟按键不让它出来，不美观
    var width = Screen.width;
    var height = 218.0 + Screen.topSafeHeight;

    return Container(
      width: width,
      height: height + 80,
      child: Stack(
        children: <Widget>[
          Image(
            image: CachedNetworkImageProvider(movieDetail.photos[0].image),
            fit: BoxFit.cover,
            width: width,
            height: height,
          ),
          Opacity(
            opacity: 0.7,
            child: Container(color: coverColor, width: width, height: height),
          ),
          buildContent(context),
        ],
      ),
    );
  }

  Widget buildContent(BuildContext context) {
    // var a=movieDetail.rating.details["1"];
    // debugPrint("hi"+a.toString());
    var allcount = movieDetail.rating.details["1"] +
        movieDetail.rating.details["2"] +
        movieDetail.rating.details["3"] +
        movieDetail.rating.details["4"] +
        movieDetail.rating.details["5"];
    var width = Screen.width;
    var height = 218.0 + Screen.topSafeHeight;
    return Container(
        width: width,
        height: height + 80,
        padding: EdgeInsets.fromLTRB(15, 54 + Screen.topSafeHeight, 10, 0),
        color: Colors.transparent,
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      new BoxShadow(
                          color: Color(0x66000000),
                          offset: new Offset(1.0, 1.0),
                          blurRadius: 5.0,
                          spreadRadius: 2)
                    ],
                  ),
                  child: MovieCoverImage(movieDetail.images.large,
                      width: 100, height: 133),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          child: Row(
                        children: <Widget>[
                          Text(
                            movieDetail.title,
                            style: TextStyle(
                                fontSize: fixedFontSize(20),
                                color: AppColor.white,
                                fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          GestureDetector(
                              child: Icon(
                                Icons.play_arrow,
                                color: AppColor.white,
                                ),
                              onTap: () {
                                debugPrint(movieDetail.videos[0].link);
                                // HomePage();
                                // AppNavigator.push(context, MovieVideoPlay(url:'http://120.27.155.106/cfee/vod.php?url=http://v.qq.com/x/cover/7casb7nes159mrl.html?ptag=douban.movie'));
                                // AppNavigator.push(context,MyApp());
                                // AppNavigator.push(context, HomePage());
                                AppNavigator.pushWebVideo(
                                    context,
                                    vipVideoUrl + movieDetail.videos[0].link,
                                    movieDetail.title,
                                    'play');
                                //   AppNavigator.pushVideoPage(
                                //     context,
                                //     'https://jiexi.bm6ig.cn/?url=' +
                                //             movieDetail.videos[0].link,
                                //     );
                              }),
                        ],
                      )),
                      // Text(movieDetail.title,
                      //   style: TextStyle(
                      //     fontSize: fixedFontSize(20),
                      //     color: AppColor.white,
                      //     fontWeight: FontWeight.bold),
                      //   maxLines: 1,
                      //   overflow: TextOverflow.ellipsis,
                      // ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        movieDetail.originalTitle + '（${movieDetail.year}）',
                        style: TextStyle(
                            fontSize: fixedFontSize(16),
                            color: AppColor.white,
                            fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new StaticRatingBar(
                            size: 13.0,
                            rate: movieDetail.rating.average / 2,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            movieDetail.rating.average.toString(),
                            style: TextStyle(
                                color: AppColor.white,
                                fontSize: fixedFontSize(12)),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '${countries2String(movieDetail.countries)}/${list2String(movieDetail.genres)}/ 上映时间：${list2String(movieDetail.pubdates)}/ 片长：${list2String(movieDetail.durations)}/${actor2String(movieDetail.directors)}/${actor2String(movieDetail.casts)}',
                        style: TextStyle(
                            color: AppColor.white, fontSize: fixedFontSize(12)),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
              ],
            ),
            // SizedBox(height: 15,),
            ScoreStartWidget(
              score: movieDetail.rating.average,
              p1: movieDetail.rating.details["1"] / allcount,
              p2: movieDetail.rating.details["2"] / allcount,
              p3: movieDetail.rating.details["3"] / allcount,
              p4: movieDetail.rating.details["4"] / allcount,
              p5: movieDetail.rating.details["5"] / allcount,
              // p1:0.0,
              // p2:0.1,
              // p3:0.2,
              // p4:0.5,
              // p5:0.3,
            ),
          ],
        ));
  }

  String actor2String(List<MovieActor> actors) {
    StringBuffer sb = new StringBuffer();
    actors.forEach((actor) {
      sb.write(' ${actor.name} ');
    });
    return sb.toString();
  }

  String list2String(List list) {
    StringBuffer sb = new StringBuffer();
    list.forEach((item) {
      sb.write(' $item ');
    });
    return sb.toString();
  }

  String countries2String(List countries) {
    StringBuffer sb = new StringBuffer();
    countries.forEach((country) {
      sb.write('$country ');
    });
    return sb.toString();
  }
}
