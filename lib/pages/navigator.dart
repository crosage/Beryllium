import 'package:blockchain/pages/admin/admin_page.dart';
import 'package:blockchain/pages/file/file_allow_page.dart';
import 'package:blockchain/pages/file/file_self_page.dart';
import 'package:blockchain/pages/file/file_upload_page.dart';
import 'package:blockchain/pages/home/home_page.dart';
import 'package:blockchain/pages/user/register_page.dart';
import 'package:blockchain/pages/setting/setting_page.dart';
import 'package:blockchain/pages/user/user_info_page.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:blockchain/model/user.dart';
import 'package:provider/provider.dart';
import 'file/file_history_page.dart';
import 'user/login_page.dart';

class navigator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return navigatorState();
  }
}

class navigatorState extends State<navigator> {
  late UserModel userModel;
  int index = 0;
  bool visable = true;
  PaneDisplayMode paneDisplayMode = PaneDisplayMode.open;

  @override
  void initState() {
    super.initState();
  }

  void handleIndexChanged(int newIndex) {
    setState(() {
      index = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    userModel = Provider.of<UserModel>(context, listen: true);
    print(userModel.token);
    return NavigationView(
      onOpenSearch: () {
      },
      appBar: const NavigationAppBar(
        title: Text('NavigationView'),
      ),
      pane: NavigationPane(
        selected: index,
        onChanged: (newIndex) => setState(() {
          index=newIndex;
        }),
        header: Visibility(
          visible: visable,
          child: IconButton(
            icon: Icon(FluentIcons.global_nav_button),
            onPressed: () {
              if (paneDisplayMode == PaneDisplayMode.open) {
                print("$paneDisplayMode to compact");

                setState(() {
                  paneDisplayMode = PaneDisplayMode.compact;
                  visable = false;
                });
                print("$paneDisplayMode to compact");
              } else if (paneDisplayMode == PaneDisplayMode.compact) {
                print("$paneDisplayMode to open");

                setState(() {
                  paneDisplayMode = PaneDisplayMode.open;
                  visable = false;
                });
                print("$paneDisplayMode to open");
              }
            },
          ),
        ),
        displayMode: paneDisplayMode,
        items: [
          PaneItem(
            icon: const Icon(FluentIcons.home),
            title: const Text('首页'),
            body: Container(
              child: IconButton(
                icon: Icon(FluentIcons.remove_link_chain,size: 500,),
                onPressed: () {},
              ),
            ),
          ),
          PaneItemSeparator(),
          PaneItemExpander(
            icon: const Icon(FluentIcons.contact),
            title: const Text('我的账号'),
            body: Container(
              child: IconButton(
                icon: Icon(Icons.accessible_forward),
                onPressed: () {},
              ),
            ),
            items: [
              if (userModel.token == "")
                PaneItem(
                  icon: const Icon(FluentIcons.follow_user),
                  title: const Text('登录'),
                  body: LoginPage(
                    navigateToNewPage: handleIndexChanged,
                  ),
                ),
              if (userModel.token == "")
                PaneItem(
                  icon: const Icon(FluentIcons.add_friend),
                  title: const Text('注册'),
                  body: RegisterPage(
                    navigateToNewPage: handleIndexChanged,
                  ),
                ),
              PaneItem(
                icon: const Icon(FluentIcons.account_management),
                title: const Text('个人信息设置'),
                body: UserInfoPage(
                  navigateToNewPage: handleIndexChanged,
                ),
              ),
              if (userModel.token != "")
              PaneItem(
                icon: const Icon(Icons.logout),
                title: const Text('登出'),
                body: Row(children: [Text("正在处理登出")],),
                onTap: (){
                  userModel.clearUser();
                  handleIndexChanged(1);
                }
              ),
            ],
          ),
          PaneItemExpander(
            icon: const Icon(FluentIcons.file_request),
            title: const Text('文件'),
            body: Container(
              child: IconButton(
                icon: Icon(Icons.accessible_forward),
                onPressed: () {},
              ),
            ),

            items: [
                PaneItem(
                  icon: const Icon(FluentIcons.upload),
                  title: const Text('文件上传'),
                  body: FileUploadPage(
                    navigateToNewPage: handleIndexChanged,
                  ),
                  enabled:userModel.token != ""
                ),

                PaneItem(
                  icon: const Icon(FluentIcons.download),
                  title: const Text('查看被共享文件'),
                  body: FileAllowPage(
                    navigateToNewPage: handleIndexChanged,
                  ),
                  enabled: userModel.token != ""
                ),
              PaneItem(
                icon: const Icon(FluentIcons.open_file),
                title: const Text('查看我上传的文件'),
                body: FileSelfPage(
                  navigateToNewPage: handleIndexChanged,
                ),
                enabled: userModel.token != ""
              ),
              PaneItem(
                  icon: const Icon(FluentIcons.delve_analytics_logo),
                  title: const Text('文件操作记录'),
                  body: FileHistoryPage(
                    navigateToNewPage: handleIndexChanged,
                  ),
                  enabled: userModel.token != ""
              ),
            ],
          ),

          PaneItem(
            icon: const Icon(FluentIcons.admin_a_logo32),
            title: const Text('管理员界面'),
            body: AdminPage(
              navigateToNewPage: handleIndexChanged,
            ),
            enabled: userModel.type==2,
          ),
        ],
        footerItems: [
          PaneItem(
            icon: const Icon(FluentIcons.settings),
            title: const Text('设置'),
            body: SettingPage(navigateToNewPage: handleIndexChanged),
          ),
        ],
      ),
    );
  }
}
