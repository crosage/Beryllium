import 'package:fluent_ui/fluent_ui.dart';
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      content: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextBox(
              controller: _usernameController,
              placeholder: "username",
            ),
            SizedBox(height: 20.0),
            TextBox(
              controller: _passwordController,
              placeholder: "password",
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            Button(
              child: const Text('Standard Button'),
              onPressed: () => debugPrint('pressed button'),
            )
          ],
        ),
      ),
    );
  }

  void _login() {
    String username = _usernameController.text;
    String password = _passwordController.text;

  }
}