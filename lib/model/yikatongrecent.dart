class yikatongrecent {
  int? code;
  String? msg;
  String? time;
  Data? data;

  yikatongrecent({this.code, this.msg, this.time, this.data});

  yikatongrecent.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    time = json['time'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    data['time'] = this.time;
    if (this.data != null) {
      data['data'] = this.data?.toJson();
    }
    return data;
  }
}

class Data {
  String? retcode;
  String? desc;
  List<Obj>? obj;

  Data({this.retcode, this.desc, this.obj});

  Data.fromJson(Map<String, dynamic> json) {
    retcode = json['retcode'];
    desc = json['desc'];
    if (json['obj'] != null) {
      obj = <Obj>[];
      json['obj'].forEach((v) {
        obj?.add(new Obj.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['retcode'] = this.retcode;
    data['desc'] = this.desc;
    if (this.obj != null) {
      data['obj'] = this.obj?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Obj {
  String? logicdate;
  String? syscode;
  String? sysname;
  String? poscode;
  String? trancode;
  String? tranName;
  String? jnDateTime;
  String? effectdate;
  String? bankacc;
  int? cardBalance;
  int? tranAmt;
  String? ebagamt;

  Obj(
      {this.logicdate,
      this.syscode,
      this.sysname,
      this.poscode,
      this.trancode,
      this.tranName,
      this.jnDateTime,
      this.effectdate,
      this.bankacc,
      this.cardBalance,
      this.tranAmt,
      this.ebagamt});

  Obj.fromJson(Map<String, dynamic> json) {
    logicdate = json['logicdate'];
    syscode = json['syscode'];
    sysname = json['sysname'];
    poscode = json['poscode'];
    trancode = json['trancode'];
    tranName = json['TranName'];
    jnDateTime = json['JnDateTime'];
    effectdate = json['effectdate'];
    bankacc = json['bankacc'];
    cardBalance = json['CardBalance'];
    tranAmt = json['TranAmt'];
    ebagamt = json['ebagamt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['logicdate'] = this.logicdate;
    data['syscode'] = this.syscode;
    data['sysname'] = this.sysname;
    data['poscode'] = this.poscode;
    data['trancode'] = this.trancode;
    data['TranName'] = this.tranName;
    data['JnDateTime'] = this.jnDateTime;
    data['effectdate'] = this.effectdate;
    data['bankacc'] = this.bankacc;
    data['CardBalance'] = this.cardBalance;
    data['TranAmt'] = this.tranAmt;
    data['ebagamt'] = this.ebagamt;
    return data;
  }
}
