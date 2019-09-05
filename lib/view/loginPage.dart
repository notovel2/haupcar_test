import 'package:flutter/material.dart';
import 'package:haupcar_test/components/CustomTextField.dart';
import 'package:haupcar_test/components/Loading.dart';
import 'package:haupcar_test/service/auth_service.dart';
import 'package:haupcar_test/utils/Alert.dart';
import 'package:haupcar_test/view/homePage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Stack(
            children: _buildStackWidgets(context),
          ),
        ),
      )
    );
  }

  List<Widget> _buildStackWidgets(BuildContext context) {
    List<Widget> widgets = [];
    widgets.add(_buildLoginSection(context));
    if(_isLoading) {
      widgets.add(LoadingIndicator());
    }
    return widgets;
  }

  Widget _buildLoginSection(BuildContext context) {
    return Card(
      child: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Welcome",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold
              ),
            ),
            CustomTextField(
              textAlign: TextAlign.center,
              controller: _usernameController,
            ),
            CustomTextField(
              textAlign: TextAlign.center,
              controller: _passwordController,
              isObsecure: true,
            ),
            RaisedButton(
              child: Text("Login"),
              onPressed: _onLogin,
            )
          ],
        ),
      ),
    );
  }

  _onLogin() {
    String username = _usernameController.text;
    String password = _passwordController.text;
    this.setState((){
      _isLoading = true;
    });
    AuthService.shared.login(username, password)
      .then((user){
        print("login success");
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => HomePage())
        );
      }, onError: (error) {
        print("error");
        ErrorHandler.showAlertDialog(context, error);
      })
      .catchError((error){
        print("Error.onLogin: $error");
      })
      .whenComplete(() {
        print("complete");
        setState(() {
          _isLoading = false;
        });
      });
  }
}