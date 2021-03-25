import 'package:flutter/material.dart';

import 'package:movie_recommend/public.dart';

// 演员相关影视
class ActorDetailWorks extends StatelessWidget {
  final List<MovieActorWork> works;
  final String actorName;

  const ActorDetailWorks(this.works, this.actorName);

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text('影视作品 (${works.length}部)',
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
              itemCount: works.length + 1, //增加查看更多作品功能
              itemBuilder: (BuildContext context, int index) {
                return _buildWorks(context, index);
              },
            ),
          )
        ],
      ),
    );
  }

  // Widget _bulidMoreWorks(BuildContext context){
  //   double width = 90;
  //   double paddingRight = 0;
  // }

  Widget _buildWorks(BuildContext context, int index) {
    double width = 90;

    MovieActorWork work;
    if (index < works.length) {
      work = works[index];
    }
    double paddingRight = 0;
    // if (index == works.length - 1) {
    //   paddingRight = 15;
    // }
    if (index == works.length) {
      paddingRight = 15;
    }
    return GestureDetector(
      onTap: () {
        index < works.length
            ? AppNavigator.pushMovieDetail(context, work.movie.id)
            : AppNavigator.pushMovieList(
                context, actorName, 'actor_movie_search');
      },
      child: Container(
        margin: EdgeInsets.only(left: 15, right: paddingRight),
        width: width,
        child: index < works.length
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MovieCoverImage(
                    work.movie.images.small,
                    width: width,
                    height: width / 0.75,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    work.movie.title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, color: AppColor.white),
                    maxLines: 1,
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
                        rate: work.movie.rating.average / 2,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        work.movie.rating.average.toString(),
                        style: TextStyle(color: AppColor.white, fontSize: 12.0),
                      )
                    ],
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '所有作品',
                    style: TextStyle(fontSize: 15, color: AppColor.lightGrey),
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    // size:24,
                    color: AppColor.lightGrey,
                  ),
                ],
              ),
      ),
    );
  }
}
