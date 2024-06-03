import 'dart:convert';

import 'package:get/get.dart';
import 'package:prescribo/controller/dashboard_controller.dart';
import 'package:prescribo/controller/login_controller.dart';
import 'package:prescribo/controller/registration_controller.dart';
import 'package:prescribo/main.dart';
import 'package:prescribo/models/drugs_response.dart';
import 'package:prescribo/models/login_response.dart';
import 'package:prescribo/models/patient_prescription_response.dart';
import 'package:prescribo/models/patient_response.dart';
import 'package:prescribo/models/prescription_create_response.dart';
import 'package:prescribo/models/register_response.dart';
import 'package:http/http.dart' as http;
import 'package:prescribo/models/user_details.dart';
import 'package:prescribo/models/user_update.dart';
import 'package:prescribo/services/urls.dart';
import 'package:prescribo/utils/constants.dart';

class RemoteServices {
  static Future<RegisterResponse?> registration(
    context,
    String? username,
    String? email,
    String? password1,
    String? password2,
  ) async {
    try {
      http.Response response = await http.post(
        registerUri,
        body: jsonEncode({
          "username": username,
          "email": email,
          "password1": password1,
          "password2": password2,
        }),
        headers: <String, String>{
          'content-type': 'application/json; charset=UTF-8',
        },
      );
      var responseData = jsonDecode(response.body);
      print("responseData");
      print(responseData);
      if (response.statusCode == 201) {
        Get.showSnackbar(Constants.customSnackBar(
            tag: true, message: "Account Successfully Created"));
        sharedPreferences.setString('token', responseData['token']);

        Get.toNamed("/updateProf");
      } else {
        Get.put(RegistrationController()).isClicked.value = false;
        Constants.printValues(responseData);
        // throw Exception("Error: ${response.reasonPhrase}");
      }
    } catch (e) {
      print(e);
      Get.put(RegistrationController()).isClicked.value = false;
      Get.showSnackbar(Constants.customSnackBar(tag: false, message: "$e"));
    }
    return null;
  }

  static Future<UserUpdateResponse?> updateDetails(
      String? firstName,
      String? lastName,
      String? phone,
      String? gender,
      String? address,
      String? dob) async {
    try {
      http.Response response = await http.put(userUpdateUri,
          body: jsonEncode({
            "user": {"last_name": lastName, "first_name": firstName},
            "phone": phone,
            "gender": gender,
            "address": address,
            "dob": dob
          }),
          headers: {
            'content-type': 'application/json; charset=UTF-8',
            'Authorization': "Token ${sharedPreferences.getString('token')}"
          });
      var responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Get.showSnackbar(Constants.customSnackBar(
            tag: true, message: "Bio successfully updated"));
        Get.offAllNamed("/dashboard");
      } else {
        Get.put(RegistrationController()).isClicked.value = false;
        Constants.printValues(responseData);
      }
    } catch (e) {
      print(e);
      Get.put(RegistrationController()).isClicked.value = false;
      Get.showSnackbar(Constants.customSnackBar(tag: false, message: "$e"));
    }
    return null;
  }

  static Future<UserDetailResponse?> userDetails({String? username}) async {
    try {
      http.Response response;
      if (username != null) {
        response = await http.get(Uri.parse("$baseUrl/auth/user/$username/"),
            headers: {
              'Authorization': "Token ${sharedPreferences.getString('token')}"
            });
      } else {
        response = await http.get(userUri, headers: {
          'Authorization': "Token ${sharedPreferences.getString('token')}"
        });
      }
      if (response.statusCode == 200) {
        // print(response.body);
        return userDetailResponseFromJson(response.body);
      } else {
        print(response.reasonPhrase);
        throw Exception("${response.reasonPhrase}");
      }
    } catch (e) {
      Get.showSnackbar(Constants.customSnackBar(
          message: "An error occurred: $e", tag: false));
    }
    return null;
  }

  static Future<PatientResponse?> patientDetail({String? username}) async {
    try {
      http.Response response;
      if (username != null) {
        response = await http.get(Uri.parse("$baseUrl/auth/patient/$username/"),
            headers: {
              'Authorization': "Token ${sharedPreferences.getString('token')}"
            });
      } else {
        response = await http.get(patientUri, headers: {
          'Authorization': "Token ${sharedPreferences.getString('token')}"
        });
      }

      if (response.statusCode == 200) {
        // print("patient: ${response.body}");
        return patientResponseFromJson(response.body);
      } else {
        var responseData = jsonDecode(response.body);
        // print(responseData);
        if (responseData['detail'] != null) {
          return patientResponseFromJson(response.body);
        }
      }
    } catch (e) {
      Get.showSnackbar(Constants.customSnackBar(
          message: "An error occurred: $e", tag: false));
    }
    return null;
  }

  static Future<LoginResponse?> login(
      String? username, String? password) async {
    try {
      http.Response response = await http
          .post(loginUri, body: {"username": username, "password": password});
      var responseData = jsonDecode(response.body);
      if (responseData != null) {
        if (responseData['key'] != null) {
          sharedPreferences.setString('token', responseData['key']);

          Get.offAllNamed('/dashboard');
        } else if (responseData['non_field_errors'] != null) {
          Get.put(LoginController()).isClicked.value = false;
          Constants.printValues(responseData);
        }
      }
    } catch (e) {
      Get.put(LoginController()).isClicked.value = false;
      Get.showSnackbar(Constants.customSnackBar(
          message: "An error occurred: $e", tag: false));
    }

    return null;
  }

  static Future<List<DrugsResponse>?>? drugList() async {
    try {
      http.Response response = await http.get(drugsUri, headers: {
        'Authorization': "Token ${sharedPreferences.getString('token')}"
      });
      if (response.statusCode == 200) {
        return drugsResponseFromJson(response.body);
      } else {
        throw Exception("Failed to get medicine");
      }
    } catch (e) {
      Get.showSnackbar(
          Constants.customSnackBar(message: "Server Error: $e", tag: false));
    }
  }

  static Future<DrugsResponse?> addDrug(
      {String? name, double? gram, String? expireDate, double? price}) async {
    try {
      http.Response response = await http.post(drugsUri,
          body: jsonEncode({
            "name": name,
            "gram": gram,
            "expiry_date": expireDate,
            "price": price
          }),
          headers: {
            'content-type': 'application/json; charset=UTF-8',
            'Authorization': "Token ${sharedPreferences.getString('token')}"
          });
      if (response.statusCode == 201) {
        Get.showSnackbar(Constants.customSnackBar(
            tag: true, message: "Drug Successfully Added"));
      } else {
        print(response.body);
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      Get.showSnackbar(Constants.customSnackBar(tag: false, message: "$e"));
    }
    return null;
  }

  static Future<DrugsResponse?> updateDrug(
      {String? id,
      String? name,
      double? gram,
      String? expireDate,
      double? price}) async {
    try {
      http.Response response = await http.put(
          Uri.parse("$baseUrl/core/drugs/$id/"),
          body: jsonEncode({
            "name": name,
            "gram": gram,
            "expiry_date": expireDate,
            "price": price
          }),
          headers: {
            'content-type': 'application/json; charset=UTF-8',
            'Authorization': "Token ${sharedPreferences.getString('token')}"
          });
      if (response.statusCode == 200) {
        Get.showSnackbar(
            Constants.customSnackBar(tag: true, message: "Drug Updated"));
        Get.close(2);
      } else {
        Get.showSnackbar(
            Constants.customSnackBar(tag: true, message: response.body));

        print(response.body);
      }
    } catch (e) {}
  }

  static Future<PrescriptionCreateResponse?> prescribeDrugs(
      {required List<Map<String, dynamic>>? drugsPrescribe,
      required String patient,
      bool? payment,
      required String diagnosis}) async {
    try {
      http.Response response = await http.post(prescribeUri,
          body: jsonEncode({
            "drug_prescribed": drugsPrescribe,
            "diagnosis": diagnosis,
            "payment_status": false,
            "patient": patient
          }),
          headers: {
            'content-type': 'application/json; charset=UTF-8',
            'Authorization': "Token ${sharedPreferences.getString('token')}"
          });
      if (response.statusCode == 201) {
        Get.showSnackbar(
            Constants.customSnackBar(message: "Prescription Saved", tag: true));
        // return prescriptionCreateResponseFromJson(response.body);
      } else {
        throw Exception("${response.reasonPhrase}");
      }
    } catch (e) {
      Get.showSnackbar(
          Constants.customSnackBar(message: "Server Error: $e", tag: false));
    }
  }

  static Future<List<PatientPrescriptionResponse?>?> patientPrescriptions(
      {String? id}) async {
    try {
      http.Response response;
      if (id != null) {
        response = await http.get(Uri.parse("$baseUrl/core/prescriptions/$id/"),
            headers: {
              'Authorization': "Token ${sharedPreferences.getString('token')}"
            });
      } else {
        response = await http.get(patientPrescriptionsUri, headers: {
          'content-type': 'application/json; charset=UTF-8',
          'Authorization': "Token ${sharedPreferences.getString('token')}"
        });
      }

      if (response.statusCode == 200) {
        print(response.body);
        return patientPrescriptionResponseFromJson(response.body);
      } else {
        print("error");
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      Get.showSnackbar(Constants.customSnackBar(tag: false, message: "$e"));
    }
    return null;
  }

  static Future<bool> paymentStatus(String presId) async {
    try {
      http.Response response = await http.put(
          Uri.parse("$baseUrl/core/prescription/$presId/payment/"),
          body: jsonEncode({"payment_status": true}),
          headers: {
            'content-type': 'application/json; charset=UTF-8',
            'Authorization': "Token ${sharedPreferences.getString('token')}"
          });
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception("${response.reasonPhrase}");
      }
    } catch (e) {
      Get.showSnackbar(Constants.customSnackBar(tag: false, message: "$e"));
    }
    return false;
  }
}
