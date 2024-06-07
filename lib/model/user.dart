// 等待修复代码质量问题

import 'package:fluent_ui/fluent_ui.dart';

class User {
  String? token;
  String username;
  int userType;
  int uid;

  User({
    required this.username,
    required this.userType,
    required this.uid,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      token: json['token'],
      username: json['username'],
      userType: json['usertype'],
      uid: json['uid'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['username'] = this.username;
    data['usertype'] = this.userType;
    data['uid'] = this.uid;
    return data;
  }
}




class UserModel with ChangeNotifier {
  String _token = "";
  int _type = 0;
  String _name = "";
  int _uid = 0;

  String get token => _token;

  int get type => _type;

  String get name => _name;

  int get uid => _uid;

  set token(String newToken) {
    _token = newToken;
    notifyListeners();
  }

  set type(int newType) {
    _type = newType;
    notifyListeners();
  }

  set name(String newName) {
    _name = newName;
    notifyListeners();
  }

  set uid(int newUid) {
    _uid = newUid;
    notifyListeners();
  }

  void updateUser(User user) {
    _token = user.token ?? "";
    _type = user.userType ?? 0;
    _name = user.username ?? "";
    _uid = user.uid ?? 0;
    notifyListeners();
  }

  void clearUser() {
    _token = "";
    _type = 0;
    _name = "";
    _uid = 0;
    notifyListeners();
  }
}
