import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/util/utils.dart';

class AccountDeleted extends StatefulWidget {
  const AccountDeleted({Key? key}) : super(key: key);

  @override
  State<AccountDeleted> createState() => _AccountDeletedState();
}

class _AccountDeletedState extends State<AccountDeleted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Your Delete account request is submitted.".tr,
          style: ThemeUtils.blackRegular.copyWith(fontSize: FontUtils.medium),
        ),
        height12(),
        Text(
          "You can exit the app.".tr,
          style: ThemeUtils.blackRegular.copyWith(fontSize: FontUtils.medium),
        ),
        height12(),
        InkWell(onTap: () {}, child: buildContainerWithoutImage(style: ThemeUtils.whiteSemiBold.copyWith(fontSize: FontUtils.mediumSmall), color: ColorsUtils.accent, text: 'Confirm Delete'.tr)),
      ],
    ),
            )));
  }
}
