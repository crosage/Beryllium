import 'dart:math';
import 'package:fluent_ui/fluent_ui.dart';
import '../../model/user.dart';

class HomePage extends StatefulWidget {
  final Function(int) navigateToNewPage;
  HomePage({Key? key, required this.navigateToNewPage}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  List<Tab> tabs = [];
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    // 每次初始化时清空tabs
    tabs = [];
    late Tab tab;
    tab=generateTab(0);
    tabs.add(tab);
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
  @override
  void dispose() {
    super.dispose();
  }
}
