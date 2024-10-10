import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/util/utils.dart';

class CanNotDeleteAccScreen extends StatefulWidget {
  final List list;
  const CanNotDeleteAccScreen({Key? key,required this.list}) : super(key: key);

  @override
  State<CanNotDeleteAccScreen> createState() => _CanNotDeleteAccScreenState();
}

class _CanNotDeleteAccScreenState extends State<CanNotDeleteAccScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            height10(),
            Text(
              "Delete Account".tr,
              style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.large),
            ),
            height20(),
            Text(
              "We can't delete your account yet".tr,
              style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.mediumSmall),
            ),
            height10(),
            Text(
              "It looks like something needs to be resolved before we can delete your account. Once you have resolved the issue, please retry deleting your account from the settings.".tr,
              style: ThemeUtils.blackRegular.copyWith(fontSize: FontUtils.verySmall),
            ),
            height12(),
            Column(children: widget.list.map((e) =>  commonRow(title: e)).toList()),
            // commonRow(title: "Looks like you have some amount in your wallet account, you need to withdraw the full amount."),
            // commonRow(title: "Looks like you’re the primary merchant of the sub users linked with you account. You’ll need to go to your manage merchant page and unlink all sub merchants then return to settings to delete your account."),
            Spacer(),
            InkWell(onTap: () {Get.back();}, child: buildContainerWithoutImage(style: ThemeUtils.whiteSemiBold.copyWith(fontSize: FontUtils.mediumSmall), color: ColorsUtils.accent, text: 'Okay'.tr)),
            height12()
          ]),
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
