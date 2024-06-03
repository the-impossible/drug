import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:prescribo/controller/login_controller.dart';
import 'package:prescribo/services/remote_services.dart';
import 'package:prescribo/utils/constants.dart';
import 'package:prescribo/utils/defaultButton.dart';
import 'package:prescribo/utils/defaultText.dart';
import 'package:prescribo/utils/defaultTextFormField.dart';

class Login extends StatelessWidget {
  final _formkey = GlobalKey<FormState>();
  final controller = Get.put(LoginController());

  _login() async {
    var isValid = _formkey.currentState!.validate();
    if (!isValid) return;
    _formkey.currentState!.save();
    controller.isClicked.value = true;

    await RemoteServices.login(
        controller.username.value, controller.password.value);

    controller.isClicked.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.backgroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  "assets/images/pill_bottle.svg",
                  width: 120,
                  height: 120,
                ),
                const SizedBox(height: 20),
                const DefaultText(
                  text: "Welcome Back",
                  color: Colors.black,
                  size: 30,
                  weight: FontWeight.bold,
                ),
                const SizedBox(height: 30),
                Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      DefaultTextFormField(
                        obscureText: false,
                        label: "Username",
                        icon: Icons.person,
                        fillColor: Colors.white,
                        validator: Constants.validator,
                        onSaved: (newValue) =>
                            controller.username.value = newValue!,
                        keyboardInputType: TextInputType.text,
                        // maxLines: 1,
                      ),
                      const SizedBox(height: 20),
                      Obx(() => DefaultTextFormField(
                            obscureText: controller.passwordHidden.value,
                            label: "Password",
                            icon: Icons.lock,
                            maxLines: 1,
                            fillColor: Colors.white,
                            validator: Constants.validator,
                            onSaved: (newValue) =>
                                controller.password.value = newValue!,
                            suffixIcon: GestureDetector(
                              onTap: () => controller.passwordHidden.value =
                                  !controller.passwordHidden.value,
                              child: Icon(controller.passwordHidden.value
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                            ),
                          )),
                      const SizedBox(height: 40),
                      SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Obx(() => DefaultButton(
                                onPressed: () {
                                  _login();
                                },
                                textSize: 18,
                                child: Constants.loadingCirc(
                                    "Login", controller.isClicked.value),
                                // text: "Login",
                              )))
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: InkWell(
                    onTap: () => Get.toNamed('/register'),
                    child: RichText(
                        text: const TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: Colors.black87,
                                fontSize: 18),
                            children: [
                          TextSpan(
                            text: "Create One",
                            style: TextStyle(
                                color: Constants.primaryColor,
                                fontWeight: FontWeight.bold),
                          )
                        ])),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
