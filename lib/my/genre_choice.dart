import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:movie_recommend/public.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GenreChoice extends StatefulWidget {
  GenreChoice({Key key}) : super(key: key);

  _GenreChoiceState createState() => _GenreChoiceState();
}

class _GenreChoiceState extends State<GenreChoice> {
  final Set<String> _selectedGenre = <String>{};
  List genreList;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    if (genreList == null) {
      return Scaffold(
        body: Center(
          child: CupertinoActivityIndicator(),
        ),
      );
    }

    final List<Widget> chips = [];

    genreList.forEach((genre) {
      chips.add(FilterChip(
        elevation: 0,
        label: Text(genre['genre']),
        selected: _selectedGenre.contains(genre['id'].toString()),
        onSelected: (bool value) {
          setState(() {
            if (!value) {
              _selectedGenre.remove(genre['id'].toString());
            } else {
              _selectedGenre.add(genre['id'].toString());
            }
            print(_selectedGenre.toString());
          });
        },
      ));
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        title: Text('喜欢类型'),
        backgroundColor: AppColor.white,
        leading: GestureDetector(
          onTap: back,
          child: Image.asset('images/icon_arrow_back_black.png'),
        ),
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Text(
              '请选择您喜欢的电影类型',
              style: TextStyle(color: AppColor.darkGrey, fontSize: 18),
            ),
            SizedBox(
              height: 30,
            ),
            Wrap(
              spacing: 10,
              children: chips,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              '* 请至少选择 1 个类型 *',
              style: TextStyle(color: AppColor.grey, fontSize: 14),
            ),
            SizedBox(
              height: 10,
            ),
            new SizedBox(
              width: double.infinity,
              child: new CupertinoButton(
                pressedOpacity: 0.7,
                padding: EdgeInsets.symmetric(vertical: 10),
                color: AppColor.orange,
                child: Text('保存'),
                onPressed: () {
                  saveGenre();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future saveGenre() async {
    MorecApi api = new MorecApi();
    String genre = _selectedGenre
        .toString()
        .replaceAll('{', '')
        .replaceAll('}', '')
        .replaceAll(', ', ',');
    var response = api.favorGenre(genre);
    if (response != null) {
      Fluttertoast.showToast(
        msg: "保存成功",
        gravity: ToastGravity.CENTER,
      );
      back();
    }
  }

  // 返回上个页面
  back() {
    Navigator.pop(context);
  }

  Future<void> _fetchData() async {
    MorecApi api = new MorecApi();
    List genreListData = await api.getGenreList();

    setState(() {
      genreList = genreListData;
    });
  }
}
