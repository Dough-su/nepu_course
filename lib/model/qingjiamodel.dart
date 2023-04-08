class qingjiamodel {
  late String bjdm;
  late String bjmc;
  late String bz;
  late String cjsj;
  late String dqshjd;
  late int dqszj;
  late String fileext;
  late String filename;
  late String filepath;
  late String jsjcdm;
  late String jsrq;
  late String jssj;
  late String qjlxdm;
  late String qjxss;
  late String qsjcdm;
  late String qsrq;
  late String qssj;
  late int rownum;
  late String sflx;
  late String sfxj;
  late String sfxwzs;
  late String shjgsm;
  late String shztdm;
  late String sqdm;
  late double ts;
  late String xsbh;
  late String xsdm;
  late String xsxm;
  late String yxdm;
  late String yxmc;
  late String zymc;

  qingjiamodel(
      {required this.bjdm,
      required this.bjmc,
      required this.bz,
      required this.cjsj,
      required this.dqshjd,
      required this.dqszj,
      required this.fileext,
      required this.filename,
      required this.filepath,
      required this.jsjcdm,
      required this.jsrq,
      required this.jssj,
      required this.qjlxdm,
      required this.qjxss,
      required this.qsjcdm,
      required this.qsrq,
      required this.qssj,
      required this.rownum,
      required this.sflx,
      required this.sfxj,
      required this.sfxwzs,
      required this.shjgsm,
      required this.shztdm,
      required this.sqdm,
      required this.ts,
      required this.xsbh,
      required this.xsdm,
      required this.xsxm,
      required this.yxdm,
      required this.yxmc,
      required this.zymc});

  qingjiamodel.fromJson(Map<String, dynamic> json) {
    bjdm = json['bjdm'];
    bjmc = json['bjmc'];
    bz = json['bz'];
    cjsj = json['cjsj'];
    dqshjd = json['dqshjd'];
    dqszj = json['dqszj'];
    fileext = json['fileext'];
    filename = json['filename'];
    filepath = json['filepath'];
    jsjcdm = json['jsjcdm'];
    jsrq = json['jsrq'];
    jssj = json['jssj'];
    qjlxdm = json['qjlxdm'];
    qjxss = json['qjxss'];
    qsjcdm = json['qsjcdm'];
    qsrq = json['qsrq'];
    qssj = json['qssj'];
    rownum = json['rownum_'];
    sflx = json['sflx'];
    sfxj = json['sfxj'];
    sfxwzs = json['sfxwzs'];
    shjgsm = json['shjgsm'];
    shztdm = json['shztdm'];
    sqdm = json['sqdm'];
    ts = json['ts'];
    xsbh = json['xsbh'];
    xsdm = json['xsdm'];
    xsxm = json['xsxm'];
    yxdm = json['yxdm'];
    yxmc = json['yxmc'];
    zymc = json['zymc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bjdm'] = this.bjdm;
    data['bjmc'] = this.bjmc;
    data['bz'] = this.bz;
    data['cjsj'] = this.cjsj;
    data['dqshjd'] = this.dqshjd;
    data['dqszj'] = this.dqszj;
    data['fileext'] = this.fileext;
    data['filename'] = this.filename;
    data['filepath'] = this.filepath;
    data['jsjcdm'] = this.jsjcdm;
    data['jsrq'] = this.jsrq;
    data['jssj'] = this.jssj;
    data['qjlxdm'] = this.qjlxdm;
    data['qjxss'] = this.qjxss;
    data['qsjcdm'] = this.qsjcdm;
    data['qsrq'] = this.qsrq;
    data['qssj'] = this.qssj;
    data['rownum_'] = this.rownum;
    data['sflx'] = this.sflx;
    data['sfxj'] = this.sfxj;
    data['sfxwzs'] = this.sfxwzs;
    data['shjgsm'] = this.shjgsm;
    data['shztdm'] = this.shztdm;
    data['sqdm'] = this.sqdm;
    data['ts'] = this.ts;
    data['xsbh'] = this.xsbh;
    data['xsdm'] = this.xsdm;
    data['xsxm'] = this.xsxm;
    data['yxdm'] = this.yxdm;
    data['yxmc'] = this.yxmc;
    data['zymc'] = this.zymc;
    return data;
  }
}
