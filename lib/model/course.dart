class course {
  String? kcmc;
  String? teaxms;
  String? jsrq;
  String? jxbmc;
  int? zc;
  int? xq;
  String? jxcdmc;
  String? sknrjj;
  String? qssj;
  String? jssj;

  course(
      {this.kcmc,
      this.teaxms,
      this.jsrq,
      this.jxbmc,
      this.zc,
      this.xq,
      this.jxcdmc,
      this.sknrjj,
      this.qssj,
      this.jssj});

  course.fromJson(Map<String, dynamic> json) {
    kcmc = json['kcmc'];
    teaxms = json['teaxms'];
    jsrq = json['jsrq'];
    jxbmc = json['jxbmc'];
    zc = json['zc'];
    xq = json['xq'];
    jxcdmc = json['jxcdmc'];
    sknrjj = json['sknrjj'];
    qssj = json['qssj'];
    jssj = json['jssj'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kcmc'] = this.kcmc;
    data['teaxms'] = this.teaxms;
    data['jsrq'] = this.jsrq;
    data['jxbmc'] = this.jxbmc;
    data['zc'] = this.zc;
    data['xq'] = this.xq;
    data['jxcdmc'] = this.jxcdmc;
    data['sknrjj'] = this.sknrjj;
    data['qssj'] = this.qssj;
    data['jssj'] = this.jssj;
    return data;
  }
}
