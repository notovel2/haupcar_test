import 'package:flutter/material.dart';
import 'package:haupcar_test/model/user.dart';
import 'package:haupcar_test/service/DB_service.dart';
import 'package:haupcar_test/view/loginPage.dart';

void main() => runApp(Main());

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // DBService.shared.removeUser("admin");
    // DBService.shared.addUser(User(
    //   userId: 1,
    //   username: "admin",
    //   password: "passw0rd",
    //   name: "Admin",
    //   lastName: "Manger",
    //   email: "admin@manager.com",
    //   activated: true
    // ));
    DBService.shared.init();
    return MaterialApp(
      title: 'User Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}
