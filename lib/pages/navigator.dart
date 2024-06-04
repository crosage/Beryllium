import 'package:blockchain/pages/admin/admin_page.dart';
import 'package:blockchain/pages/register/register_page.dart';
import 'package:blockchain/pages/setting/setting_page.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:blockchain/model/user.dart';
import 'package:provider/provider.dart';
import 'login/login_page.dart';

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
  void initState(){
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
        print("OPENSEARCH");
      },
      onDisplayModeChanged: (pan) {
        print("******************* $pan");
      },
      appBar: const NavigationAppBar(
        title: Text('NavigationView'),
      ),
      pane: NavigationPane(
        selected: index,
        onChanged: (newIndex) => setState(() => index = newIndex),
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
            body: const Row(),
          ),
          PaneItemSeparator(),
          PaneItem(
            icon: const Icon(FluentIcons.boards),
            title: const Text('test'),
            // infoBadge: const InfoBadge(source: Text('8')),
            body: const Row(),
            enabled: userModel.token==""
          ),
          PaneItem(
            icon: const Icon(FluentIcons.disable_updates),
            title: const Text('test2'),
            body: const Row(),
            enabled: false,
          ),
          PaneItemExpander(
            icon: const Icon(FluentIcons.contact),
            title: const Text('我的账号'),
            body: Container(
              child: IconButton(
                icon: Icon(Icons.accessible_forward),
                onPressed: () {

                },
              ),
            ),
            items: [
              if (userModel.token=="")
                PaneItem(
                  icon: const Icon(FluentIcons.follow_user),
                  title: const Text('登录'),
                  body: LoginPage(
                    navigateToNewPage: handleIndexChanged,
                  ),
                ),
              if (userModel.token=="")
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
                body: LoginPage(
                  navigateToNewPage: handleIndexChanged,
                ),
              ),
            ],
          ),
          PaneItem(
            icon: const Icon(FluentIcons.admin_a_logo32),
            title: const Text('管理员界面'),
            body: AdminPage(
              navigateToNewPage: handleIndexChanged,
            ),
            // enabled: false,
          ),
        ],
        footerItems: [
          PaneItem(
            icon: const Icon(FluentIcons.settings),
            title: const Text('Settings'),
            body: SettingPage(navigateToNewPage: handleIndexChanged),
          ),
          // PaneItemAction(
          //   icon: const Icon(FluentIcons.add),
          //   title: const Text('Add New Item'),
          //   onTap: () {
          //     // Your Logic to Add New `NavigationPaneItem`
          //     items.add(
          //       PaneItem(
          //         icon: const Icon(FluentIcons.new_folder),
          //         title: const Text('New Item'),
          //         body: const Center(
          //           child: Text(
          //             'This is a newly added Item',
          //           ),
          //         ),
          //       ),
          //     );
          //     setState(() {});
          //   },
          // ),
        ],
      ),
    );
  }
}
