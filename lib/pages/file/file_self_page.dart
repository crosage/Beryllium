import 'dart:convert';
import 'package:blockchain/model/file.dart';
import 'package:dio/dio.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart'
    show DataCell, DataRow, DataTable, Material, DataColumn;
import 'package:provider/provider.dart';
import '../../component/table_widget.dart';
import '../../model/user.dart';
import '../../service/request_with_token.dart';
import '../../utils/config.dart';

class FileSelfPage extends StatefulWidget {
  final Function(int) navigateToNewPage;

  FileSelfPage({Key? key, required this.navigateToNewPage}) : super(key: key);

  @override
  _FileSelfPageState createState() => _FileSelfPageState();
}

class _FileSelfPageState extends State<FileSelfPage> {
  late final HttpHelper httpHelper;
  late final UserModel userModel;

  @override
  void initState() {
    super.initState();
    httpHelper = HttpHelper();
    userModel = Provider.of<UserModel>(context, listen: false);
  }

  List<FileModel> _parseFiles(List<dynamic> filesData) {
    List<FileModel> parseFiles = [];
    for (var fileData in filesData) {
      parseFiles.add(
        FileModel(
          fileData["fid"],
          fileData["hash"],
          fileData["name"],
          fileData["uid"],
          fileData["share_code"],
        ),
      );
    }
    return parseFiles;
  }

  Future<List<FileModel>> fetchData() async {
    try {
      Response getResponse = await httpHelper.getRequest(
          BaseUrl + "/api/file/created-files",
          token: userModel.token);
      Map<String, dynamic> responseData = jsonDecode(getResponse.toString());
      print(responseData);
      print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
      if (responseData["code"] == 200) {
        var data = responseData["data"];
        List<FileModel> parseFiles = _parseFiles(data["files"]);
        print(data);

        print("####################################3");
        return parseFiles;
      } else {
        // Handle response code not 200
        return [];
      }
    } catch (e) {
      // Handle error
      return [];
    }

  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.withPadding(
      padding: EdgeInsets.only(bottom: 0),
      content: FutureBuilder<List<FileModel>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: ProgressRing());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<FileModel>? files = snapshot.data;
            print(files);
            if (files != null && files.isNotEmpty) {
              // Render your UI with the fetched data
              List<List<String>> filesToString = [];
              for (var file in files) {
                List<String> tmp = [];
                tmp.add(file.fid.toString());
                tmp.add(file.name);
                tmp.add(file.shareCode);
                filesToString.add(tmp);
              }
              return TableWidget(
                  headers: ["文件id", "文件名称", "文件共享码"], data: filesToString);
            } else {
              return Center(child: Text('No data available'));
            }
          }
        },
      ),
    );
  }
}
