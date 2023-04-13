class qrcodemodel {
  late int code;
  late String msg;
  late String time;
  late String data;

  qrcodemodel(
      {required this.code,
      required this.msg,
      required this.time,
      required this.data});

  qrcodemodel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    time = json['time'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    data['time'] = this.time;
    data['data'] = this.data;
    return data;
  }
}
