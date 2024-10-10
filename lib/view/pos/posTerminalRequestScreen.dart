// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/apimodels/requestmodel/pos/posTerminalRequestModel.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/loading_dialog.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/analytics_service.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/auth/register/pdfOfTermsAndCondition.dart';
import 'package:sadad_merchat_app/view/pos/posTerminalRequestSuccessScreen.dart';
import 'package:http/http.dart' as http;
import 'package:sadad_merchat_app/view/splash.dart';

class PosTerminalScreenRequest extends StatefulWidget {
  const PosTerminalScreenRequest({Key? key}) : super(key: key);

  @override
  State<PosTerminalScreenRequest> createState() =>
      _PosTerminalScreenRequestState();
}

class _PosTerminalScreenRequestState extends State<PosTerminalScreenRequest> {
  bool isTermsCondition = false;
  int wPos3Value = 0;
  int wPosQTValue = 0;
  int volumeRange = 0;
  bool isVolume = false;
  String transactionValue = '';
  PosTerminalRequestModel posReq = PosTerminalRequestModel();
  @override
  void initState() {
    // posReq.requestedposdata!.clear();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: bottomBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                height60(),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: ColorsUtils.black,
                    // size: 25,
                  ),
                ),

                // height100(),
                // Image.asset(
                //   Images.posTerminalReq,
                //   height: Get.height / 4,
                //   width: Get.width,
                // ),

                height40(),

                customSmallMedBoldText(
                    title: 'Kindly fill up POS Terminal request details'.tr,
                    color: ColorsUtils.accent),
                height40(),
                customSmallMedBoldText(
                  title: 'Transaction Volume'.tr,
                ),
                height10(),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(width: 1, color: ColorsUtils.border)),
                  child: ExpansionTile(
                    key: UniqueKey(),
                    initiallyExpanded: isVolume,
                    onExpansionChanged: (value) {
                      isVolume = value;
                      setState(() {});
                    },
                    title: customSmallSemiText(
                        color: transactionValue == ''
                            ? ColorsUtils.hintColor.withOpacity(0.5)
                            : ColorsUtils.black,
                        title: transactionValue == ''
                            ? 'Choose Transaction Volume'.tr
                            : transactionValue),
                    children: [
                      InkWell(
                          onTap: () {
                            volumeRange = 1;
                            isVolume = !isVolume;
                            transactionValue = '1-100000';
                            setState(() {});
                          },
                          child: customSmallBoldText(
                              title: '1-100000', color: ColorsUtils.grey)),
                      height10(),
                      InkWell(
                          onTap: () {
                            volumeRange = 2;

                            isVolume = !isVolume;
                            transactionValue = '100000-500000';
                            setState(() {});
                          },
                          child: customSmallBoldText(
                              title: '100000-500000', color: ColorsUtils.grey)),
                      height10(),
                      InkWell(
                          onTap: () {
                            volumeRange = 3;
                            isVolume = !isVolume;
                            transactionValue = 'more than 500000'.tr;
                            setState(() {});
                          },
                          child: customSmallBoldText(
                              title: 'more than 500000'.tr,
                              color: ColorsUtils.grey)),
                    ],
                  ),
                ),
                height40(),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: ColorsUtils.border,
                            width: 1,
                          ),
                          color: ColorsUtils.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Image.asset(Images.device,
                                  // width: Get.width * .1,
                                  height: Get.width * .25),
                            ),
                            customMediumBoldText(
                                color: ColorsUtils.accent, title: 'WPOS-3'),
                            height20(),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(15),
                                      bottomLeft: Radius.circular(15)),
                                  color: ColorsUtils.tabUnselect),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CircleAvatar(
                                      radius: 12,
                                      backgroundColor: ColorsUtils.white,
                                      child: Center(
                                        child: InkWell(
                                          onTap: () {
                                            if (wPos3Value == 0) {
                                              wPos3Value = 0;
                                            } else {
                                              wPos3Value--;
                                            }
                                            setState(() {});
                                          },
                                          child: Icon(Icons.remove,
                                              color: ColorsUtils.black,
                                              size: 15),
                                        ),
                                      ),
                                    ),
                                    customMediumBoldText(title: '$wPos3Value'),
                                    CircleAvatar(
                                      radius: 12,
                                      backgroundColor: ColorsUtils.white,
                                      child: Center(
                                        child: InkWell(
                                          onTap: () {
                                            if (wPos3Value >= 20) {
                                              Get.snackbar(
                                                  'error'.tr,
                                                  'You can not add more than 20 quantity!!'
                                                      .tr);
                                            } else {
                                              wPos3Value++;
                                              setState(() {});
                                            }
                                          },
                                          child: Icon(Icons.add,
                                              color: ColorsUtils.black,
                                              size: 15),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    width10(),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: ColorsUtils.border,
                            width: 1,
                          ),
                          color: ColorsUtils.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Image.asset(Images.wposQTBlank,
                                  height: Get.width * .25),
                            ),
                            customMediumBoldText(
                                color: ColorsUtils.accent, title: 'WPOS-QT'),
                            height20(),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(15),
                                      bottomLeft: Radius.circular(15)),
                                  color: ColorsUtils.tabUnselect),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CircleAvatar(
                                      radius: 12,
                                      backgroundColor: ColorsUtils.white,
                                      child: Center(
                                        child: InkWell(
                                          onTap: () {
                                            if (wPosQTValue == 0) {
                                              wPosQTValue = 0;
                                            } else {
                                              wPosQTValue--;
                                            }
                                            setState(() {});
                                          },
                                          child: Icon(Icons.remove,
                                              color: ColorsUtils.black,
                                              size: 15),
                                        ),
                                      ),
                                    ),
                                    customMediumBoldText(title: '$wPosQTValue'),
                                    CircleAvatar(
                                      radius: 12,
                                      backgroundColor: ColorsUtils.white,
                                      child: Center(
                                        child: InkWell(
                                          onTap: () {
                                            if (wPosQTValue >= 20) {
                                              Get.snackbar(
                                                  'error'.tr,
                                                  'You can not add more than 20 quantity!!'
                                                      .tr);
                                            } else {
                                              wPosQTValue++;
                                              setState(() {});
                                            }
                                          },
                                          child: Icon(Icons.add,
                                              color: ColorsUtils.black,
                                              size: 15),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Widget bottomBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    isTermsCondition = !isTermsCondition;
                  });
                },
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: ColorsUtils.black)),
                  child: isTermsCondition
                      ? Center(
                          child: Image.asset(
                            Images.check,
                            width: 10,
                          ),
                        )
                      : SizedBox(),
                ),
              ),
              width10(),
              Expanded(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: [
                    customVerySmallSemiText(title: 'I accept the '.tr),
                    InkWell(
                      onTap: () {
                        Get.to(() => TermsAndConditionPage());
                      },
                      child: Text('Terms and conditions'.tr,
                          style: ThemeUtils.blackBold.copyWith(
                              decoration: TextDecoration.underline,
                              fontSize: FontUtils.verySmall,
                              color: ColorsUtils.accent)),
                    ),
                    // InkWell(
                    //   onTap: () {
                    //     Get.to(() => TermsAndConditionPage());
                    //   },
                    //   child: Text(' & Privacy policy.'.tr,
                    //       style: ThemeUtils.blackBold.copyWith(
                    //           decoration: TextDecoration.underline,
                    //           fontSize: FontUtils.verySmall,
                    //           color: ColorsUtils.accent)),
                    // ),
                  ],
                ),
              ),
            ],
          ),
          height20(),
          InkWell(
            onTap: () async {
              if (transactionValue == '') {
                Get.snackbar('error'.tr, 'Please choose Transaction volume'.tr);
              } else {
                if (wPos3Value == 0 && wPosQTValue == 0) {
                  Get.snackbar('error'.tr,
                      'Please select valid quantity of Terminal device!!'.tr);
                } else {
                  if (isTermsCondition == true) {
                    String token =
                        await encryptedSharedPreferences.getString('token');
                    final url = Uri.parse(
                      '${Utility.baseUrl}posrequests',
                    );
                    Map<String, String> header = {
                      'Authorization': '$token',
                      'Content-Type': 'application/json'
                    };
                    showLoadingDialog(context: context);
                    posReq.isaccepted = true;
                    posReq.txnvolumerangeId = volumeRange;
                    print('wpos3 $wPos3Value   wposQT$wPosQTValue');
                    posReq.requestedposdata = [];
                    if (wPos3Value != 0) {
                      posReq.requestedposdata?.add(
                          Requestedposdata(deviceId: 1, quantity: wPos3Value));
                      print(posReq.requestedposdata);
                    }
                    if (wPosQTValue != 0) {
                      posReq.requestedposdata?.add(
                          Requestedposdata(deviceId: 2, quantity: wPosQTValue));
                    }

                    // posReq.requestedposdata!.forEach((element) {
                    //   if (wPos3Value != 0) {
                    //     element.deviceId = 1;
                    //     element.quantity = wPos3Value;
                    //   }
                    //   if (wPosQTValue != 0) {
                    //     element.deviceId = 2;
                    //     element.quantity = wPosQTValue;
                    //   }
                    // });

                    print(posReq.requestedposdata);
                    print(jsonEncode(posReq));

                    var result = await http.post(url,
                        headers: header, body: jsonEncode(posReq));
                    print('url $url');
                    print(
                        'token is:$token } req is ${jsonEncode(posReq)} \n response is :${result.body} ');
                    // if (result.statusCode == 401) {
                    //   SessionExpire();
                    // }

                    if (result.statusCode == 200) {
                      hideLoadingDialog(context: context);

                      AnalyticsService.sendEvent(
                          'pos terminal request success', {
                        'Id': Utility.userId,
                      });
                      // Get.snackbar(
                      //     'success', 'Pos Terminal request Successfully');

                      Get.to(() => PosTerminalRequestSuccessScreen(
                            id: jsonDecode(result.body)['requestId'].toString(),
                          ));
                    } else if (result.statusCode == 401) {
                      print('innnnnn');
                      hideLoadingDialog(context: context);
                      Get.snackbar('error'.tr,
                          '${jsonDecode(result.body)['error']['message']}');
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        Get.offAll(() => SplashScreen());
                      });
                    } else {
                      hideLoadingDialog(context: context);

                      AnalyticsService.sendEvent(
                          'pos terminal request failure', {
                        'Id': Utility.userId,
                      });
                      Get.snackbar('error'.tr,
                          '${jsonDecode(result.body)['error']['message']}');
                    }
                  } else {
                    Get.snackbar(
                        'error'.tr, 'Please accept terms and conditions'.tr);
                  }
                }
              }
            },
            child: buildContainerWithoutImage(
                color: ColorsUtils.accent, text: 'Submit'.tr),
          ),
        ],
      ),
    );
  }
}
