import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:sadad_merchat_app/controller/delete_controller.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/more/deleteAccount/deleteAccountTerms.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({Key? key}) : super(key: key);

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: DeleteAccountController(),
        builder: (DeleteAccountController controller) {
          return Scaffold(
            appBar: commonAppBar(),
            body: Container(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
                child: SingleChildScrollView(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    height15(),
                    Text(
                      "Delete Account".tr,
                      style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.large),
                    ),
                    height25(),
                    Text(
                      "We’re sorry to see you leave, we would love to know why you’re deleting your account.".tr,
                      style: ThemeUtils.blackRegular.copyWith(fontSize: FontUtils.verySmall),
                    ),
                    height20(),
                    Text(
                      "We care deeply about the user experience and listening closely to the feedback you provide.".tr,
                      style: ThemeUtils.blackRegular.copyWith(fontSize: FontUtils.verySmall),
                    ),
                    height30(),
                    ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: controller.optionList.length,
                      itemBuilder: (context, index) => commonCheckBox(index: index),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                    ),
                    height15(),
                    if (controller.optionSelectionList.last)
                      TextField(
                        decoration: InputDecoration(
                            disabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.5), borderRadius: BorderRadius.circular(5)),
                            hintText: "Please enter reason".tr,
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.5), borderRadius: BorderRadius.circular(5)),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.5), borderRadius: BorderRadius.circular(5)),
                            contentPadding: EdgeInsets.only(left: 15, top: 25),
                            border: OutlineInputBorder(borderSide: BorderSide(width: 0.5), borderRadius: BorderRadius.circular(5))),
                        controller: controller.otherController,
                        autofocus: true,
                        maxLines: 2,
                        onChanged: (value) {
                          controller.reasonForDelete = value;
                        },
                      ),
                    if (controller.optionSelectionList.last) height30(),
                    InkWell(
                        onTap: () {

                          if (controller.optionSelectionList.contains(true)) {
                            for (int i = 0; i < controller.optionSelectionList.length; i++) {
                              if (controller.optionSelectionList[i] == true) {
                                controller.reasonForDelete = controller.optionList[i];
                              }
                            }

                            if (controller.reasonForDelete == "Others") {
                              if (controller.otherController.text.isEmpty) {
                                Get.snackbar("error".tr, "Please enter reason to continue".tr);
                                return;
                              }
                            }

                            Get.to(() => DeleteAccountTerms());
                          } else {
                            Get.snackbar("error".tr, "Please select any one to continue".tr);
                          }
                        },
                        child: buildContainerWithoutImage(style: ThemeUtils.whiteSemiBold.copyWith(fontSize: FontUtils.mediumSmall), color: ColorsUtils.accent, text: 'Continue to Account Deletion'.tr)),
                    height15(),
                    InkWell(onTap: () {
                      Get.close(1);
                    },child: buildContainerWithoutImage(style: ThemeUtils.blackRegular.copyWith(fontSize: FontUtils.mediumSmall), color: ColorsUtils.lightGrey, text: 'Cancel'.tr)),
                  ]),
                ),
              ),
            ),
          );
        });
  }

  Widget commonCheckBox({required int index}) {
    DeleteAccountController controller = Get.find<DeleteAccountController>();
    return GestureDetector(
      onTap: () {
        if (!controller.optionSelectionList[index]) controller.optionSelectionList = List.filled(controller.optionList.length, false);
        controller.optionSelectionList[index] = !controller.optionSelectionList[index];
        if (controller.optionSelectionList.last) {
          controller.otherController.clear();
        }
        controller.update();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 7),
        child: Row(
          children: [
            SizedBox(
                height: Get.width * 0.04,
                width: Get.width * 0.04,
                child: Checkbox(
                    value: controller.optionSelectionList[index],
                    onChanged: (value) {
                      if (!controller.optionSelectionList[index]) controller.optionSelectionList = List.filled(controller.optionList.length, false);
                      controller.optionSelectionList[index] = !controller.optionSelectionList[index];
                      if (controller.optionSelectionList.last) {
                        controller.otherController.clear();
                      }
                      controller.update();
                    })),
            width16(),
            Text(
              controller.optionList[index],
              style: ThemeUtils.blackSemiBold.copyWith(fontSize: FontUtils.verySmall),
            )
          ],
        ),
      ),
    );
  }
}
