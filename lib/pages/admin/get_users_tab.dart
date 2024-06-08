import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' show DataCell, DataRow, DataTable, Material, DataColumn;
import 'package:provider/provider.dart';
import '../../component/table_widget.dart';
import '../../model/user.dart';
import '../../service/request_with_token.dart';
import '../../utils/config.dart';

Tab createUsersTab(BuildContext context,Function onClosed) {
  final HttpHelper httpHelper = HttpHelper();
  final UserModel userModel = Provider.of<UserModel>(context, listen: false);
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _userTypeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  List<User> _parseUsers(List<dynamic> usersData) {
    List<User> parsedUsers = [];
    for (var userData in usersData) {
      print(userData);
      parsedUsers.add(
        User.fromJson(userData)
      );
    }
    return parsedUsers;
  }
  void handleClose() {
    onClosed();
  }
  Future<List<User>> fetchData() async {
    try {
      final params = {
        "pagesize": 50000
      };
      Response getResponse = await httpHelper.getRequest(BaseUrl + "/api/user",params: params, token: userModel.token);
      Map<String, dynamic> responseData = jsonDecode(getResponse.toString());
      print(responseData);
      print("***************");
      if (responseData["code"] == 200) {
        var data = responseData["data"];
        List<User> parsedUsers = _parseUsers(data["users"]);
        return parsedUsers;
      } else {
        // Handle response code not 200
        return [];
      }
    } catch (e) {
      // Handle error
      return [];
    }
  }

  return Tab(
    onClosed: handleClose,
    text: Text("用户数据"),
    body: FutureBuilder<List<User>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: ProgressRing(),);
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No users found'));
        } else {
          List<User> users = snapshot.data!;
          List<List<dynamic>> u=[];
          for (var user in users){
            List<dynamic> now=[];
            now.add(user.uid);
            now.add(user.username);
            now.add(user.userType);
            u.add(now);
          }
          return Container(
            width: 5000,
            height: 5000,
            child: Material(
              child: TableWidget(headers: ["用户id","用户名称","用户类型"], data: u,onRowTap: (index,header){
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ContentDialog(
                      title: Text("更改用户信息"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("用户名：",style: TextStyle(fontWeight: FontWeight.bold),),
                          TextBox(
                            controller: _usernameController,
                            placeholder: users[index].username,
                          ),
                          Text("用户类型：",style: TextStyle(fontWeight: FontWeight.bold),),
                          TextBox(
                            controller: _userTypeController,
                            placeholder: users[index].userType.toString(),
                          ),
                          Text("用户密码：",style: TextStyle(fontWeight: FontWeight.bold),),
                          TextBox(
                            controller: _passwordController,
                          ),
                        ],
                      ),
                      actions: [
                        Button(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("取消"),
                        ),
                        FilledButton(
                          onPressed: () async {
                            final httpHelper = HttpHelper();
                            Map<String,dynamic> postData={
                              "uid":users[index].uid,
                              "usertype":_userTypeController.text.isEmpty ? 0 : int.parse(_userTypeController.text),
                              "username":_usernameController.text,
                              "password":_passwordController.text
                            };
                            final response = await httpHelper.postRequest(BaseUrl+"/api/user/"+users[index].uid.toString(), postData, token: userModel.token);
                            Navigator.of(context).pop();
                          },
                          child: Text("确认更改"),
                        ),
                      ],
                    );
                  },
                );
              },),
            ),
          );
        }
      },
    ),
  );
}
