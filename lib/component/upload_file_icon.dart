import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:file_picker/file_picker.dart';

import '../service/request_with_token.dart';

class UploadFileIcon extends StatelessWidget {
  final String url;
  final String? token;
  final double size;
  const UploadFileIcon({
    Key? key,
    required this.url,
    this.token,
    this.size=24.0
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconButton(
        icon: Icon(Icons.upload_file,size: size,),
        onPressed: () => _pickAndUploadFile(context),
      ),
    );
  }

  Future<void> _pickAndUploadFile(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        PlatformFile file = result.files.single;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ContentDialog(
              title: Text("文件信息"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("文件名: ${file.name}"),
                  Text("大小: ${(file.size/1024/1024).toStringAsFixed(2)} MB"),
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
                    final response = await httpHelper.uploadFile(url, file.path!, token: token);
                    Navigator.of(context).pop();
                  },
                  child: Text("上传"),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // 处理异常
    }
  }

}
