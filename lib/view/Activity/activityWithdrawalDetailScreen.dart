// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/settlement/settlementWithdrawalDetailResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:sadad_merchat_app/viewModel/settlement/settlementViewModel.dart';

class ActivityWithdrawalDetailScreen extends StatefulWidget {
  final String id;
  const ActivityWithdrawalDetailScreen({Key? key, required this.id})
      : super(key: key);

  @override
  State<ActivityWithdrawalDetailScreen> createState() =>
      _SettlementWithdrawalDetailScreenState();
}

class _SettlementWithdrawalDetailScreenState
    extends State<ActivityWithdrawalDetailScreen> {
  SettlementWithdrawalDetailResponseModel? withdrawalRes;
  SettlementWithdrawalListViewModel settlementWithdrawalListViewModel =
      Get.find();

  ///hello
  String token = '';
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
                if (controller.activityWithdrawalDetailApiResponse.status ==
                        Status.LOADING ||
                    controller.activityWithdrawalDetailApiResponse.status ==
                        Status.INITIAL) {
                  return const Center(child: Loader());
                }
                if (controller.activityWithdrawalDetailApiResponse.status ==
                    Status.ERROR) {
                  return const SessionExpire();
                  // return Text('something wrong');
                }
                withdrawalRes =
                    controller.activityWithdrawalDetailApiResponse.data;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    height30(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Icon(Icons.arrow_back_ios_outlined)),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: ClampingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //top details
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // height20(),
                                  customLargeBoldText(
                                      title: 'Withdrawal Details'.tr),
                                  height30(),
                                  Container(
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
                                              color: ColorsUtils.accent,
                                              title: 'Withdrawal Amount',
                                              value:
                                                  '${withdrawalRes!.amount ?? '0'} QAR'),
                                          commonColumnField(
                                              color: ColorsUtils.accent,
                                              title: 'Sadad Charges',
                                              value:
                                                  '${withdrawalRes!.withdrawalcommission ?? "0"} QAR '),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              commonColumnField(
                                                  color: ColorsUtils.accent,
                                                  title:
                                                      'Balance at Withdrawal Request',
                                                  value:
                                                      '${withdrawalRes!.availableFundWhileRequest ?? "0"} QAR'),
                                              Spacer(),
                                              // Padding(
                                              //   padding: const EdgeInsets.only(
                                              //       bottom: 10),
                                              //   child: const CircleAvatar(
                                              //     backgroundColor:
                                              //         ColorsUtils.lightBg,
                                              //     radius: 12,
                                              //     child: Icon(
                                              //         Icons
                                              //             .arrow_forward_ios_sharp,
                                              //         size: 12,
                                              //         color: ColorsUtils.black),
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  height10(),
                                  Container(
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
                                          customSmallSemiText(
                                              title: 'Withdrawal Type'.tr),
                                          height10(),
                                          customMediumBoldText(
                                              title:
                                                  '${withdrawalRes!.withdrawaltype == null ? 'NA' : withdrawalRes!.withdrawaltype == 'manual' ? 'Manual' : 'Automatic'}',
                                              color: ColorsUtils.accent),
                                          withdrawalRes!.withdrawaltype ==
                                                  'manual'
                                              ? SizedBox()
                                              : Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    height20(),
                                                    customSmallSemiText(
                                                        title:
                                                            'Withdrawal Frequency'),
                                                    height10(),
                                                    customMediumBoldText(
                                                        title:
                                                            '${withdrawalRes!.withdrawaltype == null ? 'NA' : withdrawalRes!.withdrawaltype}',
                                                        color:
                                                            ColorsUtils.accent),
                                                  ],
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  height10(),
                                  Container(
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
                                          Row(
                                            children: [
                                              commonColumnField(
                                                  color: ColorsUtils.black,
                                                  title: 'Bank Name'.tr,
                                                  value:
                                                      '${withdrawalRes!.userbank == null ? 'NA' : withdrawalRes!.userbank!.bank!.name ?? 'NA'}'),
                                              Spacer(),
                                              withdrawalRes!.userbank == null
                                                  ? SizedBox()
                                                  : Container(
                                                      height: 60,
                                                      width: 60,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                            color: ColorsUtils
                                                                .border,
                                                            width: 1),
                                                      ),
                                                      child: Image.network(
                                                        '${Utility.baseUrl}containers/api-banks/download/${withdrawalRes!.userbank!.bank!.logo}',
                                                        headers: {
                                                          HttpHeaders
                                                                  .authorizationHeader:
                                                              token
                                                        },
                                                        fit: BoxFit.contain,
                                                        loadingBuilder:
                                                            (BuildContext
                                                                    context,
                                                                Widget child,
                                                                ImageChunkEvent?
                                                                    loadingProgress) {
                                                          if (loadingProgress ==
                                                              null)
                                                            return child;
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
                                              color: ColorsUtils.accent,
                                              title: 'Bank Number (IBAN)',
                                              value:
                                                  '${withdrawalRes!.userbank == null ? 'NA' : withdrawalRes!.userbank!.ibannumber ?? "NA"} '),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              commonColumnField(
                                                  color: ColorsUtils.black,
                                                  title: 'Bank reference No'.tr,
                                                  value:
                                                      '${withdrawalRes!.userbank == null ? 'NA' : withdrawalRes!.bankreferenceno ?? "NA"}'),
                                              Spacer(),
                                              // Padding(
                                              //   padding: const EdgeInsets.only(
                                              //       bottom: 10),
                                              //   child: const CircleAvatar(
                                              //     backgroundColor:
                                              //         ColorsUtils.lightBg,
                                              //     radius: 12,
                                              //     child: Icon(
                                              //         Icons
                                              //             .arrow_forward_ios_sharp,
                                              //         size: 12,
                                              //         color: ColorsUtils.black),
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  height10(),
                                  Container(
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
                                      child: commonColumnField(
                                          color: ColorsUtils.accent,
                                          title: 'Username',
                                          value:
                                              '${withdrawalRes!.user == null ? 'NA' : withdrawalRes!.user!.name ?? "NA"} '),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            height30(),

                            ///bottom container
                            Container(
                              width: Get.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(
                                      15,
                                    ),
                                    topLeft: Radius.circular(15)),
                                color: ColorsUtils.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customMediumLargeBoldText(
                                        title: 'Track Your Payout'),
                                    height30(),
                                    Stack(
                                      children: [
                                        Positioned(
                                          top: 40,
                                          left: 20,
                                          child: Container(
                                            width: 2,
                                            height:
                                                withdrawalRes!
                                                                .withdrawalrequeststatus!.name ==
                                                            'REQUESTED' ||
                                                        withdrawalRes!
                                                                .withdrawalrequeststatus!
                                                                .name ==
                                                            'CANCELLED' ||
                                                        withdrawalRes!
                                                                .withdrawalrequeststatus!
                                                                .name ==
                                                            'ON HOLD'
                                                    ? Get.width * 0.38
                                                    : Get.width * 0.85,
                                            color: ColorsUtils.green,
                                          ),
                                        ),
                                        Positioned(
                                          top: Get.width * 0.87,
                                          left: 20,
                                          child: Container(
                                            width: 2,
                                            height: Get.width * 0.85,
                                            color: ColorsUtils.white,
                                          ),
                                        ),

                                        ///data
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ///req create
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor:
                                                      ColorsUtils.green,
                                                  child: Image.asset(
                                                      Images.navigator,
                                                      width: 20),
                                                ),
                                                width20(),
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          customSmallBoldText(
                                                              title:
                                                                  'Request Create'),
                                                          Spacer(),
                                                          customVerySmallNorText(
                                                              title: withdrawalRes!
                                                                          .created ==
                                                                      null
                                                                  ? ""
                                                                  : '${DateFormat('dd MMM yyyy, HH:mm:ss').format(DateTime.parse(withdrawalRes!.created.toString()))}',
                                                              color: ColorsUtils
                                                                  .grey),
                                                        ],
                                                      ),
                                                      height20(),
                                                      Container(
                                                        height: Get.width * 0.2,
                                                        decoration: BoxDecoration(
                                                            color: ColorsUtils
                                                                .white,
                                                            border: Border.all(
                                                                width: 1,
                                                                color:
                                                                    ColorsUtils
                                                                        .border),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      20),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  customSmallSemiText(
                                                                      title: 'Withdrawal ID'
                                                                          .tr),
                                                                  Spacer(),
                                                                  commonTextBox(
                                                                      color: ColorsUtils
                                                                          .green,
                                                                      title:
                                                                          'SENT'),
                                                                ],
                                                              ),
                                                              height10(),
                                                              customSmallSemiText(
                                                                  title: withdrawalRes!
                                                                          .withdrawnumber ??
                                                                      "NA"),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            height40(),

                                            ///sadad action
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor:
                                                      ColorsUtils.green,
                                                  child: Image.asset(
                                                      Images.sadadTrack,
                                                      width: 20),
                                                ),
                                                width20(),
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          customSmallBoldText(
                                                              title:
                                                                  'Sadad Action'),
                                                          Spacer(),
                                                          customVerySmallNorText(
                                                              title: withdrawalRes!
                                                                          .payout ==
                                                                      null
                                                                  ? ""
                                                                  : '${DateFormat('dd MMM yyyy, HH:mm:ss').format(DateTime.parse(withdrawalRes!.modified.toString()))}',
                                                              color: ColorsUtils
                                                                  .grey),
                                                        ],
                                                      ),
                                                      height20(),
                                                      Container(
                                                        height: Get.width * 0.2,
                                                        decoration: BoxDecoration(
                                                            color: ColorsUtils
                                                                .white,
                                                            border: Border.all(
                                                                width: 1,
                                                                color:
                                                                    ColorsUtils
                                                                        .border),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      20),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  customSmallSemiText(
                                                                      title: 'Withdrawal ID'
                                                                          .tr),
                                                                  Spacer(),
                                                                  commonTextBox(
                                                                      color: (withdrawalRes!.withdrawalrequeststatus!.name ==
                                                                              'REJECTED')
                                                                          ? ColorsUtils
                                                                              .accent
                                                                          : (withdrawalRes!.withdrawalrequeststatus!.name == 'CANCELLED')
                                                                              ? ColorsUtils.reds
                                                                              : withdrawalRes!.withdrawalrequeststatus!.name == 'REQUESTED'
                                                                                  ? ColorsUtils.yellow
                                                                                  : withdrawalRes!.withdrawalrequeststatus!.name == 'ON HOLD'
                                                                                      ? ColorsUtils.tabUnselectLabel
                                                                                      : ColorsUtils.green,
                                                                      title: '${withdrawalRes!.withdrawalrequeststatus!.name == 'APPROVED' || withdrawalRes!.withdrawalrequeststatus!.name == 'IN PROGRESS' ? 'ACCEPTED' : withdrawalRes!.withdrawalrequeststatus!.name}')
                                                                ],
                                                              ),
                                                              height10(),
                                                              customSmallSemiText(
                                                                  title: withdrawalRes!
                                                                          .withdrawnumber ??
                                                                      "NA"),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            height40(),

                                            ///bank action
                                            withdrawalRes!
                                                            .withdrawalrequeststatus!.name ==
                                                        'REQUESTED' ||
                                                    withdrawalRes!
                                                            .withdrawalrequeststatus!
                                                            .name ==
                                                        'CANCELLED' ||
                                                    withdrawalRes!
                                                            .withdrawalrequeststatus!
                                                            .name ==
                                                        'ON HOLD'
                                                ? SizedBox()
                                                : Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 20,
                                                        backgroundColor:
                                                            ColorsUtils.reds,
                                                        child: Image.asset(
                                                            Images.bankTrack,
                                                            width: 20),
                                                      ),
                                                      width20(),
                                                      Expanded(
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                customSmallMedBoldText(
                                                                    title:
                                                                        'Payout'),
                                                                Spacer(),
                                                                customSmallNorText(
                                                                    title: withdrawalRes!.payout ==
                                                                            null
                                                                        ? ""
                                                                        : '${DateFormat('dd MMM yyyy, HH:mm:ss').format(DateTime.parse(withdrawalRes!.payout!.modified.toString()))}',
                                                                    color: ColorsUtils
                                                                        .grey),
                                                              ],
                                                            ),
                                                            height20(),
                                                            withdrawalRes!
                                                                        .payout ==
                                                                    null
                                                                ? SizedBox()
                                                                : Container(
                                                                    height:
                                                                        Get.width *
                                                                            0.2,
                                                                    decoration: BoxDecoration(
                                                                        color: ColorsUtils
                                                                            .white,
                                                                        border: Border.all(
                                                                            width:
                                                                                1,
                                                                            color: ColorsUtils
                                                                                .border),
                                                                        borderRadius:
                                                                            BorderRadius.circular(15)),
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              20),
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              customSmallSemiText(title: 'Payout ID'.tr),
                                                                              Spacer(),
                                                                              commonTextBox(
                                                                                  color: (withdrawalRes!.payout!.payoutstatus!.name == 'REJECTED' || withdrawalRes!.payout!.payoutstatus!.name == 'CANCELLED')
                                                                                      ? ColorsUtils.reds
                                                                                      : (withdrawalRes!.payout!.payoutstatus!.name == 'REQUESTED' || withdrawalRes!.payout!.payoutstatus!.name == 'PENDING' || withdrawalRes!.payout!.payoutstatus!.name == 'PROCESSING')
                                                                                          ? ColorsUtils.yellow
                                                                                          : ColorsUtils.green,
                                                                                  title: withdrawalRes!.payout!.payoutstatus!.name ?? "NA")
                                                                            ],
                                                                          ),
                                                                          height10(),
                                                                          customSmallSemiText(
                                                                              title: '${withdrawalRes!.payout!.payoutId ?? "NA"}'),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                            height10(),
                                                            withdrawalRes!
                                                                        .payout!
                                                                        .payoutstatus!
                                                                        .name ==
                                                                    'REJECTED'
                                                                ? Container(
                                                                    width: Get
                                                                        .width,
                                                                    height:
                                                                        Get.width *
                                                                            0.2,
                                                                    decoration: BoxDecoration(
                                                                        color: ColorsUtils
                                                                            .white,
                                                                        border: Border.all(
                                                                            width:
                                                                                1,
                                                                            color: ColorsUtils
                                                                                .border),
                                                                        borderRadius:
                                                                            BorderRadius.circular(15)),
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              20),
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          customSmallSemiText(
                                                                              title: 'Rejection Reason'.tr),
                                                                          height10(),
                                                                          customSmallSemiText(
                                                                              title: withdrawalRes!.rejectedReason == null
                                                                                  ? withdrawalRes!.payout == null
                                                                                      ? 'NA'
                                                                                      : withdrawalRes!.payout!.reasonToReject ?? "NA"
                                                                                  : withdrawalRes!.rejectedReason ?? 'NA' ?? 'NA'),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
                                                                : SizedBox(),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                            height40()
                                          ],
                                        ),
                                      ],
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
    await settlementWithdrawalListViewModel.activityWithdrawalDetail(widget.id);
  }
}
