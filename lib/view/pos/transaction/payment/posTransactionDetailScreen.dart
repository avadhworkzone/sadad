import 'dart:developer';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/transaction/payment/posPaymentDetailResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/downloadFile.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/pos/terminals/terminalDetailScreen.dart';
import 'package:sadad_merchat_app/view/pos/transaction/refund/posRefundTransactionScreen.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:sadad_merchat_app/viewModel/pos/transaction/posTransactionViewModel.dart';

class PosTransactionDetailScreen extends StatefulWidget {
  String? id;
  PosTransactionDetailScreen({Key? key, this.id}) : super(key: key);

  @override
  State<PosTransactionDetailScreen> createState() =>
      _PosTransactionDetailScreenState();
}

class _PosTransactionDetailScreenState
    extends State<PosTransactionDetailScreen> {
  PosTransactionViewModel posTransactionViewModel = Get.find();
  PosPaymentDetailResponseModel? paymentDetailRes;
  EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences();
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
            body: GetBuilder<PosTransactionViewModel>(
              builder: (controller) {
                log('status is ${controller.posPaymentDetailApiResponse.status}');
                if (controller.posPaymentDetailApiResponse.status ==
                        Status.LOADING ||
                    controller.posPaymentDetailApiResponse.status ==
                        Status.INITIAL) {
                  return const Center(
                    child: Loader(),
                  );
                }
                if (controller.posPaymentDetailApiResponse.status ==
                    Status.ERROR) {
                  //return const Center(child: Text('Error'));

                  return SessionExpire();
                }
                paymentDetailRes =
                    posTransactionViewModel.posPaymentDetailApiResponse.data;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      height60(),
                      Row(
                        children: [
                          InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: const Icon(Icons.arrow_back_ios)),
                          // const Spacer(),
                          // Icon(Icons.more_vert)
                        ],
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              height40(),
                              customMediumLargeBoldText(
                                  color: ColorsUtils.black,
                                  title: 'Transactions Details'.tr),
                              height20(),
                              Container(
                                width: Get.width,
                                decoration: BoxDecoration(
                                    color: ColorsUtils.white,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        color: ColorsUtils.border, width: 1)),
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            paymentDetailRes == null
                                                ? SizedBox()
                                                : commonColumnField(
                                                    color: ColorsUtils.black,
                                                    title: 'Transactions ID.',
                                                    value:
                                                        '${paymentDetailRes!.invoicenumber ?? "NA"}'),
                                            Spacer(),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: commonTextBox(
                                                  title:
                                                      '${paymentDetailRes!.transactionstatus!.name}',
                                                  color: paymentDetailRes!
                                                              .transactionstatus!
                                                              .id
                                                              .toString() ==
                                                          '1'
                                                      ? ColorsUtils.yellow
                                                      : paymentDetailRes!
                                                                  .transactionstatus!
                                                                  .id
                                                                  .toString() ==
                                                              '2'
                                                          ? ColorsUtils.reds
                                                          : paymentDetailRes!
                                                                      .transactionstatus!
                                                                      .id
                                                                      .toString() ==
                                                                  '3'
                                                              ? ColorsUtils
                                                                  .green
                                                              : paymentDetailRes!
                                                                          .transactionstatus!
                                                                          .id
                                                                          .toString() ==
                                                                      '4'
                                                                  ? ColorsUtils
                                                                      .green
                                                                  : paymentDetailRes!
                                                                              .transactionstatus!.id
                                                                              .toString() ==
                                                                          '5'
                                                                      ? ColorsUtils
                                                                          .yellow
                                                                      : paymentDetailRes!.transactionstatus!.id.toString() ==
                                                                              '6'
                                                                          ? ColorsUtils
                                                                              .blueBerryPie
                                                                          : ColorsUtils
                                                                              .accent),
                                            )
                                          ],
                                        ),
                                        height10(),
                                        Directionality(
                                          textDirection: TextDirection.ltr,
                                          child: customSmallSemiText(
                                              color: ColorsUtils.grey,
                                              title:
                                                  '${intl.DateFormat('dd MMM yyyy, HH:mm:ss').format(DateTime.parse(paymentDetailRes!.created.toString()))}'),
                                        )
                                      ]),
                                ),
                              ),
                              height10(),
                              Container(
                                width: Get.width,
                                decoration: BoxDecoration(
                                    color: ColorsUtils.white,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        color: ColorsUtils.border, width: 1)),
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        commonColumnField(
                                            color: ColorsUtils.black,
                                            title: 'Transactions Amount'.tr,
                                            value:
                                                '${paymentDetailRes!.amount ?? "0"} QAR'),
                                        commonColumnField(
                                            color: ColorsUtils.black,
                                            title: 'Transactions Type'.tr,
                                            value:
                                                '${paymentDetailRes!.postransaction!.transactionType == 'manual_entry' ? 'ManualEntry Purchase' : paymentDetailRes!.postransaction!.transactionType == 'card_verification' ? 'Card Verification' : paymentDetailRes!.postransaction!.transactionType == 'preauth_complete' ? 'Preauth Complete' : paymentDetailRes!.postransaction!.transactionType.toString().capitalize ?? "NA"}'),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            commonColumnField(
                                                color: ColorsUtils.black,
                                                title: 'Payment Method'.tr,
                                                value: paymentDetailRes!
                                                            .cardtype ==
                                                        null
                                                    ? 'NA'
                                                    : '${paymentDetailRes!.cardtype ?? "NA"}'),
                                            Spacer(),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 5),
                                              child: Image.asset(
                                                paymentDetailRes!.cardtype ==
                                                        'MASTERCARD'
                                                    ? Images.masterCard
                                                    : paymentDetailRes!
                                                                .cardtype ==
                                                            'VISA'
                                                        ? Images.visaCard
                                                        : paymentDetailRes!
                                                                    .cardtype ==
                                                                'GOOGLE PAY'
                                                            ? Images.googlePay
                                                            : paymentDetailRes!
                                                                        .cardtype ==
                                                                    'APPLE PAY'
                                                                ? Images
                                                                    .applePay
                                                                : paymentDetailRes!
                                                                            .cardtype ==
                                                                        'NAPS'
                                                                    ? Images
                                                                        .napsImage
                                                                    : paymentDetailRes!.cardtype ==
                                                                            'AMERICAN EXPRESS'
                                                                        ? Images
                                                                            .amex
                                                                        : paymentDetailRes!.cardtype ==
                                                                                'UPI'
                                                                            ? Images.upi
                                                                            : paymentDetailRes!.cardtype == 'JCB'
                                                                                ? Images.jcb
                                                                                : paymentDetailRes!.cardtype == 'SADAD PAY'
                                                                                    ? Images.sadadWalletPay
                                                                                    : Images.mobilePay,
                                                width: 45,
                                                height: 45,
                                              ),
                                            )
                                          ],
                                        ),
                                        commonColumnField(
                                            color: ColorsUtils.black,
                                            title: 'Transactions Mode'.tr,
                                            value: paymentDetailRes!
                                                        .transactionmode ==
                                                    null
                                                ? 'NA'
                                                : '${paymentDetailRes!.transactionmode!.name ?? 'NA'}'),
                                        commonColumnField(
                                            color: ColorsUtils.black,
                                            title: 'Card Number'.tr,
                                            value:
                                                '${paymentDetailRes!.postransaction!.maskedPan ?? "NA"}'),
                                        commonColumnField(
                                            color: ColorsUtils.black,
                                            title: 'Card Entry Type'.tr,
                                            value:
                                                '${paymentDetailRes!.postransaction!.cardType ?? "NA"}'),
                                      ]),
                                ),
                              ),
                              height10(),
                              Container(
                                width: Get.width,
                                decoration: BoxDecoration(
                                    color: ColorsUtils.white,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        color: ColorsUtils.border, width: 1)),
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        commonColumnField(
                                            color: ColorsUtils.black,
                                            title: 'RRN',
                                            value:
                                                '${paymentDetailRes!.postransaction!.rrn ?? "NA"}'),
                                        commonColumnField(
                                            color: ColorsUtils.black,
                                            title: 'Sadad charges'.tr,
                                            value:
                                                '${paymentDetailRes!.servicecharge ?? "NA"} ${paymentDetailRes!.servicecharge != null ? 'QAR' : ''}'),
                                      ]),
                                ),
                              ),
                              height10(),
                              Container(
                                width: Get.width,
                                decoration: BoxDecoration(
                                    color: ColorsUtils.white,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        color: ColorsUtils.border, width: 1)),
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Get.to(() => TerminalDetailScreen(
                                                id: paymentDetailRes!
                                                    .postransaction!
                                                    .terminal!
                                                    .terminalId));
                                          },
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              commonColumnField(
                                                  color: ColorsUtils.black,
                                                  title: 'Terminal ID'.tr,
                                                  value:
                                                      '${paymentDetailRes!.postransaction!.terminal!.terminalId ?? "NA"}'),
                                              width20(),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10),
                                                child: Container(
                                                  width: 20,
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          color: ColorsUtils
                                                              .black)),
                                                  child: Icon(
                                                      Icons
                                                          .arrow_forward_ios_sharp,
                                                      size: 12),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        commonColumnField(
                                            color: ColorsUtils.black,
                                            title: 'Terminal Name'.tr,
                                            value:
                                                '${paymentDetailRes!.postransaction!.terminal!.name ?? "NA"}'),
                                        commonColumnField(
                                            color: ColorsUtils.black,
                                            title: 'Terminal Location'.tr,
                                            value:
                                                '${paymentDetailRes!.postransaction!.terminal!.location ?? 'NA'}'),
                                        commonColumnField(
                                            color: ColorsUtils.black,
                                            title: 'Device Serial Number'.tr,
                                            value:
                                                '${paymentDetailRes!.postransaction!.terminal!.deviceSerialNo ?? "NA"}'),
                                        commonColumnField(
                                            color: ColorsUtils.black,
                                            title: 'Device Type'.tr,
                                            value:
                                                '${paymentDetailRes!.postransaction!.terminal!.posdevice!.devicetype ?? "NA"}'),
                                      ]),
                                ),
                              ),
                              height10(),
                              Container(
                                width: Get.width,
                                decoration: BoxDecoration(
                                    color: ColorsUtils.white,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        color: ColorsUtils.border, width: 1)),
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: commonColumnField(
                                      color: ColorsUtils.black,
                                      title: 'Transaction response message'.tr,
                                      value:
                                          '${paymentDetailRes!.postransaction!.transResponseMessage ?? "NA"}'),
                                ),
                              ),
                              height10(),
                              Container(
                                width: Get.width,
                                decoration: BoxDecoration(
                                    color: ColorsUtils.white,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        color: ColorsUtils.border, width: 1)),
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            paymentDetailRes!.refundTxn ==
                                                        null ||
                                                    paymentDetailRes!
                                                        .refundTxn!.isEmpty
                                                ? SizedBox()
                                                : Get.to(() =>
                                                    PosRefundTransactionScreen(
                                                      id: paymentDetailRes!
                                                          .refundTxn!.first.id
                                                          .toString(),
                                                    ));
                                          },
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              commonColumnField(
                                                  color: ColorsUtils.black,
                                                  title: 'Refund Id'.tr,
                                                  value:
                                                      '${(paymentDetailRes!.refundTxn == null || paymentDetailRes!.refundTxn!.isEmpty) ? "NA" : paymentDetailRes!.refundTxn!.first.invoicenumber ?? "NA"}'),
                                              width20(),
                                              (paymentDetailRes!.refundTxn ==
                                                          null ||
                                                      paymentDetailRes!
                                                          .refundTxn!.isEmpty)
                                                  ? SizedBox()
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 10),
                                                      child: Container(
                                                        width: 20,
                                                        height: 20,
                                                        decoration: BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                                color:
                                                                    ColorsUtils
                                                                        .black)),
                                                        child: Icon(
                                                            Icons
                                                                .arrow_forward_ios_sharp,
                                                            size: 12),
                                                      ),
                                                    )
                                            ],
                                          ),
                                        ),
                                        commonColumnField(
                                            color: ColorsUtils.black,
                                            title: 'Dispute ID'.tr,
                                            value: paymentDetailRes!.dispute ==
                                                    null
                                                ? 'NA'
                                                : '${paymentDetailRes!.dispute!.disputeId ?? "NA"}'),
                                      ]),
                                ),
                              ),
                              height30(),
                              InkWell(
                                onTap: () {
                                  downloadFile(
                                      context: context,
                                      isRadioSelected: 1,
                                      isEmail: false,
                                      url:
                                          '${Utility.baseUrl}transactions/downloadReceipt?transactionId=${paymentDetailRes!.invoicenumber}&isPOS=true');
                                },
                                child: commonButtonBox(
                                    color: ColorsUtils.accent,
                                    text: 'Download Receipt'.tr,
                                    img: Images.download),
                              ),
                              height30(),
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
                setState(() {});
                initData();
              } else {
                Get.snackbar('error', 'Please check your connection');
              }
            } else {
              Get.snackbar('error', 'Please check your connection');
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
              Get.snackbar('error', 'Please check your connection');
            }
          } else {
            Get.snackbar('error', 'Please check your connection');
          }
        },
      );
    }
  }

  void initData() async {
    String userId = await encryptedSharedPreferences.getString('id');

    posTransactionViewModel.paymentDetail(id: widget.id, userId: userId);
  }
}
