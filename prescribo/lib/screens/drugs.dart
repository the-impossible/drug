import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:prescribo/controller/drug_controller.dart';
import 'package:prescribo/services/remote_services.dart';
import 'package:prescribo/utils/constants.dart';
import 'package:prescribo/utils/defaultButton.dart';
import 'package:prescribo/utils/defaultContainer.dart';
import 'package:prescribo/utils/defaultText.dart';
import 'package:prescribo/utils/defaultTextFormField.dart';

class Drugs extends StatelessWidget {
  Drugs({super.key});

  final _form = GlobalKey<FormState>();
  late String _name, _price, _gram, _expiryDate;

  final controller = Get.put(DrugController());

  _addDrug() async {
    var isValid = _form.currentState!.validate();
    if (!isValid) return;
    _form.currentState!.save();
    controller.isClicked.value = true;

    await RemoteServices.addDrug(
      name: _name,
      price: double.parse(_price),
      gram: double.parse(_gram),
      expireDate: _expiryDate,
    );
    controller.isClicked.value = false;
    Get.close(1);
    // print("Data collected: $_name, $_price");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.backgroundColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios,
                        color: Constants.secondaryColor),
                    iconSize: 25,
                  ),
                  const DefaultText(
                    text: "Drugs",
                    size: 20.0,
                    color: Constants.secondaryColor,
                  )
                ],
              ),
              const SizedBox(height: 40.0),
              const DefaultTextFormField(
                label: "Search by name",
                obscureText: false,
                icon: Icons.search_outlined,
                fillColor: Colors.white,
                maxLines: 1,
              ),
              const SizedBox(height: 30),
              // controller.data['userType'] == 'pharmacist'
              // ?
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  DefaultButton(
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    topRight: Radius.circular(20.0))),
                            builder: (context) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Form(
                                        key: _form,
                                        child: Column(
                                          children: [
                                            DefaultTextFormField(
                                              obscureText: false,
                                              hintText: "Name",
                                              label: "Name",
                                              validator: Constants.validator,
                                              onSaved: (newValue) =>
                                                  _name = newValue!,
                                            ),
                                            const SizedBox(height: 20.0),
                                            DefaultTextFormField(
                                              obscureText: false,
                                              hintText: "Price",
                                              label: "Price",
                                              validator: Constants.validator,
                                              keyboardInputType:
                                                  TextInputType.number,
                                              onSaved: (newValue) =>
                                                  _price = newValue!,
                                            ),
                                            const SizedBox(height: 20.0),
                                            DefaultTextFormField(
                                              obscureText: false,
                                              hintText: "Gram",
                                              label: "Gram",
                                              validator: Constants.validator,
                                              keyboardInputType:
                                                  TextInputType.number,
                                              onSaved: (newValue) =>
                                                  _gram = newValue!,
                                            ),
                                            const SizedBox(height: 20.0),
                                            DefaultTextFormField(
                                              text: controller.expiryDate.value,
                                              onTap: () =>
                                                  controller.pickDate(context),
                                              obscureText: false,
                                              hintText: "Expiry Date",
                                              label: "Expiry Date",
                                              validator: Constants.validator,
                                              keyboardInputType:
                                                  TextInputType.none,
                                              onSaved: (newValue) =>
                                                  _expiryDate = newValue!,
                                            ),
                                            // const Spacer(),
                                            const SizedBox(height: 20.0),
                                            SizedBox(
                                              width: size.width,
                                              child: Obx(() => DefaultButton(
                                                    onPressed: () {
                                                      _addDrug();
                                                    },
                                                    textSize: 18,
                                                    child:
                                                        Constants.loadingCirc(
                                                            "Submit",
                                                            controller.isClicked
                                                                .value),

                                                    // const DefaultText(
                                                    //   text: "Submit",
                                                    // )
                                                  )),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                      textSize: 18,
                      child: const DefaultText(text: "Add Drug"))
                ],
              ),
              // : const SizedBox.shrink(),
              const SizedBox(height: 20.0),
              FutureBuilder(
                  future: RemoteServices.drugList(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!.isEmpty) {
                      return const DefaultText(
                        text: "No Drug",
                      );
                    } else if (snapshot.hasData) {
                      var data = snapshot.data;
                      return Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return DefaultContainer(
                              child: GestureDetector(
                                onTap: () {
                                  Constants.showDrugDetails(
                                      size,
                                      "${data[index].drugId}",
                                      "${data[index].name}",
                                      "${data[index].price}",
                                      "${data[index].gram}",
                                      DateFormat("yyyy-MM-dd")
                                          .format(data[index].expiryDate!),
                                      context);
                                },
                                child: ListTile(
                                  title: DefaultText(
                                      text: data[index].name,
                                      color: Constants.secondaryColor,
                                      size: 18.0),
                                  trailing: DefaultText(
                                      text: data[index].price.toString()),
                                  subtitle: Row(
                                    children: [
                                      DefaultText(
                                        text:
                                            "Expiry Date: ${DateFormat("dd-MM-yyyy").format(data[index].expiryDate!)}",
                                        size: 12.0,
                                      ),
                                      const Spacer(),
                                      DefaultText(
                                        text: "Gram: ${data[index].gram}",
                                        size: 12.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                    return const CircularProgressIndicator(
                        color: Constants.secondaryColor);
                  })
            ],
          ),
        ),
      ),
    );
  }
}
