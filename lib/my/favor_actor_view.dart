import 'package:flutter/material.dart';

import 'package:movie_recommend/public.dart';

// import 'cover_image_view.dart';

class FavorActorView extends StatelessWidget {
  final List<MovieActor> actors;

  FavorActorView(this.actors);

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

    return actors != null
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
              return FavorActorCoverView(actors[index]);
            },
            itemCount: actors.length,
            // ),
            // )
          )
        : Container();
  }
}

class FavorActorCoverView extends StatelessWidget {
  final MovieActor actor;

  FavorActorCoverView(this.actor);

  @override
  Widget build(BuildContext context) {
    // // 单个电影的宽度
    // // 一行放置 2 个 演员头像
    // var width = Screen.width / 2;

    // return GestureDetector(
    //   onTap: () {
    //     AppNavigator.pushActorDetail(context, actor);
    //   },
    //   child: Container(
    //     width: width,
    //     child: Stack(
    //       alignment: Alignment.bottomCenter,
    //       children: <Widget>[
    //         CoverImageView(actor.avatars.small, width: width, height: width / 0.75,),
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
    //                 actor.name, style: TextStyle(color: AppColor.white, fontSize: 16,),
    //                 overflow: TextOverflow.ellipsis,),
    //             ),
    //           ),
    //         )
    //         // SizedBox(height: 5,),
    //         // Text(
    //         //   actor.name,
    //         //   overflow: TextOverflow.ellipsis,
    //         //   style: TextStyle(fontSize: 14, color: Color(0xff5b5b5b)),
    //         //   maxLines: 1,
    //         // ),
    //       ],
    //     ),
    //   ),
    // );
    double imgWidth = 100;
    double height = imgWidth / 0.7;
    double spaceWidth = 15;
    // double actionWidth = 60;
    return GestureDetector(
      onTap: () {
        AppNavigator.pushActorDetail(context, actor);
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
              actor.avatars.small,
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
                    actor.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                        actor.enName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '代表作：${actor.works}',
                    style: TextStyle(color: AppColor.grey, fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${actor.collectionTime}    收藏该演员',
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
