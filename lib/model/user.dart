import 'package:flutter/foundation.dart';
import 'package:haupcar_test/commons/json_property.dart';

class User {
  User({
    @required this.username, 
    @required this.password,
    @required this.userId,
    this.activated = false,
    @required this.name,
    @required this.lastName,
    @required this.email});
  static User shared;
  String username;
  String password;
  int userId;
  bool activated;
  String name;
  String lastName;
  String email;

  Map<String, dynamic> toJson() =>
    {
      JsonProperty.username : username,
      JsonProperty.password : password,
      JsonProperty.userId : userId,
      JsonProperty.activated : activated,
      JsonProperty.name : name,
      JsonProperty.lastName : lastName,
      JsonProperty.email : email
    };

  User.fromJson(Map<String, dynamic> json)
    : username = json[JsonProperty.username],
      password = json[JsonProperty.password],
      userId = json[JsonProperty.userId],
      activated = json[JsonProperty.activated],
      name = json[JsonProperty.name],
      lastName = json[JsonProperty.lastName],
      email = json[JsonProperty.email];

  bool operator ==(other) {
    if(other is User) {
      User user = other; 
      return (user.username == username);
    }
    return false;
  }
  @override
  int get hashCode => username.hashCode;
}