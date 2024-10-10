import 'package:get/get.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/main.dart';

class MoreController extends GetxController {
  RxString token = "".obs;
  RxBool isLoading = false.obs;
  RxString logoImage =
      Images.qnbABank
          .obs;

  getToken() async {
    isLoading.value = true;
    token.value = await encryptedSharedPreferences.getString('token');
    isLoading.value = false;
  }
}
