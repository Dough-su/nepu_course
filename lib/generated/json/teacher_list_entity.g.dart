import 'package:muse_nepu_course/generated/json/base/json_convert_content.dart';
import 'package:muse_nepu_course/model/teacher_list_entity.dart';

TeacherListEntity $TeacherListEntityFromJson(Map<String, dynamic> json) {
  final TeacherListEntity teacherListEntity = TeacherListEntity();
  final String? id = jsonConvert.convert<String>(json['id']);
  if (id != null) {
    teacherListEntity.id = id;
  }
  final String? text = jsonConvert.convert<String>(json['text']);
  if (text != null) {
    teacherListEntity.text = text;
  }
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    teacherListEntity.title = title;
  }
  return teacherListEntity;
}

Map<String, dynamic> $TeacherListEntityToJson(TeacherListEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['text'] = entity.text;
  data['title'] = entity.title;
  return data;
}

extension TeacherListEntityExtension on TeacherListEntity {
  TeacherListEntity copyWith({
    String? id,
    String? text,
    String? title,
  }) {
    return TeacherListEntity()
      ..id = id ?? this.id
      ..text = text ?? this.text
      ..title = title ?? this.title;
  }
}