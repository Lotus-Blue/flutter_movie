import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:movie_recommend/public.dart';

import 'actor_detail/actor_detail_view.dart';

class MovieActorListItem extends StatelessWidget {
  final MovieActorDetail actor;
  final String actionStr;

  const MovieActorListItem(this.actor, this.actionStr);

  @override
  Widget build(BuildContext context) {
    double imgWidth = 100;
    double height = imgWidth / 0.65;
    double spaceWidth = 15;
    double actionWidth = 0;

    return GestureDetector(
      onTap: () {
        AppNavigator.push(context, ActorDetailView(id: actor.id));
        // AppNavigator.pushActorDetail(context, actor);
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
              width: Screen.width - imgWidth - spaceWidth * 2 - actionWidth,
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
                    height: 5,
                  ),
                  Text(
                    '职业:' + professionList2String(actor.professions),
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
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // SizedBox(
            //   height: 5,
            // ),
            // Text(
            //   '${actor.enName} （${actor.birthday} ${actor.bornPlace})',
            //   style: TextStyle(
            //     fontSize: fixedFontSize(16),
            //     color: AppColor.white,
            //     fontWeight: FontWeight.bold,
            //   ),
            //   maxLines: 1,
            //   overflow: TextOverflow.ellipsis,
            // ),
            // SizedBox(height: 5,),
            // Text('出生地:'+'${actorDetail.bornPlace}',
            //   style: TextStyle(
            //     fontSize: fixedFontSize(16),
            //     color: AppColor.white,
            //     fontWeight: FontWeight.bold,
            //   ),
            //     maxLines: 1,
            //     overflow: TextOverflow.ellipsis,
            // ),
            SizedBox(
              height: 5,
            ),
            // Text(
            //   '职业:' + professionList2String(actor.professions),
            //   style: TextStyle(
            //     fontSize: fixedFontSize(16),
            //     color: AppColor.white,
            //     fontWeight: FontWeight.bold,
            //   ),
            //   maxLines: 1,
            //   overflow: TextOverflow.ellipsis,
            // ),
            SizedBox(
              height: 10,
            ),
            // Text(
            //   '代表作: ' + worksList2String(actor.works),
            //   style:
            //       TextStyle(color: AppColor.white, fontSize: fixedFontSize(14)),
            //   maxLines: 3,
            //   overflow: TextOverflow.ellipsis,
            // ),
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
