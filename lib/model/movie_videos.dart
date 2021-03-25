/// 电影videos链接

class MovieVideos {
  String link;

  MovieVideos(this.link);

  MovieVideos.fromJson(Map data) {
    link = data['sample_link'];
  }
}
