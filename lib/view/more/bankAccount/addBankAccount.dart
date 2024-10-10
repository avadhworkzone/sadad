     import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/more/bankAccount/bankAccountDetail.dart';
import 'package:sadad_merchat_app/viewModel/more/bank/bankAccountViewModel.dart';

class AddBankAccountScreen extends StatelessWidget {
  AddBankAccountScreen({Key? key}) : super(key: key);

  final cnt = Get.find<BankAccountViewModel>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            height60(),
            Image.asset(
              Images.bank,
              height: 236,
              width: 236,
            ),
            height80(),
            Text('Bank Account'.tr,
                style: ThemeUtils.blackSemiBold
                    .copyWith(fontSize: FontUtils.medLarge)),
            height12(),
            Text(
                'Add your bank account details to transfer your account amount to it.'
                    .tr,
                textAlign: TextAlign.center,
                style:
                    ThemeUtils.blackRegular.copyWith(fontSize: FontUtils.small)),
            height64(),
            InkWell(
              onTap: () {
                Get.off(() => BankAccountDetail(), arguments: true);
              },
              child: buildContainerWithoutImage(
                  width: 212,
                  borderRadius: BorderRadius.circular(12),
                  color: ColorsUtils.accent,
                  plusIcon: true,
                  text: 'Add bank account'.tr),
            ),
          ],
        ),
      ),
    );
  }
}
