import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:cvgm_app/core/utils.dart';

class LoginView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(child: Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          _buildTextFields(),
          Divider(),
          _buildButtons(),
        ],
      ),
    ), inAsyncCall: _saving);
  }

  final TextEditingController _usernameController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  bool _saving = false;

  Widget _buildTextFields() {
    return new Container(
      child: new Column(
        children: <Widget>[
          Container(
            child: TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                  labelText: 'Username'
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Username can not be empty';
                }
                return null;
              }
            ),
          ),
          Container(
            child: new TextFormField(
              controller: _passwordController,
              decoration: new InputDecoration(
                  labelText: 'Password'
              ),
              obscureText: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Password can not be empty';
                }
                return null;
              }
            ),
          )
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return new Container(
      child: new Column(
        children: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.blue, // background
              onPrimary: Colors.white, // foreground
            ),
            child: new Text('Login'),
            onPressed: () => _loginPressed,
          ),
          SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.blue, // background
              onPrimary: Colors.white, // foreground
            ),
            child: new Text('Forgot password'),
            onPressed: () => _passwordReset,
          )
        ],
      ),
    );
  }

  _passwordReset() async {
    launch('https://radio.cvgm.net/accounts/password/reset/');
  }

  _loginPressed () async {
    setState(() {
      _saving = true;
    });

    final bool result = await login(_usernameController.text, _passwordController.text);

    if (!result) {
      setState(() {
        _saving = false;
      });
      return displayDialog(context, 'Error loging in', 'There was an error logging in');
    }

    setState(() {
      _saving = true;
    });

    // do something
  }
}
