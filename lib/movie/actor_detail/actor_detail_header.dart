import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:ui' as ui;

import 'package:movie_recommend/public.dart';

class ActorDetailHeader extends StatelessWidget {
  final MovieActorDetail actorDetail;
  final Color coverColor;

  const ActorDetailHeader(this.actorDetail, this.coverColor);

  @override
  Widget build(BuildContext context) {
    var width = Screen.width;
    var height = 218.0 + Screen.topSafeHeight;

    return Container(
      width: width,
      height: height,
      child: Stack(
        children: <Widget>[
          Image(
            image: CachedNetworkImageProvider(actorDetail.photos.length == 0
                ? actorDetail.avatars.large
                : actorDetail.photos[0].image),
            fit: BoxFit.cover,
            width: width,
            height: height,
          ),
          Opacity(
            opacity: 0.7,
            child: Container(color: coverColor, width: width, height: height),
          ),
          buildContent(context),
          // BackdropFilter(
          //   filter: ui.ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
          //   child: Container(
          //       width: width,
          //       height: height,
          //       padding:
          //           EdgeInsets.fromLTRB(30, 54 + Screen.topSafeHeight, 10, 20),
          //       color: Colors.transparent,
          //       child: Column(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         crossAxisAlignment: CrossAxisAlignment.center,
          //         children: <Widget>[
          //           CircleAvatar(
          //             backgroundImage: CachedNetworkImageProvider(actorDetail.avatars.large),
          //             radius: 50.0,
          //           ),
          //           SizedBox(height: 10,),
          //           Text(actorDetail.name, style:TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColor.white, ))
          //         ],
          //       )),
          // ),
        ],
      ),
    );
  }

  Widget buildContent(BuildContext context) {
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
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: MovieCoverImage(actorDetail.avatars.large,
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
                            actorDetail.name,
                            style: TextStyle(
                                fontSize: fixedFontSize(20),
                                color: AppColor.white,
                                fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      '${actorDetail.enName} （${actorDetail.birthday} ${actorDetail.bornPlace})',
                      style: TextStyle(
                        fontSize: fixedFontSize(16),
                        color: AppColor.white,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
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
                    Text(
                      '职业:' + professionList2String(actorDetail.professions),
                      style: TextStyle(
                        fontSize: fixedFontSize(16),
                        color: AppColor.white,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '代表作: ' + worksList2String(actorDetail.works),
                      style: TextStyle(
                          color: AppColor.white, fontSize: fixedFontSize(14)),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
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
