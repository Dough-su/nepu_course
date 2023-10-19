import 'package:muse_nepu_course/generated/json/base/json_field.dart';
import 'package:muse_nepu_course/generated/json/teacher_list_entity.g.dart';
import 'dart:convert';
export 'package:muse_nepu_course/generated/json/teacher_list_entity.g.dart';

@JsonSerializable()
class TeacherListEntity {
	String? id;
	String? text;
	String? title;

	TeacherListEntity();

	factory TeacherListEntity.fromJson(Map<String, dynamic> json) => $TeacherListEntityFromJson(json);

	Map<String, dynamic> toJson() => $TeacherListEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}