// import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;

import 'package:movie_recommend/model/movie_news.dart';

// import 'package:movie_recommend/model/movie_actor.dart';

class ApiClient {
  static const String baseUrl = 'http://api.douban.com/v2/movie/';

  static const String apiKey = '0b2bdeda43b5688921839c8ecb20399b';
  static const String webUrl = 'https://movie.douban.com/';
  static const String searchByNameUrl =
      'https://movie.douban.com/j/subject_suggest?q=';
  // static const String apiUrl = "http://120.76.128.109:8777/api/";
  // static const String apiUrl2 = "http://129.204.0.235:8777/api/";

  static const String apiUrl = "http://120.76.128.109:8666/api/";
  static const String apiUrl2 = "http://120.76.128.109:8666/api/";

  // static const String searchByTagUrl='https://movie.douban.com/j/new_search_subjects?sort=T&range=0,10&tags=%E7%94%B5%E5%BD%B1,%E6%88%98%E4%BA%89&start=0';
  var dio = ApiClient.createDio();
  var dio2 = ApiClient.createDio2();
  var dio3 = ApiClient.createDio3();
  var dio4 = ApiClient.createDio4();
  var dio5 = ApiClient.createDio5();

  // 获取首页热门新闻文章
  Future<List<MovieNews>> getNewsList() async {
    List<MovieNews> news = [];

    await http.get(webUrl).then((http.Response response) {
      var document = parse(response.body.toString());
      List<dom.Element> items =
          document.getElementsByClassName('gallery-frame');
      items.forEach((item) {
        String cover =
            item.getElementsByTagName('img')[0].attributes['src'].toString();
        String link =
            item.getElementsByTagName('a')[0].attributes['href'].toString();
        String title =
            item.getElementsByTagName('h3')[0].text.toString().trim();
        String summary =
            item.getElementsByTagName('p')[0].text.toString().trim();
        MovieNews movieNews = new MovieNews(title, cover, summary, link);
        news.add(movieNews);
      });
    });
    return news;
  }

  // 获取正在上映电影
  Future<dynamic> getNowPlayingList({int start, int count}) async {
    Response<Map> response = await dio
        .get('in_theaters', queryParameters: {"start": start, 'count': count});
    return response.data['subjects'];
  }

  // 获取即将上映电影
  Future<dynamic> getComingList({int start, int count}) async {
    Response<Map> response = await dio
        .get('coming_soon', queryParameters: {"start": start, 'count': count});
    return response.data['subjects'];
  }

  // 获取本周口碑榜电影
  Future<dynamic> getWeeklyList() async {
    Response<Map> response = await dio.get('weekly');
    List content = response.data['subjects'];
    List movies = [];
    content.forEach((data) {
      movies.add(data['subject']);
    });
    return movies;
  }

  // 获取新片榜电影
  Future<dynamic> getNewMoviesList() async {
    Response<Map> response = await dio.get('new_movies');
    return response.data['subjects'];
  }

  // 获取北美票房榜电影
  Future<dynamic> getUsBoxList() async {
    Response<Map> response = await dio.get('us_box');
    List content = response.data['subjects'];
    List movies = [];
    content.forEach((data) {
      movies.add(data['subject']);
    });
    return movies;
  }

  // 获取 top250 榜单
  Future<dynamic> getTop250List({int start, int count}) async {
    Response<Map> response = await dio
        .get('top250', queryParameters: {'start': start, 'count': count});
    return response.data['subjects'];
  }

  // 输入电影标签获取搜索结果
  Future<dynamic> getSearchListByTag(
      {String tag,
      int start,
      int count,
      String action,
      String tagWay = "T"}) async {
    String searchByTagUrl =
        'https://movie.douban.com/j/new_search_subjects?sort=$tagWay&range=0,10&tags=%E7%94%B5%E5%BD%B1,$tag&start=$start';
    Response<Map> response = await dio3.get(searchByTagUrl);

    //若返回为空，则利用用户的ip请求数据
    // if (response.data["r"] == 1||response.data["data"].length == 0 ) {
    if (response.data["data"].length == 0) {
      response =
          await dio4.post('tag_data', data: {"tag": tag, "start": start});
    }
    // debugPrint('$Response');
    var len; //数量
    if (response.data['data'].length != 0) {
      //注意:不要用==null判断，用长度
      len = response.data['data'].length;
      // debugPrint(response.data['data'].toString());
    } else if (response.data['data'].length == 0) {
      len = 0;
    }
    // debugPrint(len.toString());
    // debugPrint(response.data['data'].toString());
    var jsonData = List<Map<String, dynamic>>();
    var cnt = 0;
    // for (int i = start; i < start + count; i++) {//应该是下面这句，否则会越界啊，你想想start为20的时候
    for (int i = 0; i < count; i++) {
      if (cnt++ >= len) {
        break;
      }
      if (action == "recommend") {
        jsonData.add(response.data['data'][i]);
      } else
        jsonData.add(
            await getMovieDetail(response.data['data'][i]['id'].toString()));
    }
    return jsonData;
  }

  // 输入电影名字获取搜索结果【电影】
  Future<dynamic> getSearchListByName(
      {String name, var start, int count, String action}) async {
    // Response<List> response = await dio2.get(name);
    Response<List> response = await dio2.get(name);
    if (response.data.length == 0) {
      //注意:不要用==null判断，用长度
      response = await dio4.post('name_data', data: {"name": name});
    }
    var len = response.data.length;
    // debugPrint(response.data.toString());
    var jsonData = List<Map<String, dynamic>>();
    // for (int i = start; i < start + count; i++) {//应该是下面这句，否则会越界啊，你想想start为20的时候
    for (int i = 0; i < count; i++) {
      if (i >= len) {
        break;
      }
      if (action == "search") {
        jsonData.add(await getMovieDetail(response.data[i]['id'].toString()));
      } else
        jsonData.add(response.data[i]);
    }
    return jsonData;
  }

  //输入name返回具体一个结果【推荐演员用】
  Future<dynamic> getCelebritySearchByApi({String name}) async {
    Response response =
        await dio5.post('CelebritySearch', data: {"name": name});
    Map<String, dynamic> actorData;
    if (response.data != "0") actorData = await getActorDetail(response.data);
    // debugPrint(actorData.toString());
    return actorData;
  }

  //输入name返回具体一个结果【推荐演员用】这个是给后台计算用的，不用返回数据，只需返回id
  Future<dynamic> getCelebritySearchByApi2({String name}) async {
    Response response =
        await dio5.post('CelebritySearch', data: {"name": name});
    return response.data;
  }

  //输入name返回具体一个结果【推荐电影用】这个是给后台计算用的，不用返回数据，只需返回id
  Future<dynamic> getMovieSearchByApi2({String name}) async {
    Response response = await dio5.post('MovieSearch', data: {"name": name});
    return response.data;
  }

  //输入name返回所有搜索结果【演员】
  Future<dynamic> getAllSearchListByName({String name, String action}) async {
    // Response<List> response = await dio4.post('data', data: {"name":name});
    Response<List> response;
    var jsonData = List<Map<String, dynamic>>();
    //  try {
    //    debugPrint("dio开始");
    //   //  response = await dio2.get(name);
    //    response = await dio4.post('name_data', data: {"name":name});
    //    }
    //    catch (e) {
    //      debugPrint("dio错误");
    //      return jsonData;
    //   }

    response = await dio2.get(name);
    if (response.data.length == 0) {
      response = await dio4.post('name_data', data: {"name": name});
      // debugPrint(response.toString());
      // debugPrint("hi");
    }
    // var len=response.data.length;
    var len; //数量
    if (response.data.length != 0) {
      len = response.data.length;
      // debugPrint(response.data.toString());
    } else if (response.data.length == 0) {
      len = 0;
    }
    for (int i = 0; i < len; i++) {
      if (response.data[i]['type'] == "celebrity" &&
          response.data[i]['title'] == name) {
        // jsonData.add(response.data[i]);
        if (action == "search") {
          jsonData.add(await getActorDetail(response.data[i]["id"]));
          // continue;
        } else {
          jsonData.add(response.data[i]);
          break;
        }
      }
    }
    // debugPrint(jsonData.toString());
    return jsonData;
  }

  // // 根据标签搜索
  // Future<dynamic> getSearchListByTag({String tag, int start, int count}) async {
  //   Response<Map> response = await dio.get('search', queryParameters: {'tag':tag, 'start':start, 'count':count});
  //   return response.data['subjects'];
  // }

  //   // 根据关键字搜索
  // Future<dynamic> getSearchListByKey({String key, int start, int count}) async {
  //   Response<Map> response = await dio.get('search', queryParameters: {'q':key, 'start':start, 'count':count});
  //   return response.data['subjects'];
  // }

  //获取最新vip解析接口
  Future<dynamic> getMovieAcessUrl() async {
    Response<Map> response = await dio5.get('movie');
    return response.data;
  }

  // 获取电影详情
  Future<dynamic> getMovieDetail(String movieId) async {
    Response<Map> response = await dio.get('subject/$movieId');
    return response.data;
  }

  // 影片剧照
  Future<dynamic> getMovieAlbum({String movieId, int start, int count}) async {
    Response<Map> response = await dio.get('subject/$movieId/photos',
        queryParameters: {'start': start, 'count': count});
    return response.data['photos'];
  }

  // 演员详细信息
  Future<dynamic> getActorDetail(String actorId) async {
    Response<Map> response = await dio.get('celebrity/$actorId');
    // debugPrint(actorId);
    return response.data;
  }

  // 获取演员相册
  Future<dynamic> getActorPhotos({String actorId, int start, int count}) async {
    Response<Map> response = await dio.get('celebrity/$actorId/photos',
        queryParameters: {'start': start, 'count': count});
    return response.data['photos'];
  }

  // 获取电影名与电影各标签之间的相似度
  Future<dynamic> getSimilarity({String srcWord, String targetWord}) async {
    Response<Map> response = await dio5.post('nlp', data: {
      "action": "WordSimilarity",
      'SrcWord': srcWord,
      "TargetWord": targetWord
    });
    if (response.data['Similarity'] == 0) {
      response.data['Similarity'] = 0.0;
    }
    return response.data['Similarity'];
  }

  // 获取与电影名最相似的前top个词
  Future<dynamic> getSimilarWord({String text, int top}) async {
    // debugPrint("hi");
    Response<Map> response = await dio5.post('nlp', data: {
      "action": "SimilarWordCollection",
      'Text': text,
      "WordNumber": top
    });
    debugPrint(response.toString());
    return response.data['SimilarWords'];
  }

  // 获取电影评论的前情感指数，返回0-1，越接近1表示越正面
  Future<dynamic> getSentimentIndex({String text}) async {
    // debugPrint("开始");
    Response<Map> response = await dio5
        .post('nlp', data: {"action": "EmotionAnalysis", 'Text': text});
    //注意，上面是用post而不是get，queryParameters改为data
    return response.data;
  }

  static Dio createDio() {
    var options = BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: 10000,
        receiveTimeout: 100000,
        contentType: ContentType.json,
        queryParameters: {"apikey": apiKey});
    return Dio(options);
  }

  static Dio createDio2() {
    var options = BaseOptions(
      baseUrl: searchByNameUrl,
      connectTimeout: 10000,
      receiveTimeout: 100000,
      contentType: ContentType.json,
    );
    return Dio(options);
  }

  static Dio createDio3() {
    var options = BaseOptions(
      baseUrl: '',
      connectTimeout: 10000,
      receiveTimeout: 100000,
      contentType: ContentType.json,
    );
    return Dio(options);
  }

  static Dio createDio4() {
    var options = BaseOptions(
      baseUrl: apiUrl,
      connectTimeout: 10000,
      receiveTimeout: 100000,
      contentType: ContentType.json,
    );
    return Dio(options);
  }

  static Dio createDio5() {
    var options = BaseOptions(
      baseUrl: apiUrl2,
      connectTimeout: 10000,
      receiveTimeout: 100000,
      contentType: ContentType.json,
    );
    return Dio(options);
  }
}
