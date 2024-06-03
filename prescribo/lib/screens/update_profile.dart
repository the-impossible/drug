import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prescribo/controller/registration_controller.dart';
import 'package:prescribo/services/remote_services.dart';
import 'package:prescribo/utils/constants.dart';
import 'package:prescribo/utils/defaultButton.dart';
import 'package:prescribo/utils/defaultDropDown.dart';
import 'package:prescribo/utils/defaultText.dart';
import 'package:prescribo/utils/defaultTextFormField.dart';

class UpdateProfile extends StatelessWidget {
  UpdateProfile({super.key});

  final _formKey = GlobalKey<FormState>();
  final controller = Get.put(RegistrationController());

  update() async {
    var isValid = _formKey.currentState!.validate();
    if (!isValid) return;
    _formKey.currentState!.save();
    controller.isClicked.value = true;

    await RemoteServices.updateDetails(
        controller.firstName.value,
        controller.lastName.value,
        controller.phone.value,
        controller.gender.value,
        controller.address.value,
        controller.DOB.value);

    controller.isClicked.value = false;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: Constants.backgroundColor,
        appBar: AppBar(
          centerTitle: true,
          title: const DefaultText(text: "Bio Data"),
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
                        label: "First Name",
                        icon: Icons.person_pin,
                        fillColor: Colors.white,
                        validator: Constants.validator,
                        onSaved: (newValue) =>
                            controller.firstName.value = newValue!,
                        keyboardInputType: TextInputType.text,
                        // maxLines: 1,
                      ),
                      const SizedBox(height: 20),
                      DefaultTextFormField(
                        obscureText: false,
                        label: "Last Name",
                        icon: Icons.person_pin,
                        fillColor: Colors.white,
                        validator: Constants.validator,
                        onSaved: (newValue) =>
                            controller.lastName.value = newValue!,
                        keyboardInputType: TextInputType.text,
                        // maxLines: 1,
                      ),
                      const SizedBox(height: 20),
                      DefaultTextFormField(
                        obscureText: false,
                        label: "phone",
                        icon: Icons.phone_android,
                        fillColor: Colors.white,
                        validator: Constants.validator,
                        onSaved: (newValue) =>
                            controller.phone.value = newValue!,
                        keyboardInputType: TextInputType.phone,
                        // maxLines: 1,
                      ),
                      const SizedBox(height: 20),
                      DefaultDropDown(
                        onChanged: (value) {
                          controller.dropdown.value = value!;
                        },
                        dropdownMenuItemList: ['male', 'female']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: DefaultText(
                              text: value,
                            ),
                          );
                        }).toList(),
                        text: "Gender",
                        onSaved: (newValue) {
                          controller.gender.value = newValue;
                        },
                        validator: (value) {
                          if (value == null) {
                            return "Select your gender";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      DefaultTextFormField(
                        maxLines: 2,
                        obscureText: false,
                        label: "address",
                        icon: Icons.location_city,
                        fillColor: Colors.white,
                        validator: Constants.validator,
                        onSaved: (newValue) =>
                            controller.address.value = newValue!,
                        keyboardInputType: TextInputType.text,
                        // maxLines: 1,
                      ),
                      const SizedBox(height: 20.0),
                      Obx(() => DefaultTextFormField(
                            text: controller.dob.value,
                            keyboardInputType: TextInputType.none,
                            onTap: () => controller.pickDate(context),
                            onSaved: (newVal) {
                              controller.DOB.value = newVal!;
                            },
                            fillColor: Colors.white,
                            icon: Icons.baby_changing_station,
                            label: "Date of birth",
                            validator: Constants.validator,
                            obscureText: false,
                          )),
                      const SizedBox(height: 40),
                      SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Obx(() => DefaultButton(
                                onPressed: () {
                                  update();
                                },
                                textSize: 18,
                                child: Constants.loadingCirc(
                                    "Update", controller.isClicked.value),
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
