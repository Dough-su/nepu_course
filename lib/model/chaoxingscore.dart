class chaoxingscore {
  String? aliasName;
  List<Allexam>? allexam;
  int? completeNum;
  String? coursename;
  String? max;
  String? min;
  String? name;
  String? score;
  int? workMarked;
  int? workSubmited;

  chaoxingscore(
      {this.aliasName,
      this.allexam,
      this.completeNum,
      this.coursename,
      this.max,
      this.min,
      this.name,
      this.score,
      this.workMarked,
      this.workSubmited});

  chaoxingscore.fromJson(Map<String, dynamic> json) {
    aliasName = json['aliasName'];
    if (json['allexam'] != null) {
      allexam = <Allexam>[];
      json['allexam'].forEach((v) {
        allexam!.add(new Allexam.fromJson(v));
      });
    }
    completeNum = json['completeNum'];
    coursename = json['coursename'];
    max = json['max'];
    min = json['min'];
    name = json['name'];
    score = json['score'];
    workMarked = json['workMarked'];
    workSubmited = json['workSubmited'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['aliasName'] = this.aliasName;
    if (this.allexam != null) {
      data['allexam'] = this.allexam!.map((v) => v.toJson()).toList();
    }
    data['completeNum'] = this.completeNum;
    data['coursename'] = this.coursename;
    data['max'] = this.max;
    data['min'] = this.min;
    data['name'] = this.name;
    data['score'] = this.score;
    data['workMarked'] = this.workMarked;
    data['workSubmited'] = this.workSubmited;
    return data;
  }
}

class Allexam {
  int? stuOriginScore;
  int? stuScore;
  String? title;
  int? totalScore;

  Allexam({this.stuOriginScore, this.stuScore, this.title, this.totalScore});

  Allexam.fromJson(Map<String, dynamic> json) {
    stuOriginScore = json['stuOriginScore'];
    stuScore = json['stuScore'];
    title = json['title'];
    totalScore = json['totalScore'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stuOriginScore'] = this.stuOriginScore;
    data['stuScore'] = this.stuScore;
    data['title'] = this.title;
    data['totalScore'] = this.totalScore;
    return data;
  }
}
