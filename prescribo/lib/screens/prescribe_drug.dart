import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prescribo/controller/prescribe_controller.dart';
import 'package:prescribo/models/drugs_response.dart';
import 'package:prescribo/models/user_details.dart';
import 'package:prescribo/services/remote_services.dart';
import 'package:prescribo/utils/constants.dart';
import 'package:prescribo/utils/defaultButton.dart';
import 'package:prescribo/utils/defaultText.dart';
import 'package:prescribo/utils/defaultTextFormField.dart';

class PrescribeDrug extends StatelessWidget {
  PrescribeDrug({super.key});

  final _form = GlobalKey<FormState>();
  final controller = Get.put(PrescribeController());

  removeDrug(int index, var removedItem, var drugId) {
    controller.drugList.removeAt(index);

    controller.drugPrescribed
        .removeWhere((element) => element['drug'] == drugId);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Constants.backgroundColor,
        appBar: AppBar(
          title: const DefaultText(text: "Prescribe"),
          centerTitle: true,
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Expanded(
                    child: Form(
                      key: _form,
                      child: Column(
                        children: [
                          DefaultTextFormField(
                            // text: controller.diagnosis.value,
                            obscureText: false,
                            hintText: "Diagnosis",
                            label: "Diagnosis",
                            validator: Constants.validator,
                            fillColor: Colors.white,
                            onSaved: (newValue) =>
                                controller.diagnosis.value = newValue!,
                          ),
                          const SizedBox(height: 20.0),
                          DropdownSearch<DrugsResponse>(
                            mode: Mode.MENU,
                            items: controller.drugs,
                            itemAsString: (DrugsResponse? drug) => drug!.name!,
                            showSearchBox: true,
                            dropdownSearchDecoration: const InputDecoration(
                                labelText: "Drug",
                                fillColor: Colors.white,
                                filled: true,
                                border: UnderlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
                                    borderSide:
                                        BorderSide(color: Colors.white))),
                            onChanged: (value) {
                              controller.drug!.value = value!.name!;
                              controller.price!.value = value.price!;
                              controller.drugId!.value = value.drugId!;
                            },
                            validator: Constants.drugValidator,
                          ),
                          const SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: DefaultTextFormField(
                                text: controller.qtyTxt.value,
                                label: "Quantity",
                                obscureText: false,
                                icon: Icons.date_range_outlined,
                                fillColor: Colors.white,
                                maxLines: 1,
                                keyboardInputType: TextInputType.number,
                                onSaved: (value) =>
                                    controller.qty!.value = value!,
                              )),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: DefaultTextFormField(
                                  text: controller.dosageTxt.value,
                                  label: "Dosage",
                                  obscureText: false,
                                  icon: Icons.date_range_outlined,
                                  fillColor: Colors.white,
                                  maxLines: 1,
                                  keyboardInputType: TextInputType.text,
                                  onSaved: (value) =>
                                      controller.dosage!.value = value!,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(() => DefaultText(
                                      text:
                                          "Total: ${controller.calculateTotal(controller.drugList)}",
                                      size: 18.0,
                                      color: Constants.secondaryColor,
                                    )),
                                DefaultButton(
                                    onPressed: () {
                                      var isValid =
                                          _form.currentState!.validate();
                                      if (!isValid) return;

                                      _form.currentState!.save();
                                      controller.populateTable();
                                    },
                                    textSize: 15.0,
                                    child: const DefaultText(
                                      text: "Add Drug to List",
                                      size: 15,
                                    ))
                              ],
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Obx(() => Expanded(
                                flex: 3,
                                child: ListView(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  children: [
                                    Table(
                                      border: TableBorder.all(),
                                      children: [
                                        const TableRow(
                                            decoration: BoxDecoration(
                                                color:
                                                    Constants.secondaryColor),
                                            children: [
                                              TableCell(
                                                verticalAlignment:
                                                    TableCellVerticalAlignment
                                                        .middle,
                                                child: DefaultText(
                                                  text: "Name",
                                                  size: 18.0,
                                                  color: Constants.altColor,
                                                  align: TextAlign.center,
                                                ),
                                              ),
                                              TableCell(
                                                verticalAlignment:
                                                    TableCellVerticalAlignment
                                                        .middle,
                                                child: DefaultText(
                                                  text: "QTY",
                                                  size: 18.0,
                                                  color: Constants.altColor,
                                                  align: TextAlign.center,
                                                ),
                                              ),
                                              TableCell(
                                                verticalAlignment:
                                                    TableCellVerticalAlignment
                                                        .middle,
                                                child: DefaultText(
                                                  align: TextAlign.center,
                                                  text: "Price",
                                                  size: 18.0,
                                                  color: Constants.altColor,
                                                ),
                                              ),
                                              TableCell(
                                                verticalAlignment:
                                                    TableCellVerticalAlignment
                                                        .middle,
                                                child: DefaultText(
                                                  text: "Total",
                                                  size: 18.0,
                                                  color: Constants.altColor,
                                                  align: TextAlign.center,
                                                ),
                                              ),
                                              TableCell(
                                                verticalAlignment:
                                                    TableCellVerticalAlignment
                                                        .middle,
                                                child: DefaultText(
                                                  text: "Action",
                                                  size: 18.0,
                                                  color: Constants.altColor,
                                                  align: TextAlign.center,
                                                ),
                                              ),
                                            ]),
                                        for (var index = 0;
                                            index < controller.drugList.length;
                                            index++)
                                          TableRow(
                                            children: [
                                              TableCell(
                                                  verticalAlignment:
                                                      TableCellVerticalAlignment
                                                          .top,
                                                  child: DefaultText(
                                                      align: TextAlign.center,
                                                      text: controller
                                                          .drugList[index]
                                                          .name)),
                                              TableCell(
                                                  verticalAlignment:
                                                      TableCellVerticalAlignment
                                                          .middle,
                                                  child: DefaultText(
                                                      align: TextAlign.center,
                                                      text: controller
                                                          .drugList[index]
                                                          .qty)),
                                              TableCell(
                                                  verticalAlignment:
                                                      TableCellVerticalAlignment
                                                          .middle,
                                                  child: DefaultText(
                                                      align: TextAlign.center,
                                                      text: controller
                                                          .drugList[index].price
                                                          .toString())),
                                              TableCell(
                                                  verticalAlignment:
                                                      TableCellVerticalAlignment
                                                          .middle,
                                                  child: DefaultText(
                                                      align: TextAlign.center,
                                                      text: controller
                                                          .drugList[index].total
                                                          .toString())),
                                              TableCell(
                                                  verticalAlignment:
                                                      TableCellVerticalAlignment
                                                          .middle,
                                                  child: IconButton(
                                                      onPressed: () {
                                                        removeDrug(
                                                            index,
                                                            controller.drugList[
                                                                index],
                                                            controller
                                                                .drugList[index]
                                                                .drugId);
                                                        // print(controller.drugList);
                                                        // print(
                                                        //     controller.drugPrescribed);
                                                      },
                                                      icon: const Icon(
                                                        Icons.delete,
                                                        color: Colors.red,
                                                      ))),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                          const Spacer(),
                          SizedBox(
                            width: size.width,
                            child: Obx(() => DefaultButton(
                                  onPressed: () async {
                                    var isValid =
                                        _form.currentState!.validate();
                                    if (!isValid) return;

                                    _form.currentState!.save();
                                    controller.isClicked.value = true;
                                    await RemoteServices.prescribeDrugs(
                                        drugsPrescribe:
                                            controller.drugPrescribed,
                                        patient: controller.data["pk"],
                                        diagnosis: controller.diagnosis.value);
                                    controller.isClicked.value = false;
                                    Get.close(2);
                                  },
                                  textSize: 18,
                                  child: Constants.loadingCirc(
                                      "Prescribe", controller.isClicked.value),
                                )),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        }));
  }
}
