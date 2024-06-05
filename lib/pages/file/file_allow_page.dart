import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart'
    show DataCell, DataRow, DataTable, Material, DataColumn;
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

  @override
  void initState() {
    super.initState();
    httpHelper = HttpHelper();
    userModel = Provider.of<UserModel>(context, listen: false);
  }

  Future<List<ExtendedUser>> fetchData() async {
    try {
      Response getResponse = await httpHelper.getRequest(BaseUrl + "/api/user",
          token: userModel.token);
      Map<String, dynamic> responseData = jsonDecode(getResponse.toString());
      if (responseData["code"] == 200) {
        var data = responseData["data"];
        print(data);
        // return parsedUsers;
        return [];
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
        content: FutureBuilder<List<ExtendedUser>>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: ProgressRing());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<ExtendedUser>? users = snapshot.data;
              if (users != null && users.isNotEmpty) {
                // Render your UI with the fetched data
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        // title: Text(users[index].name),
                        // subtitle: Text(users[index].email),
                        );
                  },
                );
              } else {
                return Center(child: Text('No data available'));
              }
            }
          },
        ));
  }
}
