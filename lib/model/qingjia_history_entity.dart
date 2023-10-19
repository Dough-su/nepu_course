import 'package:muse_nepu_course/generated/json/base/json_field.dart';
import 'package:muse_nepu_course/generated/json/qingjia_history_entity.g.dart';
import 'dart:convert';
export 'package:muse_nepu_course/generated/json/qingjia_history_entity.g.dart';

@JsonSerializable()
class QingjiaHistoryEntity {
	int? sEcho;
	int? iDisplayStart;
	int? iDisplayLength;
	List<int>? iSortColList;
	List<String>? sSortDirList;
	int? iTotalRecords;
	int? iTotalDisplayRecords;
	List<QingjiaHistoryAaData>? aaData;

	QingjiaHistoryEntity();

	factory QingjiaHistoryEntity.fromJson(Map<String, dynamic> json) => $QingjiaHistoryEntityFromJson(json);

	Map<String, dynamic> toJson() => $QingjiaHistoryEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class QingjiaHistoryAaData {
	@JSONField(name: "LXMC")
	String? lXMC;
	@JSONField(name: "REDFLAG")
	int? rEDFLAG;
	@JSONField(name: "JSSJ")
	String? jSSJ;
	@JSONField(name: "HOUR")
	int? hOUR;
	@JSONField(name: "TJLX")
	String? tJLX;
	@JSONField(name: "XJZT")
	dynamic xJZT;
	@JSONField(name: "SHZTMC")
	String? sHZTMC;
	@JSONField(name: "XJJG")
	dynamic xJJG;
	@JSONField(name: "HAS_FILE")
	String? hasFile;
	@JSONField(name: "SHZT")
	String? sHZT;
	@JSONField(name: "SHJGMC")
	String? sHJGMC;
	@JSONField(name: "SHJG")
	String? sHJG;
	@JSONField(name: "WXSH_IND")
	String? wxshInd;
	@JSONField(name: "QJSY")
	String? qJSY;
	@JSONField(name: "ID")
	String? iD;
	@JSONField(name: "KSSJ")
	String? kSSJ;
	@JSONField(name: "TS")
	int? tS;

	QingjiaHistoryAaData();

	factory QingjiaHistoryAaData.fromJson(Map<String, dynamic> json) => $QingjiaHistoryAaDataFromJson(json);

	Map<String, dynamic> toJson() => $QingjiaHistoryAaDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}