import 'package:flutter/material.dart';

import 'package:cvgm_app/login/widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text('Login'),
        centerTitle: true,
      ),
      body: LoginView(),
    );
  }
}
