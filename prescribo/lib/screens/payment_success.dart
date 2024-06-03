// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import 'package:prescribo/services/remote_services.dart';
import 'package:prescribo/utils/constants.dart';
import 'package:prescribo/utils/defaultButton.dart';
import 'package:prescribo/utils/defaultContainer.dart';
import 'package:prescribo/utils/defaultText.dart';

class PaymentSuccessful extends StatelessWidget {
  PaymentSuccessful({super.key});

  final data = Get.arguments;

  // final controller = Get.put(PaymentController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Constants.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 100.0),
            const SizedBox(
              child: Icon(
                Icons.check_circle,
                color: Constants.secondaryColor,
                size: 250,
              ),
            ),
            const SizedBox(height: 20.0),
            DefaultText(
              text: data['message'],
              size: 18.0,
              color: Constants.secondaryColor,
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Constants.altColor),
                  padding:
                      MaterialStateProperty.all(const EdgeInsets.all(15.0)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      side: const BorderSide(color: Constants.primaryColor),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                onPressed: () {
                  Get.close(2);
                },
                child: const DefaultText(
                  color: Constants.primaryColor,
                  text: "Go to Home",
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
