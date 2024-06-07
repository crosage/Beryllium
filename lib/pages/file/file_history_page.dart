import 'dart:math';
import 'package:blockchain/component/table_widget.dart';
import 'package:blockchain/pages/file/file_history_all_tab.dart';
import 'package:fluent_ui/fluent_ui.dart';
import '../../model/user.dart';

class FileHistoryPage extends StatefulWidget {
  final Function(int) navigateToNewPage;
  FileHistoryPage({Key? key, required this.navigateToNewPage}) : super(key: key);

  @override
  _FileHistoryPageState createState() => _FileHistoryPageState();
}

class _FileHistoryPageState extends State<FileHistoryPage> {
  int currentIndex = 0;
  List<Tab> tabs = [];
  List<ExtendedUser> users = [];

  @override
  void initState() {
    super.initState();
    tabs = [];
    late Tab allTab,checkTab,deleteTab,updateTab,uploadTab,downloadTab;
    allTab=allFileTab(context,
            (){setState(() {
      tabs!.remove(allTab);
      if (currentIndex > 0) currentIndex--;
    });},"All");
    tabs.add(allTab);

    checkTab=allFileTab(context,
            (){setState(() {
          tabs!.remove(checkTab);
          if (currentIndex > 0) currentIndex--;
        });},"Check");
    tabs.add(checkTab);

    deleteTab=allFileTab(context,
            (){setState(() {
          tabs!.remove(deleteTab);
          if (currentIndex > 0) currentIndex--;
        });},"Delete");
    tabs.add(deleteTab);

    updateTab=allFileTab(context,
            (){setState(() {
          tabs!.remove(updateTab);
          if (currentIndex > 0) currentIndex--;
        });},"Update");
    tabs.add(updateTab);

    uploadTab=allFileTab(context,
            (){setState(() {
          tabs!.remove(uploadTab);
          if (currentIndex > 0) currentIndex--;
        });},"Upload");
    tabs.add(uploadTab);

    downloadTab=allFileTab(context,
            (){setState(() {
          tabs!.remove(downloadTab);
          if (currentIndex > 0) currentIndex--;
        });},"Download");
    tabs.add(downloadTab);
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
