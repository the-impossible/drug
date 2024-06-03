import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:prescribo/services/remote_services.dart';
import 'package:prescribo/utils/constants.dart';
import 'package:prescribo/utils/defaultContainer.dart';
import 'package:prescribo/utils/defaultText.dart';

class ScannedQR extends StatelessWidget {
  ScannedQR({super.key});

  var code = Get.arguments;

  @override
  Widget build(BuildContext context) {
    // print(code);
    return Scaffold(
        appBar: AppBar(
          title: const DefaultText(
            text: "Prescription Details",
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SafeArea(
            child: Center(
                child: Column(
              children: [
                FutureBuilder(
                    future: RemoteServices.patientPrescriptions(id: code),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!.isEmpty) {
                        return const DefaultText(
                          text: "Prescription Not Found",
                          size: 18.0,
                          color: Constants.secondaryColor,
                        );
                      } else if (snapshot.hasData) {
                        var data = snapshot.data!;
                        return Column(
                          children: [
                            Row(
                              children: [
                                ClipOval(
                                    child: Image.memory(
                                  base64Decode(
                                      data[0]!.patient!.user!.imageMem!),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                )),
                                const SizedBox(width: 20.0),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DefaultText(
                                      text:
                                          "${data[0]!.patient!.user!.firstName} - ${data[0]!.patient!.user!.lastName}",
                                      size: 18.0,
                                      color: Constants.secondaryColor,
                                    ),
                                    DefaultText(
                                      text: "${data[0]!.patient!.address}",
                                      size: 18.0,
                                      color: Constants.secondaryColor,
                                    ),
                                    DefaultText(
                                      text: "${data[0]!.patient!.phone}",
                                      size: 18.0,
                                      color: Constants.secondaryColor,
                                    ),
                                    DefaultText(
                                      text: "${data[0]!.patient!.user!.email}",
                                      size: 18.0,
                                      color: Constants.secondaryColor,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 20.0),
                            Row(
                              children: [
                                DefaultText(
                                  text:
                                      "Visitation Date: ${DateFormat("dd-MM-yyyy").format(data[0]!.date!)}",
                                  size: 18.0,
                                  color: Constants.secondaryColor,
                                ),
                                const Spacer(),
                                DefaultText(
                                  text: "Amount: ${data[0]!.total}",
                                  size: 18.0,
                                  color: Constants.secondaryColor,
                                ),
                              ],
                            ),
                            const SizedBox(height: 10.0),
                            Row(
                              children: [
                                DefaultText(
                                  text: "Diagnosis: ${data[0]!.diagnosis}",
                                  size: 18.0,
                                  color: Constants.secondaryColor,
                                ),
                                const Spacer(),
                                data[0]!.paymentStatus!
                                    ? const DefaultText(
                                        text: "PAID",
                                        size: 18.0,
                                        color: Colors.green,
                                      )
                                    : const DefaultText(
                                        text: "NOT PAID",
                                        size: 18.0,
                                        color: Colors.red,
                                      ),
                              ],
                            ),
                            const SizedBox(height: 30.0),
                            const DefaultText(
                              text: "Prescribed Drugs",
                              size: 18.0,
                              color: Constants.primaryColor,
                            ),
                            const Divider(
                              thickness: 1.5,
                            ),
                            data[0]!.drugPrescribed!.isNotEmpty
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    itemCount: data.length,
                                    itemBuilder: (context, index) {
                                      return DefaultContainer(
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              DefaultText(
                                                text:
                                                    "Drug Name: ${data[0]!.drugPrescribed![index].drug!.name}",
                                                size: 18.0,
                                                color: Constants.secondaryColor,
                                              ),
                                              DefaultText(
                                                text:
                                                    "Quantity: ${data[0]!.drugPrescribed![index].quantity}",
                                                size: 18.0,
                                                color: Constants.secondaryColor,
                                              ),
                                              DefaultText(
                                                text:
                                                    "Price: ${data[0]!.drugPrescribed![index].drug!.price}",
                                                size: 18.0,
                                                color: Constants.secondaryColor,
                                              ),
                                              DefaultText(
                                                text:
                                                    "Dosage: ${data[0]!.drugPrescribed![index].dosage}",
                                                size: 18.0,
                                                color: Constants.secondaryColor,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    })
                                : const DefaultText(text: "No Prescribed Drugs")
                          ],
                        );
                      }
                      return const CircularProgressIndicator(
                          color: Constants.secondaryColor);
                    })
              ],
            )),
          ),
        ));
  }
}
