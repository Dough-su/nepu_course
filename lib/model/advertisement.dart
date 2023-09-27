  class advertisement {
  late String content;
  late String date;
  late String redirect;

  advertisement({required this.content, required this.date, required this.redirect});

  advertisement.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    date = json['date'];
    redirect = json['redirect'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    data['date'] = this.date;
    data['redirect'] = this.redirect;
    return data;
  }
}
