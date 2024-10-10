import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/controller/delete_controller.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/verifyAccountDeleteModel.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/loading_dialog.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/more/deleteAccount/deleteAccount.dart';
import 'package:sadad_merchat_app/view/more/deleteAccount/deleteAccountFinalPage.dart';
import 'package:sadad_merchat_app/view/more/notification.dart';
import 'package:sadad_merchat_app/view/more/selectlanguage.dart';
import 'package:sadad_merchat_app/widget/BusinessDetails.dart';
import 'package:sadad_merchat_app/widget/fingerAndFace.dart';
import 'package:http/http.dart' as http;

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String face = '';
  String finger = '';
  String isallowtodelete = '';
  @override
  void initState() {
    initData();
    // TODO: implement initState
    isAllowToDelete();
    super.initState();
  }
  void isAllowToDelete() async {
    isallowtodelete = await encryptedSharedPreferences.getString('isAllowToDelete');
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            height24(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text("Settings".tr, style: ThemeUtils.blackSemiBold.copyWith(fontSize: FontUtils.medLarge)),
            ),
            height32(),
            BusinessDetailsWidget(
              name: "Language".tr,
              notification: 0,
              subName: Get.locale.toString() == "ar" ? "Arabic".tr : "English".tr,
              onTap: () => Get.to(() => SelectLanguage()),
            ),
            height16(),
            Divider(thickness: 1, height: 1, color: ColorsUtils.dividerCreateInvoice),
            Container(
              width: double.infinity,
              color: ColorsUtils.createInvoiceContainer,
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Text('Login and security'.tr, style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.medium)),
            ),
            height16(),
            BusinessDetailsWidget(
              name: 'Fingerprint'.tr,
              notification: 0,
              subName: finger == 'true' ? 'Yes'.tr : 'No'.tr,
              onTap: () async {
                await Get.to(FingerAndFaceScreen(
                  text: 'Fingerprint'.tr,
                ));
                initData();
              },
            ),
            Utility.androidVersion <= 32 && Platform.isAndroid ? SizedBox() : dividerData(),
            Utility.androidVersion <= 32 && Platform.isAndroid
                ? SizedBox()
                : BusinessDetailsWidget(
                    name: 'Face detection'.tr,
                    notification: 0,
                    subName: face == 'true' ? 'Yes'.tr : 'No'.tr,
                    onTap: () async {
                      await Get.to(FingerAndFaceScreen(text: 'Face detection'.tr));
                      initData();
                    },
                  ),
            Utility.androidVersion <= 32 && Platform.isAndroid ? SizedBox() : height16(),
            Divider(thickness: 1, height: 1, color: ColorsUtils.dividerCreateInvoice),
            Container(
              width: double.infinity,
              color: ColorsUtils.createInvoiceContainer,
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Text("Notifications".tr, style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.medium)),
            ),
            height15(),
            BusinessDetailsWidget(
              notification: 0,
              name: "Notification".tr,
              subName: "",
              onTap: () => Get.to(NotificationScreen()),
            ),
            dividerData(),
            BusinessDetailsWidget(
              notification: 0,
              name: 'App ver'.tr,
              subName: Functions.appVersion.toString(),
              hideArrow: true,
            ), // BusinessDetailsWidget(
            //   notification: 0,
            //   name: "Delete account".tr,
            //   subName: "",
            //   onTap: () => Get.to(NotificationScreen()),
            // ),
            Utility.androidVersion <= 32 && Platform.isAndroid ? SizedBox() : height16(),
            isallowtodelete == "false" ? SizedBox() :
            Column(
              children: [
                Divider(thickness: 1, height: 1, color: ColorsUtils.dividerCreateInvoice),
                Container(
                  width: double.infinity,
                  color: ColorsUtils.createInvoiceContainer,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  child: Text("Account Settings".tr, style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.medium)),
                ),
                height15(),
                BusinessDetailsWidget(
                  notification: 0,
                  name: "Delete Account".tr,
                  nameStyle: ThemeUtils.maroonSemiBold.copyWith(fontSize: FontUtils.small),
                  subName: "",
                  onTap: () {
                    // //Get.to(DeleteAccount());
                    // DeleteAccountController controller = Get.put(DeleteAccountController());
                    // controller.sendOtp(navigate: true, navigateScreen: DeleteAccount());
                    validateMerchantForDeleteAccount();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  initData() async {
    finger = await encryptedSharedPreferences.getString('bioDetectionFinger');
    face = await encryptedSharedPreferences.getString('bioDetectionFace');
    print('finger=$finger');
    print('face=$face');
    setState(() {});
  }

  validateMerchantForDeleteAccount() async {
    showLoadingDialog(context: context);
    String token = await encryptedSharedPreferences.getString('token');
    final url = Uri.parse(Utility.baseUrl + "usermetaauths/validateMerchantForDeleteAccount");
    Map<String, String> header = {'Authorization': token, 'Content-Type': 'application/json'};
    var result = await http.get(url, headers: header);
    print(url);
    print(result.body);
    print(result.statusCode);
    Get.back();
    if (result.statusCode == 200) {
      VerifyAccountDeleteModel verifyAccountDeleteModel = verifyAccountDeleteModelFromJson(result.body);
      if (verifyAccountDeleteModel.isallowedtodelete ?? true) {
        Get.to(DeleteAccount());
      } else {
        Get.to(CanNotDeleteAccScreen(list: verifyAccountDeleteModel.message??[]));
      }
    } else {
      Get.snackbar('error', '${jsonDecode(result.body)['error']['message']}');
    }
  }
}
