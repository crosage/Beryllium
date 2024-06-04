import 'package:blockchain/model/user.dart';
import 'package:blockchain/pages/navigator.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
void main() {
  runApp(
    ChangeNotifierProvider(create: (_)=>UserModel(),child: MyApp(),)
  );
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