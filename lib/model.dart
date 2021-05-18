import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  UserModel() {
    intializeProperties();
  }
  static bool isUserLoggedIn = false;
  static late String currentUserKey;
  static late List<String>? userKeyValues;
  static late SharedPreferences sharedPreferences;

  Future<void> intializeProperties() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }
}

class User {
  User(
      {this.userMobileNo,
      this.userpassword,
      this.name,
      this.percentage,
      this.photo_url,
      this.played,
      this.rating,
      this.won});
  int? userMobileNo;
  String? userpassword;
  String? name;
  String? played;
  String? won;
  String? percentage;
  String? rating;
  String? photo_url;

  User.fromJson(Map<String, dynamic> json) {
    this.userMobileNo = json['username'];
    this.userpassword = json['password'];
    this.name = json['name'];
    this.played = json['played'];
    this.won = json['won'];
    this.percentage = json['percentage'];
    this.rating = json['rating'];
    this.photo_url = json['photo_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json["username"] = userMobileNo;
    json["password"] = userpassword;
    json['name'] = name;
    json['played'] = played;
    json['won'] = won;
    json['percentage'] = percentage;
    json['rating'] = rating;
    json['photo_url'] = photo_url;
    return json;
  }
}

class Items {
  Items(
      {this.admin_username,
      this.country,
      this.game_icon_url,
      this.game_name,
      this.id,
      this.name,
      this.tournament_url});
  String? id;
  String? game_name;
  String? tournament_url;
  String? admin_username;
  String? game_icon_url;
  String? name;
  String? country;

  Items.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.game_name = json['game_name'];
    this.tournament_url = json['tournament_url'];
    this.admin_username = json['admin_username'];
    this.game_icon_url = json['game_icon_url'];
    this.name = json['name'];
    this.country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json["id"] = id;
    json["game_name"] = game_name;
    json['tournament_url'] = tournament_url;
    json['admin_username'] = admin_username;
    json['game_icon_url'] = game_icon_url;
    json['name'] = name;
    json['country'] = country;
    return json;
  }
}
