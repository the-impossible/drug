import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prescribo/utils/constants.dart';
import 'package:prescribo/utils/defaultText.dart';

class LoginController extends GetxController {
  var passwordHidden = true.obs;
  var isClicked = false.obs;

  RxString username = ''.obs;
  RxString password = ''.obs;
}
