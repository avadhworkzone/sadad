import 'package:get/get.dart';
import 'package:sadad_merchat_app/model/repo/more/personalInfo/changeNameRepo.dart';
import 'package:sadad_merchat_app/staticData/loading_dialog.dart';

class ChangeNameViewModel extends GetxController {
  ChangeNameRepo changeNameRepo = ChangeNameRepo();

  void onChangePassword(context) async {
    showLoadingDialog(context: context);
    await changeNameRepo.changeUserName(context);
    hideLoadingDialog(context: context);
  }
}
