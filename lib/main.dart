import 'package:facebook_insta_login_app/home.dart';
import 'package:facebook_insta_login_app/user_data.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString('accessToken');

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home:
        accessToken != null ? UserData(accessToken: accessToken) : const Home(),
  ));
}
