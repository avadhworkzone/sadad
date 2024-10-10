import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/auth/register/createBusinessAccount.dart';

class RegisterSelectAccount extends StatefulWidget {
  const RegisterSelectAccount({Key? key}) : super(key: key);

  @override
  State<RegisterSelectAccount> createState() => _RegisterSelectAccountState();
}

class _RegisterSelectAccountState extends State<RegisterSelectAccount> {
  int isRadioSelected = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Column(mainAxisSize: MainAxisSize.min, children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: InkWell(
            onTap: () {
              Get.to(() => CreateBusinessAccount());
            },
            child: buildContainerWithoutImage(
                color: ColorsUtils.accent, text: 'Next'.tr),
          ),
        )
      ]),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            height40(),
            InkWell(
              onTap: () {
                Get.back();
              },
              child: const Icon(
                Icons.arrow_back_ios,
                size: 30,
              ),
            ),
            height30(),
            customMediumLargeBoldText(title: 'Register'.tr),
            height5(),
            customSmallMedSemiText(title: 'Select your account type'.tr),
            height30(),
            InkWell(
              onTap: () {
                setState(() {
                  isRadioSelected = 1;
                });
              },
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                        color: isRadioSelected == 1
                            ? ColorsUtils.accent
                            : ColorsUtils.border,
                        width: 2)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Radio<int>(
                      groupValue: isRadioSelected,
                      value: 1,
                      activeColor: ColorsUtils.accent,
                      onChanged: (newValue) {
                        setState(() {
                          isRadioSelected = newValue!;
                        });
                      },
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customSmallMedBoldText(
                                title: 'Personal Account'.tr),
                            customSmallSemiText(
                                title:
                                    'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore.')
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            height20(),
            InkWell(
              onTap: () {
                setState(() {
                  isRadioSelected = 2;
                });
              },
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: isRadioSelected == 2
                            ? ColorsUtils.accent
                            : ColorsUtils.border,
                        width: 2)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Radio<int>(
                      groupValue: isRadioSelected,
                      value: 2,
                      activeColor: ColorsUtils.accent,
                      onChanged: (newValue) {
                        setState(() {
                          isRadioSelected = newValue!;
                        });
                      },
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customSmallMedBoldText(
                                title: 'Business Account'.tr),
                            customSmallSemiText(
                                title:
                                    'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore.')
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
