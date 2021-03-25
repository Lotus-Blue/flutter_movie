import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/rendering.dart';
import 'dart:async';

import 'package:movie_recommend/public.dart';

import 'dart:collection'; //排序

import 'dart:math';

class MorecApi {
  // static const String baseUrl = 'http://192.168.2.168:8000/';
  static const String baseUrl = 'http://120.76.128.109:8000/';

  var dio = MorecApi.createDio();

  // 用户注册
  Future<dynamic> register(String username, String password) async {
    var registerDio = MorecApi.createRegisterDio();
    Response<Map> response;
    var data = {"username": username, "password": password};
    try {
      response = await registerDio.post('user/', data: data);
    } catch (e) {
      Toast.show('用户名存在');
      return null;
    }
    return response;
  }

  // 用户登陆
  Future<dynamic> login(String username, String password) async {
    Response<Map> response;
    try {
      response = await dio
          .post('login/', data: {'username': username, 'password': password});
    } catch (e) {
      print('账号密码错误');
      Toast.show('账号或密码错误');
      return null;
    }
    return response;
  }

  // 读取当前电影类型
  Future<dynamic> getGenreList() async {
    Response<List> response;
    try {
      response = await dio.get('genre/');
    } catch (e) {
      Toast.show('网络异常');
      return null;
    }
    return response.data;
  }

  // 用户添加电影类型
  Future<dynamic> favorGenre(String genre) async {
    Response<Map> response;
    var data = {
      'genre': genre,
    };
    try {
      response = await dio.post('user_favor_genre/', data: data);
    } catch (e) {
      Toast.show('网络异常');
      return null;
    }
    return response.data;
  }

  //用户添加电影的相似电影信息
  Future<dynamic> postRecommendMovie(
      String doubanId,
      String movieName,
      String recommendMovieId,
      String recommendMoviePhoto,
      String recommendMovieScore) async {
    Response<Map> response;
    int page = 1;
    bool isFound = false;
    while (isFound == false) {
      try {
        response = await dio.get('movie/', queryParameters: {'page': page++});
        debugPrint(response.data.toString());
        for (int i = 0; i < response.data["results"].length; i++) {
          if (response.data['results'][i]["doubanId"] == doubanId) {
            isFound = true;

            //防止加入重复的
            var dataIdSet = new Set();
            var dataPhotoSet = new Set();

            String closetMovie =
                response.data['results'][i]['closest_movie'] + recommendMovieId;
            String moviePhoto =
                response.data['results'][i]['movieImg'] + recommendMoviePhoto;

            List closetMovieId = closetMovie.split(',');
            List closetMoviePhoto = moviePhoto.split(',');

            dataIdSet.addAll(closetMovieId);
            dataPhotoSet.addAll(closetMoviePhoto);

            recommendMovieId = list2String(dataIdSet.toList());
            recommendMoviePhoto = list2String(dataPhotoSet.toList());

            var data = {
              'id': response.data['results'][i]["id"],
              'movieId': "null",
              'doubanId': doubanId,
              'movieName': movieName,
              'closest_movie': recommendMovieId,
              'movieImg': recommendMoviePhoto,
              'movieScore': recommendMovieScore,
            };
            // try {
            response = await dio.put('movie/', data: data);
            // debugPrint("-1");
            break;
            // } catch (e) {
            // debugPrint("0");
            // Toast.show('网络异常');
            // return null;
            // }
          }
        }
        if (response.data["results"].length < 10) {
          break;
        }
      } catch (e) {
        debugPrint("1");
        Toast.show('网络异常');
        return null;
      }
    }
    // for (int i = 0; i < response.data["results"].length; i++) {
    //   if (response.data['results'][i]["doubanId"] == doubanId) {
    //     isFound = true;
    //     var data = {
    //       'id': response.data['results'][i]["id"],
    //       'movieId': "null",
    //       'doubanId': doubanId,
    //       'movieName': movieName,
    //       'closest_movie': recommendMovieId,
    //       'movieImg': recommendMoviePhoto,
    //       'movieScore': recommendMovieScore,
    //     };
    //     try {
    //       response = await dio.put('movie/', data: data);
    //     } catch (e) {
    //       debugPrint(e);
    //       debugPrint("2");
    //       Toast.show('网络异常');
    //       return null;
    //     }
    //   }
    // }
    if (isFound == false) {
      //开始创建新的，后台没保存
      var data = {
        'movieId': "null",
        'doubanId': doubanId,
        'movieName': movieName,
        'closest_movie': recommendMovieId,
        'movieImg': recommendMoviePhoto,
        'movieScore': recommendMovieScore,
      };
      try {
        response = await dio.post('movie/', data: data);
      } catch (e) {
        debugPrint("3");
        Toast.show('网络异常');
        return null;
      }
    }
    return response.data;
  }

  //用户添加演员的相似演员信息
  Future<dynamic> postRecommendActor(String actorId, String actorName,
      String recommendActorId, String recommendActorPhoto) async {
    Response<Map> response;
    int page = 1;
    bool isFound = false;
    while (isFound == false) {
      try {
        response = await dio.get('actor/', queryParameters: {'page': page++});
        for (int i = 0; i < response.data["results"].length; i++) {
          if (response.data['results'][i]["actorId"] == actorId) {
            isFound = true;

            //防止加入重复的
            var dataIdSet = new Set();
            var dataPhotoSet = new Set();

            String closetActor =
                response.data['results'][i]['closest_actor'] + recommendActorId;
            String actorPhoto =
                response.data['results'][i]['actorPhoto'] + recommendActorPhoto;

            List closetActorId = closetActor.split(',');
            List closetActorPhoto = actorPhoto.split(',');

            dataIdSet.addAll(closetActorId);
            dataPhotoSet.addAll(closetActorPhoto);

            recommendActorId = list2String(dataIdSet.toList());
            recommendActorPhoto = list2String(dataPhotoSet.toList());

            // debugPrint(recommendActorId);
            // debugPrint(recommendActorPhoto);

            var data = {
              'id': response.data['results'][i]["id"],
              'name': actorName,
              'actorId': actorId,
              'closest_actor': recommendActorId.toString(),
              'actorPhoto': recommendActorPhoto.toString(),
            };
            // try {
            response = await dio.put('actor/', data: data);
            break;
            // } catch (e) {
            // debugPrint("2");
            // Toast.show('网络异常');
            // return null;
            // }
          }
        }
        if (response.data["results"].length < 10) {
          break;
        }
      } catch (e) {
        debugPrint("1");
        Toast.show('网络异常');
        return null;
      }
    }

    if (isFound == false) {
      //开始创建新的，后台没保存
      var data = {
        'name': actorName,
        'actorId': actorId,
        'closest_actor': recommendActorId,
        'actorPhoto': recommendActorPhoto,
      };
      try {
        response = await dio.post('actor/', data: data);
      } catch (e) {
        debugPrint("3");
        Toast.show('网络异常');
        return null;
      }
    }
    return response.data;
  }

  //判断是否为该电影评估过分，若有，返回数据，无返回null
  Future<dynamic> isMovieRated(String id) async {
    Response<Map> response;
    try {
      response = await dio.get('user_movie_rating/$id/');
    } catch (e) {
      return null;
    }
    return response.data;
  }

  //为电影评分
  Future<dynamic> rateMovie(String id, String score) async {
    Response<Map> response;
    try {
      response = await dio.get('user_movie_rating/$id/');
      // try{
      response = await dio.delete('user_movie_rating/$id/');
      // }
      // catch(e){
      // Toast.show('重建评分数据上传错误!');
      // return null;
      // }

    } catch (e) {}

    var data = {
      "doubanId": id,
      "rating": score,
    };
    try {
      // debugPrint(jwt);
      response = await dio.post('user_movie_rating/', data: data);
    } catch (e) {
      Toast.show('新建评分数据上传错误');
      return null;
    }

    return response.data;
  }

  // 判断当前电影是否被收藏
  Future<dynamic> isMovieFavor(String id) async {
    Response<Map> response;
    try {
      response = await dio.get('user_favor_movie/$id/');
    } catch (e) {
      // Toast.show('网络异常');
      return null;
    }
    return response.data;
  }

  // 判断当前演员是否被收藏
  Future<dynamic> isActorFavor(String id) async {
    Response<Map> response;
    try {
      response = await dio.get('user_favor_actor/$id/');
    } catch (e) {
      return null;
    }
    return response.data;
  }

  // 收藏该电影
  Future<dynamic> favorMovie(MovieDetail movie) async {
    Response<Map> response;
    var data = {
      'doubanId': movie.id,
      'title': movie.title,
      'poster': movie.images.small,
      'year': movie.year,
      'averageRating': movie.rating.average,
      'genresString': genres2String(movie.genres),
      'tagsString': genres2String(movie.tags),
      'directorsString': actor2String(movie.directors),
      'castsString': actor2String(movie.casts),
      'collectionTime': DateTime.now().year.toString() +
          '-' +
          DateTime.now().month.toString() +
          '-' +
          DateTime.now().day.toString(),
    };
    try {
      response = await dio.post('user_favor_movie/', data: data);
    } catch (e) {
      Toast.show('网络异常');
      return null;
    }
    return response.data;
  }

  // 取消收藏该电影
  Future<dynamic> cancelFavorMovie(String id) async {
    Response<Map> response;
    try {
      response = await dio.delete('user_favor_movie/$id/');
    } catch (e) {
      // Toast.show('网络异常');
      return null;
    }
    return response.data;
  }

  // 收藏该演员
  Future<dynamic> favorActor(MovieActorDetail actor) async {
    Response<Map> response;
    List<MovieActorWork> works = actor.works;
    List worksId = [];
    List worksName = [];
    works.forEach((work) {
      worksId.add(work.movie.id);
    });

    works.forEach((work) {
      worksName.add(work.movie.title);
    });

    String worksIdString = worksId
        .toString()
        .replaceAll('[', '')
        .replaceAll(']', '')
        .replaceAll(', ', ',');

    String worksNameString = worksName
        .toString()
        .replaceAll('[', '')
        .replaceAll(']', '')
        .replaceAll(', ', ' / ');

    // print(worksString);

    var data = {
      "actorId": actor.id,
      "name": actor.name,
      "avatar": actor.avatars.small,
      "worksId": worksIdString,
      "worksName": worksNameString,
      "enName": actor.enName,
      "professions": '演员 ' + '${actor.professions}',
      "collectionTime": DateTime.now().year.toString() +
          '-' +
          DateTime.now().month.toString() +
          '-' +
          DateTime.now().day.toString(),
    };
    try {
      response = await dio.post('user_favor_actor/', data: data);
    } catch (e) {
      Toast.show('网络异常');
      return null;
    }
    return response.data;
  }

  // 取消收藏该演员
  Future<dynamic> cancelFavorActor(String id) async {
    Response<Map> response;
    try {
      response = await dio.delete('user_favor_actor/$id/');
    } catch (e) {
      // Toast.show('网络异常');
      return null;
    }
    return response;
  }

  // 查询用户的收藏的演员
  Future<dynamic> getFavorActorList() async {
    Response<List> response;
    try {
      response = await dio.get('user_favor_actor/');
    } catch (e) {
      Toast.show('网络异常');
      return null;
    }
    return response.data;
  }

  // 查询用户的收藏电影
  Future<dynamic> getFavorMovieList() async {
    Response<List> response;
    try {
      response = await dio.get('user_favor_movie/');
    } catch (e) {
      Toast.show('网络异常');
      return null;
    }
    return response.data;
  }

  //判断该电影是否已经推荐过，推荐过就不用写入了
  Future<dynamic> isAddRecommendation(String movieId) async {
    Response<Map> response;
    try {
      response = await dio.get('recommendation/movie/$movieId/');
    } catch (e) {
      return null;
    }
    return response.data;
  }

  //判断该演员是否已经推荐过，推荐过就不用写入了
  Future<dynamic> isAddActorRecommendation(String actorId) async {
    Response<Map> response;
    try {
      response = await dio.get('recommendation/actor/$actorId/');
    } catch (e) {
      return null;
    }
    return response.data;
  }

  //增加电影推荐
  Future<dynamic> addRecommendation(String movieId, String description) async {
    Response<Map> response;
    var isData = await isAddRecommendation(movieId);
    if (isData == null) {
      var random = new Random();
      var data = {
        "doubanId": movieId,
        "description": description,
        "random_rank": random.nextDouble()
      };
      try {
        debugPrint(movieId);
        response = await dio.post('recommendation/movie/', data: data);
      } catch (e) {
        // debugPrint("上传出错");
        // Toast.show('上传电影推荐发生错误');
        return null;
      }
      return response.data;
    } else
      return null;
  }

  //增加演员推荐
  Future<dynamic> addActorRecommendation(
      String actorId, String description) async {
    Response<Map> response;
    var isData = await isAddActorRecommendation(actorId);
    if (isData == null) {
      var random = new Random();
      var data = {
        "actorId": actorId,
        "description": description,
        "random_rank": random.nextDouble()
      };
      try {
        // debugPrint("正品："+actorId);
        response = await dio.post('recommendation/actor/', data: data);
      } catch (e) {
        // Toast.show('上传演员推荐发生错误');
        return null;
      }
      return response.data;
    } else
      return null;
  }

  //增加电影-电影推荐movie_sim_movie
  Future<dynamic> recommendMovieTitleSimMovie(MovieDetail movie) async {
    ApiClient client = new ApiClient();

    //标题相似词
    List<dynamic> similarWord =
        await client.getSimilarWord(text: movie.title, top: 20);

    List tagsList = movie.tags;
    List genresList = movie.genres;

    String tag = tagsList[0]; //拿来与相似词搜出来的电影做相似度比较，小于0.5我们就认为这个不怎么正常
    String genre = genresList[0]; //同上

    String description = '根据你喜欢的电影「${movie.title}」推荐';

    debugPrint(similarWord.length.toString());

    //逐个进行搜索
    for (int i = 0; i < similarWord.length; i++) {
      var resultData = await client.getMovieSearchByApi2(name: similarWord[i]);
      if (resultData != "0") {
        debugPrint("id:" + resultData.toString());
        //有该影片
        var similarityData1 =
            await client.getSimilarity(srcWord: movie.title, targetWord: tag);
        var similarityData2 =
            await client.getSimilarity(srcWord: movie.title, targetWord: genre);

        //有一定关联性才加入
        if ((similarityData1 + similarityData2) > 0.8) {
          var isRecommended = await isAddRecommendation(movie.id);
          if (isRecommended == null) {
            addRecommendation(resultData, description);
          }
        }
      }
    }
  }

  //增加标签-电影推荐tag_sim_movie
  Future<dynamic> recommendMovieTagSimMovie(
      List recommendMovieId, String movieTitle) async {
    String description = '根据你喜欢的电影「$movieTitle」推荐';
    // debugPrint(recommendMovieId.toString());
    for (int i = 0; i < recommendMovieId.length; i++) {
      // debugPrint("hhh");
      var isRecommended = await isAddRecommendation(recommendMovieId[i]);
      if (isRecommended == null) {
        await addRecommendation(recommendMovieId[i], description);
      }
    }
  }

  //判断是否已经添加了贴合标签
  Future<dynamic> isWriteFavorActorGenreTag(String actorId) async {
    Response<Map> response;
    try {
      response = await dio.get('user_favor_actor/$actorId/');
      if (response.data["genresName"] == "" ||
          response.data["tagsName"] == "") {
        return null;
      }
    } catch (e) {
      return null;
    }
    return response.data;
  }

  //为演员添加最贴合标签
  Future<dynamic> writeFavorActorGenreTag(
      String actorId, String tags, String genres) async {
    var responsedData = await isWriteFavorActorGenreTag(actorId);
    if (responsedData == null) {
      Response<Map> response;
      var data = {"genresName": genres, "tagsName": tags};
      try {
        response = await dio.put('user_favor_actor/$actorId/', data: data);
        // Toast.show('计算成功');
      } catch (e) {
        Toast.show('网络异常');
        return null;
      }
      return response.data;
    }
    return null;
  }

  //为演员计算最贴合标签
  Future<dynamic> writeFavorActorGenreTagOperation(
      MovieActorDetail actor) async {
    var data = await isWriteFavorActorGenreTag(actor.id);

    if (data == null) {
      ApiClient client = new ApiClient();
      List works = actor.works;
      List worksId = [];
      works.forEach((work) {
        worksId.add(work.movie.id);
      });

      var tagCountDict = {};
      var genreCountDict = {};

      // 对上面字典排序用到的临时字典
      // var tagCount = {};
      // var genreCount = {};

      // 真正要写入的tag和genre
      // var writeTag = [];
      // var writeGenre = [];

      for (int i = 0; i < worksId.length; i++) {
        MovieDetail movie =
            MovieDetail.fromJson(await client.getMovieDetail(worksId[i]));
        List tags = movie.tags;
        List genres = movie.genres;
        // debugPrint("tags:"+tags.toString());
        // debugPrint("genres:"+genres.toString());

        int totalTagServings = 0;
        int totalGenreServings = 0;

        for (int i = 1; i <= tags.length; i++) {
          totalTagServings += i;
        }
        for (int i = 1; i <= genres.length; i++) {
          totalGenreServings += i;
        }

        //开始对tags计算
        for (int i = 0; i < tags.length; i++) {
          double resultData = await client.getSimilarity(
              srcWord: actor.name, targetWord: tags[i]);
          if (tagCountDict.containsKey(tags[i]) == false) {
            if (resultData != 0.0) {
              tagCountDict[tags[i]] =
                  ((tags.length - i) / totalTagServings) * resultData;
            } else {
              tagCountDict[tags[i]] =
                  ((tags.length - i) / totalTagServings) * (1 / 4);
            }
          } else if (resultData != 0) {
            tagCountDict[tags[i]] = tagCountDict[tags[i]] +
                ((tags.length - i) / totalTagServings) * resultData;
          } else {
            tagCountDict[tags[i]] = tagCountDict[tags[i]] +
                ((tags.length - i) / totalTagServings) *
                    (1 /
                        8); //此时没有similarity数据，真是让人头疼，取其中间吧，一般如果第一个都没，后面全没了，其实也没多大影响
          }
        }

        //开始对genres计算
        for (int i = 0; i < genres.length; i++) {
          double resultData = await client.getSimilarity(
              srcWord: actor.name, targetWord: genres[i]);
          if (genreCountDict.containsKey(genres[i]) == false) {
            if (resultData != 0) {
              genreCountDict[genres[i]] =
                  ((genres.length - i) / totalGenreServings) * resultData;
            } else {
              genreCountDict[genres[i]] =
                  ((genres.length - i) / totalGenreServings) * (1 / 2);
            }
          } else if (resultData != 0) {
            genreCountDict[genres[i]] = genreCountDict[genres[i]] +
                ((genres.length - i) / totalGenreServings) * resultData;
          } else {
            genreCountDict[genres[i]] = genreCountDict[genres[i]] +
                ((genres.length - i) / totalGenreServings) *
                    (1 /
                        2); //此时没有similarity数据，真是让人头疼，取其中间吧，一般如果第一个都没，后面全没了，其实也没多大影响
          }
        }
      }

      //对tagCountDict的value排序
      var sortedKeys = tagCountDict.keys.toList(growable: false)
        ..sort((k1, k2) => tagCountDict[k1].compareTo(tagCountDict[k2]));
      LinkedHashMap tagCount = new LinkedHashMap.fromIterable(sortedKeys,
          key: (k) => k, value: (k) => tagCountDict[k]);

      //对genreCountDict的value排序
      var sortedKeys2 = genreCountDict.keys.toList(growable: false)
        ..sort((k1, k2) => genreCountDict[k1].compareTo(genreCountDict[k2]));
      LinkedHashMap genreCount = new LinkedHashMap.fromIterable(sortedKeys2,
          key: (k) => k, value: (k) => genreCountDict[k]);

      List tagCountList = tagCount.keys.toList();
      List genreCountList = genreCount.keys.toList();

      String writeTags = "";
      String writeGenres = "";
      for (int i = 0; i < tagCountList.length; i++) {
        if (i != (tagCountList.length - 1)) {
          writeTags += tagCountList[i] + ",";
        } else {
          writeTags += tagCountList[i];
        }
      }
      for (int i = 0; i < genreCountList.length; i++) {
        if (i != (genreCountList.length - 1)) {
          writeGenres += genreCountList[i] + ",";
        } else {
          writeGenres += genreCountList[i];
        }
      }

      // String writeTags =
      //     tagCount.keys.toString().replaceAll("(", "").replaceAll(")", "");//这种办法出来的结果竟然有省略号？？？
      // String writeGenres =
      //     genreCount.keys.toString().replaceAll("(", "").replaceAll(")", "");

      // debugPrint("writeTags:"+writeTags);
      // debugPrint("writeGenres:"+writeGenres);

      var responseData =
          await writeFavorActorGenreTag(actor.id, writeTags, writeGenres);
      return responseData;
    }
    return null;
  }

  //增加演员-电影推荐actor_sim_movie
  Future<dynamic> recommendActorSimMovie(MovieActorDetail actor) async {
    ApiClient client = new ApiClient();
    var data = await isWriteFavorActorGenreTag(actor.id);
    debugPrint("1");
    if (data != null) {
      debugPrint("2");
      String actorTagsString = data["tagsName"];
      String actorGenresString = data["genresName"];
      List actorTags;
      List actorGenres;

      actorTags = actorTagsString.split(',');
      actorGenres = actorGenresString.split(',');

      String favorTags = "";
      if (actorTags[actorTags.length - 1] != actor.name) {
        favorTags = actorTags[actorTags.length - 1];
      } else {
        favorTags = actorTags[actorTags.length - 2];
      }
      String favorGenres = actorGenres[actorGenres.length - 1] +
          "," +
          actorGenres[actorGenres.length - 2];
      var recommendData = await client.getSearchListByTag(
          tag: actor.name + "," + favorTags + "," + favorGenres,
          start: 0,
          count: 20,
          action: "recommend");
      debugPrint("11" + recommendData.toString());
      List<MovieItem> newMovies = getMovieList(recommendData);
      List recommendMovieId = [];
      newMovies.forEach((movie) {
        debugPrint(movie.id);
        if (movie.averageRating != null &&
            double.parse(movie.averageRating) > 7.0) {
          //只推荐7.0以上的，7.0以下的都不用想，一般是烂片；还有不要推荐本影片进去
          recommendMovieId.add(movie.id);
        }
      });
      // String writeId = recommendMovieId.toString().replaceAll("[","").replaceAll("]","");
      String description = '根据你喜欢的演员及其作品「${actor.name}」推荐';
      for (int i = 0; i < recommendMovieId.length; i++) {
        debugPrint(recommendMovieId[i]);
        addRecommendation(recommendMovieId[i], description);
      }
    } else {
      String description = '根据你喜欢的演员「${actor.name}」推荐';
      List works = actor.works;
      List worksId = [];
      works.forEach((work) {
        worksId.add(work.movie.id);
      });
      for (int i = 0; i < 2; i++) {
        addRecommendation(worksId[i], description);
      }
    }
  }

  //从演员高分电影中做出推荐
  Future<dynamic> recommendActorTopMovie(
      MovieActorDetail actor, List recMovieId) async {
    // ApiClient client = new ApiClient();
    String description = '根据你喜欢的演员「${actor.name}」推荐';
    for (int i = 0; i < recMovieId.length; i++) {
      debugPrint("推荐Top：" + recMovieId[i]);
      await addRecommendation(recMovieId[i], description);
    }
  }

  //从演员主要作品中发掘与该演员有关的演员以及挑选sim中top演员
  Future<dynamic> recommendActorSimActor(
      MovieActorDetail actor, List recActorId, List recActorName) async {
    ApiClient client = new ApiClient();
    String description = '根据你喜欢的演员及其作品「${actor.name}」推荐';
    var data = await isWriteFavorActorGenreTag(actor.id);
    String actorTagsString = data["tagsName"];
    String actorGenresString = data["genresName"];
    List actorTags;
    List actorGenres;
    if (data != null) {
      actorTags = actorTagsString.split(',');
      actorGenres = actorGenresString.split(',');
      for (int i = (actorTags.length - 1);
          i > actorTags.length - (actorTags.length * (2 / 3)).toInt();
          i--) {
        var isHasActorData =
            await client.getCelebritySearchByApi2(name: actorTags[i]);
        if (isHasActorData != "0" && isHasActorData != actor.id) {
          await addActorRecommendation(isHasActorData, description);
        }
      }

      for (int i = 0; i < recActorId.length; i++) {
        var similarityData1 = await client.getSimilarity(
            srcWord: actorGenres[actorGenres.length - 1],
            targetWord: recActorName[i]);
        var similarityData2 = await client.getSimilarity(
            srcWord: actorTags[actorGenres.length - 1],
            targetWord: recActorName[i]);

        //有一定关联性才加入
        if ((similarityData1 + similarityData2) > 1.0) {
          var isRecommended = await isAddActorRecommendation(recActorId[i]);
          if (isRecommended == null) {
            await addActorRecommendation(recActorId[i], description);
          }
        }
      }
    }
  }

  //读取用户喜爱tag和genres
  Future<dynamic> getUserTaste(String name) async {
    Response<Map> response;
    try {
      response = await dio.get('recommendation/taste/$name/');
    } catch (e) {
      Toast.show('网络异常');
      return null;
    }
    return response.data;
  }

  //删除用户喜爱tag和genres
  Future<dynamic> deleteUserTaste(String name) async {
    Response<Map> response;
    try {
      response = await dio.delete('recommendation/taste/$name/');
    } catch (e) {
      Toast.show('网络异常');
      return null;
    }
    return response.data;
  }

  // 返回电影推荐
  Future<dynamic> getRecommendation(int page, int pageSize) async {
    Response<Map> response;
    try {
      response = await dio.get('recommendation/movie',
          queryParameters: {'page': page, 'page_size': pageSize});
      // debugPrint(response.data.toString());
    } catch (e) {
      Toast.show('无更多推荐');
      return null;
    }
    return response.data['results'];
  }

  // 返回演员推荐
  Future<dynamic> getActorRecommendation(int page, int pageSize) async {
    Response<Map> response;
    try {
      response = await dio.get('recommendation/actor',
          queryParameters: {'page': page, 'page_size': pageSize});
      // debugPrint(response.data.toString());
    } catch (e) {
      Toast.show('无更多推荐');
      return null;
    }
    return response.data['results'];
  }

  static Dio createDio() {
    var options = BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: 10000,
        receiveTimeout: 100000,
        headers: {'Authorization': 'JWT ' + jwt});
    return Dio(options);
  }

  static Dio createRegisterDio() {
    var options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: 10000,
      receiveTimeout: 100000,
    );
    return Dio(options);
  }
}

String actor2String(List<MovieActor> actors) {
  StringBuffer sb = new StringBuffer();
  actors.forEach((actor) {
    sb.write(' ${actor.name} ');
  });
  return sb.toString();
}

String genres2String(List genres) {
  StringBuffer sb = new StringBuffer();
  genres.forEach((genre) {
    sb.write('$genre,');
  });
  return sb.toString();
}

String list2String(List datas) {
  StringBuffer sb = new StringBuffer();
  datas.forEach((data) {
    sb.write('$data,');
  });
  return sb.toString();
}

List<MovieItem> getMovieList(var list) {
  List content = list;
  List<MovieItem> movies = [];
  content.forEach((data) {
    MovieItem movie = new MovieItem(
      title: data['title'],
      id: data['id'],
      images: MovieImage(small: data['img'] ?? data['cover']),
      averageRating: data["rate"].toString(),
    );
    // //debugPrint(actor.avatars.small.toString());
    movies.add(movie);
    // movies.add(MovieItem.fromJson(data));
  });
  return movies;
}
