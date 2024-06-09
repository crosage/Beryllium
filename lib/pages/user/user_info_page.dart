import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart' show Icons, Material, TextField;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../model/user.dart';
import '../../service/request_with_token.dart';
import '../../utils/config.dart';

class UserInfoPage extends StatefulWidget {
  final Function(int) navigateToNewPage;

  UserInfoPage({Key? key, required this.navigateToNewPage}) : super(key: key);

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  late TextEditingController _controller;
  late final UserModel userModel;
  final HttpHelper httpHelper = HttpHelper();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    userModel = Provider.of<UserModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 20,),
                Icon(Icons.perm_contact_calendar),
                Text("修改用户名:  ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                Container(
                  child: TextBox(
                    controller: _controller,
                    onSubmitted: (value) async{

                    },
                  ),
                  width: 500,
                ),
                IconButton(icon: Icon(Icons.check,size: 20,), onPressed: () async{
                  Map<String,dynamic> postData={
                    "uid":userModel.uid,
                    "username":_controller.text,
                  };
                  final response = await httpHelper.postRequest(BaseUrl+"/api/user/"+userModel.uid.toString(), postData, token: userModel.token);

                })
              ],
            ),
          ),

          Row(
            children: [
              SizedBox(width: 20,),
              FilledButton(child: Text("永久删除用户"),onPressed: () async{
                final response = await httpHelper.deleteRequest(BaseUrl+"/api/user/"+userModel.uid.toString(), token: userModel.token);
                userModel.clearUser();
                widget.navigateToNewPage(0);
              },style:ButtonStyle(backgroundColor: ButtonState.all(Color.fromARGB(255, 203, 64, 66))))
            ],
          )

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
