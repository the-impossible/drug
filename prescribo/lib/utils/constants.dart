import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:prescribo/controller/drug_controller.dart';
import 'package:prescribo/models/drugs_response.dart';
import 'package:prescribo/services/remote_services.dart';
import 'package:prescribo/utils/defaultButton.dart';
import 'package:prescribo/utils/defaultText.dart';
import 'package:intl/intl.dart';
import 'package:prescribo/utils/defaultTextFormField.dart';

class Constants {
  static const Color primaryColor = Color(0xFF5A81FA);
  static const Color altColor = Color(0xFFCDDEFF);
  static const Color backgroundColor = Color(0xFFF2F5FF);
  static const Color secondaryColor = Color(0xFF2C3D8F);
  static const Color containerColor = Color.fromARGB(255, 189, 162, 122);

  static Widget loadingCirc(String action, bool isClicked) {
    if (isClicked) {
      print(isClicked);
      return const CircularProgressIndicator(color: Constants.altColor);
    } else {
      print(isClicked);

      return DefaultText(text: action, color: Colors.white, size: 18.0);
    }
  }

  static String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return "Field is required";
    }
    return null;
  }

  static String? drugValidator(DrugsResponse? value) {
    if (value == null) {
      return "Field is required";
    }
    return null;
  }

  static customSnackBar({String? title, String? message, required bool tag}) {
    return GetSnackBar(
        title: title,
        // message: message,
        messageText: DefaultText(
          text: message,
          color: Colors.white,
        ),
        backgroundColor: tag ? Colors.green : Colors.red,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
        snackStyle: SnackStyle.FLOATING,
        margin: const EdgeInsets.all(20.0),
        borderRadius: 10);
  }

  static printValues(dynamic responseData) {
    responseData.forEach((key, value) {
      if (value is List) {
        // If the value is a list, join its elements into a single string
        var joinedValue = value.join(', ');
        Get.showSnackbar(Constants.customSnackBar(
            tag: false, message: "$key: $joinedValue"));
      } else if (value is Map<String, dynamic>) {
        value.forEach((key, innerValue) {
          if (innerValue is Iterable) {
            // If the inner value is an iterable (like a list), join its elements into a single string
            var joinedValue = innerValue.join(', ');
            Get.showSnackbar(Constants.customSnackBar(
                tag: false, message: "$key: $joinedValue"));
          } else {
            Get.showSnackbar(Constants.customSnackBar(
                tag: false, message: "$key: $innerValue"));
          }
        });
      } else {
        responseData.forEach((key, value) {
          Get.showSnackbar(
              Constants.customSnackBar(tag: false, message: "$key: $value"));
        });
      }
    });
  }

  static dialogBox(context,
      {String? text,
      Color? color,
      Color? textColor,
      Widget? icon,
      List<Widget>? actions,
      bool barrier = false,
      Widget? content}) {
    return showDialog(
        barrierDismissible: barrier,
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: color,
              content: SizedBox(
                height: 150.0,
                child: Column(
                  children: [
                    if (icon != null) icon,
                    const SizedBox(height: 10.0),
                    if (content != null) content,
                  ],
                ),
              ),
              actions: actions,
            ));
  }

  static void showDrugDetails(
      Size size,
      String drugId,
      String nameText,
      String priceText,
      String gramText,
      String expiryDateText,
      BuildContext context) {
    final _form = GlobalKey<FormState>();
    late String _name, _price, _gram, _expiryDate;

    final controller = Get.put(DrugController());

    TextEditingController name = TextEditingController(text: nameText);
    TextEditingController price = TextEditingController(text: priceText);
    TextEditingController gram = TextEditingController(text: gramText);
    TextEditingController expiryDate =
        TextEditingController(text: expiryDateText);

    controller.expiryDate.value.text = expiryDateText;

    updateDrug(String id) async {
      var isValid = _form.currentState!.validate();
      if (!isValid) return;
      _form.currentState!.save();

      controller.isClicked.value = true;
      await RemoteServices.updateDrug(
          id: id,
          name: _name,
          price: double.parse(_price),
          gram: double.parse(_gram),
          expireDate: _expiryDate);

      // print("Data collected: $_name, $_expiryDate");
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))),
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                        text: name,
                        obscureText: false,
                        hintText: "Name",
                        label: "Name",
                        validator: Constants.validator,
                        onSaved: (newValue) => _name = newValue!,
                      ),
                      const SizedBox(height: 20.0),
                      DefaultTextFormField(
                        text: price,
                        obscureText: false,
                        hintText: "Price",
                        label: "Price",
                        validator: Constants.validator,
                        keyboardInputType: TextInputType.number,
                        onSaved: (newValue) => _price = newValue!,
                      ),
                      const SizedBox(height: 20.0),

                      DefaultTextFormField(
                        text: gram,
                        obscureText: false,
                        hintText: "Gram",
                        label: "Gram",
                        validator: Constants.validator,
                        keyboardInputType: TextInputType.number,
                        onSaved: (newValue) => _gram = newValue!,
                      ),
                      const SizedBox(height: 20.0),

                      DefaultTextFormField(
                        text: controller.expiryDate.value,
                        onTap: () =>
                            Get.put(DrugController()).pickDate(context),
                        obscureText: false,
                        hintText: "Expiry Date",
                        label: "Expiry Date",
                        validator: Constants.validator,
                        keyboardInputType: TextInputType.none,
                        onSaved: (newValue) => _expiryDate = newValue!,
                      ),
                      // const Spacer(),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        width: size.width,
                        child: Obx(() => DefaultButton(
                            onPressed: () {
                              // controller.isClicked.value = true;
                              updateDrug(drugId);
                            },
                            textSize: 18,
                            child: Constants.loadingCirc(
                                "Update Drug", controller.isClicked.value)

                            // const DefaultText(
                            //   text: "Update Drug",
                            //   size: 18.0,
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
      },
    );
  }
}
