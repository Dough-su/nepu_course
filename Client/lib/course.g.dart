// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

course _$courseFromJson(Map<String, dynamic> json) {
  return course(
    kcmc: json['kcmc'] as String,
    jxcdmc: json['jxcdmc'] as String,
    teaxms: json['teaxms'] as String,
    xq: json['xq'] as int,
    zc: json['zc'] as int,
    jxbmc: json['jxbmc'] as String,
    sknrjj: json['sknrjj'] as String,
    qssj: json['qssj'] as String,
    jssj: json['jssj'] as String,
  );
}

Map<String, dynamic> _$courseToJson(course instance) => <String, dynamic>{
      'kcmc': instance.kcmc,
      'jxcdmc': instance.jxcdmc,
      'teaxms': instance.teaxms,
      'xq': instance.xq,
      'zc': instance.zc,
      'jxbmc': instance.jxbmc,
      'sknrjj': instance.sknrjj,
      'qssj': instance.qssj,
      'jssj': instance.jssj,
    };
