class noticex {
  String? version;
  String? notice;

  noticex({this.version, this.notice});

  noticex.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    notice = json['notice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['version'] = this.version;
    data['notice'] = this.notice;
    return data;
  }
}
