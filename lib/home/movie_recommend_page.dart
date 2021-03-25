import 'package:flutter/material.dart';
import 'home_movie_recommendation.dart';
import 'home_actor_recommendation.dart';

class MovieRecommendPageView extends StatefulWidget {
  @override
  _MovieRecommendPageViewState createState() => _MovieRecommendPageViewState();
}

class _MovieRecommendPageViewState extends State<MovieRecommendPageView> {
  @override
  Widget build(BuildContext context) {
    return PageView(
      children: <Widget>[
        MovieRecommendationView(
          title: '猜你喜欢',
        ),
        ActorRecommendationView(
          title: '猜你喜欢',
        ),
      ],
    );
  }
}
