import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prescribo/screens/dashboard.dart';
import 'package:prescribo/screens/drugs.dart';
import 'package:prescribo/screens/login.dart';
import 'package:prescribo/screens/payment_success.dart';
import 'package:prescribo/screens/prescribe_drug.dart';
import 'package:prescribo/screens/prescription_detail.dart';
import 'package:prescribo/screens/qr.dart';
import 'package:prescribo/screens/scanner/qr_scanner.dart';
import 'package:prescribo/screens/scanner/result.dart';
import 'package:prescribo/screens/update_profile.dart';
import 'package:prescribo/screens/view_detail.dart';
import 'package:prescribo/screens/register.dart';
import 'package:prescribo/screens/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharedPreferences;

void main(List<String> args) async {
  runApp(const Prescribo());
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
}

class Prescribo extends StatelessWidget {
  const Prescribo({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PRESCRIBO',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: "/",
      getPages: [
        GetPage(name: "/", page: () => const SplashScreen()),
        GetPage(name: "/login", page: () => Login()),
        GetPage(name: "/register", page: () => Register()),
        GetPage(name: "/updateProf", page: () => UpdateProfile()),
        GetPage(name: "/dashboard", page: () => Dashboard()),
        GetPage(name: "/viewPatientDetail", page: () => ViewPatientDetail()),
        GetPage(name: "/prescribeDrug", page: () => PrescribeDrug()),
        GetPage(name: "/drugs", page: () => Drugs()),
        GetPage(name: "/scan", page: () => const Scan()),
        GetPage(name: "/result", page: () => ScannedQR()),
        GetPage(name: "/payment_success", page: () => PaymentSuccessful()),
        GetPage(name: "/qr", page: () => QR()),
        GetPage(
            name: "/prescriptionDetails", page: () => PrescriptionDetails()),
      ],
    );
  }
}
