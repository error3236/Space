class User {
  String? uid;

  User({this.uid});

  User.fromJson(Map<String, dynamic> json) {
    uid = json["uid"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['uid'] = uid;
    return data;
  }
}
