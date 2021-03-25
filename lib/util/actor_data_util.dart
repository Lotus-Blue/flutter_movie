import 'package:movie_recommend/public.dart';

class ActorDataUtil {
  static List<MovieActorDetail> getActorList(var list) {
    List content = list;
    List<MovieActorDetail> actors = [];
    content.forEach((data) {
      actors.add(MovieActorDetail.fromJson(data));
    });
    return actors;
  }
}
