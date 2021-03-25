//及时向用户推荐相关电影

import 'package:flutter/material.dart';

import 'package:movie_recommend/public.dart';

import 'package:movie_recommend/movie/movie_detail/movie_detail_view.dart';

class MovieDetailRecommendView extends StatelessWidget {
  final List<MovieItem> movies;

  const MovieDetailRecommendView(this.movies);

  @override
  Widget build(BuildContext context) {
    // List<MovieDetail> movies = [];
    // movies.forEach((movie) {
    //   movies.add(movie);
    // });

    return movies.length > 0
        ? Container(
            // padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text('推荐电影 (${movies.length}部)',
                      style: TextStyle(
                          fontSize: fixedFontSize(16),
                          fontWeight: FontWeight.bold,
                          color: AppColor.white)),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox.fromSize(
                  size: Size.fromHeight(180),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: movies.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildMovieView(context, index, movies);
                    },
                  ),
                )
              ],
            ),
          )
        : Container();
  }

  _buildMovieView(BuildContext context, int index, List<MovieItem> movies) {
    MovieItem movie = movies[index];
    double paddingRight = 0.0;
    if (index == movies.length - 1) {
      paddingRight = 15.0;
    }
    return Container(
      margin: EdgeInsets.only(left: 15, right: paddingRight),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              if (movie.id == null) {
                Toast.show('暂无该影片信息');
              } else {
                AppNavigator.push(context, MovieDetailView(id: movie.id));
              }
            },
            child: MovieCoverImage(movie.images.small, width: 100, height: 133),
          ),
          SizedBox(
            height: 8.0,
          ),
          Container(
            width: 80,
            child: Center(
              child: Text(
                movie.title,
                style: TextStyle(
                    fontSize: fixedFontSize(14), color: AppColor.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          SizedBox(
            height: 3,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new StaticRatingBar(
                  size: 12.0,
                  rate: double.parse(movie.averageRating) / 2,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  movie.averageRating,
                  style: TextStyle(color: AppColor.white, fontSize: 12.0),
                )
              ])
        ],
      ),
    );
  }
}
