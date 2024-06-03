import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prescribo/controller/prescription_controller.dart';
import 'package:prescribo/utils/constants.dart';
import 'package:prescribo/utils/defaultContainer.dart';
import 'package:prescribo/utils/defaultText.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PrescriptionDetails extends StatelessWidget {
  PrescriptionDetails({super.key});

  final controller = Get.put(PrescriptionDetailController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        // backgroundColor: Constants.backgroundColor,
        appBar: AppBar(
          title: const DefaultText(text: "Prescription Details"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const DefaultText(
                text: "Below is the list of prescribed drugs",
                size: 18.0,
              ),
              const SizedBox(height: 20.0),
              controller.data['drugs_prescribed'].isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount:
                          controller.data['drugs_prescribed'].length ?? 0,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            SizedBox(
                              width: size.width,
                              child: DefaultContainer(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      DefaultText(
                                        text:
                                            "Drug Name: ${controller.data['drugs_prescribed'][index].drug!.name}",
                                        size: 15.0,
                                        color: Constants.secondaryColor,
                                      ),
                                      DefaultText(
                                        text:
                                            "Quantity: ${controller.data['drugs_prescribed'][index].quantity}",
                                        size: 15.0,
                                        color: Constants.secondaryColor,
                                      ),
                                      DefaultText(
                                        text:
                                            "Price: ${controller.data['drugs_prescribed'][index].drug.price}",
                                        size: 15.0,
                                        color: Constants.secondaryColor,
                                      ),
                                      DefaultText(
                                        text:
                                            "Dosage: ${controller.data['drugs_prescribed'][index].dosage}",
                                        size: 15.0,
                                        color: Constants.secondaryColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            DefaultText(
                              text:
                                  "Total: ${controller.data['drugs_prescribed'][index].total}",
                              size: 15.0,
                              color: Constants.secondaryColor,
                            ),
                          ],
                        );
                      },
                    )
                  : const DefaultText(text: "No Drug was prescribed"),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      print("object");
                      Get.toNamed("/qr",
                          arguments: {'id': controller.data['pres_id']});
                      // Constants.dialogBox(context,
                      //     barrier: true,
                      //     content: QrImage(
                      //       data: controller.data['pres_id'],
                      //       size: 140,
                      //     ));
                    },
                    child: const DefaultText(text: "View Qr Code"),
                  ),
                  !(controller.data['status'])
                      ? GestureDetector(
                          onTap: () {
                            controller.makePayment(context);
                          },
                          child: const DefaultText(text: "Make Payment"),
                        )
                      : const SizedBox.shrink(),
                ],
              )
            ],
          ),
        ));
  }
}
