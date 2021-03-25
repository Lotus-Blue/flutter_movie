import 'package:flutter/material.dart';
// import '../app/api_client.dart';
// import 'dart:convert';

import 'package:movie_recommend/movie/movie_search_list_view.dart';
import 'package:movie_recommend/movie/actor_search_list_view.dart';

class SearchBarDelegate extends SearchDelegate<String> {
  String action;

  SearchBarDelegate(this.action);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = "",
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () => close(context, null));
  }

  @override
  Widget buildResults(BuildContext context) {
    if (action == "actor_name") {
      return MovieActorSearchListView(query, action);
    } else
      return MovieSearchListView(query, action);
    // ApiClient client = new ApiClient();
    // var a=client.getSearchListByTag(tag:'喜剧', start:0,count:20);
    // return Container(
    //   child: Text('$a'),
    // );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return super.appBarTheme(context);
  }
}
