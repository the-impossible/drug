// To parse this JSON data, do
//
//     final userUpdateResponse = userUpdateResponseFromJson(jsonString);

import 'dart:convert';

UserUpdateResponse userUpdateResponseFromJson(String str) => UserUpdateResponse.fromJson(json.decode(str));

String userUpdateResponseToJson(UserUpdateResponse data) => json.encode(data.toJson());

class UserUpdateResponse {
    final String? firstName;
    final String? lastName;
    final List<String>? phone;
    final List<String>? gender;
    final String? address;
    final List<String>? dob;

    UserUpdateResponse({
        this.firstName,
        this.lastName,
        this.phone,
        this.gender,
        this.address,
        this.dob,
    });

    factory UserUpdateResponse.fromJson(Map<String, dynamic> json) => UserUpdateResponse(
        firstName: json["first_name"],
        lastName: json["last_name"],
        phone: json["phone"] == null ? [] : List<String>.from(json["phone"]!.map((x) => x)),
        gender: json["gender"] == null ? [] : List<String>.from(json["gender"]!.map((x) => x)),
        address: json["address"],
        dob: json["dob"] == null ? [] : List<String>.from(json["dob"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "phone": phone == null ? [] : List<dynamic>.from(phone!.map((x) => x)),
        "gender": gender == null ? [] : List<dynamic>.from(gender!.map((x) => x)),
        "address": address,
        "dob": dob == null ? [] : List<dynamic>.from(dob!.map((x) => x)),
    };
}
