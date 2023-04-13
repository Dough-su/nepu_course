class getaccno {
  late int code;
  late String msg;
  late String time;
  late Data data;

  getaccno(
      {required this.code,
      required this.msg,
      required this.time,
      required this.data});

  getaccno.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    time = json['time'];
    data = (json['data'] != null ? new Data.fromJson(json['data']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    data['time'] = this.time;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  late String retcode;
  late String desc;
  late Obj obj;

  Data({required this.retcode, required this.desc, required this.obj});

  Data.fromJson(Map<String, dynamic> json) {
    retcode = json['retcode'];
    desc = json['desc'];
    obj = (json['obj'] != null ? new Obj.fromJson(json['obj']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['retcode'] = this.retcode;
    data['desc'] = this.desc;
    if (this.obj != null) {
      data['obj'] = this.obj.toJson();
    }
    return data;
  }
}

class Obj {
  late String name;
  late String accNo;
  late int bankbalance;
  late int cardbalance;
  late int tmpbalance;
  late int pretmpbalance;
  late int state;
  late int frozen;
  late String schoolname;
  late String identitycode;
  late String sex;
  late String classname;

  Obj(
      {required this.name,
      required this.accNo,
      required this.bankbalance,
      required this.cardbalance,
      required this.tmpbalance,
      required this.pretmpbalance,
      required this.state,
      required this.frozen,
      required this.schoolname,
      required this.identitycode,
      required this.sex,
      required this.classname});

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
