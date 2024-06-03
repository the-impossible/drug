import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:prescribo/utils/constants.dart';
import 'package:prescribo/utils/defaultButton.dart';
import 'package:prescribo/utils/defaultText.dart';

class ViewPatientDetail extends StatelessWidget {
  ViewPatientDetail({super.key});

  final data = Get.arguments;
  // final controller = Get.put(PrescribeController());

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: AppBar(
        title: DefaultText(
            text: "Prescribe Drug for ${data['patient'].user.firstName}"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                  child: Image.memory(
                base64Decode(data['patient'].user.imageMem!),
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              )),
              const SizedBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  DefaultButton(
                      onPressed: () {
                        Get.toNamed("/prescribeDrug", arguments: {
                          'username': data['patient'].user.username,
                          'pk': data['patient'].pk
                        });
                      },
                      child: const DefaultText(text: "Prescribe Drug"))
                ],
              ),
              Row(
                children: [
                  const DefaultText(
                    text: "NAME: ",
                    size: 20.0,
                    color: Constants.secondaryColor,
                  ),
                  DefaultText(
                    text:
                        "${data['patient'].user.firstName} ${data['patient'].user.lastName}",
                    size: 20.0,
                    color: Constants.secondaryColor,
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  const DefaultText(
                    text: "EMAIL: ",
                    size: 20.0,
                    color: Constants.secondaryColor,
                  ),
                  DefaultText(
                    text: "${data['patient'].user.email}",
                    size: 20.0,
                    color: Constants.secondaryColor,
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  const DefaultText(
                    text: "PHONE: ",
                    size: 20.0,
                    color: Constants.secondaryColor,
                  ),
                  DefaultText(
                    text: "${data['patient'].phone}",
                    size: 20.0,
                    color: Constants.secondaryColor,
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  const DefaultText(
                    text: "GENDER: ",
                    size: 20.0,
                    color: Constants.secondaryColor,
                  ),
                  DefaultText(
                    text: "${data['patient'].gender}",
                    size: 20.0,
                    color: Constants.secondaryColor,
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  const DefaultText(
                    text: "DATE OF BIRTH: ",
                    size: 20.0,
                    color: Constants.secondaryColor,
                  ),
                  DefaultText(
                    text: DateFormat("dd-MM-yyyy").format(data['patient'].dob),
                    size: 20.0,
                    color: Constants.secondaryColor,
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  const DefaultText(
                    text: "ADDRESS: ",
                    size: 20.0,
                    color: Constants.secondaryColor,
                  ),
                  DefaultText(
                    text: "${data['patient'].address}",
                    size: 20.0,
                    color: Constants.secondaryColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
