import 'package:flutter/material.dart';
import 'package:haupcar_test/service/auth_service.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';

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

  Widget _buildLoading() {
    return Center(
      child: Container(
        color: Colors.blueAccent.withOpacity(0.7),
        padding: EdgeInsets.all(20),
        child: Loading(indicator: BallSpinFadeLoaderIndicator(), size: 100.0,),
      ),
    );
  }

  List<Widget> _buildStackWidgets(BuildContext context) {
    List<Widget> widgets = [];
    widgets.add(_buildLoginSection(context));
    if(_isLoading) {
      widgets.add(_buildLoading());
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
            TextField(
              controller: _usernameController,
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
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
      }, onError: (error) {
        print("error");
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