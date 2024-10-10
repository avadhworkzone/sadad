import 'package:get/get.dart';

class MerchantInformationController extends GetxController {
  RxInt selectedTile = 9999.obs;
  RxString linkMessage = "".obs;

  String? mobileError;
  String? emailError;

  RxBool isTermsAndConditionsCheck = false.obs;
}