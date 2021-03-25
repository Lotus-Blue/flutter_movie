import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:movie_recommend/model/movie_item.dart';
import 'home_movie_cover_view.dart';

import 'package:movie_recommend/public.dart';
import '../home/home_section_view.dart';

class MovieClassiyItem extends StatelessWidget {
  final String tag;
  final List<MovieItem> movies;

  MovieClassiyItem(this.tag, this.movies);

  @override
  Widget build(BuildContext context) {
    var children = movies.map((movie) => HomeMovieCoverView(movie)).toList();
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          HomeSectionView(tag, 'search'),
          Container(
            padding: EdgeInsets.fromLTRB(15, 10, 0, 10),
            child: Wrap(
              spacing: 15,
              runSpacing: 20,
              children: children,
            ),
          ),
          Container(
            height: 10,
            color: Color(0xFFF5F5F5),
          )
        ],
      ),
    );
  }
}
/*
            Container(
              padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: Row(
                children: <Widget>[
                  Text(tag, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                  Icon(CupertinoIcons.forward, size: 16,),
                ],
              ),
            )
          ),
          Wrap(spacing: 15, runSpacing: 20, children: children,),
        ],
      ),
    );*/

//   }

// }
