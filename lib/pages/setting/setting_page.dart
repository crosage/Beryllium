import 'package:blockchain/model/user.dart';
import 'package:dio/dio.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:blockchain/component/required_text_field.dart';
import 'package:blockchain/service/request_with_token.dart';
import 'package:blockchain/utils/config.dart';
import 'package:flutter/material.dart'
    show DataCell, DataColumn, DataRow, DataTable, Material;

class SettingPage extends StatefulWidget {
  final Function(int) navigateToNewPage;

  SettingPage(
      {Key? key,
        required this.navigateToNewPage,})
      : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class UUser {
  UUser(this.name, this.age, {this.selected = false});

  String name;
  int age;
  bool selected;
}

class _SettingPageState extends State<SettingPage> {
  HttpHelper httpHelper = HttpHelper();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _checkController = TextEditingController();

  List<UUser> data = [
    UUser('老孟', 18),
    UUser('老孟1', 19, selected: true),
    UUser('老孟2', 20),
    UUser('老孟3', 21),
    UUser('老孟4', 22),
  ];

  List<DataRow> _buildDataRows() {
    return data.map((user) {
      return DataRow(
        selected: user.selected,
        onSelectChanged: (selected) {
          setState(() {
            user.selected = selected ?? false;
          });
        },
        cells: [
          DataCell(Text('${user.name}')),
          DataCell(Text('${user.age}')),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.withPadding(
      padding: EdgeInsets.only(bottom: 0),
      content: Material(
        child: DataTable(
          sortColumnIndex: 1,
          sortAscending: true,
          columns: [
            DataColumn(label: Text('姓名')),
            DataColumn(
              label: Text('年龄'),
            ),
          ],
          rows: _buildDataRows(),
        ),
      ),
    );
  }
}
