import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:haupcar_test/model/user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
  
class DBService {
  static DBService shared = DBService();
  List<User> _users = [];
  int _currentUserId;
  get users => _users;
  get currentUserId => _currentUserId;
  

  Future init() async{
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int current = (prefs.getInt("userId") ?? 0);
      _currentUserId = current;
      List<User> users;
      try {
        users = await getUsers();
      } catch (e) {
        print("$e");
        await addUser(User(
          username: "admin",
          password: "passw0rd",
          name: "Admin",
          lastName: "Manger",
          email: "admin@manager.com",
          activated: true
        ));
      }
      
      if(users.length <= 0) {
        await addUser(User(
          username: "admin",
          password: "passw0rd",
          name: "Admin",
          lastName: "Manger",
          email: "admin@manager.com",
          activated: true
        ));
      }
    } catch (e) {
    }
  }

  Future<List<User>> getUsers() async{
    String contents = await _read();
    Map<String, dynamic> json = jsonDecode(contents);
    var userlist = json["users"];
    if(userlist is List) {
        _users = userlist.map((data) => User.fromJson(data)).toList();
      print("$userlist");
    }
    return users;
  }
  _increaseUserId() async{
    try {
      SharedPreferences prefs =  await SharedPreferences.getInstance();
      _currentUserId += 1;
      prefs.setInt("userId", _currentUserId);
    } catch (e) {
      throw(e);
    }
  }
  Future<bool> addUser(User user) async {
    try {
      user.userId = _currentUserId;
      await _increaseUserId();
      user.password = hmac(user.password);
      if(!_users.contains(user)) {
        _users.add(user);
      }
      _saveUsers(_users);
      return true;
    } catch (e) {
      print("dbservice.adduser: $e");
      Future.error("Failed to add users");
    }
    return false;
  }

  bool removeUser(String username) {
    try {
      _users.removeWhere((userItem) => userItem.username == username);
      _users.forEach((user) => print(user.username));
      _saveUsers(_users);
      return true;
    } catch (e) {
      print("dbservice.removeuser: $e");
      throw("Failed to remove users");
    }
  }

  String hmac(String data) {
    try {
      var key = utf8.encode("w#!f^*j8bv");
      var bytes = utf8.encode(data);
      var hmacSha256 = Hmac(sha256, key);
      return hmacSha256.convert(bytes).toString();
    } catch (e) {
      print("dbservice.hmac: $e");
      throw("hmac convertion failed : $e");
    }
  }

  _saveUsers(List<User> userlist) {
    String json = jsonEncode({
      "users": userlist
    });
    _write(json);
  }

  _write(String data) async{
    try {
      File file = await _localFile;
      file.writeAsString(data);
    } catch (e) {
      print("dbservice.write: $e");
    }
  }

  Future<String> _read() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      print("dbservice.write: $e");
    }
    return "";
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async{
    final path = await _localPath;
    return File("$path/data.json");
  }
}