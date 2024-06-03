import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prescribo/utils/defaultText.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QR extends StatelessWidget {
  QR({super.key});

  final data = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: DefaultText(text: "Prescription Qr Code")),
      body: Center(
        child: QrImage(
          data: data['id'],
          size: 200,
        ),
      ),
    );
  }
}
