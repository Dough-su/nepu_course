class yikatong {
  int? code;
  String? msg;
  String? time;
  Data? data;

  yikatong({this.code, this.msg, this.time, this.data});

  yikatong.fromJson(Map<String, dynamic> json) {
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
  Obj? obj;

  Data({this.retcode, this.desc, this.obj});

  Data.fromJson(Map<String, dynamic> json) {
    retcode = json['retcode'];
    desc = json['desc'];
    obj = json['obj'] != null ? new Obj.fromJson(json['obj']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['retcode'] = this.retcode;
    data['desc'] = this.desc;
    if (this.obj != null) {
      data['obj'] = this.obj?.toJson();
    }
    return data;
  }
}

class Obj {
  String? name;
  String? accNo;
  int? bankbalance;
  int? cardbalance;
  int? tmpbalance;
  int? pretmpbalance;
  int? state;
  int? frozen;
  String? schoolname;
  String? identitycode;
  String? sex;
  String? classname;

  Obj(
      {this.name,
      this.accNo,
      this.bankbalance,
      this.cardbalance,
      this.tmpbalance,
      this.pretmpbalance,
      this.state,
      this.frozen,
      this.schoolname,
      this.identitycode,
      this.sex,
      this.classname});

  Obj.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    accNo = json['AccNo'];
    bankbalance = json['bankbalance'];
    cardbalance = json['cardbalance'];
    tmpbalance = json['tmpbalance'];
    pretmpbalance = json['pretmpbalance'];
    state = json['state'];
    frozen = json['frozen'];
    schoolname = json['schoolname'];
    identitycode = json['identitycode'];
    sex = json['sex'];
    classname = json['classname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['AccNo'] = this.accNo;
    data['bankbalance'] = this.bankbalance;
    data['cardbalance'] = this.cardbalance;
    data['tmpbalance'] = this.tmpbalance;
    data['pretmpbalance'] = this.pretmpbalance;
    data['state'] = this.state;
    data['frozen'] = this.frozen;
    data['schoolname'] = this.schoolname;
    data['identitycode'] = this.identitycode;
    data['sex'] = this.sex;
    data['classname'] = this.classname;
    return data;
  }
}
