import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' show DataCell, DataRow, DataTable, Material, DataColumn;
import 'package:provider/provider.dart';
import '../../component/table_widget.dart';
import '../../model/filelog.dart';
import '../../model/user.dart';
import '../../service/request_with_token.dart';
import '../../utils/config.dart';

Tab allFileTab(BuildContext context,Function onClosed,String type) {
  final HttpHelper httpHelper = HttpHelper();
  final UserModel userModel = Provider.of<UserModel>(context, listen: false);

  void handleClose() {
    onClosed();
  }
  Future<List<LogEntry>> fetchData() async {
    try {
      final params = {
        'operationtype': type,
        "pagesize":500
      };
      print("###############################");
      Response getResponse = await httpHelper.getRequest(BaseUrl + "/api/file/file-changelog",params: params, token: userModel.token);
      Map<String, dynamic> responseData = jsonDecode(getResponse.toString());
      print("respon****************");
      print(responseData);
      print(getResponse.statusCode);
      if (responseData["code"] == 200) {
        var data = responseData["data"];
        print("1233333333333333333333333333333333333333333");
        List<LogEntry> parsedLogs = List<LogEntry>.from(data["filelog"].map((entry) => LogEntry.fromJson(entry)));
        print("LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL");
        return parsedLogs;
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
    text: Text("${type} log"),
    body: FutureBuilder<List<LogEntry>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: ProgressRing(),);
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No logs found'));
        } else {
          List<LogEntry> Logs = snapshot.data!;
          List<List<dynamic>> u=[];
          for (var log in Logs){
            List<dynamic> now=[];
            now.add(log.username);
            now.add(log.name);
            now.add(log.uid);
            now.add(log.operation);
            now.add(log.timestamp);
            u.add(now);
          }
          return Container(
            width: 5000,
            height: 5000,
            child: Material(
              child: TableWidget(headers: ["用户名","文件名","用户id","操作类型","时间"], data: u,onRowTap: (index,header){

              },),
            ),
          );
        }
      },
    ),
  );
}
