import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/model/repo/more/personalInfo/chagePasswordRepo.dart';
import 'package:sadad_merchat_app/staticData/loading_dialog.dart';

class ChangePasswordViewModel extends GetxController {
  TextEditingController confirmPasswordCnt = TextEditingController();
  TextEditingController passwordCnt = TextEditingController();
  TextEditingController currentPasswordCnt = TextEditingController();
  ChangePasswordRepo changePasswordRepo = ChangePasswordRepo();

  void onChangePassword(context) async {
    showLoadingDialog(context: context);
    await changePasswordRepo.changePass(
        password: confirmPasswordCnt.text,
        currentPassword: currentPasswordCnt.text);
    hideLoadingDialog(context: context);
  }
}
