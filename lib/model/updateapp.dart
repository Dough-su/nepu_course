class updateapp {
  String? version;
  String? link;
  String? descrption;

  updateapp({this.version, this.link, this.descrption});

  updateapp.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    link = json['link'];
    descrption = json['descrption'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['version'] = this.version;
    data['link'] = this.link;
    data['descrption'] = this.descrption;
    return data;
  }
}
