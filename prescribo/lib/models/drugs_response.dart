// To parse this JSON data, do
//
//     final drugsResponse = drugsResponseFromJson(jsonString);

import 'dart:convert';

List<DrugsResponse> drugsResponseFromJson(String str) =>
    List<DrugsResponse>.from(
        json.decode(str).map((x) => DrugsResponse.fromJson(x)));

String drugsResponseToJson(List<DrugsResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DrugsResponse {
  final String? drugId;
  final String? name;
  final double? gram;
  final DateTime? expiryDate;
  final double? price;

  DrugsResponse({
    this.drugId,
    this.name,
    this.gram,
    this.expiryDate,
    this.price,
  });

  factory DrugsResponse.fromJson(Map<String, dynamic> json) => DrugsResponse(
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
