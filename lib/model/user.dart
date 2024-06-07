// 等待修复代码质量问题

import 'package:fluent_ui/fluent_ui.dart';

class User {
  String? token;
  String username;
  int userType;
  int uid;

  User(this.username, this.userType, this.uid,{this.token});
}

class ExtendedUser extends User {
  bool selected;

  ExtendedUser(String username, int userType, int uid, {String? token, this.selected = false})
      : super(username, userType, uid, token: token);
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
