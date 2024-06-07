import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart' show Icons, Material, TextField;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:path_provider/path_provider.dart';

class SettingPage extends StatefulWidget {
  final Function(int) navigateToNewPage;

  SettingPage({Key? key, required this.navigateToNewPage}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String _savePath = '';
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    final directory = await getApplicationDocumentsDirectory();
    final configDirectory = Directory('${directory.path}');
    final file = File('${configDirectory.path}/config.json');

    // Create directory if it doesn't exist
    if (!await configDirectory.exists()) {
      await configDirectory.create(recursive: true);
    }

    print(directory.path);
    if (await file.exists()) {
      final contents = await file.readAsString();
      final config = jsonDecode(contents);
      print(config);
      setState(() {
        _savePath = config['savePath'] ?? '${file.path}';
        _controller.text = _savePath; // Set text from saved config
      });
    } else {
      final config = {'savePath': '${file.path}'};
      await file.writeAsString(jsonEncode(config));
      setState(() {
        _savePath = config['savePath']!;
        _controller.text = _savePath; // Set default text
      });
    }
  }

  Future<void> _saveConfig() async {
    final directory = await getApplicationDocumentsDirectory();
    final configDirectory = Directory('${directory.path}');
    final file = File('${configDirectory.path}/config.json');
    final config = {'savePath': _controller.text};
    await file.writeAsString(jsonEncode(config));
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Material(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 20,),
                Icon(Icons.save),
                Text("文件保存路径:  ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                Container(
                  child: TextField(
                    controller: _controller,
                    onChanged: (value) {
                      setState(() {
                        _savePath = value;
                      });
                    },
                    onSubmitted: (value) {

                    },
                  ),
                  width: 500,
                ),
                IconButton(icon: Icon(Icons.check,size: 20,), onPressed: (){_saveConfig();})
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
