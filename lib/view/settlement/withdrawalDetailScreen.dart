// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/settlement/settlementWithdrawalDetailResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/settlement/settlementPayoutDetailScreen.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:sadad_merchat_app/viewModel/settlement/settlementViewModel.dart';

class SettlementWithdrawalDetailScreen extends StatefulWidget {
  final String id;
  const SettlementWithdrawalDetailScreen({Key? key, required this.id})
      : super(key: key);

  @override
  State<SettlementWithdrawalDetailScreen> createState() =>
      _SettlementWithdrawalDetailScreenState();
}

class _SettlementWithdrawalDetailScreenState
    extends State<SettlementWithdrawalDetailScreen> {
  SettlementWithdrawalDetailResponseModel? withdrawalRes;
  SettlementWithdrawalListViewModel settlementWithdrawalListViewModel =
      Get.find();
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
                if (controller.settlementWithdrawalDetailApiResponse.status ==
                        Status.LOADING ||
                    controller.settlementWithdrawalDetailApiResponse.status ==
                        Status.INITIAL) {
                  return const Center(child: Loader());
                }
                if (controller.settlementWithdrawalDetailApiResponse.status ==
                    Status.ERROR) {
                  return const SessionExpire();
                  // return Text('something wrong');
                }
                withdrawalRes =
                    controller.settlementWithdrawalDetailApiResponse.data;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    height40(),
                    BackButton(),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              height30(),
                              customLargeBoldText(
                                  title: 'Withdrawal Details'.tr),
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
                                              title: 'Withdrawal ID'.tr),
                                          Spacer(),
                                          commonTextBox(
                                              color: (withdrawalRes!
                                                              .withdrawalrequeststatus!
                                                              .name ==
                                                          'REJECTED' ||
                                                      withdrawalRes!
                                                              .withdrawalrequeststatus!
                                                              .name ==
                                                          'CANCELLED')
                                                  ? ColorsUtils.reds
                                                  : withdrawalRes!
                                                              .withdrawalrequeststatus!
                                                              .name ==
                                                          'REQUESTED'
                                                      ? ColorsUtils.yellow
                                                      : ColorsUtils.green,
                                              title:
                                                  '${withdrawalRes!.withdrawalrequeststatus!.name == 'APPROVED' ? 'ACCEPTED' : withdrawalRes!.withdrawalrequeststatus!.name}')
                                        ],
                                      ),
                                      height10(),
                                      customMediumBoldText(
                                          title:
                                              '${withdrawalRes!.withdrawnumber ?? "NA"}'),
                                      height10(),
                                      Directionality(
                                        textDirection: TextDirection.ltr,
                                        child: customSmallSemiText(
                                            title:
                                                '${intl.DateFormat('dd MMM yyyy, HH:mm:ss').format(DateTime.parse(withdrawalRes!.created.toString()))}',
                                            color: ColorsUtils.grey),
                                      )
                                    ],
                                  ),
                                ),
                              ),
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
                                      customSmallSemiText(
                                          title: 'Withdrawal Type'.tr),
                                      height10(),
                                      Row(
                                        children: [
                                          customMediumBoldText(
                                              title:
                                                  '${withdrawalRes!.withdrawaltype == null ? 'NA' : withdrawalRes!.withdrawaltype == 'manual' ? 'Manual' : 'Automatic'}',
                                              color: ColorsUtils.accent),
                                          Spacer(),
                                          Image.asset(
                                            Images.onlinePayment,
                                            height: 30,
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
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
                                          title: 'Withdrawal Amount'.tr,
                                          value:
                                              '${withdrawalRes!.amount} QAR'),
                                      commonColumnField(
                                          color: ColorsUtils.accent,
                                          title: 'Balance At Withrawal Request',
                                          value:
                                              '${withdrawalRes!.availableFundWhileRequest ?? "0"} QAR'),
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
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                        color:
                                                            ColorsUtils.border,
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
                                      // commonColumnField(
                                      //     color: ColorsUtils.black,
                                      //     title: 'Withdrawal Type',
                                      //     value:
                                      //         '${withdrawalRes!.withdrawaltype ?? "NA"}'),
                                      withdrawalRes!.payout == null
                                          ? SizedBox()
                                          : InkWell(
                                              onTap: () {
                                                if (withdrawalRes!
                                                            .payout!
                                                            .payoutstatus!
                                                            .name ==
                                                        'REJECTED' ||
                                                    withdrawalRes!
                                                            .payout!
                                                            .payoutstatus!
                                                            .name ==
                                                        'PROCESSED') {
                                                  Get.to(() =>
                                                      SettlementPayoutDetailScreen(
                                                          id: withdrawalRes!
                                                              .payout!.id
                                                              .toString()));
                                                }
                                              },
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  commonColumnField(
                                                      color: ColorsUtils.black,
                                                      title: 'Payout Status'.tr,
                                                      value:
                                                          '${withdrawalRes!.payout!.payoutstatus!.name ?? "NA"}'),
                                                  Spacer(),
                                                  ((withdrawalRes!
                                                                  .payout!
                                                                  .payoutstatus!
                                                                  .name ==
                                                              'REJECTED') ||
                                                          (withdrawalRes!
                                                                  .payout!
                                                                  .payoutstatus!
                                                                  .name ==
                                                              'PROCESSED'))
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 10),
                                                          child:
                                                              const CircleAvatar(
                                                            backgroundColor:
                                                                ColorsUtils
                                                                    .lightBg,
                                                            radius: 12,
                                                            child: Icon(
                                                                Icons
                                                                    .arrow_forward_ios_sharp,
                                                                size: 12,
                                                                color:
                                                                    ColorsUtils
                                                                        .black),
                                                          ),
                                                        )
                                                      : SizedBox(),
                                                ],
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              ),
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
    await settlementWithdrawalListViewModel
        .settlementWithdrawalDetail(widget.id);
  }
}
