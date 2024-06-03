import 'package:get/get.dart';
import 'package:prescribo/models/patient_prescription_response.dart';
import 'package:prescribo/models/patient_response.dart';
import 'package:prescribo/models/user_details.dart';
import 'package:prescribo/services/remote_services.dart';
import 'package:prescribo/utils/constants.dart';

class DashboardController extends GetxController {
  var isClicked = false.obs;

  RxString userType = ''.obs;
  RxString username = ''.obs;
  RxString noUser = ''.obs;
  RxBool isLoading = false.obs;
  Rx<PatientResponse> patient = PatientResponse().obs;

  Future<void> fetchData() async {
    try {
      isLoading.value = true; // Set isLoading to true when fetching data
      // Fetch user details and patient details concurrently
      final userDetailsFuture = RemoteServices.userDetails();
      final patientDetailsFuture = RemoteServices.patientDetail();

      // Await both futures
      final userDetails = await userDetailsFuture;
      final patientDetails = await patientDetailsFuture;

      if (userDetails != null) {
        userType.value = userDetails.userType!;
        // Navigate to viewPatientDetail only if userDetails exist
        if (userType.value == "patient") {
          if (patientDetails != null) {
            patient.value = patientDetails;
          }
          if (patientDetails != null && patientDetails.detail != null) {
            Get.showSnackbar(Constants.customSnackBar(
                tag: false, message: "kindly update your profile"));
            Get.toNamed("/updateProf");
          }
        }
      }
    } catch (e) {
      // Handle errors if any
      print('Error fetching data: $e');
    } finally {
      isLoading.value = false; // Set isLoading to false after data is fetched
    }
  }

  // getUserDetails() async {
  //   try {
  //     isLoading.value = true; // Set isLoading to true when fetching data
  //     UserDetailResponse? user = await RemoteServices.userDetails();

  //     if (user != null) {
  //       userType.value = user.userType!;
  //     }
  //   } finally {
  //     isLoading.value = false; // Set isLoading to false after data is fetched
  //   }
  // }

  // getPatientDetails() async {
  //   try {
  //     isLoading.value = true; // Set isLoading to true when fetching data
  //     PatientResponse? patient = await RemoteServices.patientDetail();

  //     if (patient != null) {
  //       if (patient.detail != null) {
  //         Get.toNamed("/updateProf");
  //       }
  //     }
  //   } finally {
  //     isLoading.value = false; // Set isLoading to false after data is fetched
  //   }
  // }

  getUserDetailsWithUsername(String? username) async {
    PatientResponse? patient =
        await RemoteServices.patientDetail(username: username);

    if (patient != null) {
      Get.close(1);
      Get.toNamed("/viewPatientDetail", arguments: {'patient': patient});
    } else {
      noUser.value = "User Not Found";
    }
  }
  // getUserDetailsWithUsername(String? username) async {
  //   UserDetailResponse? user =
  //       await RemoteServices.userDetails(username: username);

  //   if (user != null) {
  //     Get.close(1);
  //     Get.toNamed("/viewPatientDetail", arguments: {'user': user});
  //   } else {
  //     noUser.value = "User Not Found";
  //   }
  // }

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    await fetchData();
  }
}
