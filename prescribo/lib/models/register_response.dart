// To parse this JSON data, do
//
//     final registerResponse = registerResponseFromJson(jsonString);

import 'dart:convert';

RegisterResponse registerResponseFromJson(String str) =>
    RegisterResponse.fromJson(json.decode(str));

String registerResponseToJson(RegisterResponse data) =>
    json.encode(data.toJson());

class RegisterResponse {
  final String? username;
  final List<String>? email;
  final List<String>? password1;
  final String? password2;
  // final List<String>? username;
  // final List<String>? email;
  // final List<String>? password1;
  // final List<String>? password2;

  RegisterResponse({
    this.username,
    this.email,
    this.password1,
    this.password2,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      RegisterResponse(
        username: json["username"],
        // username: json["username"] == null ? [] : List<String>.from(json["username"]!.map((x) => x)),
        email: json["email"] == null
            ? []
            : List<String>.from(json["email"]!.map((x) => x)),
        password1: json["password1"] == null
            ? []
            : List<String>.from(json["password1"]!.map((x) => x)),
        password2: json["password2"],
        // password2: json["password2"] == null
        //     ? []
        //     : List<String>.from(json["password2"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        // "username": username == null ? [] : List<dynamic>.from(username!.map((x) => x)),
        "email": email == null ? [] : List<dynamic>.from(email!.map((x) => x)),
        "password1": password1 == null
            ? []
            : List<dynamic>.from(password1!.map((x) => x)),
        // "password2": password2 == null
        //     ? []
        //     : List<dynamic>.from(password2!.map((x) => x)),
      };
}
