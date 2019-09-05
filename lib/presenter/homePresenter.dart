import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
}