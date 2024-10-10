import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/loading_dialog.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/analytics_service.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/settlement/withdrawalRequestSuccessScreen.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:http/http.dart' as http;

class AutoWithdrawalRequestScreen extends StatefulWidget {
  const AutoWithdrawalRequestScreen({Key? key}) : super(key: key);

  @override
  State<AutoWithdrawalRequestScreen> createState() =>
      _AutoWithdrawalRequestScreenState();
}

class _AutoWithdrawalRequestScreenState
    extends State<AutoWithdrawalRequestScreen> {
  bool isTermsCondition = false;
  bool isTc = false;
  String filterValue = '';
  ConnectivityViewModel connectivityViewModel = Get.find();

  @override
  void initState() {
    connectivityViewModel.startMonitoring();
    filterValue = Utility.settlementWithdrawPeriod;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: bottomButton(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              height60(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: BackButton(),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: customLargeBoldText(title: 'Auto Withdrawal Request'.tr),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: InkWell(
                  onTap: () {
                    bottomSelection(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border:
                            Border.all(width: 1, color: ColorsUtils.border)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: customSmallMedSemiText(
                                color: ColorsUtils.grey,
                                title: Utility
                                            .settlementWithdrawPeriodAlready ==
                                        true
                                    ? Utility.settlementWithdrawPeriod.tr
                                    : filterValue == ''
                                        ? 'Choose withdrawal Request Period'.tr
                                        : filterValue.tr),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down_sharp,
                            size: 30,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Utility.settlementWithdrawPeriodAlready == false
                  ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
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
                                      border:
                                          Border.all(color: ColorsUtils.black)),
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
                              width20(),
                              customVerySmallSemiText(
                                  title: 'I agree to the Sadad'.tr + ' '),
                              // width5(),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isTc = !isTc;
                                  });
                                  // Get.to(() => TermsAndConditionPage());
                                },
                                child: Text('Terms and conditions'.tr,
                                    style: ThemeUtils.blackBold.copyWith(
                                        decoration: TextDecoration.underline,
                                        fontSize: FontUtils.verySmall,
                                        color: ColorsUtils.accent)),
                              ),
                            ],
                          ),
                        ),
                        isTc == false
                            ? SizedBox()
                            : Padding(
                                padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                                child: customSmallSemiText(
                                    title:
                                        'You are add there to follow below terms and conditions by clicking "I agree",\n\n1. The auto withdrawal would be generated based on the chosen request frequency.\n2. You are not allowed to cancel the auto withdrawal request.\n3. You can’t get refund for the auto withdrawal request. \n4. Your auto withdrawal would be on hold.'
                                            .tr)),
                        isTc == false
                            ? SizedBox()
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 35,
                                ),
                                child: customSmallSemiText(
                                    title:
                                    '\u2022 If the primary bank account details are changed and not verified by SADAD Admin.\n\u2022 If the sufficient amount is not maintained in your SADAD wallet account which is less than the set auto withdrawal amount.\n\u2022 If subscribed services (POS Rental, SADAD paid services) charges are due and not cleared from your SADAD wallet account'
                                            .tr),
                              ),
                      ],
                    )
                  : SizedBox()
            ],
          ),
        ));
  }

  Column bottomButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: InkWell(
            onTap: () async {
              if (filterValue == '') {
                Get.snackbar('Error', 'Please Select Period!');
              } else {
                if (Utility.settlementWithdrawPeriodAlready == false) {
                  if (isTermsCondition == false) {
                    Get.snackbar('Error', 'Please Agree on Terms & Conditions');
                  } else if (filterValue == '') {
                    Get.snackbar('Error', 'Please Select Period!');
                  }
                }
                await termsAndConditionAPiCall();
              }
            },
            child: buildContainerWithoutImage(
                color: ColorsUtils.accent, text: 'Submit'.tr),
          ),
        )
      ],
    );
  }

  Future<void> autoWithdrawalApiCall() async {
    connectivityViewModel.startMonitoring();

    if (connectivityViewModel.isOnline != null) {
      if (connectivityViewModel.isOnline!) {
        showLoadingDialog(context: context);
        String token = await encryptedSharedPreferences.getString('token');
        String id = await encryptedSharedPreferences.getString('id');
        final url = Uri.parse(
          '${Utility.baseUrl}usermetapersonals/auto-withdrawal',
        );
        Map<String, String> header = {
          'Authorization': token,
          'Content-Type': 'application/json'
        };
        Map<String, dynamic>? body = {
          "frequency":
              "${filterValue == '' ? 'daily' : filterValue.toLowerCase()}"
        };
        var result =
            await http.patch(url, headers: header, body: jsonEncode(body));

        print(
            'token is:$token } req is ${jsonEncode(body)} \n response is :${result.body} ');
        if (result.statusCode == 401) {
          hideLoadingDialog(context: context);
          Utility.settlementWithdrawPeriod = '';
          SessionExpire();
        }

        if (result.statusCode == 200) {
          filterValue == ''
              ? Utility.settlementWithdrawPeriod == 'Daily'
              : Utility.settlementWithdrawPeriod = filterValue;
          hideLoadingDialog(context: context);
          Get.off(() => WithdrawalSuccessScreenScreen());
          // Get.back();
          // Get.snackbar('Success',
          //     'Your withdrawal status has been change to ${Utility.settlementWithdrawPeriod}.');
          print('hiiiii2');
          AnalyticsService.sendEvent('auto withdrawal  request success', {
            'Id': Utility.userId,
          });
        } else {
          hideLoadingDialog(context: context);

          Utility.settlementWithdrawPeriod = '';
          AnalyticsService.sendEvent('auto withdrawal  request failure', {
            'Id': Utility.userId,
          });
          Get.snackbar(
              'error'.tr, '${jsonDecode(result.body)['error']['message']}');
        }
      } else {
        Get.snackbar('error'.tr, 'Please check your connection'.tr);
      }
    } else {
      Get.snackbar('error'.tr, 'Please check your connection'.tr);
    }
  }

  Future<void> termsAndConditionAPiCall() async {
    // showLoadingDialog(context: context);
    String token = await encryptedSharedPreferences.getString('token');
    String id = await encryptedSharedPreferences.getString('id');
    final url = Uri.parse(
      '${Utility.baseUrl}usermetapersonals/agreeAutoWithdrawalTC',
    );
    Map<String, String> header = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };

    var result = await http.patch(
      url,
      headers: header,
    );

    print('token is:$token }  \n response is :${result.body} ');
    if (result.statusCode == 401) {
      SessionExpire();
    }

    if (result.statusCode == 200) {
      print('hiiiii');
      // hideLoadingDialog(context: context);

      await autoWithdrawalApiCall();
    } else {
      // hideLoadingDialog(context: context);
      Get.snackbar(
          'error'.tr, '${jsonDecode(result.body)['error']['message']}');
    }
  }

  bottomSelection(BuildContext context) {
    showModalBottomSheet<void>(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setBottomState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 70,
                        height: 5,
                        child: Divider(color: ColorsUtils.border, thickness: 4),
                      ),
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        filterValue = 'Daily';
                        Utility.settlementWithdrawPeriod = 'Daily';
                        setState(() {});
                        print(filterValue);
                        Get.back();
                      },
                      child: customSmallMedBoldText(title: 'Daily'.tr)),
                  height20(),
                  InkWell(
                      onTap: () {
                        filterValue = 'Weekly';
                        Utility.settlementWithdrawPeriod = 'Weekly';
                        setState(() {});
                        print(filterValue);

                        Get.back();
                      },
                      child: customSmallMedBoldText(title: 'Weekly'.tr)),
                  height20(),
                  InkWell(
                      onTap: () {
                        filterValue = 'Monthly';
                        Utility.settlementWithdrawPeriod = 'Monthly';

                        setState(() {});
                        print(filterValue);

                        Get.back();
                      },
                      child: customSmallMedBoldText(title: 'Monthly'.tr)),
                  height40(),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
