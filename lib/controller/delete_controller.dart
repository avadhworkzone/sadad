import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/view/more/deleteAccount/deleteAccountFinalPage.dart';
import 'package:sadad_merchat_app/view/more/deleteAccount/sendOtpScreen.dart';
import 'package:http/http.dart' as http;

class DeleteAccountController extends GetxController {
  String reasonForDelete = "";
  TextEditingController otherController = TextEditingController();
  Timer? timer;
  int counter = 60;
  String code = "";
  List optionList = [
    "Closing my business".tr,
    "Don't feel convenient service/support".tr,
    "Required features aren't available".tr,
    "Security and Privacy concerns".tr,
    "Delay in settlement".tr,
    "Created another account".tr,
    "Others".tr
  ];
  List<bool> optionSelectionList = [];

  List termsAndConditions = [
    "Please note deleting your Sadad account does not release you from any liability related to your account balance, including but not limited to POS terminal rentals, SADAD paid services, disputes etc.".tr,
    "Once you delete your Sadad account, you will no longer be able to process any refunds, issue any payments or respond to any customer disputes.".tr,
    "If you have any reason to believe that you may have further refunds to issue or disputes to respond to, we recommend keeping your account open until those have been resolved.".tr,
    "We also recommend exporting any reports that are required, as Sadad Support has limited access once an account is deleted.".tr,
    "Deleting an account will not prevent settlement payouts from happening (e.g. if an account was deleted today, a withdrawal accepted before delete request would still deposit into the account’s bank account) We strongly recommend waiting until all funds have been successfully paid out to your bank account before deleting your Sadad account.".tr,
    "Your sub users’ accounts would be terminated automatically by Deleting your account.".tr,
    "We delay deletion 60 days after it's requested. A deletion request is cancelled if you log back in to your Sadad account during this time.".tr,
    "After 60 days, your account and all of your information will be permanently deleted, and you won't be able to retrieve your information. You can't regain access once it's deleted".tr,
    "Copies of some information (e.g. log records) may remain in our database but are disassociated from personal identifiers.".tr,
    "Some information may remain visible to others (past Sadad wallet transfer payments history).".tr
  ];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    optionSelectionList = List.filled(optionList.length, false);
  }

  sendOtp({required bool navigate, Widget? navigateScreen}) async {
    String token = await encryptedSharedPreferences.getString('token');
    final url = Uri.parse(Utility.baseUrl + "/usermetaauths/resendOtp?type=deleteuserotp");
    print("url" "$url");
    Map<String, String> header = {'Authorization': token, 'Content-Type': 'application/json'};
    var result = await http.get(url, headers: header);
    print(result.body);
    print(result.statusCode);
    print(result.body);
    if (result.statusCode == 200) {
      if (navigate) {
        Get.to(navigateScreen);
      }
      Get.snackbar('success'.tr, 'OTP Send Successfully'.tr);
    } else if (result.statusCode == 401) {
      Get.to(CanNotDeleteAccScreen(list: []));
    } else {
      Get.snackbar('error', '${jsonDecode(result.body)['error']['message']}');
    }
  }
}
