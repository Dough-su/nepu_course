// import 'package:json_annotation/json_annotation.dart';
// import 'package:json_serializable/json_serializable.dart';
part 'course.g.dart';

///这个标注是告诉生成器，这个类是需要生成Model类的
// ignore: deprecated_member_use
// @JsonSerializable()
class course {
  course(
      {required this.kcmc,
      required this.jxcdmc,
      required this.teaxms,
      required this.xq,
      required this.zc,
      required this.jxbmc,
      required this.sknrjj,
      required this.qssj,
      required this.jssj});

  String kcmc;
  String jxcdmc;
  String teaxms;
  int xq;
  int zc;
  String jxbmc;
  String sknrjj;
  String qssj;
  String jssj;

  factory course.fromJson(Map<String, dynamic> json) => _$courseFromJson(json);

  Map<String, dynamic> toJson() => _$courseToJson(this);
}
