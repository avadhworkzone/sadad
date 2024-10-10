import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/DashBoard/availableBalanceResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/settlement/userBankListResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/loading_dialog.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/analytics_service.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/util/validations.dart';
import 'package:sadad_merchat_app/view/settlement/autoWithdrawalRequest.dart';
import 'package:sadad_merchat_app/view/settlement/withdrawalRequestSuccessScreen.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:sadad_merchat_app/viewModel/dashboard/dashBoardViewModel.dart';
import 'package:sadad_merchat_app/viewModel/settlement/settlementViewModel.dart';
import 'package:http/http.dart' as http;

class SettlementWithdrawalScreen extends StatefulWidget {
  const SettlementWithdrawalScreen({Key? key}) : super(key: key);

  @override
  State<SettlementWithdrawalScreen> createState() =>
      _SettlementWithdrawalScreenState();
}

class _SettlementWithdrawalScreenState
    extends State<SettlementWithdrawalScreen> {
  TextEditingController withdrawAmount = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isAutoWithdrawal = true;
  SettlementWithdrawalListViewModel settlementListViewModel = Get.find();
  List<UserBankListResponseModel> userBankRes = [];
  AvailableBalanceResponseModel? avaBalResponse;
  DashBoardViewModel dashBoardViewModel = Get.find();
  String token = '';
  String bankListSelect = 'Choose your bank';
  String userBankId = '';
  bool isChooseBank = false;
  var now;
  var tomorrow;
  var week;
  var month;
  ConnectivityViewModel connectivityViewModel = Get.find();

  @override
  void initState() {
    connectivityViewModel.startMonitoring();

    isAutoWithdrawal = false;
    initData();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (connectivityViewModel.isOnline != null) {
      if (connectivityViewModel.isOnline!) {
        return Scaffold(
            bottomNavigationBar: bottomButton(),
            body: GetBuilder<SettlementWithdrawalListViewModel>(
              builder: (controller) {
                if (controller.userBankListApiResponse.status ==
                        Status.LOADING ||
                    controller.userBankListApiResponse.status ==
                        Status.INITIAL) {
                  return Center(
                    child: Loader(),
                  );
                }
                if (controller.userBankListApiResponse.status == Status.ERROR) {
                  return SessionExpire();
                  // return Center(child: Text('Something wrong'));
                }
                userBankRes = controller.userBankListApiResponse.data;
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 50),
                            color: ColorsUtils.lightPink,
                            height: Get.height * 0.225,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  height40(),
                                  BackButton(),
                                  Container(),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 20,
                            left: 20,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: ColorsUtils.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: ColorsUtils.grey.withOpacity(0.4),
                                      blurRadius: 10,
                                    ),
                                  ]),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: GetBuilder<DashBoardViewModel>(
                                  builder: (controller) {
                                    if (controller.availableBalanceApiResponse
                                                .status ==
                                            Status.LOADING ||
                                        controller.availableBalanceApiResponse
                                                .status ==
                                            Status.INITIAL) {
                                      return const Center(child: Loader());
                                    }
                                    if (controller.availableBalanceApiResponse
                                            .status ==
                                        Status.ERROR) {
                                      return const SessionExpire();
                                      // return Text('something wrong');
                                    }
                                    AvailableBalanceResponseModel
                                        avaBalResponse = controller
                                            .availableBalanceApiResponse.data;
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        customSmallMedBoldText(
                                            title:
                                                'Total Available Balance'.tr),
                                        height15(),
                                        currencyText(
                                            avaBalResponse.totalavailablefunds!
                                                .toDouble(),
                                            ThemeUtils.blackBold.copyWith(
                                                color: ColorsUtils.accent,
                                                fontSize: FontUtils.large),
                                            ThemeUtils.blackSemiBold.copyWith(
                                                color: ColorsUtils.accent,
                                                fontSize:
                                                    FontUtils.mediumSmall))
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                customMediumBoldText(
                                    title: 'Auto Withdrawal'.tr),
                                Spacer(),
                                Utility.settlementWithdrawPeriod == ''
                                    ? SizedBox()
                                    : Switch(
                                        activeColor: ColorsUtils.accent,
                                        value: isAutoWithdrawal,
                                        onChanged: (value) async {
                                          await autoWithdrawalApiCall();
                                          if (isAutoWithdrawal == true) {
                                            bankListSelect = 'Choose your bank';
                                            withdrawAmount.clear();
                                            setState(() {});
                                          }
                                        },
                                      )
                              ],
                            ),
                            height10(),
                            Utility.settlementWithdrawPeriod == ''
                                ? customSmallMedSemiText(
                                    title:
                                        'Set your auto withdrawal on then select withdrawal period.'
                                            .tr)
                                : Row(
                                    children: [
                                      customSmallSemiText(
                                          title: 'Next Withdrawal date'.tr),
                                      Spacer(),
                                      customSmallSemiText(
                                          title: Utility
                                                      .settlementWithdrawPeriod ==
                                                  'Daily'
                                              ? '$tomorrow'
                                              : Utility.settlementWithdrawPeriod ==
                                                      'Weekly'
                                                  ? '$week'
                                                  : '$month')
                                    ],
                                  ),
                            height10(),
                            Utility.settlementWithdrawPeriod == ''
                                ? InkWell(
                                    onTap: () async {
                                      await Get.to(
                                          () => AutoWithdrawalRequestScreen());
                                      isAutoWithdrawal = Utility
                                              .settlementWithdrawPeriod.isEmpty
                                          ? false
                                          : true;
                                      if (isAutoWithdrawal == true) {
                                        withdrawAmount.clear();
                                        bankListSelect = 'Choose your bank';
                                        isChooseBank = false;
                                      }
                                      setState(() {});
                                    },
                                    child: Row(
                                      children: [
                                        customSmallMedBoldText(
                                            title: 'Set Auto Withdrawal on'.tr,
                                            color: ColorsUtils.accent),
                                        width20(),
                                        const Icon(
                                          Icons.arrow_forward_ios_sharp,
                                          color: ColorsUtils.accent,
                                          size: 20,
                                        )
                                      ],
                                    ),
                                  )
                                : Row(
                                    children: [
                                      customSmallSemiText(
                                          title:
                                              Utility.settlementWithdrawPeriod.tr),
                                      Spacer(),
                                      IgnorePointer(
                                        ignoring: isAutoWithdrawal == false
                                            ? true
                                            : false,
                                        child: InkWell(
                                          onTap: () async {
                                            Utility.settlementWithdrawPeriodAlready =
                                                true;
                                            await Get.to(() =>
                                                AutoWithdrawalRequestScreen());
                                            if (isAutoWithdrawal == true) {
                                              withdrawAmount.clear();
                                              bankListSelect =
                                                  'Choose your bank';
                                              isChooseBank = false;
                                            }
                                            setState(() {});
                                          },
                                          child: Row(
                                            children: [
                                              customSmallBoldText(
                                                  title: 'Change period'.tr,
                                                  color: ColorsUtils.accent),
                                              width10(),
                                              Icon(
                                                Icons.arrow_forward_ios_sharp,
                                                size: 20,
                                                color: ColorsUtils.accent,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                          ],
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 30),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              customMediumLargeBoldText(
                                  title: 'Manual Withdrawal'.tr),
                              height30(),
                              SizedBox(
                                child: IgnorePointer(
                                  ignoring:
                                      isAutoWithdrawal == true ? true : false,
                                  child: commonTextField(
                                      isRead: isAutoWithdrawal == true
                                          ? true
                                          : false,
                                      suffix: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        child: Text(
                                          'QAR',
                                          style: ThemeUtils.blackSemiBold
                                              .copyWith(fontSize: 16),
                                        ),
                                      ),
                                      contollerr: withdrawAmount,
                                      hint: 'Withdrawal amount'.tr,
                                      keyType: TextInputType.numberWithOptions(
                                          decimal: true),
                                      // keyType: TextInputType.number,
                                      onChange: (str) {},
                                      regularExpression: TextValidation
                                          .doubleDigitsValidationPattern,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Amount cannot be empty".tr;
                                        }
                                        if (value == '0') {
                                          return "Amount cannot be 0".tr;
                                        }

                                        return null;
                                      },
                                      inputLength: 20),
                                ),
                              ),
                              height20(),
                              // Container(
                              //   decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(15),
                              //       border: Border.all(
                              //           width: 1, color: ColorsUtils.border)),
                              //   child: Padding(
                              //     padding: const EdgeInsets.symmetric(
                              //         horizontal: 20, vertical: 12),
                              //     child: Row(
                              //       children: [
                              //         Expanded(
                              //           child: customSmallMedSemiText(
                              //               color: ColorsUtils.hintColor
                              //                   .withOpacity(0.5),
                              //               title: 'Choose your bank'),
                              //         ),
                              //         Icon(
                              //           Icons.keyboard_arrow_down_sharp,
                              //           size: 30,
                              //         )
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              // height30(),
                              IgnorePointer(
                                ignoring:
                                    isAutoWithdrawal == true ? true : false,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          width: 1, color: ColorsUtils.border)),
                                  child: ExpansionTile(
                                    key: UniqueKey(),
                                    initiallyExpanded: isChooseBank,
                                    onExpansionChanged: (value) {
                                      isChooseBank = value;
                                      setState(() {});
                                    },
                                    title: customSmallMedSemiText(
                                        color: userBankId == ''
                                            ? ColorsUtils.hintColor
                                                .withOpacity(0.5)
                                            : ColorsUtils.black,
                                        title: bankListSelect.tr),
                                    children: [
                                      ListView.builder(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        itemCount: userBankRes.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: InkWell(
                                              onTap: () {
                                                userBankId = userBankRes[index]
                                                    .id
                                                    .toString();
                                                isChooseBank = !isChooseBank;
                                                bankListSelect =
                                                    '${userBankRes[index].bank!.name + ' ****' + userBankRes[index].ibannumber.toString().substring(userBankRes[index].ibannumber.toString().length - 4)}';
                                                setState(() {});
                                              },
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 60,
                                                    width: 60,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                          color: ColorsUtils
                                                              .border,
                                                          width: 1),
                                                    ),
                                                    child: Image.network(
                                                      '${Utility.baseUrl}containers/api-banks/download/${userBankRes[index].bank!.logo}',
                                                      headers: {
                                                        HttpHeaders
                                                                .authorizationHeader:
                                                            token
                                                      },
                                                      fit: BoxFit.contain,
                                                      loadingBuilder: (BuildContext
                                                              context,
                                                          Widget child,
                                                          ImageChunkEvent?
                                                              loadingProgress) {
                                                        if (loadingProgress ==
                                                            null) return child;
                                                        return Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            value: loadingProgress
                                                                        .expectedTotalBytes !=
                                                                    null
                                                                ? loadingProgress
                                                                        .cumulativeBytesLoaded /
                                                                    loadingProgress
                                                                        .expectedTotalBytes!
                                                                : null,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  width10(),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      customSmallMedBoldText(
                                                          title:
                                                              userBankRes[index]
                                                                  .bank!
                                                                  .name),
                                                      height10(),
                                                      customSmallSemiText(
                                                          title: userBankRes[
                                                                          index]
                                                                      .ibannumber ==
                                                                  null
                                                              ? 'NA'
                                                              : '********${userBankRes[index].ibannumber.toString().substring(userBankRes[index].ibannumber.toString().length - 4)}')
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              )
                              // Row(
                              //   children: [
                              //     Icon(
                              //       Icons.add,
                              //       size: 30,
                              //       color: isAutoWithdrawal == true
                              //           ? ColorsUtils.accent.withOpacity(0.5)
                              //           : ColorsUtils.accent,
                              //     ),
                              //     width10(),
                              //     customMediumBoldText(
                              //         title: 'Add Bank',
                              //         color: isAutoWithdrawal == true
                              //             ? ColorsUtils.accent.withOpacity(0.5)
                              //             : ColorsUtils.accent)
                              //   ],
                              // )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ));
      } else {
        return InternetNotFound(
          onTap: () async {
            connectivityViewModel.startMonitoring();

            if (connectivityViewModel.isOnline != null) {
              if (connectivityViewModel.isOnline!) {
                isAutoWithdrawal = false;
                setState(() {});
                initData();
              } else {
                Get.snackbar('error'.tr, 'Please check your connection'.tr);
              }
            } else {
              Get.snackbar('error'.tr, 'Please check your connection'.tr);
            }
          },
        );
      }
    } else {
      return InternetNotFound(
        onTap: () async {
          connectivityViewModel.startMonitoring();

          if (connectivityViewModel.isOnline != null) {
            if (connectivityViewModel.isOnline!) {
              isAutoWithdrawal = false;
              setState(() {});
              initData();
            } else {
              Get.snackbar('error'.tr, 'Please check your connection'.tr);
            }
          } else {
            Get.snackbar('error'.tr, 'Please check your connection'.tr);
          }
        },
      );
    }
  }

  Column bottomButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: InkWell(
            onTap: () async {
              if (isAutoWithdrawal == false) {
                if (_formKey.currentState!.validate()) {
                  connectivityViewModel.startMonitoring();

                  if (connectivityViewModel.isOnline != null) {
                    if (connectivityViewModel.isOnline!) {
                      if (userBankId == '') {
                        Get.snackbar('error', 'please select bank!');
                      } else {
                        showLoadingDialog(context: context);
                        String token =
                            await encryptedSharedPreferences.getString('token');
                        String id =
                            await encryptedSharedPreferences.getString('id');
                        final url = Uri.parse(
                          '${Utility.baseUrl}withdrawalrequests',
                        );
                        Map<String, String> header = {
                          'Authorization': token,
                          'Content-Type': 'application/json'
                        };
                        Map<String, dynamic>? body = {
                          "userId": int.parse(id),
                          "message": "Withdraw request",
                          "userbankId": userBankId,
                          "amount": double.parse(withdrawAmount.text),
                          "createdby": int.parse(id)
                        };

                        var result = await http.post(
                          url,
                          headers: header,
                          body: jsonEncode(body),
                        );

                        print(
                            'token is:$token \n req is : ${jsonEncode(body)}  \n response is :${result.body} ');
                        if (result.statusCode == 401) {
                          SessionExpire();
                        }

                        if (result.statusCode == 200) {
                          AnalyticsService.sendEvent(
                              'withdrawal request success', {
                            'Id': Utility.userId,
                          });
                          hideLoadingDialog(context: context);

                          Get.off(() => WithdrawalSuccessScreenScreen());
                          // Get.snackbar('Success'.tr,
                          //     'you have submitted new withdrawal request!!');
                        } else {
                          AnalyticsService.sendEvent(
                              'withdrawal request failure', {
                            'Id': Utility.userId,
                          });
                          Get.snackbar('error'.tr,
                              '${jsonDecode(result.body)['error']['message']}');
                          hideLoadingDialog(context: context);
                        }
                      }
                      // }
                    } else {
                      Get.snackbar('error'.tr, 'Please check your connection'.tr);
                    }
                  } else {
                    Get.snackbar('error'.tr, 'Please check your connection'.tr);
                  }
                }
              }
            },
            child: buildContainerWithoutImage(
                text: 'Submit'.tr,
                color: isAutoWithdrawal == true
                    ? ColorsUtils.accent.withOpacity(0.5)
                    : ColorsUtils.accent),
          ),
        )
      ],
    );
  }

  Future<void> autoWithdrawalApiCall() async {
    connectivityViewModel.startMonitoring();

    if (connectivityViewModel.isOnline != null) {
      if (connectivityViewModel.isOnline!) {
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
          "frequency": isAutoWithdrawal == false
              ? "${Utility.settlementWithdrawPeriod.toLowerCase()}"
              : 'manual'
        };
        var result =
            await http.patch(url, headers: header, body: jsonEncode(body));

        print(
            'token is:$token } req is ${jsonEncode(body)} \n response is :${result.body} ');
        if (result.statusCode == 401) {
          SessionExpire();
        }

        if (result.statusCode == 200) {
          isAutoWithdrawal = !isAutoWithdrawal;
          if (isAutoWithdrawal == true) {
            withdrawAmount.clear();
            bankListSelect = 'Choose your bank';
            FocusScope.of(context).unfocus();
          }
          setState(() {});
          AnalyticsService.sendEvent('auto withdrawal  request success', {
            'Id': Utility.userId,
          });
          Get.snackbar(
              'Success',
              isAutoWithdrawal == true
                  ? '${'Your withdrawal status has been change to'.tr} ${Utility.settlementWithdrawPeriod.tr}.'
                  : 'Your withdrawal status has been change to manual.'.tr);
        } else {
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

  initData() async {
    token = await encryptedSharedPreferences.getString('token');
    String id = await encryptedSharedPreferences.getString('id');
    final url = Uri.parse(
      '${Utility.baseUrl}usermetapersonals/?filter[where][userId]=$id',
    );
    Map<String, String> header = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };

    var result = await http.get(url, headers: header);

    print('token is:$token } req is $url \n response is :${result.body} ');

    if (result.statusCode == 200) {
      print('resssssss is ${jsonDecode(result.body)[0]['autowithdrawfreq']}');
      if (jsonDecode(result.body)[0]['autowithdrawfreq'] == 'manual') {
        isAutoWithdrawal = false;
        setState(() {});
      } else {
        isAutoWithdrawal = true;
        Utility.settlementWithdrawPeriod =
            '${jsonDecode(result.body)[0]['autowithdrawfreq']}';
        setState(() {});
      }
    } else {
      AnalyticsService.sendEvent('auto withdrawal  request failure', {
        'Id': Utility.userId,
      });
      // Get.snackbar(
      //     'error'.tr, '${jsonDecode(result.body)['error']['message']}');
    }

    await settlementListViewModel.userBankList();

    now = DateTime.now();
    tomorrow = intl.DateFormat('dd MMM yyyy')
        .format(DateTime(now.year, now.month, now.day + 1));
    week = intl.DateFormat('dd MMM yyyy')
        .format(DateTime(now.year, now.month, now.day + 7));
    month = intl.DateFormat('dd MMM yyyy')
        .format(DateTime(now.year, now.month, now.day + 30));
  }
}
