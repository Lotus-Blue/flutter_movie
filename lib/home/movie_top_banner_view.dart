import 'package:flutter/material.dart';

// import 'package:carousel_slider/carousel_slider.dart';
import 'package:palette_generator/palette_generator.dart';

import 'package:movie_recommend/public.dart';
import 'movie_top_item_view.dart';

class MovieTopBannerView extends StatelessWidget {
  final List<MovieTopBanner> banners;

  MovieTopBannerView(this.banners);

  @override
  Widget build(BuildContext context) {
    if (banners == null) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
            color: Color(0xff3E454D),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        width: Screen.width,
        height: Screen.width * 9 / 15,
      );
    }

    return PageView(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            AppNavigator.pushMovieTopList(
              context,
              banners[0].title,
              banners[0].subTitle,
              banners[0].action,
            );
          },
          child: MovieTopItemView(banners[0].movies, banners[0].title,
              banners[0].subTitle, banners[0].coverColor),
        ),
        GestureDetector(
          onTap: () {
            AppNavigator.pushMovieTopList(
              context,
              banners[1].title,
              banners[1].subTitle,
              banners[1].action,
            );
          },
          child: MovieTopItemView(banners[1].movies, banners[1].title,
              banners[1].subTitle, banners[1].coverColor),
        ),
        GestureDetector(
          onTap: () {
            AppNavigator.pushMovieTopList(
              context,
              banners[2].title,
              banners[2].subTitle,
              banners[2].action,
            );
          },
          child: MovieTopItemView(banners[2].movies, banners[2].title,
              banners[2].subTitle, banners[2].coverColor),
        ),
        GestureDetector(
          onTap: () {
            AppNavigator.pushMovieTopList(
              context,
              banners[3].title,
              banners[3].subTitle,
              banners[3].action,
            );
          },
          child: MovieTopItemView(banners[3].movies, banners[3].title,
              banners[3].subTitle, banners[3].coverColor),
        ),
      ],
    );

    /*
    Container(
      color: Colors.white,
      child: CarouselSlider(
        items: banners.map((banner) {
          return Builder(
            builder: (BuildContext context) {
              return GestureDetector(
                onTap: () {
                  AppNavigator.pushMovieTopList(context, banner.title, banner.subTitle, banner.action,);
                },
                  child: Container(
                    width: Screen.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: MovieTopItemView(banner.movies, banner.title, banner.subTitle, banner.coverColor)
                ),
              );
            },
          );
        }).toList(),
        aspectRatio: 15 / 9,
        
      ),
    );*/
  }
}

class MovieTopBanner {
  List<MovieItem> movies;
  String title;
  String subTitle;
  String action;
  PaletteColor coverColor;
  MovieTopBanner(
      this.movies, this.title, this.subTitle, this.action, this.coverColor);
}
