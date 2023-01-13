class score {
  String? xsxm;
  String? zcjfs;
  String? xnxqmc;
  String? cjjd;
  String? kcmc;
  String? cjdm;
  String? zcj;
  String? wzc;
  String? kkbmmc;
  String? xf;
  String? zxs;
  String? xdfsmc;
  String? jxbmc;
  String? fenshu60;
  String? fenshu70;
  String? fenshu80;
  String? fenshu90;
  String? fenshu100;
  String? zongrenshu;
  String? paiming;
  String? pscj;
  String? sycj;
  String? qzcj;
  String? qmcj;
  String? sjcj;

  score(
      {this.xsxm,
      this.zcjfs,
      this.xnxqmc,
      this.cjjd,
      this.kcmc,
      this.cjdm,
      this.zcj,
      this.wzc,
      this.kkbmmc,
      this.xf,
      this.zxs,
      this.xdfsmc,
      this.jxbmc,
      this.fenshu60,
      this.fenshu70,
      this.fenshu80,
      this.fenshu90,
      this.fenshu100,
      this.zongrenshu,
      this.paiming,
      this.pscj,
      this.sycj,
      this.qzcj,
      this.qmcj,
      this.sjcj});

  score.fromJson(Map<String, dynamic> json) {
    xsxm = json['xsxm'];
    zcjfs = json['zcjfs'];
    xnxqmc = json['xnxqmc'];
    cjjd = json['cjjd'];
    kcmc = json['kcmc'];
    cjdm = json['cjdm'];
    zcj = json['zcj'];
    wzc = json['wzc'];
    kkbmmc = json['kkbmmc'];
    xf = json['xf'];
    zxs = json['zxs'];
    xdfsmc = json['xdfsmc'];
    jxbmc = json['jxbmc'];
    fenshu60 = json['fenshu60'];
    fenshu70 = json['fenshu70'];
    fenshu80 = json['fenshu80'];
    fenshu90 = json['fenshu90'];
    fenshu100 = json['fenshu100'];
    zongrenshu = json['zongrenshu'];
    paiming = json['paiming'];
    pscj = json['pscj'];
    sycj = json['sycj'];
    qzcj = json['qzcj'];
    qmcj = json['qmcj'];
    sjcj = json['sjcj'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['xsxm'] = this.xsxm;
    data['zcjfs'] = this.zcjfs;
    data['xnxqmc'] = this.xnxqmc;
    data['cjjd'] = this.cjjd;
    data['kcmc'] = this.kcmc;
    data['cjdm'] = this.cjdm;
    data['zcj'] = this.zcj;
    data['wzc'] = this.wzc;
    data['kkbmmc'] = this.kkbmmc;
    data['xf'] = this.xf;
    data['zxs'] = this.zxs;
    data['xdfsmc'] = this.xdfsmc;
    data['jxbmc'] = this.jxbmc;
    data['fenshu60'] = this.fenshu60;
    data['fenshu70'] = this.fenshu70;
    data['fenshu80'] = this.fenshu80;
    data['fenshu90'] = this.fenshu90;
    data['fenshu100'] = this.fenshu100;
    data['zongrenshu'] = this.zongrenshu;
    data['paiming'] = this.paiming;
    data['pscj'] = this.pscj;
    data['sycj'] = this.sycj;
    data['qzcj'] = this.qzcj;
    data['qmcj'] = this.qmcj;
    data['sjcj'] = this.sjcj;
    return data;
  }
}
