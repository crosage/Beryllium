import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' show Icons;

import 'login.dart';

List<NavigationPaneItem> items = [
  PaneItem(
    icon: const Icon(FluentIcons.home),
    title: const Text('Home'),
    body: const Row(),
  ),
  PaneItemSeparator(),
  PaneItem(
    icon: const Icon(FluentIcons.boards),
    title: const Text('test'),
    // infoBadge: const InfoBadge(source: Text('8')),
    body: const Row(

    ),
  ),
  PaneItem(
    icon: const Icon(FluentIcons.disable_updates),
    title: const Text('test2'),
    body: const Row(),
    enabled: false,
  ),
  PaneItemExpander(
    icon: const Icon(FluentIcons.contact),
    title: const Text('Account'),
    body: LoginPage(),
    items: [
      PaneItem(
        icon: const Icon(Icons.login),
        title: const Text('Mail'),
        body: LoginPage(),
      ),
      PaneItem(
        icon: const Icon(FluentIcons.add_friend),
        title: const Text('注册'),
        body: const Row(),
      ),
    ],
  ),
];

class navigator extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return navigatorState();
  }
}

class navigatorState extends State<navigator>{
  int index=0;
  bool visable=true;
  PaneDisplayMode paneDisplayMode=PaneDisplayMode.open;
  @override
  Widget build(BuildContext context){
    return NavigationView(
      onOpenSearch: (){
        print("OPENSEARCH");
      },
      onDisplayModeChanged: (pan){
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
          child:IconButton(icon: Icon(FluentIcons.global_nav_button),onPressed: (){
          if(paneDisplayMode==PaneDisplayMode.open){
            print("$paneDisplayMode to compact");

            setState(() {
              paneDisplayMode=PaneDisplayMode.compact;
              visable=false;
            });
            print("$paneDisplayMode to compact");
          }
          else if (paneDisplayMode==PaneDisplayMode.compact){
            print("$paneDisplayMode to open");

            setState(() {
              paneDisplayMode=PaneDisplayMode.open;
              visable=false;
            });
            print("$paneDisplayMode to open");
          }
        },),),
        displayMode: paneDisplayMode,
        items: items,
        footerItems: [
          PaneItem(
            icon: const Icon(FluentIcons.settings),
            title: const Text('Settings'),
            body: Row(),
          ),
          PaneItemAction(
            icon: const Icon(FluentIcons.add),
            title: const Text('Add New Item'),
            onTap: () {
              // Your Logic to Add New `NavigationPaneItem`
              items.add(
                PaneItem(
                  icon: const Icon(FluentIcons.new_folder),
                  title: const Text('New Item'),
                  body: const Center(
                    child: Text(
                      'This is a newly added Item',
                    ),
                  ),
                ),
              );
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}