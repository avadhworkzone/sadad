// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/settlement/settlementPayoutDetailResponse.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/settlement/withdrawalDetailScreen.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:sadad_merchat_app/viewModel/settlement/settlementViewModel.dart';

class SettlementPayoutDetailScreen extends StatefulWidget {
  final String id;
  const SettlementPayoutDetailScreen({Key? key, required this.id})
      : super(key: key);

  @override
  State<SettlementPayoutDetailScreen> createState() =>
      _SettlementPayoutDetailScreenState();
}

class _SettlementPayoutDetailScreenState
    extends State<SettlementPayoutDetailScreen> {
  SettlementPayoutDetailResponseModel? payoutRes;
  String token = '';
  SettlementWithdrawalListViewModel settlementWithdrawalListViewModel =
      Get.find();
  ConnectivityViewModel connectivityViewModel = Get.find();

  @override
  void initState() {
    connectivityViewModel.startMonitoring();

    initData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (connectivityViewModel.isOnline != null) {
      if (connectivityViewModel.isOnline!) {
        return Scaffold(
            backgroundColor: ColorsUtils.lightBg,
            body: GetBuilder<SettlementWithdrawalListViewModel>(
              builder: (controller) {
                if (controller.settlementPayoutDetailApiResponse.status ==
                        Status.LOADING ||
                    controller.settlementPayoutDetailApiResponse.status ==
                        Status.INITIAL) {
                  return const Center(child: Loader());
                }
                if (controller.settlementPayoutDetailApiResponse.status ==
                    Status.ERROR) {
                  return const SessionExpire();
                  // return Text('something wrong');
                }
                payoutRes = controller.settlementPayoutDetailApiResponse.data;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    height40(),
                    BackButton(),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              height30(),
                              customLargeBoldText(title: 'Payout Details'.tr),
                              height30(),
                              Container(
                                decoration: BoxDecoration(
                                    color: ColorsUtils.white,
                                    border: Border.all(
                                        width: 1, color: ColorsUtils.border),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          customSmallSemiText(
                                              title: 'Payout ID'.tr),
                                          Spacer(),
                                          commonTextBox(
                                              color: (payoutRes!.payoutstatus!
                                                              .name ==
                                                          'REJECTED' ||
                                                      payoutRes!.payoutstatus!
                                                              .name ==
                                                          'CANCELLED')
                                                  ? ColorsUtils.reds
                                                  : payoutRes!.payoutstatus!
                                                              .name ==
                                                          'REQUESTED'
                                                      ? ColorsUtils.yellow
                                                      : ColorsUtils.green,
                                              title:
                                                  '${payoutRes!.payoutstatus!.name ?? "NA"}')
                                        ],
                                      ),
                                      height10(),
                                      customMediumBoldText(
                                          title:
                                              '${payoutRes!.payoutId ?? 'NA'}'),
                                      height10(),
                                      Directionality(
                                        textDirection: TextDirection.ltr,
                                        child: customSmallSemiText(
                                            title:
                                                '${intl.DateFormat('dd MMM yyyy, HH:mm:ss').format(DateTime.parse(payoutRes!.created.toString()))}',
                                            color: ColorsUtils.grey),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              // height10(),
                              // Container(
                              //   decoration: BoxDecoration(
                              //       color: ColorsUtils.white,
                              //       border: Border.all(
                              //           width: 1, color: ColorsUtils.border),
                              //       borderRadius: BorderRadius.circular(15)),
                              //   child: Padding(
                              //     padding: const EdgeInsets.all(20),
                              //     child: Column(
                              //       crossAxisAlignment: CrossAxisAlignment.start,
                              //       children: [
                              //         customSmallSemiText(title: 'Payout Type'),
                              //         height10(),
                              //         Row(
                              //           children: [
                              //             customMediumBoldText(
                              //                 title:
                              //                     '${payoutRes!.withdrawalrequest!.withdrawaltype == 'manual' ? payoutRes!.withdrawalrequest!.withdrawaltype : 'Automatic'}',
                              //                 color: ColorsUtils.accent),
                              //             Spacer(),
                              //             Image.asset(
                              //               Images.onlinePayment,
                              //               height: 30,
                              //             )
                              //           ],
                              //         )
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              height10(),
                              Container(
                                decoration: BoxDecoration(
                                    color: ColorsUtils.white,
                                    border: Border.all(
                                        width: 1, color: ColorsUtils.border),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      commonColumnField(
                                          color: ColorsUtils.accent,
                                          title: 'Payout Amount'.tr,
                                          value:
                                              '${payoutRes!.payoutAmount} QAR'),
                                      commonColumnField(
                                          color: ColorsUtils.accent,
                                          title: 'Payout charges'.tr,
                                          value:
                                              '${payoutRes!.payoutCommissionAmount} QAR'),
                                      Row(
                                        children: [
                                          commonColumnField(
                                              color: ColorsUtils.black,
                                              title: 'Bank Name'.tr,
                                              value:
                                                  '${payoutRes!.withdrawalrequest!.userbank == null ? 'NA' : payoutRes!.withdrawalrequest!.userbank!.bank!.name ?? 'NA'}'),
                                          Spacer(),
                                          payoutRes!.withdrawalrequest!
                                                      .userbank ==
                                                  null
                                              ? SizedBox()
                                              : Container(
                                                  height: 60,
                                                  width: 60,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                        color:
                                                            ColorsUtils.border,
                                                        width: 1),
                                                  ),
                                                  child: Image.network(
                                                    '${Utility.baseUrl}containers/api-banks/download/${payoutRes!.withdrawalrequest!.userbank!.bank!.logo}',
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
                                                )
                                        ],
                                      ),
                                      commonColumnField(
                                          color: ColorsUtils.black,
                                          title: 'Bank Number (IBAN)'.tr,
                                          value:
                                              '${payoutRes!.withdrawalrequest!.userbank == null ? 'NA' : payoutRes!.withdrawalrequest!.userbank!.ibannumber}'),
                                      InkWell(
                                        onTap: () {
                                          Get.to(() =>
                                              SettlementWithdrawalDetailScreen(
                                                id: payoutRes!
                                                    .withdrawalrequest!.id
                                                    .toString(),
                                              ));
                                        },
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            commonColumnField(
                                                color: ColorsUtils.black,
                                                title: 'Withdrawal ID'.tr,
                                                value:
                                                    '${payoutRes!.withdrawalrequest!.withdrawnumber}'),
                                            Spacer(),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10),
                                              child: const CircleAvatar(
                                                backgroundColor:
                                                    ColorsUtils.lightBg,
                                                radius: 12,
                                                child: Icon(
                                                    Icons
                                                        .arrow_forward_ios_sharp,
                                                    size: 12,
                                                    color: ColorsUtils.black),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      commonColumnField(
                                          color: ColorsUtils.black,
                                          title: 'Bank reference No'.tr,
                                          value:
                                              '${payoutRes!.withdrawalrequest!.bankreferenceno ?? "NA"}'),
                                    ],
                                  ),
                                ),
                              ),
                              height10(),
                              payoutRes!.payoutstatus!.name != 'REJECTED' ||
                                      (payoutRes!.reasonToReject == '' ||
                                          payoutRes!.reasonToReject == null)
                                  ? SizedBox()
                                  : Container(
                                      width: Get.width,
                                      decoration: BoxDecoration(
                                          color: ColorsUtils.white,
                                          border: Border.all(
                                              width: 1,
                                              color: ColorsUtils.border),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            commonColumnField(
                                                color: ColorsUtils.black,
                                                title: 'Rejection Reason'.tr,
                                                value:
                                                    '${payoutRes!.reasonToReject ?? "NA"}'),
                                          ],
                                        ),
                                      ),
                                    ),
                              height30()
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ));
      } else {
        return InternetNotFound(
          onTap: () async {
            connectivityViewModel.startMonitoring();

            if (connectivityViewModel.isOnline != null) {
              if (connectivityViewModel.isOnline!) {
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

  void initData() async {
    token = await encryptedSharedPreferences.getString('token');

    await settlementWithdrawalListViewModel.settlementPayoutDetail(widget.id);
  }
}
