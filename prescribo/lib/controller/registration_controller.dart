import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:prescribo/utils/constants.dart';
import 'package:prescribo/utils/defaultText.dart';

class RegistrationController extends GetxController {
  var passwordHidden = true.obs;
  var isClicked = false.obs;

  RxString username = ''.obs;
  RxString email = ''.obs;
  RxString firstName = ''.obs;
  RxString lastName = ''.obs;
  RxString phone = ''.obs;
  RxString gender = ''.obs;
  RxString DOB = ''.obs;
  RxString dropdown = ''.obs;
  RxString address = ''.obs;
  RxString password1 = ''.obs;
  RxString password2 = ''.obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  Rx<TextEditingController> dob = TextEditingController().obs;

  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
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
      dob.value.text = DateFormat("yyyy-MM-dd").format(selectedDate.value);
    }
  }
}
