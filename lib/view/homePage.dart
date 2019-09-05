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
          setState(() {
            _isLoading = true;
          });
          AuthService.shared.logout()
            .then(
              (res) => widget.presenter.routeToLoginPage(context), 
              onError: (erorr) => print("Failed to logout")
            )
            .whenComplete(() {
              setState(() {
                _isLoading = false;
              });
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

  Widget _buildListSection(BuildContext context, List<User> users) {
    return Container(
      child: Card(
        child: ListView(
          children: _buildListViewItem(users),
        ),
      ),
    );
  }

  List<Widget> _buildListViewItem(List<User> users) {
    return users.map<Widget>((user) =>
      ListTile(
        title: Text("${user.name} ${user.lastName}"),
        subtitle: Text("@${user.username}"),
      )
    ).toList();
  }

  _showFormDialog() {
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    final nameController = TextEditingController();
    final lastnameController = TextEditingController();
    final emailController = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) =>
      SimpleDialog(
        title: Text("Add User"),
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: Table(
              // border: TableBorder.all(width: 1),
              children: [
                _buildTableRow(
                  title: "Username",
                  controller: usernameController,
                ),
                _buildTableRow(
                  title: "Password",
                  controller: passwordController,
                ),
                _buildTableRow(
                  title: "Name",
                  controller: nameController,
                ),
                _buildTableRow(
                  title: "Last name",
                  controller: lastnameController,
                ),
                _buildTableRow(
                  title: "E-mail",
                  controller: emailController,
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 5, right: 5),
            child: RaisedButton(
              child: Text("Save"),
              onPressed: (){},
            ),
          )
        ],
      )
    );
  }

  TableRow _buildTableRow({
    String title, 
    bool isObsecure = false,
    TextEditingController controller}) {
    return TableRow(
      children: [
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Text(title),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: CustomTextField(
            isObsecure: isObsecure,
            controller: controller,
            hintText: title,
          ),
        )
      ]
    );
  }
}