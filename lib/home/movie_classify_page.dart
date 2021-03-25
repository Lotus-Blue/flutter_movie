import 'package:flutter/material.dart';
import 'movie_classify_view.dart';
import '../movie/movie_classify_list_view.dart';

class MovieTagPageView extends StatefulWidget {
  @override
  _MovieTagPageViewState createState() => _MovieTagPageViewState();
}

class _MovieTagPageViewState extends State<MovieTagPageView> {
  @override
  Widget build(BuildContext context) {
    return PageView(
      children: <Widget>[
        MovieClassifyView(),
        MovieClassifyListView(),
      ],
    );
  }
}
