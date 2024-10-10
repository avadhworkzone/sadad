import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/controller/delete_controller.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/more/deleteAccount/deleteAccountFinalPage.dart';
import 'package:http/http.dart' as http;
import 'package:sadad_merchat_app/view/more/deleteAccount/sendOtpScreen.dart';

class DeleteAccountTerms extends StatefulWidget {
  const DeleteAccountTerms({Key? key}) : super(key: key);

  @override
  State<DeleteAccountTerms> createState() => _DeleteAccountTermsState();
}

class _DeleteAccountTermsState extends State<DeleteAccountTerms> {
  DeleteAccountController controller = Get.find<DeleteAccountController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
          child: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              height10(),
              Text(
                "Delete Account".tr,
                style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.large),
              ),
              height20(),
              Text(
                "Terms & Conditions".tr,
                style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.mediumSmall),
              ),
              height10(),
              ListView.builder(
                itemCount: controller.termsAndConditions.length,
                itemBuilder: (context, index) => commonRow(title: controller.termsAndConditions[index]),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
              ),
              height20(),
              InkWell(
                  onTap: () {
                    // Get.to(SendOtpScreen());
                    controller.sendOtp(navigate: true, navigateScreen: SendOtpScreen());
                  },
                  child: buildContainerWithoutImage(style: ThemeUtils.whiteSemiBold.copyWith(fontSize: FontUtils.mediumSmall), color: ColorsUtils.accent, text: 'Confirm Delete'.tr)),
              height15(),
            InkWell(
                onTap: () {
                Get.close(2);
                },
                child: buildContainerWithoutImage(style: ThemeUtils.blackRegular.copyWith(fontSize: FontUtils.mediumSmall), color: ColorsUtils.lightGrey, text: 'Cancel'.tr)),
              height15(),
            ]),
          ),
        ),
      ),
    );
  }

  Widget commonRow({required String title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "\u2022 ",
            style: ThemeUtils.blackRegular.copyWith(fontSize: FontUtils.large, height: 1.1),
          ),
          Expanded(
            child: Text(
              title.tr,
              style: ThemeUtils.blackRegular.copyWith(fontSize: FontUtils.verySmall),
            ),
          ),
        ],
      ),
    );
  }
}
