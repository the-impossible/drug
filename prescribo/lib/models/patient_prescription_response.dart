// To parse this JSON data, do
//
//     final patientPrescriptionResponse = patientPrescriptionResponseFromJson(jsonString);

import 'dart:convert';

List<PatientPrescriptionResponse> patientPrescriptionResponseFromJson(
        String str) =>
    List<PatientPrescriptionResponse>.from(
        json.decode(str).map((x) => PatientPrescriptionResponse.fromJson(x)));

String patientPrescriptionResponseToJson(
        List<PatientPrescriptionResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PatientPrescriptionResponse {
  final String? presId;
  final Patient? patient;
  final DateTime? date;
  final String? diagnosis;
  final bool? paymentStatus;
  final double? total;
  final String? doctor;
  final List<DrugPrescribed>? drugPrescribed;

  PatientPrescriptionResponse({
    this.presId,
    this.patient,
    this.date,
    this.diagnosis,
    this.paymentStatus,
    this.total,
    this.doctor,
    this.drugPrescribed,
  });

  factory PatientPrescriptionResponse.fromJson(Map<String, dynamic> json) =>
      PatientPrescriptionResponse(
        presId: json["pres_id"],
        patient:
            json["patient"] == null ? null : Patient.fromJson(json["patient"]),
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        diagnosis: json["diagnosis"],
        paymentStatus: json["payment_status"],
        total: json["total"],
        doctor: json["doctor"],
        drugPrescribed: json["drug_prescribed"] == null
            ? []
            : List<DrugPrescribed>.from(json["drug_prescribed"]!
                .map((x) => DrugPrescribed.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pres_id": presId,
        "patient": patient?.toJson(),
        "date": date?.toIso8601String(),
        "diagnosis": diagnosis,
        "payment_status": paymentStatus,
        "total": total,
        "doctor": doctor,
        "drug_prescribed": drugPrescribed == null
            ? []
            : List<dynamic>.from(drugPrescribed!.map((x) => x.toJson())),
      };
}

class DrugPrescribed {
  final String? drugpresId;
  final Drug? drug;
  final String? dosage;
  final int? quantity;
  final double? total;
  final String? prescription;

  DrugPrescribed({
    this.drugpresId,
    this.drug,
    this.dosage,
    this.quantity,
    this.total,
    this.prescription,
  });

  factory DrugPrescribed.fromJson(Map<String, dynamic> json) => DrugPrescribed(
        drugpresId: json["drugpres_id"],
        drug: json["drug"] == null ? null : Drug.fromJson(json["drug"]),
        dosage: json["dosage"],
        quantity: json["quantity"],
        total: json["total"],
        prescription: json["prescription"],
      );

  Map<String, dynamic> toJson() => {
        "drugpres_id": drugpresId,
        "drug": drug?.toJson(),
        "dosage": dosage,
        "quantity": quantity,
        "total": total,
        "prescription": prescription,
      };
}

class Drug {
  final String? drugId;
  final String? name;
  final double? gram;
  final DateTime? expiryDate;
  final double? price;

  Drug({
    this.drugId,
    this.name,
    this.gram,
    this.expiryDate,
    this.price,
  });

  factory Drug.fromJson(Map<String, dynamic> json) => Drug(
        drugId: json["drug_id"],
        name: json["name"],
        gram: json["gram"],
        expiryDate: json["expiry_date"] == null
            ? null
            : DateTime.parse(json["expiry_date"]),
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "drug_id": drugId,
        "name": name,
        "gram": gram,
        "expiry_date": expiryDate?.toIso8601String(),
        "price": price,
      };
}

class Patient {
  final User? user;
  final String? pk;
  final String? address;
  final DateTime? dob;
  final String? phone;
  final String? gender;

  Patient({
    this.user,
    this.pk,
    this.address,
    this.dob,
    this.phone,
    this.gender,
  });

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        pk: json["pk"],
        address: json["address"],
        dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
        phone: json["phone"],
        gender: json["gender"],
      );

  Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "pk": pk,
        "address": address,
        "dob":
            "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
        "phone": phone,
        "gender": gender,
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
