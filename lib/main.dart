import 'package:flutter/material.dart';
import 'package:haupcar_test/model/user.dart';
import 'package:haupcar_test/service/DB_service.dart';
import 'package:haupcar_test/view/loginPage.dart';

void main() => runApp(Main());

class Main extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}
