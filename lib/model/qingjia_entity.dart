import 'package:muse_nepu_course/generated/json/base/json_field.dart';
import 'package:muse_nepu_course/generated/json/qingjia_entity.g.dart';
import 'dart:convert';
export 'package:muse_nepu_course/generated/json/qingjia_entity.g.dart';

@JsonSerializable()
class QingjiaEntity {
	String? msg;
	bool? error;
	dynamic url;

	QingjiaEntity();

	factory QingjiaEntity.fromJson(Map<String, dynamic> json) => $QingjiaEntityFromJson(json);

	Map<String, dynamic> toJson() => $QingjiaEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}