import 'package:muse_nepu_course/generated/json/base/json_convert_content.dart';
import 'package:muse_nepu_course/model/qingjia_history_entity.dart';

QingjiaHistoryEntity $QingjiaHistoryEntityFromJson(Map<String, dynamic> json) {
  final QingjiaHistoryEntity qingjiaHistoryEntity = QingjiaHistoryEntity();
  final int? sEcho = jsonConvert.convert<int>(json['sEcho']);
  if (sEcho != null) {
    qingjiaHistoryEntity.sEcho = sEcho;
  }
  final int? iDisplayStart = jsonConvert.convert<int>(json['iDisplayStart']);
  if (iDisplayStart != null) {
    qingjiaHistoryEntity.iDisplayStart = iDisplayStart;
  }
  final int? iDisplayLength = jsonConvert.convert<int>(json['iDisplayLength']);
  if (iDisplayLength != null) {
    qingjiaHistoryEntity.iDisplayLength = iDisplayLength;
  }
  final List<int>? iSortColList = (json['iSortColList'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<int>(e) as int).toList();
  if (iSortColList != null) {
    qingjiaHistoryEntity.iSortColList = iSortColList;
  }
  final List<String>? sSortDirList = (json['sSortDirList'] as List<dynamic>?)
      ?.map(
          (e) => jsonConvert.convert<String>(e) as String)
      .toList();
  if (sSortDirList != null) {
    qingjiaHistoryEntity.sSortDirList = sSortDirList;
  }
  final int? iTotalRecords = jsonConvert.convert<int>(json['iTotalRecords']);
  if (iTotalRecords != null) {
    qingjiaHistoryEntity.iTotalRecords = iTotalRecords;
  }
  final int? iTotalDisplayRecords = jsonConvert.convert<int>(
      json['iTotalDisplayRecords']);
  if (iTotalDisplayRecords != null) {
    qingjiaHistoryEntity.iTotalDisplayRecords = iTotalDisplayRecords;
  }
  final List<QingjiaHistoryAaData>? aaData = (json['aaData'] as List<dynamic>?)
      ?.map(
          (e) =>
      jsonConvert.convert<QingjiaHistoryAaData>(e) as QingjiaHistoryAaData)
      .toList();
  if (aaData != null) {
    qingjiaHistoryEntity.aaData = aaData;
  }
  return qingjiaHistoryEntity;
}

Map<String, dynamic> $QingjiaHistoryEntityToJson(QingjiaHistoryEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['sEcho'] = entity.sEcho;
  data['iDisplayStart'] = entity.iDisplayStart;
  data['iDisplayLength'] = entity.iDisplayLength;
  data['iSortColList'] = entity.iSortColList;
  data['sSortDirList'] = entity.sSortDirList;
  data['iTotalRecords'] = entity.iTotalRecords;
  data['iTotalDisplayRecords'] = entity.iTotalDisplayRecords;
  data['aaData'] = entity.aaData?.map((v) => v.toJson()).toList();
  return data;
}

extension QingjiaHistoryEntityExtension on QingjiaHistoryEntity {
  QingjiaHistoryEntity copyWith({
    int? sEcho,
    int? iDisplayStart,
    int? iDisplayLength,
    List<int>? iSortColList,
    List<String>? sSortDirList,
    int? iTotalRecords,
    int? iTotalDisplayRecords,
    List<QingjiaHistoryAaData>? aaData,
  }) {
    return QingjiaHistoryEntity()
      ..sEcho = sEcho ?? this.sEcho
      ..iDisplayStart = iDisplayStart ?? this.iDisplayStart
      ..iDisplayLength = iDisplayLength ?? this.iDisplayLength
      ..iSortColList = iSortColList ?? this.iSortColList
      ..sSortDirList = sSortDirList ?? this.sSortDirList
      ..iTotalRecords = iTotalRecords ?? this.iTotalRecords
      ..iTotalDisplayRecords = iTotalDisplayRecords ?? this.iTotalDisplayRecords
      ..aaData = aaData ?? this.aaData;
  }
}

QingjiaHistoryAaData $QingjiaHistoryAaDataFromJson(Map<String, dynamic> json) {
  final QingjiaHistoryAaData qingjiaHistoryAaData = QingjiaHistoryAaData();
  final String? lXMC = jsonConvert.convert<String>(json['LXMC']);
  if (lXMC != null) {
    qingjiaHistoryAaData.lXMC = lXMC;
  }
  final int? rEDFLAG = jsonConvert.convert<int>(json['REDFLAG']);
  if (rEDFLAG != null) {
    qingjiaHistoryAaData.rEDFLAG = rEDFLAG;
  }
  final String? jSSJ = jsonConvert.convert<String>(json['JSSJ']);
  if (jSSJ != null) {
    qingjiaHistoryAaData.jSSJ = jSSJ;
  }
  final int? hOUR = jsonConvert.convert<int>(json['HOUR']);
  if (hOUR != null) {
    qingjiaHistoryAaData.hOUR = hOUR;
  }
  final String? tJLX = jsonConvert.convert<String>(json['TJLX']);
  if (tJLX != null) {
    qingjiaHistoryAaData.tJLX = tJLX;
  }
  final dynamic xJZT = json['XJZT'];
  if (xJZT != null) {
    qingjiaHistoryAaData.xJZT = xJZT;
  }
  final String? sHZTMC = jsonConvert.convert<String>(json['SHZTMC']);
  if (sHZTMC != null) {
    qingjiaHistoryAaData.sHZTMC = sHZTMC;
  }
  final dynamic xJJG = json['XJJG'];
  if (xJJG != null) {
    qingjiaHistoryAaData.xJJG = xJJG;
  }
  final String? hasFile = jsonConvert.convert<String>(json['HAS_FILE']);
  if (hasFile != null) {
    qingjiaHistoryAaData.hasFile = hasFile;
  }
  final String? sHZT = jsonConvert.convert<String>(json['SHZT']);
  if (sHZT != null) {
    qingjiaHistoryAaData.sHZT = sHZT;
  }
  final String? sHJGMC = jsonConvert.convert<String>(json['SHJGMC']);
  if (sHJGMC != null) {
    qingjiaHistoryAaData.sHJGMC = sHJGMC;
  }
  final String? sHJG = jsonConvert.convert<String>(json['SHJG']);
  if (sHJG != null) {
    qingjiaHistoryAaData.sHJG = sHJG;
  }
  final String? wxshInd = jsonConvert.convert<String>(json['WXSH_IND']);
  if (wxshInd != null) {
    qingjiaHistoryAaData.wxshInd = wxshInd;
  }
  final String? qJSY = jsonConvert.convert<String>(json['QJSY']);
  if (qJSY != null) {
    qingjiaHistoryAaData.qJSY = qJSY;
  }
  final String? iD = jsonConvert.convert<String>(json['ID']);
  if (iD != null) {
    qingjiaHistoryAaData.iD = iD;
  }
  final String? kSSJ = jsonConvert.convert<String>(json['KSSJ']);
  if (kSSJ != null) {
    qingjiaHistoryAaData.kSSJ = kSSJ;
  }
  final int? tS = jsonConvert.convert<int>(json['TS']);
  if (tS != null) {
    qingjiaHistoryAaData.tS = tS;
  }
  return qingjiaHistoryAaData;
}

Map<String, dynamic> $QingjiaHistoryAaDataToJson(QingjiaHistoryAaData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['LXMC'] = entity.lXMC;
  data['REDFLAG'] = entity.rEDFLAG;
  data['JSSJ'] = entity.jSSJ;
  data['HOUR'] = entity.hOUR;
  data['TJLX'] = entity.tJLX;
  data['XJZT'] = entity.xJZT;
  data['SHZTMC'] = entity.sHZTMC;
  data['XJJG'] = entity.xJJG;
  data['HAS_FILE'] = entity.hasFile;
  data['SHZT'] = entity.sHZT;
  data['SHJGMC'] = entity.sHJGMC;
  data['SHJG'] = entity.sHJG;
  data['WXSH_IND'] = entity.wxshInd;
  data['QJSY'] = entity.qJSY;
  data['ID'] = entity.iD;
  data['KSSJ'] = entity.kSSJ;
  data['TS'] = entity.tS;
  return data;
}

extension QingjiaHistoryAaDataExtension on QingjiaHistoryAaData {
  QingjiaHistoryAaData copyWith({
    String? lXMC,
    int? rEDFLAG,
    String? jSSJ,
    int? hOUR,
    String? tJLX,
    dynamic xJZT,
    String? sHZTMC,
    dynamic xJJG,
    String? hasFile,
    String? sHZT,
    String? sHJGMC,
    String? sHJG,
    String? wxshInd,
    String? qJSY,
    String? iD,
    String? kSSJ,
    int? tS,
  }) {
    return QingjiaHistoryAaData()
      ..lXMC = lXMC ?? this.lXMC
      ..rEDFLAG = rEDFLAG ?? this.rEDFLAG
      ..jSSJ = jSSJ ?? this.jSSJ
      ..hOUR = hOUR ?? this.hOUR
      ..tJLX = tJLX ?? this.tJLX
      ..xJZT = xJZT ?? this.xJZT
      ..sHZTMC = sHZTMC ?? this.sHZTMC
      ..xJJG = xJJG ?? this.xJJG
      ..hasFile = hasFile ?? this.hasFile
      ..sHZT = sHZT ?? this.sHZT
      ..sHJGMC = sHJGMC ?? this.sHJGMC
      ..sHJG = sHJG ?? this.sHJG
      ..wxshInd = wxshInd ?? this.wxshInd
      ..qJSY = qJSY ?? this.qJSY
      ..iD = iD ?? this.iD
      ..kSSJ = kSSJ ?? this.kSSJ
      ..tS = tS ?? this.tS;
  }
}