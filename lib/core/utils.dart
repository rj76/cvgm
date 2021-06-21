import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

Future<bool> login(username, password) async {
  HttpOverrides.global = new MyHttpOverrides();

  final http.Client _httpClient = new http.Client();
  final String url = 'https://radio.cvgm.net/account/signin/';
  final Map body = {
    'username': username,
    'password': password
  };

  var response = await _httpClient.post(
    Uri.parse(url),
    body: body,
  );

  if (response.statusCode != 200) {
    return false;
  }

  String? rawCookie = response.headers['set-cookie'];

  if (rawCookie == null) {
    return false;
  }

  final int index = rawCookie.indexOf(';');
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(
      'cookie', index == -1 ? rawCookie : rawCookie.substring(0, index));

  return true;
}

Future<Map<String, String>> getHeaders() async {
  final prefs = await SharedPreferences.getInstance();
  final String? cookie = prefs.getString('cookie');

  return {'set-cookie': cookie!};
}

Future<bool> postOneliner(text) async {
  HttpOverrides.global = new MyHttpOverrides();
  final http.Client _httpClient = new http.Client();
  final onelinerUrl = 'https://radio.cvgm.net/demovibes/ajax/oneliner_submit/';
  final Map<String, String> body = {
    "Line": text,
  };

  final response = await _httpClient.post(
      Uri.parse(onelinerUrl),
      body: body,
      headers: await getHeaders()
  );

  if (response.statusCode != 200) {
    return false;
  }

  return true;
}

Future<dynamic> displayDialog(context, title, text) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Text(title),
            content: Text(text)
        );
      }
  );
}
