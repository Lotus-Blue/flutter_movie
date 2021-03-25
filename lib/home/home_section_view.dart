import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:movie_recommend/app/app_navigator.dart';

// import 'package:movie_recommend/movie/movie_classify_list_view.dart';

class HomeSectionView extends StatelessWidget {
  final String title;
  final String action;

  HomeSectionView(this.title, this.action);

  var textwidth;

  @override
  Widget build(BuildContext context) {
    if (title == '即将上映' ||
        title == '影院热映' ||
        title == '中国大陆' ||
        title == '小说改编' ||
        title == '超级英雄') {
      textwidth = 80.0;
    } else if (title == '纪录片') {
      textwidth = 60.0;
    } else {
      textwidth = 40.0;
    }
    return Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(15, 15, 15, 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '$title',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: textwidth,
                  height: 2,
                  color: Colors.black,
                )
              ],
            ),
            GestureDetector(
                onTap: () {
                  // if (action == 'search') {
                  //   AppNavigator.push(context, MovieClassifyListView());
                  // } else {
                  AppNavigator.pushMovieList(context, title, action);
                  // }
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '全部',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Icon(
                      CupertinoIcons.forward,
                      size: 14,
                    ),
                  ],
                ))
          ],
        ));
  }
}
