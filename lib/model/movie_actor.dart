import 'package:flutter/cupertino.dart';
import 'package:movie_recommend/model/movie_image.dart';

/// 演员
class MovieActor {
  String alt;
  MovieImage avatars;
  String name;
  String id;

  //方便从数据库接收数据
  String enName;
  String professions;
  String works;
  String collectionTime;

  MovieActor(
      {this.id,
      this.alt,
      this.avatars,
      this.name,
      this.enName,
      this.professions,
      this.works,
      this.collectionTime});

  MovieActor.fromJson(Map data) {
    String avatarPlaceholder =
        'http://img3.doubanio.com/f/movie/ca527386eb8c4e325611e22dfcb04cc116d6b423/pics/movie/celebrity-default-small.png';
    id = data['id'];
    alt = data['alt'];

    enName = data["enName"];
    professions = data["professions"];
    works = data["works"];
    debugPrint(works);
    collectionTime = data["collectionTime"];

    if (data['avatars'] == null) {
      avatars = new MovieImage(
          small: avatarPlaceholder,
          medium: avatarPlaceholder,
          large: avatarPlaceholder);
    } else {
      avatars = MovieImage.fromJson(data['avatars']);
    }
    name = data['name'];
  }
}
