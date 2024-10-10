import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/util/utils.dart';

class BusinessDocumentScreen extends StatefulWidget {
  const BusinessDocumentScreen({Key? key}) : super(key: key);

  @override
  State<BusinessDocumentScreen> createState() => _BusinessDocumentScreenState();
}

class _BusinessDocumentScreenState extends State<BusinessDocumentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        height40(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: InkWell(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back_ios,
            ),
          ),
        ),
        height40(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: customMediumLargeBoldText(
                      color: ColorsUtils.black, title: 'Business Documents'),
                ),
                height10(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: customSmallSemiText(
                      title:
                          'You have to add the blow documents to verify your account.'),
                ),
                const Divider(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      customSmallMedBoldText(
                          title: 'Your account status',
                          color: ColorsUtils.black),
                      Spacer(),
                      Image.asset(
                        Images.clock,
                        width: 20,
                        height: 20,
                      ),
                      width10(),
                      customSmallSemiText(
                          title: 'Not verified', color: ColorsUtils.black),
                    ],
                  ),
                ),
                const Divider(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      customSmallMedBoldText(
                          title: 'Requirements Documents',
                          color: ColorsUtils.black),
                      Spacer(),
                      Image.asset(
                        Images.quation,
                        width: 20,
                        height: 20,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: ListView.builder(
                    itemCount: 10,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                height: Get.height * 0.1,
                                width: Get.width * 0.2,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border:
                                        Border.all(color: ColorsUtils.border)),
                                child: SizedBox(
                                  child: Center(
                                      child: Image.asset(
                                    Images.noImage,
                                    height: 50,
                                    width: 50,
                                  )),
                                ),
                              ),
                              width10(),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        customSmallBoldText(
                                            color: ColorsUtils.black,
                                            title: 'Commercial registration.'),
                                        Spacer(),
                                        Icon(Icons.more_vert)
                                      ],
                                    ),
                                    height10(),
                                    customSmallSemiText(
                                        title: 'Expiration date: 12-07-2025',
                                        color: ColorsUtils.black),
                                    height10(),
                                    customSmallSemiText(
                                        title: 'Verified'.tr,
                                        color: ColorsUtils.green)
                                  ],
                                ),
                              ),
                            ],
                          ),
                          height20(),
                          Divider()
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    ));
  }
}
