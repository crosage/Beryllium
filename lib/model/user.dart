import 'package:fluent_ui/fluent_ui.dart';

class User {
  String? token;
  String? username;
  int? userType;

  User(this.token, this.username, this.userType);
}

class UserModel with ChangeNotifier {
  String _token = "";
  int _type = 0;
  String _name = "";

  String get token => _token;
  int get type => _type;
  String get name => _name;

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

  void updateUser(User user) {
    _token = user.token ?? "";
    _type = user.userType ?? 0;
    _name = user.username ?? "";
    notifyListeners();
  }

  void clearUser() {
    _token = "";
    _type = 0;
    _name = "";
    notifyListeners();
  }
}
