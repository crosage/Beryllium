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

  List<ExtendedUser> _parseUsers(List<dynamic> usersData) {
    List<ExtendedUser> parsedUsers = [];
    for (var userData in usersData) {
      parsedUsers.add(
        ExtendedUser(
          userData["username"],
          userData["type"],
          userData["uid"],
        ),
      );
    }
    return parsedUsers;
  }
  void handleClose() {
    onClosed();
  }
  Future<List<ExtendedUser>> fetchData() async {
    try {
      Response getResponse = await httpHelper.getRequest(BaseUrl + "/api/user", token: userModel.token);
      Map<String, dynamic> responseData = jsonDecode(getResponse.toString());
      if (responseData["code"] == 200) {
        var data = responseData["data"];
        List<ExtendedUser> parsedUsers = _parseUsers(data["users"]);
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
    body: FutureBuilder<List<ExtendedUser>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: ProgressRing(),);
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No users found'));
        } else {
          List<ExtendedUser> users = snapshot.data!;
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
              child: TableWidget(headers: ["用户id","用户名称","用户型"], data: u,onRowTap: (index,header){

              },),
            ),
          );
        }
      },
    ),
  );
}
