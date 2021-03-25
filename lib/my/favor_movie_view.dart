import 'package:flutter/material.dart';

import 'package:movie_recommend/public.dart';

// import 'cover_image_view.dart';
// import '../movie/movie_list_item.dart';
import 'package:flutter/cupertino.dart';

class FavorMovieView extends StatelessWidget {
  final List<MovieItem> movies;

  FavorMovieView(this.movies);

  @override
  Widget build(BuildContext context) {
    // return Container(
    //     child: ListView.builder(
    //       itemCount: this.movies.length,
    //       itemBuilder: (BuildContext context, int index) {
    //         if (index+1 == movies.length) {
    //           return Container(
    //             padding: EdgeInsets.all(10),
    //             child: Center(
    //               child: Offstage(
    //                 // offstage: _loaded,
    //                 child: CupertinoActivityIndicator(),
    //               ),
    //             ),
    //           );
    //         }
    //         return  MovieListItem(movies[index], '');
    //       },
    //       // controller: _scrollController,
    //     ),
    //   );

    return movies != null
        ? ListView.builder(
            // color: Colors.white,
            // child: Scrollbar(
            // child: Row(
            // addAutomaticKeepAlives: true,
            // itemCount: movies.length,
            // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //   crossAxisCount: 3,
            //   childAspectRatio: 3/4,
            // ),
            itemBuilder: (BuildContext context, int index) {
              return FavorMovieCoverView(movies[index]);
            },
            itemCount: movies.length,
            // ),
            // )
          )
        : Container();
  }
}

class FavorMovieCoverView extends StatelessWidget {
  final MovieItem movie;

  FavorMovieCoverView(this.movie);

  @override
  Widget build(BuildContext context) {
    // // 单个电影的宽度
    // // 一行放置 3 个 电影
    // var width = Screen.width/3;

    // return GestureDetector(
    //   onTap: () {
    //     AppNavigator.pushMovieDetail(context, movie.id);
    //   },
    //   child: Container(
    //     width: width,
    //     child: Stack(
    //       alignment: Alignment.bottomCenter,
    //       children: <Widget>[
    //         CoverImageView(movie.images.small, width: width, height: width / 0.75,),
    //         Opacity(
    //           opacity: 0.8,
    //           child: Container(
    //             decoration: BoxDecoration(
    //               color: Colors.black,
    //             ),
    //             height: 40,
    //             width: width,
    //             child: Center(
    //               child: Text(
    //                 movie.title, style: TextStyle(color: AppColor.white, fontSize: 16,),
    //                 overflow: TextOverflow.ellipsis,),
    //             ),
    //           ),
    //         )
    //       ],
    //     ),
    //   ),
    // );
    double imgWidth = 100;
    double height = imgWidth / 0.7;
    double spaceWidth = 15;
    double actionWidth = 60;
    // Widget action = _getActionWidget(context);
    // ApiClient client = new ApiClient();
    // // MorecApi api = new MorecApi();
    // MovieDetail data;

    // Future<void> fetchData() async {
    // data =
    //     MovieDetail.fromJson(await client.getMovieDetail("12300"));
    // }
    // fetchData();

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
              // width: Screen.width - imgWidth - spaceWidth * 2 - actionWidth,
              width: Screen.width - imgWidth - spaceWidth * 2,
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
                        rate: double.parse(movie.averageRating) /
                            2, //注意是double，不是int
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        movie.averageRating,
                        style: TextStyle(color: AppColor.grey, fontSize: 12.0),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${movie.year} /${movie.genresString}/${movie.directorsString}/ ${movie.castsString}',
                    style: TextStyle(color: AppColor.grey, fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${movie.collectionTime}    收藏该电影",
                  ),
                ],
              ),
            ),
            // Container(
            //   width: actionWidth,
            //   height: height,
            //   // child: Center(child: action),
            // ),
          ],
        ),
      ),
    );
  }
}

// List<MovieItem> getMovieList(var list) {
//   List content = list;
//   List<MovieItem> movies = [];
//   content.forEach((data) {
//     movies.add(MovieItem.fromJson(data));
//   });
//   return movies;
// }
