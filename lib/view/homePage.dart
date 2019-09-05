import 'package:flutter/material.dart';
import 'package:haupcar_test/commons/json_property.dart';
import 'package:haupcar_test/components/CustomTextField.dart';
import 'package:haupcar_test/components/Loading.dart';
import 'package:haupcar_test/model/user.dart';
import 'package:haupcar_test/presenter/homePresenter.dart';
import 'package:haupcar_test/service/DB_service.dart';
import 'package:haupcar_test/service/auth_service.dart';
import 'package:haupcar_test/view/loginPage.dart';

class HomePage extends StatefulWidget{
  final HomePresenter presenter = HomePresenter();
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    widget.presenter.view = widget;
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: _buildAppbarActions(),
      ),
      body: SafeArea(
        child: Scaffold(
          body: Center(
            child: Stack(
              children: _buildStack(context),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: (){
              print("Add");
              _showFormDialog();
            },
          ),
        ),
      ),
      
    );
  }

  List<Widget> _buildAppbarActions() {
    return [
      IconButton(
        icon: Icon(Icons.power_settings_new),
        onPressed: (){
          _setLoading(true);
          widget.presenter.logout(context)
            .then(
              (res){}, 
              onError: (erorr) => print("Failed to logout")
            )
            .whenComplete(() {
              _setLoading(false);
            });
        },
      )
    ];
  }

  List<Widget> _buildStack(BuildContext context) {
    List<Widget> widgets = [];
    widgets.add(_buildListSection(context, DBService.shared.users));
    if(_isLoading) {
      widgets.add(LoadingIndicator());
    }
    return widgets;
  }

  Widget _buildDismissible(User user) {
    // if(user.username == User.shared.username) {
    //   return ListTile(
    //     title: Text("${user.name} ${user.lastName}"),
    //     subtitle: Text("@${user.username}"),
    //   );
    // }
    return Dismissible(
      direction: DismissDirection.endToStart,
      background: Container(
        margin: EdgeInsets.only(right: 5),
        color: Colors.red,
        alignment: Alignment.centerRight,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      key: Key(user.username),
      onDismissed: (direction) {
        widget.presenter.removeUser(user.username);
      },
      child: ListTile(
        title: Text("${user.name} ${user.lastName}"),
        subtitle: Text("@${user.username}"),
      ),
    );
  }

  Widget _buildListSection(BuildContext context, List<User> users) {
    return Container(
      child: Card(
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return _buildDismissible(user);
          },
        ),
      ),
    );
  }

  _showFormDialog() {
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    final nameController = TextEditingController();
    final lastnameController = TextEditingController();
    final emailController = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
      SimpleDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Add User"),
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                _buildTextFormField(
                  controller: usernameController,
                  hintText: "Username"
                ),
                _buildTextFormField(
                  controller: passwordController,
                  hintText: "Password",
                  obsecureText: true
                ),
                _buildTextFormField(
                  controller: nameController,
                  hintText: "Name",
                ),
                _buildTextFormField(
                  controller: lastnameController,
                  hintText: "Last name"
                ),
                _buildTextFormField(
                  controller: emailController,
                  hintText: "E-mail"
                ),
                Container(
                  margin: EdgeInsets.only(left: 5, right: 5),
                  child: RaisedButton(
                    child: Text("Save"),
                    onPressed: () {
                      if(_formKey.currentState.validate()) {
                        print("valid !");
                        _setLoading(true);
                        widget.presenter.addUser(
                          User(
                            username: usernameController.text,
                            password: passwordController.text,
                            name: nameController.text,
                            lastName: lastnameController.text,
                            email: emailController.text
                          )
                        )
                        .catchError((error) {
                          print("$error");
                        })
                        .whenComplete((){
                          Navigator.of(context).pop();
                          _setLoading(false);
                        });
                      }
                    },
                  ),
                )

              ],
            ),
          ),
          
        ],
      )
    );
  }

  _setLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  _buildTextFormField({
    bool obsecureText = false,
    @required TextEditingController controller,
    String hintText,
  }) {
    return CustomTextFormField(
      isObsecure: obsecureText,
      controller: controller,
      hintText: hintText,
    );
  }
}