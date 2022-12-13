import 'package:json_annotation/json_annotation.dart';

part 'score.g.dart';

List<Score> getScoreList(List<dynamic> list) {
  List<Score> result = [];
  list.forEach((item) {
    result.add(Score.fromJson(item));
  });
  return result;
}

// @JsonSerializable()
class Score extends Object {
  @JsonKey(name: 'xsxm')
  String xsxm;

  @JsonKey(name: 'zcjfs')
  String zcjfs;

  @JsonKey(name: 'xnxqmc')
  String xnxqmc;

  @JsonKey(name: 'cjjd')
  String cjjd;

  @JsonKey(name: 'kcmc')
  String kcmc;

  @JsonKey(name: 'cjdm')
  String cjdm;

  @JsonKey(name: 'zcj')
  String zcj;

  @JsonKey(name: 'wzc')
  String wzc;

  @JsonKey(name: 'kkbmmc')
  String kkbmmc;

  @JsonKey(name: 'xf')
  String xf;

  @JsonKey(name: 'zxs')
  String zxs;

  @JsonKey(name: 'xdfsmc')
  String xdfsmc;

  @JsonKey(name: 'jxbmc')
  String jxbmc;

  @JsonKey(name: 'fenshu60')
  String fenshu60;

  @JsonKey(name: 'fenshu70')
  String fenshu70;

  @JsonKey(name: 'fenshu80')
  String fenshu80;

  @JsonKey(name: 'fenshu90')
  String fenshu90;

  @JsonKey(name: 'fenshu100')
  String fenshu100;

  @JsonKey(name: 'zongrenshu')
  String zongrenshu;

  @JsonKey(name: 'paiming')
  String paiming;
  @JsonKey(name: 'cj1')
  String cj1;
  @JsonKey(name: 'cj2')
  String cj2;
  @JsonKey(name: 'cj3')
  String cj3;
  @JsonKey(name: 'cj4')
  String cj4;
  @JsonKey(name: 'cj5')
  String cj5;

  Score(
    this.xsxm,
    this.zcjfs,
    this.xnxqmc,
    this.cjjd,
    this.kcmc,
    this.cjdm,
    this.zcj,
    this.wzc,
    this.kkbmmc,
    this.xf,
    this.zxs,
    this.xdfsmc,
    this.jxbmc,
    this.fenshu60,
    this.fenshu70,
    this.fenshu80,
    this.fenshu90,
    this.fenshu100,
    this.zongrenshu,
    this.paiming,
    this.cj1,
    this.cj2,
    this.cj3,
    this.cj4,
    this.cj5,
  );

  factory Score.fromJson(Map<String, dynamic> srcJson) =>
      _$ScoreFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ScoreToJson(this);
}
