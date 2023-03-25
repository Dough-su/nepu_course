class promgpt {
  late String act;
  late String prompt;

  promgpt({required this.act, required this.prompt});

  promgpt.fromJson(Map<String, dynamic> json) {
    act = json['act'];
    prompt = json['prompt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['act'] = this.act;
    data['prompt'] = this.prompt;
    return data;
  }
}
