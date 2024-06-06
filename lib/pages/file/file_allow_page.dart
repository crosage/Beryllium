import 'dart:convert';
import 'package:blockchain/model/file.dart';
import 'package:dio/dio.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart'
    show FloatingActionButton, Icons, SizedBox;
import 'package:provider/provider.dart';
import '../../component/table_widget.dart';
import '../../model/user.dart';
import '../../service/request_with_token.dart';
import '../../utils/config.dart';

class FileAllowPage extends StatefulWidget {
  final Function(int) navigateToNewPage;

  FileAllowPage({Key? key, required this.navigateToNewPage}) : super(key: key);

  @override
  _FileAllowPageState createState() => _FileAllowPageState();
}

class _FileAllowPageState extends State<FileAllowPage> {
  late final HttpHelper httpHelper;
  late final UserModel userModel;
  final TextEditingController _textEditingController = TextEditingController();

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
        FileModel(fileData["fid"], fileData["hash"], fileData["name"],
            fileData["uid"], fileData["share_code"],
            username: fileData["username"]),
      );
    }
    return parseFiles;
  }

  Future<List<FileModel>> fetchData() async {
    try {
      Response getResponse = await httpHelper.getRequest(
          BaseUrl + "/api/file/available-files",
          token: userModel.token);
      Map<String, dynamic> responseData = jsonDecode(getResponse.toString());
      if (responseData["code"] == 200) {
        var data = responseData["data"];
        List<FileModel> parseFiles = _parseFiles(data["files"]);
        print(data);

        // return parsedUsers;
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
    final UserModel userModel = Provider.of<UserModel>(context, listen: false);
    return ScaffoldPage.withPadding(
      padding: EdgeInsets.only(bottom: 0),
      content: Column(
        children: [
          Container(
            height: 500,
            child: FutureBuilder<List<FileModel>>(
              future: fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: ProgressRing());
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
                      tmp.add(file.username!);
                      tmp.add(file.shareCode);
                      filesToString.add(tmp);
                    }
                    return TableWidget(
                        headers: ["文件id", "文件名称", "文件所属用户", "文件共享码"],
                        data: filesToString);
                  } else {
                    return Center(child: Text('No data available'));
                  }
                }
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ContentDialog(
                        title: Text("获取文件权限"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 50,),
                            TextBox(placeholder: "输入文件的sharecode",controller: _textEditingController,),
                            SizedBox(height: 50,),
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
                                "share_code":_textEditingController.text,
                              };
                              final response = await httpHelper.postRequest(BaseUrl+"/api/file/check-share",postData, token: userModel.token);
                              Navigator.of(context).pop();
                              setState(() {

                              });
                            },
                            child: Text("上传"),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              SizedBox(
                width: 20,
              ),
            ],
          )
        ],
      ),
    );
  }
}
