/// 电影评分
// import 'score_datail.dart';

class MovieRate {
  double max;
  double average;
  String stars;
  Map details;
  double min;

  MovieRate(this.max, this.average, this.stars, this.details, this.min);

  MovieRate.fromJson(Map data) {
    average = data['average']?.toDouble();
    max = data['max'].toDouble();
    stars = data['stars'];
    details = data['details'];
    min = data['min'].toDouble();
  }
}
