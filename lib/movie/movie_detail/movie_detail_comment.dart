import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:movie_recommend/public.dart';

class MovieDetailComment extends StatelessWidget {
  final List<MovieComment> comments;
  final List<double> postiveEmotionIndex;
  final List<double> negativeEmotionIndex;

  const MovieDetailComment(
      this.comments, this.postiveEmotionIndex, this.negativeEmotionIndex);

  // List<double> postiveEmotionIndex = [];
  // List<double> negativeEmotionIndex = [];

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    Widget noComment = Text(
      '暂无短评',
      style: TextStyle(color: AppColor.white, fontSize: 14),
    );

    for (var i = 0; i < comments.length; i++) {
      children.add(CommentItemView(
          comments[i], postiveEmotionIndex[i], negativeEmotionIndex[i]));
    }

    if (comments.length == 0) {
      children.add(noComment);
    }

    //为每条评论给上情感指数0-1，越接近1越正面
    // ApiClient client = new ApiClient();

    // fetchData1() async {
    //   ApiClient client = new ApiClient();
    //   List<double> positiveEmotionIndex = [];
    //   for(int i=0;i<comments.length;i++){
    //     var data = await client.getSentimentIndex(text: comments[0].content);
    //     positiveEmotionIndex[i] = data["Positive"].toStringAsPrecision(3);
    //   }
    //   return positiveEmotionIndex;
    // }

    // fetchData2() async {
    //     ApiClient client = new ApiClient();
    //     // List<double> negativeEmotionIndex = [];
    //     for(int i=0;i<comments.length;i++){
    //       var data = await client.getSentimentIndex(text: comments[0].content);
    //       negativeEmotionIndex[i] = data["Negative"].toStringAsPrecision(3);
    //     }
    //     return negativeEmotionIndex;
    //   }

    //求平均值
    String averagePostiveEmotionIndex;
    String averageNegtiveEmotionIndex;

    //记录总值
    double totalPostiveEmotionIndex = 0;
    double totalNegativeEmotionIndex = 0;

    for (int i = 0; i < comments.length; i++) {
      totalPostiveEmotionIndex =
          totalPostiveEmotionIndex + postiveEmotionIndex[i];
      totalNegativeEmotionIndex =
          totalNegativeEmotionIndex + negativeEmotionIndex[i];
    }

    averagePostiveEmotionIndex = (totalPostiveEmotionIndex / comments.length)
        .toStringAsPrecision(2); //保留两位位小数
    averageNegtiveEmotionIndex =
        (totalNegativeEmotionIndex / comments.length).toStringAsPrecision(2);

    return Container(
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color(0x66000000),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '短评',
                style: TextStyle(
                    fontSize: 16,
                    color: AppColor.white,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 10,
              ),
              Image.asset(
                "images/positive.png",
                height: 20,
                width: 20,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                averagePostiveEmotionIndex,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 10,
              ),
              Image.asset(
                "images/negative.png",
                height: 20,
                width: 20,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                averageNegtiveEmotionIndex,
                style: TextStyle(
                    fontSize: 16,
                    // color: AppColor.lightGrey
                    color: AppColor.red,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          // Text('短评', style: TextStyle(fontSize: 16, color: AppColor.white, fontWeight: FontWeight.bold),),
          SizedBox(
            height: 30.0,
          ),
          // Image.asset("images/positive.png",
          //   height: 20,
          //   width: 20,
          // ),
          // SizedBox(height: 10,),
          // Image.network("https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/72/apple/237/slightly-frowning-face_1f641.png",
          //   height:20,
          //   width: 20,
          // ),
          Column(
            children: children,
          ),
        ],
      ),
    );
  }
}

class CommentItemView extends StatelessWidget {
  final MovieComment comment;
  final double postiveEmotionIndex;
  final double negativeEmotionIndex;

  const CommentItemView(
      this.comment, this.postiveEmotionIndex, this.negativeEmotionIndex);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColor.grey, width: 0.5))),
      margin: EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                backgroundImage:
                    CachedNetworkImageProvider(comment.author.avatar),
                radius: 16.0,
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    comment.author.name,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColor.white),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Row(
                    children: <Widget>[
                      new StaticRatingBar(
                          size: 12.0, rate: comment.rating.value),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        comment.time.split(' ')[0],
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColor.lightGrey),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            comment.content,
            style: TextStyle(fontSize: 14, color: AppColor.white),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: <Widget>[
              Icon(
                Icons.thumb_up,
                color: AppColor.lightGrey,
                size: 12,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                number2Unit(comment.usefulCount),
                style: TextStyle(fontSize: 12, color: AppColor.lightGrey),
              ),
              SizedBox(
                width: 10,
              ),
              Image.asset(
                "images/positive.png",
                height: 20,
                width: 20,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                postiveEmotionIndex.toStringAsPrecision(2),
                style: TextStyle(fontSize: 12, color: Colors.green),
              ),
              SizedBox(
                width: 10,
              ),
              Image.asset(
                "images/negative.png",
                height: 20,
                width: 20,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                negativeEmotionIndex.toStringAsPrecision(2),
                style: TextStyle(
                    fontSize: 12,
                    // color: AppColor.lightGrey
                    color: AppColor.red),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  String number2Unit(int number) {
    double n;
    if (number >= 1000) {
      n = number / 1000;
      return n.toStringAsFixed(1) + 'k';
    }
    return number.toString();
  }
}
