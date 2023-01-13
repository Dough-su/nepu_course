class pingjiaox {
  String? xnxqdm;
  String? pjlxdm;
  String? teadm;
  String? teabh;
  String? teaxm;
  String? wjdm;
  String? kcrwdm;
  String? kcptdm;
  String? kcdm;
  String? dgksdm;
  String? jxhjdm;
  String? kcmc;

  pingjiaox(
      {this.xnxqdm,
      this.pjlxdm,
      this.teadm,
      this.teabh,
      this.teaxm,
      this.wjdm,
      this.kcrwdm,
      this.kcptdm,
      this.kcdm,
      this.dgksdm,
      this.jxhjdm,
      this.kcmc});

  pingjiaox.fromJson(Map<String, dynamic> json) {
    xnxqdm = json['xnxqdm'];
    pjlxdm = json['pjlxdm'];
    teadm = json['teadm'];
    teabh = json['teabh'];
    teaxm = json['teaxm'];
    wjdm = json['wjdm'];
    kcrwdm = json['kcrwdm'];
    kcptdm = json['kcptdm'];
    kcdm = json['kcdm'];
    dgksdm = json['dgksdm'];
    jxhjdm = json['jxhjdm'];
    kcmc = json['kcmc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['xnxqdm'] = this.xnxqdm;
    data['pjlxdm'] = this.pjlxdm;
    data['teadm'] = this.teadm;
    data['teabh'] = this.teabh;
    data['teaxm'] = this.teaxm;
    data['wjdm'] = this.wjdm;
    data['kcrwdm'] = this.kcrwdm;
    data['kcptdm'] = this.kcptdm;
    data['kcdm'] = this.kcdm;
    data['dgksdm'] = this.dgksdm;
    data['jxhjdm'] = this.jxhjdm;
    data['kcmc'] = this.kcmc;
    return data;
  }
}
