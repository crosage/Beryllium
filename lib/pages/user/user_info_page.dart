import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart' show Icons, Material, TextField;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:path_provider/path_provider.dart';

class UserInfoPage extends StatefulWidget {
  final Function(int) navigateToNewPage;

  UserInfoPage({Key? key, required this.navigateToNewPage}) : super(key: key);

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  String _savePath = '';
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();

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
                Icon(Icons.perm_contact_calendar),
                Text("修改用户名:  ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
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
                IconButton(icon: Icon(Icons.check,size: 20,), onPressed: (){})
              ],
            ),
          ),
          SizedBox(height: 20,),
          FilledButton(child: Text("永久删除用户"),onPressed: (){},style:ButtonStyle(backgroundColor: ButtonState.all(Color.fromARGB(255, 203, 64, 66))))
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
