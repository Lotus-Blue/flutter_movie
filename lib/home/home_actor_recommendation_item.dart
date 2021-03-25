import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:movie_recommend/public.dart';

import 'package:movie_recommend/movie/actor_detail/actor_detail_view.dart';

class ActorRecommendationItemView extends StatefulWidget {
  final String doubanId;
  final String description;

  const ActorRecommendationItemView({Key key, this.doubanId, this.description})
      : super(key: key);
  @override
  _ActorRecommendationItemViewState createState() =>
      _ActorRecommendationItemViewState();
}

class _ActorRecommendationItemViewState
    extends State<ActorRecommendationItemView> {
  MovieActorDetail actor;

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
    if (actor == null) {
      return Container();
    }
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (BuildContext context) => ActorDetailView(id: actor.id),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(spaceWidth, spaceWidth, 0, spaceWidth),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: AppColor.lightGrey, width: 0.5)),
            color: AppColor.white),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            MovieCoverImage(
              actor.avatars.small,
              width: imgWidth,
              height: height,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(spaceWidth, 0, spaceWidth, 0),
              width: Screen.width - imgWidth - spaceWidth * 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    actor.name,
                    style: TextStyle(
                        fontSize: fixedFontSize(20),
                        // color: AppColor.white,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '${actor.enName} （${actor.birthday} ${actor.bornPlace})',
                    style: TextStyle(
                      fontSize: fixedFontSize(16),
                      // color: AppColor.white,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '代表作: ' + worksList2String(actor.works),
                    style: TextStyle(
                        // color: AppColor.white,
                        fontSize: fixedFontSize(14)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      padding: EdgeInsets.all(10),
                      width: Screen.width - imgWidth - spaceWidth * 4,
                      color: Color(0xfff2f2f2),
                      child: Text(this.widget.description,
                          style:
                              TextStyle(color: AppColor.grey, fontSize: 14))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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

  Future<void> fetchData() async {
    ApiClient client = new ApiClient();
    MovieActorDetail data = MovieActorDetail.fromJson(
        await client.getActorDetail(this.widget.doubanId));

    if (this.mounted) {
      setState(() {
        actor = data;
      });
    }
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

  String professionList2String(List professions) {
    var a = ' 演员 ';
    var len = professions.length;
    for (var i = 0; i < len; i++) {
      a += professions[i] + ' ';
    }
    return a;
  }

  String worksList2String(List<MovieActorWork> works) {
    var a = '';
    var len = works.length;
    for (var i = 0; i < len; i++) {
      if (i != (len - 1))
        a += works[i].movie.title + ' / ';
      else
        a += works[i].movie.title;
    }
    return a;
  }
}
