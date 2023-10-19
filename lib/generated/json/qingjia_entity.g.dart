import 'package:muse_nepu_course/generated/json/base/json_convert_content.dart';
import 'package:muse_nepu_course/model/qingjia_entity.dart';

QingjiaEntity $QingjiaEntityFromJson(Map<String, dynamic> json) {
  final QingjiaEntity qingjiaEntity = QingjiaEntity();
  final String? msg = jsonConvert.convert<String>(json['msg']);
  if (msg != null) {
    qingjiaEntity.msg = msg;
  }
  final bool? error = jsonConvert.convert<bool>(json['error']);
  if (error != null) {
    qingjiaEntity.error = error;
  }
  final dynamic url = json['url'];
  if (url != null) {
    qingjiaEntity.url = url;
  }
  return qingjiaEntity;
}

Map<String, dynamic> $QingjiaEntityToJson(QingjiaEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['msg'] = entity.msg;
  data['error'] = entity.error;
  data['url'] = entity.url;
  return data;
}

extension QingjiaEntityExtension on QingjiaEntity {
  QingjiaEntity copyWith({
    String? msg,
    bool? error,
    dynamic url,
  }) {
    return QingjiaEntity()
      ..msg = msg ?? this.msg
      ..error = error ?? this.error
      ..url = url ?? this.url;
  }
}