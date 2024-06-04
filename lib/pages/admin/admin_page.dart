import 'dart:math';
import 'package:blockchain/model/user.dart';
import 'package:fluent_ui/fluent_ui.dart';

class AdminPage extends StatefulWidget {
  final Function(int) navigateToNewPage;
  final Function(User) updateUserState;
  AdminPage({Key? key, required this.navigateToNewPage,required this.updateUserState}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int currentIndex = 0;
  List<Tab> tabs = [];

  @override
  void initState() {
    super.initState();
    // 每次初始化时清空tabs
    tabs = [];
  }
  /// Creates a tab for the given index
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
}
