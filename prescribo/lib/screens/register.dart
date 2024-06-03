import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prescribo/controller/registration_controller.dart';
import 'package:prescribo/services/remote_services.dart';
import 'package:prescribo/utils/constants.dart';
import 'package:prescribo/utils/defaultButton.dart';
import 'package:prescribo/utils/defaultText.dart';
import 'package:prescribo/utils/defaultTextFormField.dart';

class Register extends StatelessWidget {
  Register({super.key});

  final _formKey = GlobalKey<FormState>();
  final controller = Get.put(RegistrationController());

  register(context) async {
    var isValid = _formKey.currentState!.validate();
    if (!isValid) return;
    _formKey.currentState!.save();
    controller.isClicked.value = true;

    await RemoteServices.registration(
        context,
        controller.username.value,
        controller.email.value,
        controller.password1.value,
        controller.password2.value);

    controller.isClicked.value = false;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: Constants.backgroundColor,
        appBar: AppBar(
          centerTitle: true,
          title: const DefaultText(text: "Sign Up"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
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
                      DefaultTextFormField(
                        obscureText: false,
                        label: "email",
                        icon: Icons.email,
                        fillColor: Colors.white,
                        validator: Constants.validator,
                        onSaved: (newValue) =>
                            controller.email.value = newValue!,
                        keyboardInputType: TextInputType.emailAddress,
                        // maxLines: 1,
                      ),
                      const SizedBox(height: 20.0),
                      Obx(() => DefaultTextFormField(
                            obscureText: controller.passwordHidden.value,
                            label: "Password",
                            icon: Icons.lock,
                            maxLines: 1,
                            fillColor: Colors.white,
                            validator: Constants.validator,
                            onSaved: (newValue) =>
                                controller.password1.value = newValue!,
                            suffixIcon: GestureDetector(
                              onTap: () => controller.passwordHidden.value =
                                  !controller.passwordHidden.value,
                              child: Icon(controller.passwordHidden.value
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                            ),
                          )),
                      const SizedBox(height: 20.0),
                      Obx(() => DefaultTextFormField(
                            obscureText: controller.passwordHidden.value,
                            label: "Confirm Password",
                            icon: Icons.lock,
                            maxLines: 1,
                            fillColor: Colors.white,
                            validator: Constants.validator,
                            onSaved: (newValue) =>
                                controller.password2.value = newValue!,
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
                                  register(context);
                                },
                                textSize: 18,
                                child: Constants.loadingCirc(
                                    "Register", controller.isClicked.value),
                                // text: "Login",
                              )))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
