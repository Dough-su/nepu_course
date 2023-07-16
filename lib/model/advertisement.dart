  class advertisement {
  late String piclink;
  late String date;
  late String redirect;

  advertisement({required this.piclink, required this.date, required this.redirect});

  advertisement.fromJson(Map<String, dynamic> json) {
    piclink = json['piclink'];
    date = json['date'];
    redirect = json['redirect'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['piclink'] = this.piclink;
    data['date'] = this.date;
    data['redirect'] = this.redirect;
    return data;
  }
}
