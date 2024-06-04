import 'dart:convert';
import 'dart:math';
import 'package:blockchain/component/table_widget.dart';
import 'package:dio/dio.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' show DataCell, DataRow, DataTable, Material, DataColumn;
import 'package:provider/provider.dart';
import '../../model/user.dart';
import '../../service/request_with_token.dart';
import '../../utils/config.dart';

class AdminPage extends StatefulWidget {
  final Function(int) navigateToNewPage;
  AdminPage({Key? key, required this.navigateToNewPage}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int currentIndex = 0;
  List<Tab> tabs = [];
  List<ExtendedUser> users = [];

  @override
  void initState() {
    super.initState();
    // 每次初始化时清空tabs
    tabs = [];
    tabs.add(createUsersTab(context));
  }

  List<DataRow> _buildDataRows(List<ExtendedUser> users) {
    return users.map((user) {
      return DataRow(
        selected: user.selected,
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
                child: TableWidget(headers: ["用户id","用户名称","用户型"], data: u),
              ),
            );
          }
        },
      ),
    );
  }



  Tab generateTab(int index) {
    late Tab tab;
    tab = Tab(
      text: Text('Document $index'),
      semanticLabel: 'Document #$index',
      icon: const FlutterLogo(),
      body: Container(
        color: Colors.accentColors[Random().nextInt(Colors.accentColors.length)],
      ),
      onClosed: () {
        setState(() {
          tabs!.remove(tab);
          if (currentIndex > 0) currentIndex--;
        });
      },
    );
    return tab;
  }
  @override
  Widget build(BuildContext context) {
    print("重建！！！！！！！！！！！！！！！");
    return TabView(
      tabs: tabs!,
      currentIndex: currentIndex,
      onChanged: (index) => setState(() => currentIndex = index),
      tabWidthBehavior: TabWidthBehavior.equal,
      closeButtonVisibility: CloseButtonVisibilityMode.always,
      showScrollButtons: true,
      onNewPressed: () {
        setState(() {
          final index = tabs!.length + 1;
          final tab = generateTab(index);
          tabs!.add(tab);
        });
      },
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final item = tabs!.removeAt(oldIndex);
          tabs!.insert(newIndex, item);

          if (currentIndex == newIndex) {
            currentIndex = oldIndex;
          } else if (currentIndex == oldIndex) {
            currentIndex = newIndex;
          }
        });
      },
    );
  }
}
