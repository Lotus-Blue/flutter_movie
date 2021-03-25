// 评分细看（每颗星多少人）

class ScoreDetail {
  double d1;
  double d2;
  double d3;
  double d4;
  double d5;

  ScoreDetail(this.d1, this.d2, this.d3, this.d4, this.d5);

  ScoreDetail.fromJson(Map data) {
    d1 = data['d1']?.toDouble();
    d2 = data['d2']?.toDouble();
    d3 = data['d3']?.toDouble();
    d4 = data["d4"]?.toDouble();
    d5 = data['d5']?.toDouble();
  }
}
