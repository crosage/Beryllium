import 'package:blockchain/pages/navigator.dart';
import 'package:fluent_ui/fluent_ui.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  int index=0;

  @override
  Widget build(BuildContext context) {
    return FluentApp(
        theme: FluentThemeData(
            scaffoldBackgroundColor: Colors.white,
            accentColor: Colors.blue,
            iconTheme: const IconThemeData(size: 24)),
        darkTheme: FluentThemeData(
            scaffoldBackgroundColor: Colors.black,
            accentColor: Colors.blue,
            iconTheme: const IconThemeData(size: 24)),
        home: navigator()
    );
  }
}