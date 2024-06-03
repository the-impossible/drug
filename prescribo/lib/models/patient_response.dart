// To parse this JSON data, do
//
//     final patientResponse = patientResponseFromJson(jsonString);

import 'dart:convert';

PatientResponse patientResponseFromJson(String str) =>
    PatientResponse.fromJson(json.decode(str));

String patientResponseToJson(PatientResponse data) =>
    json.encode(data.toJson());

class PatientResponse {
  final User? user;
  final String? pk;
  final String? address;
  final DateTime? dob;
  final String? phone;
  final String? gender;
  final String? detail;

  PatientResponse({
    this.user,
    this.pk,
    this.address,
    this.dob,
    this.phone,
    this.gender,
    this.detail,
  });

  factory PatientResponse.fromJson(Map<String, dynamic> json) =>
      PatientResponse(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        pk: json["pk"],
        address: json["address"],
        dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
        phone: json["phone"],
        gender: json["gender"],
        detail: json["detail"],
      );

  Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "pk": pk,
        "address": address,
        "dob":
            "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
        "phone": phone,
        "gender": gender,
        "detail": detail,
      };
}

class User {
  final String? pk;
  final String? username;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? userType;
  final String? imageMem;

  User({
    this.pk,
    this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.userType,
    this.imageMem,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        pk: json["pk"],
        username: json["username"],
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        userType: json["user_type"],
        imageMem: json["image_mem"],
      );

  Map<String, dynamic> toJson() => {
        "pk": pk,
        "username": username,
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "user_type": userType,
        "image_mem": imageMem,
      };
}
