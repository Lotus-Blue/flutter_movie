import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:movie_recommend/public.dart';

//导入评分插件
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:fluttertoast/fluttertoast.dart';

class MovieListItem extends StatefulWidget {
  final MovieItem movie;
  final String actionStr;

  const MovieListItem(this.movie, this.actionStr);

  @override
  _MovieListItemState createState() => _MovieListItemState(movie, actionStr);
}

class _MovieListItemState extends State<MovieListItem> {
  final MovieItem movie;
  final String actionStr;

  double rate1 = 0;
  bool isMovieRated = false;

  _MovieListItemState(this.movie, this.actionStr);

  Widget _getActionWidget(BuildContext context) {
    Widget action;

    String pubdate = movie.mainlandPubdate;
    if (pubdate != '') {
      pubdate = movie.mainlandPubdate.split('-')[1] +
          '月\n' +
          movie.mainlandPubdate.split('-')[2] +
          '日';
    } else {
      pubdate = '待定';
    }
    switch (actionStr) {
      case 'coming_soon':
        action = Container(
          padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 0.5),
              borderRadius: BorderRadius.circular(2.0)),
          child: Text(
            pubdate,
            style: TextStyle(color: Colors.red, fontSize: 12.0),
          ),
        );
        break;
      default:
        action = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.favorite_border),
              color: Color(0xFFF7AC3A),
              onPressed: () {},
            ),
            Text('收藏', style: TextStyle(color: Color(0xFFF7AC3A)))
          ],
        );
        // action = Container();
        break;
    }
    return action;
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    double imgWidth = 100;
    double height = imgWidth / 0.7;
    double spaceWidth = 15;
    double actionWidth = 60;
    Widget action = _getActionWidget(context);

    return GestureDetector(
      onTap: () {
        AppNavigator.pushMovieDetail(context, movie.id);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(spaceWidth, spaceWidth, 0, spaceWidth),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: AppColor.lightGrey, width: 0.5)),
            color: AppColor.white),
        child: Row(
          children: <Widget>[
            MovieCoverImage(
              movie.images.small,
              width: imgWidth,
              height: height,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(spaceWidth, 0, spaceWidth, 0),
              height: height,
              width: actionStr == "coming_soon"
                  ? Screen.width - imgWidth - spaceWidth * 2 - actionWidth
                  : Screen.width - imgWidth - spaceWidth * 2,
              // width: Screen.width - imgWidth - spaceWidth * 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    movie.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new StaticRatingBar(
                        size: 13.0,
                        rate: movie.rating.average / 2,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        movie.rating.average.toString(),
                        style: TextStyle(color: AppColor.grey, fontSize: 12.0),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${movie.year} /${genres2String(movie.genres)}/${actor2String(movie.directors)}/${actor2String(movie.casts)}',
                    style: TextStyle(color: AppColor.grey, fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  actionStr != "coming_soon"
                      ? Row(
                          children: <Widget>[
                            Text(
                              "评价:",
                              style: TextStyle(
                                color: AppColor.darkGrey,
                                fontSize: fixedFontSize(15),
                              ),
                            ),
                            RatingBar(
                              itemSize: 23,
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
                                      color: AppColor.darkGrey,
                                      fontSize: fixedFontSize(15),
                                    ),
                                  ),
                          ],
                        )
                      : Container(),
                ],
              ),
            ),
            actionStr == "coming_soon"
                ? Container(
                    width: actionWidth,
                    height: height,
                    child: Center(child: action),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  //对电影评分
  rateMovie() async {
    MorecApi api = new MorecApi();
    var data = await api.rateMovie(movie.id.toString(), rate1.toString());
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

  Future<void> fetchData() async {
    MorecApi api = new MorecApi();
    var isMovieRatedData = await api.isMovieRated(movie.id);
    if (this.mounted) {
      setState(() {
        if (isMovieRatedData != null) {
          isMovieRated = true;
          rate1 = double.parse(isMovieRatedData["rating"]);
        }
      });
    }
  }

  String actor2String(List<MovieActor> actors) {
    StringBuffer sb = new StringBuffer();
    actors.forEach((actor) {
      sb.write(' ${actor.name} ');
    });
    return sb.toString();
  }

  String genres2String(List genres) {
    StringBuffer sb = new StringBuffer();
    genres.forEach((genre) {
      sb.write(' $genre ');
    });
    return sb.toString();
  }
}

// class MovieListItem extends StatelessWidget {
//   final MovieItem movie;
//   final String actionStr;

//   const MovieListItem(this.movie, this.actionStr);

//   Widget _getActionWidget(BuildContext context) {
//     Widget action;

//     String pubdate = movie.mainlandPubdate;
//     if (pubdate != '') {
//       pubdate = movie.mainlandPubdate.split('-')[1] +
//           '月\n' +
//           movie.mainlandPubdate.split('-')[2] +
//           '日';
//     } else {
//       pubdate = '待定';
//     }
//     switch (actionStr) {
//       case 'coming_soon':
//         action = Container(
//           padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
//           decoration: BoxDecoration(
//               border: Border.all(color: Colors.red, width: 0.5),
//               borderRadius: BorderRadius.circular(2.0)),
//           child: Text(
//             pubdate,
//             style: TextStyle(color: Colors.red, fontSize: 12.0),
//           ),
//         );
//         break;
//       default:
//         action = Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             IconButton(
//               icon: Icon(Icons.favorite_border),
//               color: Color(0xFFF7AC3A),
//               onPressed: () {},
//             ),
//             Text('收藏', style: TextStyle(color: Color(0xFFF7AC3A)))
//           ],
//         );
//           // action = Container();
//         break;
//     }
//     return action;
//   }

//   @override
//   Widget build(BuildContext context) {
//     double imgWidth = 100;
//     double height = imgWidth / 0.7;
//     double spaceWidth = 15;
//     double actionWidth = 60;
//     Widget action = _getActionWidget(context);

//     return GestureDetector(
//       onTap: () {
//         AppNavigator.pushMovieDetail(context, movie.id);
//       },
//       child: Container(
//         padding: EdgeInsets.fromLTRB(spaceWidth, spaceWidth, 0, spaceWidth),
//         decoration: BoxDecoration(
//             border: Border(
//                 bottom: BorderSide(color: AppColor.lightGrey, width: 0.5)),
//             color: AppColor.white),
//         child: Row(
//           children: <Widget>[
//             MovieCoverImage(
//               movie.images.small,
//               width: imgWidth,
//               height: height,
//             ),
//             Container(
//               padding: EdgeInsets.fromLTRB(spaceWidth, 0, spaceWidth, 0),
//               height: height,
//               width: Screen.width - imgWidth - spaceWidth * 2 - actionWidth,
//               // width: Screen.width - imgWidth - spaceWidth * 2,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Text(
//                     movie.title,
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 20,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       new StaticRatingBar(
//                         size: 13.0,
//                         rate: movie.rating.average / 2,
//                       ),
//                       SizedBox(
//                         width: 5,
//                       ),
//                       Text(
//                         movie.rating.average.toString(),
//                         style: TextStyle(color: AppColor.grey, fontSize: 12.0),
//                       )
//                     ],
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Text(
//                     '${movie.year} /${genres2String(movie.genres)}/${actor2String(movie.directors)}/${actor2String(movie.casts)}',
//                     style: TextStyle(color: AppColor.grey, fontSize: 14),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   Row(
//                     children: <Widget>[
//                                         Text(
//                     "评价:",
//                     style: TextStyle(
//                     color: AppColor.darkGrey,
//                     fontSize: fixedFontSize(15),
//                   ),
//                   ),
//                                               RatingBar(
//                               itemSize: 23,
//                               initialRating: 3,
//                               direction: Axis.horizontal,
//                               allowHalfRating: false, //只允许整数评分
//                               itemCount: 5,
//                               itemPadding:
//                                   EdgeInsets.symmetric(horizontal: 0.2),
//                               itemBuilder: (context, _) => Icon(
//                                     Icons.star,
//                                     size: 13,
//                                     color: new Color(0xffFF962E),
//                                   ),
//                               onRatingUpdate: (rating) {
//                                 // print(rating);
//                                 // setState(() {
//                                 //   this.rate1 = rating;
//                                 //   isMovieRated = true;
//                                 //   rateMovie();
//                                 // });
//                               },
//                             ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               width: actionWidth,
//               height: height,
//               child: Center(child: action),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   String actor2String(List<MovieActor> actors) {
//     StringBuffer sb = new StringBuffer();
//     actors.forEach((actor) {
//       sb.write(' ${actor.name} ');
//     });
//     return sb.toString();
//   }

//   String genres2String(List genres) {
//     StringBuffer sb = new StringBuffer();
//     genres.forEach((genre) {
//       sb.write(' $genre ');
//     });
//     return sb.toString();
//   }
// }
