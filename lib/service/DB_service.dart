import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/widgets.dart';
import 'package:haupcar_test/model/user.dart';
import 'package:path_provider/path_provider.dart';
  
class DBService {
  static DBService shared = DBService();
  List<User> _users = [];

  get users => _users;

  Future<List<User>> getUsers() async{
    String contents = await _read();
    Map<String, dynamic> json = jsonDecode(contents);
    var userlist = json["users"];
    if(userlist is List) {
      _users.addAll(
        userlist.map((data) => User.fromJson(data))
      );
      print("$userlist");
    }
    return users;
  }

  addUser(User user) {
    try {
      user.password = hmac(user.password);
      if(!_users.contains(user)) {
        _users.add(user);
      }
      _saveUsers(_users);
      return true;
    } catch (e) {
      print(e);
      throw ErrorDescription("Failed to add users");
    }
  }

  String hmac(String data) {
    try {
      var key = utf8.encode("w#!f^*j8bv");
      var bytes = utf8.encode(data);
      var hmacSha256 = Hmac(sha256, key);
      return hmacSha256.convert(bytes).toString();
    } catch (e) {
      throw ErrorDescription("hmac convertion failed : $e");
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
    }
  }

  Future<String> _read() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      return "";
    }
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