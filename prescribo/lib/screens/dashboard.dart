import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:prescribo/controller/dashboard_controller.dart';
import 'package:prescribo/services/remote_services.dart';
import 'package:prescribo/utils/constants.dart';
import 'package:prescribo/utils/defaultButton.dart';
import 'package:prescribo/utils/defaultContainer.dart';
import 'package:prescribo/utils/defaultGesture.dart';
import 'package:prescribo/utils/defaultText.dart';

class Dashboard extends StatelessWidget {
  final controller = Get.put(DashboardController());

  Dashboard({super.key});
  viewDetail() async {}
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: AppBar(
        title: const DefaultText(
          text: "Dashboard",
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (controller.userType.value == 'patient') {
            return SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DefaultText(
                            text:
                                "Welcome, \n ${controller.patient.value.user!.username}",
                            size: 18.0,
                          ),
                          ClipOval(
                              child: Image.memory(
                            base64Decode(
                                controller.patient.value.user!.imageMem!),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ))
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      const DefaultText(
                          size: 18.0,
                          text: "Below cards is your medical history"),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        child: FutureBuilder(
                            future: RemoteServices.patientPrescriptions(),
                            builder: ((context, snapshot) {
                              if (snapshot.hasData && snapshot.data!.isEmpty) {
                                return const DefaultText(
                                  text: "No Prescriptions Found",
                                  size: 18.0,
                                  color: Constants.secondaryColor,
                                );
                              } else if (snapshot.hasData) {
                                var data = snapshot.data!;
                                return ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    return DefaultContainer(
                                      child: GestureDetector(
                                        onTap: (() => Get.toNamed(
                                                "/prescriptionDetails",
                                                arguments: {
                                                  'pres_id':
                                                      data[index]!.presId,
                                                  'drugs_prescribed':
                                                      data[index]!
                                                          .drugPrescribed,
                                                  'amount': data[index]!
                                                      .total!
                                                      .toInt(),
                                                  'status': data[index]!
                                                      .paymentStatus,
                                                  'email': data[index]!
                                                      .patient!
                                                      .user!
                                                      .email
                                                })),
                                        child: ListTile(
                                          title: DefaultText(
                                              text:
                                                  "Diagnosis: ${data[index]!.diagnosis}",
                                              color: Constants.secondaryColor,
                                              size: 15.0),
                                          trailing: DefaultText(
                                              text:
                                                  "Amount: ${data[index]!.total.toString()}"),
                                          subtitle: Row(
                                            children: [
                                              DefaultText(
                                                text:
                                                    "Date: ${DateFormat("dd-MM-yyyy").format(data[index]!.date!)}",
                                                size: 12.0,
                                              ),
                                              const Spacer(),
                                              data[index]!.paymentStatus!
                                                  ? const DefaultText(
                                                      text: "PAID",
                                                      size: 12.0,
                                                      color: Colors.green,
                                                    )
                                                  : const DefaultText(
                                                      text: "NOT PAID",
                                                      size: 12.0,
                                                      color: Colors.red,
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                              return const CircularProgressIndicator(
                                  color: Constants.secondaryColor);
                            })),
                      ),
                      // const Spacer(),
                      const SizedBox(height: 20.0),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 1.5,
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.all(15.0)),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: Constants.primaryColor),
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              Get.toNamed('/scan');
                            },
                            child: const DefaultText(
                              color: Constants.primaryColor,
                              text: "Scan Prescription",
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (controller.userType.value == 'pharmacist') {
            return Column();
          } else if (controller.userType.value == 'doctor') {
            return DoctorWidget();
          } else {
            return Container();
          }
        }
      }),
    );
  }
}

class DoctorWidget extends StatelessWidget {
  DoctorWidget({
    Key? key,
  }) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final controller = Get.put(DashboardController());

  _viewDetail() async {
    var isValid = _formKey.currentState!.validate();
    if (!isValid) return;
    _formKey.currentState!.save();

    controller.getUserDetailsWithUsername(controller.username.value);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // DefaultGesture(
                //   svgAsset: "assets/images/illness.svg",
                //   tag: "Patients",
                //   func: () {
                //     Get.toNamed('/patients');
                //   },
                // ),
                DefaultGesture(
                  svgAsset: "assets/images/pill.svg",
                  tag: "Drugs",
                  func: () {
                    Get.toNamed('/drugs',
                        arguments: {'userType': controller.userType.value});
                  },
                ),
                DefaultGesture(
                  svgAsset: "assets/images/pills_1.svg",
                  tag: "Prescription",
                  func: () {
                    Constants.dialogBox(context,
                        barrier: true,
                        content: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              PatientTextField(),
                              const SizedBox(height: 20.0),
                              DefaultButton(
                                  onPressed: () {
                                    _viewDetail();
                                  },
                                  child:
                                      const DefaultText(text: "View Detail")),
                              DefaultText(text: controller.noUser.value)
                            ],
                          ),
                        ));
                    // Get.toNamed('/prescription');)
                  },
                ),
              ],
            ),
            // const SizedBox(height: 40.0),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     DefaultGesture(
            //       svgAsset: "assets/images/treatment_list.svg",
            //       tag: "Reports",
            //       func: () {
            //         Get.toNamed('/report');
            //       },
            //     ),
            //   ],
            // ),
            const SizedBox(height: 50.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(15.0)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        side: const BorderSide(color: Constants.primaryColor),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    Get.toNamed('/scan');
                  },
                  child: const DefaultText(
                    color: Constants.primaryColor,
                    text: "Scan Prescription",
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PatientTextField extends StatelessWidget {
  PatientTextField({
    Key? key,
  }) : super(key: key);
  final controller = Get.put(DashboardController());
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: Constants.validator,
      onSaved: (newValue) => controller.username.value = newValue!,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10),
        border: const UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            borderSide: BorderSide(color: Colors.white)),
        enabledBorder: const UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            borderSide: BorderSide(color: Colors.white)),
        focusedBorder: const UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            borderSide: BorderSide(color: Colors.white)),
        fillColor: Colors.grey.shade200,
        filled: true,
        hintText: "Enter patient's username",
      ),
      style: const TextStyle(
        fontFamily: 'Montserrat',
      ),
    );
  }
}
