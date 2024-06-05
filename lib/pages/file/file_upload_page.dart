import 'package:blockchain/component/upload_file_icon.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:blockchain/service/request_with_token.dart';
import 'package:blockchain/utils/config.dart';
import 'package:flutter/material.dart';
import "package:blockchain/utils/config.dart";
import 'package:provider/provider.dart';

import '../../model/user.dart';

class FileUploadPage extends StatefulWidget {
  final Function(int) navigateToNewPage;

  FileUploadPage(
      {Key? key,
        required this.navigateToNewPage,})
      : super(key: key);

  @override
  _FileUploadPageState createState() => _FileUploadPageState();
}

class _FileUploadPageState extends State<FileUploadPage> {
  HttpHelper httpHelper = HttpHelper();
  @override
  Widget build(BuildContext context) {
    final UserModel userModel = Provider.of<UserModel>(context, listen: false);
    return ScaffoldPage.withPadding(
      padding: EdgeInsets.only(bottom: 0),
      content: Material(
        child: UploadFileIcon(
          url: BaseUrl+"/api/file/upload",
          token: userModel.token,
          size: 96,
        ),
      ),
    );
  }
}
