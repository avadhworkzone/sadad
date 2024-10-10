import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/util/utils.dart';

class WithdrawalAmountScreen extends StatefulWidget {
  final String withdrawFrom;
  const WithdrawalAmountScreen({Key? key, required this.withdrawFrom})
      : super(key: key);

  @override
  State<WithdrawalAmountScreen> createState() => _WithdrawalAmountScreenState();
}

class _WithdrawalAmountScreenState extends State<WithdrawalAmountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: buildContainerWithoutImage(
                  color: ColorsUtils.accent, text: 'Submit'.tr),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Form(
            child: Column(
              children: [
                ///withdrawal amount box
                SizedBox(
                  height: Get.height * 0.45,
                  width: Get.width,
                  child: Stack(children: [
                    Container(
                      width: Get.width,
                      height: Get.height * 0.35,
                      color: widget.withdrawFrom == 'Pos'
                          ? ColorsUtils.lightYellow
                          : ColorsUtils.lightPink,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, top: 50),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: const Icon(Icons.arrow_back_ios)),
                            height40(),
                            Text(
                              'Withdrawal amount',
                              style: ThemeUtils.blackBold
                                  .copyWith(fontSize: FontUtils.medLarge),
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: 20,
                      left: 20,
                      bottom: 20,
                      child: Container(
                        width: Get.width,
                        decoration: BoxDecoration(
                            color: ColorsUtils.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: ColorsUtils.border.withOpacity(0.3),
                                  offset: Offset(0, 10),
                                  blurRadius: 10)
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                Images.onlinePayment,
                                width: 25,
                                height: 25,
                              ),
                              width10(),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Online payment Balance',
                                    style: ThemeUtils.blackSemiBold.copyWith(
                                        fontSize: FontUtils.mediumSmall),
                                  ),
                                  height20(),
                                  currencyText(
                                      175918.88,
                                      ThemeUtils.maroonBold
                                          .copyWith(fontSize: FontUtils.large),
                                      ThemeUtils.maroonRegular.copyWith(
                                          fontSize: FontUtils.verySmall)),
                                ],
                              ))
                            ],
                          ),
                        ),
                      ),
                    )
                  ]),
                ),

                ///textfield amount
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: commonTextField(
                    hint: 'Withdrawal amount',
                    suffix: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'QAR',
                        style: ThemeUtils.blackSemiBold.copyWith(fontSize: 16),
                      ),
                    ),
                  ),
                ),

                ///choose bank
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: commonTextField(
                    hint: 'Choose your bank',
                    suffix: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Icon(Icons.keyboard_arrow_down_sharp,
                          size: 30, color: ColorsUtils.black),
                    ),
                  ),
                ),

                ///row add bank
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  child: Row(
                    children: [
                      Icon(
                        Icons.add,
                        color: ColorsUtils.accent,
                        size: 30,
                      ),
                      width10(),
                      Text(
                        'Add Bank',
                        style: ThemeUtils.blackBold.copyWith(
                            fontSize: FontUtils.medium,
                            color: ColorsUtils.accent),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
