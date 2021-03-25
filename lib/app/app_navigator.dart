import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:movie_recommend/public.dart';

import 'package:movie_recommend/movie/movie_list_view.dart';
import 'package:movie_recommend/movie/movie_top_list_view.dart';
import 'package:movie_recommend/movie/movie_detail/movie_detail_view.dart';
import 'package:movie_recommend/movie/actor_detail/actor_detail_view.dart';
import 'package:movie_recommend/my/login_scene.dart';
import '../widget/webview_page.dart';
import '../widget/web_view_scene.dart';
import '../my/about.dart';
import '../my/my_scene.dart';

import 'search_type_choice.dart';

import '../my/message_page.dart';

class AppNavigator {
  static push(BuildContext context, Widget scene) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (BuildContext context) => scene,
      ),
    );
  }

  // 进入电影详情
  static pushMovieDetail(BuildContext context, String id) {
    AppNavigator.push(context, MovieDetailView(id: id));
  }

  //进入搜索选择界面
  static pushSearchChoice(BuildContext context) {
    AppNavigator.push(context, SearchChoice());
  }

  // 进入演员详情
  static pushActorDetail(BuildContext context, MovieActor actor) {
    AppNavigator.push(
        context,
        ActorDetailView(
          id: actor.id,
        ));
  }

  // 进入电影列表页面
  static pushMovieList(BuildContext context, String title, String action) {
    AppNavigator.push(context, MovieListView(title: title, action: action));
  }

  // 进入电影榜单列表页面
  static pushMovieTopList(
      BuildContext context, String title, String subTitle, String action) {
    Navigator.push(context, CupertinoPageRoute(builder: (context) {
      return MovieTopListView(
        action: action,
        title: title,
        subTitle: subTitle,
      );
    }));
  }

  // 进入 webview (新闻)
  static pushWeb(
      BuildContext context, String url, String title, String action) {
    Navigator.push(context, CupertinoPageRoute(builder: (context) {
      return WebViewPage(url: url, title: title, action: action);
    }));
  }

  // 进入 webview (播放视频)
  static pushWebVideo(
      BuildContext context, String url, String title, String action) {
    Navigator.push(context, CupertinoPageRoute(builder: (context) {
      return WebViewScene(url: url, title: title, action: action);
    }));
  }

  // 进入 播放视频 页面
  // static pushVideoPage(
  //     BuildContext context, String url) {
  //   Navigator.push(context, CupertinoPageRoute(builder: (context) {
  //     return MovieVideoPlay(url: url);
  //   }));
  // }

  // 进入登陆页面
  static pushLogin(BuildContext context) {
    Navigator.push(context, CupertinoPageRoute(builder: (context) {
      return LoginPage();
    }));
  }

  //进入"关于作者"页面
  static pushAbout(BuildContext context) {
    Navigator.push(context, CupertinoPageRoute(builder: (context) {
      return AboutMePage();
    }));
  }

  //进入”我的收藏“页面
  static pushCollection(BuildContext context) {
    Navigator.push(context, CupertinoPageRoute(builder: (context) {
      return MyScene();
    }));
  }

  //进入”消息“页面
  static pushMessage(BuildContext context) {
    Navigator.push(context, CupertinoPageRoute(builder: (context) {
      return MessagePage();
    }));
  }
}
