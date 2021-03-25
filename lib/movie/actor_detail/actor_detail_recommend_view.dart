//及时向用户推荐相关演员

import 'package:flutter/material.dart';

import 'package:movie_recommend/public.dart';

import 'package:movie_recommend/movie/actor_detail/actor_detail_view.dart';

class ActorDetailRecommendView extends StatelessWidget {
  final List<MovieActor> actors;

  const ActorDetailRecommendView(this.actors);

  @override
  Widget build(BuildContext context) {
    // List<MovieDetail> movies = [];
    // movies.forEach((movie) {
    //   movies.add(movie);
    // });

    return actors.length > 0
        ? Container(
            // padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text('推荐演员 (${actors.length}名)',
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
                    itemCount: actors.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildMovieActorView(context, index, actors);
                    },
                  ),
                )
              ],
            ),
          )
        : Container();
  }

  _buildMovieActorView(
      BuildContext context, int index, List<MovieActor> actors) {
    MovieActor actor = actors[index];
    double paddingRight = 0.0;
    if (index == actors.length - 1) {
      paddingRight = 15.0;
    }
    return Container(
      margin: EdgeInsets.only(left: 15, right: paddingRight),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              if (actor.id == null) {
                Toast.show('暂无该演员信息');
              } else {
                AppNavigator.push(context, ActorDetailView(id: actor.id));
              }
            },
            child:
                MovieCoverImage(actor.avatars.small, width: 100, height: 133),
          ),
          SizedBox(
            height: 8.0,
          ),
          Container(
            width: 80,
            child: Center(
              child: Text(
                actor.name,
                style: TextStyle(
                    fontSize: fixedFontSize(14), color: AppColor.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
