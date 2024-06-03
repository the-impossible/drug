import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:get/get.dart';
import 'package:prescribo/services/remote_services.dart';
import 'package:prescribo/utils/constants.dart';

class PrescriptionDetailController extends GetxController {
  String publicKey = 'pk_test_967fd6ae89cd3a4c7b03b27c93083beab0329110';

  final data = Get.arguments;
  final plugin = PaystackPlugin();
  RxString message = ''.obs;
  RxBool isClicked = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    plugin.initialize(publicKey: publicKey);
  }

  void makePayment(context) async {
    Charge charge = Charge()
      ..amount = data['amount'] * 100
      ..reference = 'ref_${DateTime.now()}'
      ..email = data['email']
      // ..accessCode = '+234'
      ..currency = 'NGN';

    CheckoutResponse response = await plugin.checkout(context,
        method: CheckoutMethod.card, charge: charge);

    if (response.status == true) {
      message.value = 'Payment was successful. Ref: ${response.reference}';
      if (await RemoteServices.paymentStatus(data['pres_id'])) {
        Get.toNamed('/payment_success', arguments: {
          'message': message.value,
          'invoice_number': response.reference,
        });
      } else {
        Get.showSnackbar(
            Constants.customSnackBar(tag: false, message: "An error occurred"));
      }
    } else {
      print(response.message);
    }

    isClicked.value = false;
  }
}
