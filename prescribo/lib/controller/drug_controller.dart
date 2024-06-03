import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:prescribo/utils/constants.dart';

class DrugController extends GetxController {
  final data = Get.arguments;
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  Rx<TextEditingController> expiryDate = TextEditingController().obs;
  RxBool isClicked = false.obs;

  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                    primary: Constants.primaryColor,
                    onPrimary: Constants.secondaryColor,
                    onSurface: Colors.black)),
            child: child!);
      },
    );
    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
      expiryDate.value.text =
          DateFormat("yyyy-MM-dd").format(selectedDate.value);
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    print(data);
  }
}
