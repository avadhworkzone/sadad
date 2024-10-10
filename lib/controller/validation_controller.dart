import 'package:get/get.dart';

class ValidationController extends GetxController {
  RxBool? forgotPasswordFlag = false.obs;
  RxInt? forgotPasswordPageIndex = 0.obs;
  RxBool? progressVisible = false.obs;
  RxBool? termCondition = false.obs;
  RxBool? rememberLogin = false.obs;
  RxBool? isLoading = false.obs;
  RxBool? obscureText = true.obs;
  RxString? selectRole = ''.obs;

  void updateRole(String role) {
    selectRole = role.obs;
    update();
  }

  void updateWidget() {
    update();
  }

  void chnageTC() {
    print("Controllar call");
    termCondition = termCondition!.toggle() as RxBool?;
    update();
  }

  void toggle() {
    obscureText = obscureText!.toggle() as RxBool?;
    update();
  }
}
