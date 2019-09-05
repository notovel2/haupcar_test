import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:haupcar_test/model/user.dart';
import 'package:haupcar_test/service/DB_service.dart';
import 'package:haupcar_test/service/auth_service.dart';
import 'package:haupcar_test/view/homePage.dart';
import 'package:haupcar_test/view/loginPage.dart';

class HomePresenter {
  HomePage view;

  routeToLoginPage(BuildContext context) {
     Navigator.pushReplacement(
                context, 
                MaterialPageRoute(
                  builder: (context) => LoginPage()
                ));
  }

  Future addUser(User user) async{
    await DBService.shared.addUser(user);
  }

  Future<bool> removeUser(String username) async{
    try {
      return DBService.shared.removeUser(username);
    } catch (e) {
      Future.error(e);
    }
    return false;
  }

  Future logout(BuildContext context) async{
    await AuthService.shared.logout();
    routeToLoginPage(context);
  }
}