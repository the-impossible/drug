// To parse this JSON data, do
//
//     final userDetailResponse = userDetailResponseFromJson(jsonString);

import 'dart:convert';

UserDetailResponse userDetailResponseFromJson(String str) => UserDetailResponse.fromJson(json.decode(str));

String userDetailResponseToJson(UserDetailResponse data) => json.encode(data.toJson());

class UserDetailResponse {
    final String? pk;
    final String? username;
    final String? email;
    final String? firstName;
    final String? lastName;
    final String? userType;
    final String? phone;
    final String? gender;
    final String? address;
    final dynamic dob;
    final String? imageMem;

    UserDetailResponse({
        this.pk,
        this.username,
        this.email,
        this.firstName,
        this.lastName,
        this.userType,
        this.phone,
        this.gender,
        this.address,
        this.dob,
        this.imageMem,
    });

    factory UserDetailResponse.fromJson(Map<String, dynamic> json) => UserDetailResponse(
        pk: json["pk"],
        username: json["username"],
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        userType: json["user_type"],
        phone: json["phone"],
        gender: json["gender"],
        address: json["address"],
        dob: json["dob"],
        imageMem: json["image_mem"],
    );

    Map<String, dynamic> toJson() => {
        "pk": pk,
        "username": username,
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "user_type": userType,
        "phone": phone,
        "gender": gender,
        "address": address,
        "dob": dob,
        "image_mem": imageMem,
    };
}
