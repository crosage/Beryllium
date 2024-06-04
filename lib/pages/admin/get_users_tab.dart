import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' show DataCell, DataRow, DataTable, Material, DataColumn;
import 'package:provider/provider.dart';
import '../../model/user.dart';
import '../../service/request_with_token.dart';
import '../../utils/config.dart';

List<DataRow> _buildDataRows(List<ExtendedUser> users) {
  return users.map((user) {
    return DataRow(
      selected: user.selected,
      onSelectChanged: (selected) {
        user.selected=!user.selected;
      },
      cells: [
        DataCell(Text('${user.uid}')),
        DataCell(Text('${user.username}')),
        DataCell(Text('${user.userType}')),
      ],
    );
  }).toList();
}

Tab createUsersTab(BuildContext context) {
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
          return Container(
            child: Material(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DataTable(
                    sortColumnIndex: 1,
                    sortAscending: true,
                    columns: [
                      DataColumn(label: Text('用户id')),
                      DataColumn(label: Text('用户名称')),
                      DataColumn(label: Text('用户类型')),
                    ],
                    rows: _buildDataRows(users),
                  ),
                ],
              ),
            ),
          );
        }
      },
    ),
  );
}
