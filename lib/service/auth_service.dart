import 'package:flutter/widgets.dart';
import 'package:haupcar_test/model/user.dart';
import 'package:haupcar_test/service/DB_service.dart';

class AuthService {
  static AuthService shared = AuthService();
  Future<User> login(String username, String password) async{
    try {
      List<User> users = await DBService.shared.getUsers();
      User user = users.firstWhere((it) => it.username == username);
      String encrptedPassword = DBService.shared.hmac(password);
      if(user.password == encrptedPassword) {
        User.shared = user;
        return user;
      }
    } catch (e) {
      print(e);
    }
    throw ErrorDescription("username or password is incorrect");
  }

  logout() async{

  }

}