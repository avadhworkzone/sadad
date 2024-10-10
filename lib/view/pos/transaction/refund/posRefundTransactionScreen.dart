import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/transaction/refund/posRefundDetailResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/pos/transaction/payment/posTransactionDetailScreen.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:sadad_merchat_app/viewModel/pos/transaction/posTransactionViewModel.dart';

class PosRefundTransactionScreen extends StatefulWidget {
  String? id;
  PosRefundTransactionScreen({Key? key, this.id}) : super(key: key);

  @override
  State<PosRefundTransactionScreen> createState() =>
      _PosRefundTransactionScreenState();
}

class _PosRefundTransactionScreenState
    extends State<PosRefundTransactionScreen> {
  PosTransactionViewModel posTransactionViewModel = Get.find();
  PosRefundDetailResponseModel? refundDetailRes;
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
        return Scaffold(body: GetBuilder<PosTransactionViewModel>(
          builder: (controller) {
            if (controller.posRefundDetailApiResponse.status ==
                    Status.LOADING ||
                controller.posRefundDetailApiResponse.status ==
                    Status.INITIAL) {
              return const Center(
                child: Loader(),
              );
            }
            if (controller.posRefundDetailApiResponse.status == Status.ERROR) {
              // return const Center(child: Text('Error'));

              return SessionExpire();
            }
            refundDetailRes =
                posTransactionViewModel.posRefundDetailApiResponse.data;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  height60(),
                  InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: const Icon(Icons.arrow_back_ios)),
                  height40(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          customMediumLargeBoldText(
                              color: ColorsUtils.black,
                              title: 'Refund Details'.tr),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        refundDetailRes == null
                                            ? const SizedBox()
                                            : commonColumnField(
                                                color: ColorsUtils.black,
                                                title: 'Refund ID.'.tr,
                                                value:
                                                    '${refundDetailRes!.invoicenumber ?? "NA"}'),
                                        const Spacer(),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: commonTextBox(
                                              title:
                                                  '${refundDetailRes!.transactionstatus!.name == 'PENDING' ? 'REQUESTED' : refundDetailRes!.transactionstatus!.name ?? 'NA'}',
                                              color: refundDetailRes!
                                                          .transactionstatus!.id
                                                          .toString() ==
                                                      '1'
                                                  ? ColorsUtils.yellow
                                                  : refundDetailRes!
                                                              .transactionstatus!
                                                              .id
                                                              .toString() ==
                                                          '2'
                                                      ? ColorsUtils.reds
                                                      : refundDetailRes!
                                                                  .transactionstatus!
                                                                  .id
                                                                  .toString() ==
                                                              '3'
                                                          ? ColorsUtils.green
                                                          : refundDetailRes!
                                                                      .transactionstatus!
                                                                      .id
                                                                      .toString() ==
                                                                  '4'
                                                              ? ColorsUtils
                                                                  .green
                                                              : refundDetailRes!
                                                                          .transactionstatus!
                                                                          .id
                                                                          .toString() ==
                                                                      '5'
                                                                  ? ColorsUtils
                                                                      .yellow
                                                                  : refundDetailRes!
                                                                              .transactionstatus!.id
                                                                              .toString() ==
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
                                              '${intl.DateFormat('dd MMM yyyy, HH:mm:ss').format(DateTime.parse(refundDetailRes!.created.toString()))}'),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    commonColumnField(
                                        color: ColorsUtils.black,
                                        title: 'Transaction Type'.tr,
                                        value:
                                            '${refundDetailRes!.postransaction!.transactionType}'),
                                    commonColumnField(
                                        color: ColorsUtils.accent,
                                        title: 'Refund amount'.tr,
                                        value:
                                            '${refundDetailRes!.amount ?? "NA"} QAR'),
                                    commonColumnField(
                                        color: ColorsUtils.black,
                                        title: 'Sadad Charges'.tr,
                                        value: refundDetailRes!.refundcharge ==
                                                null
                                            ? '0 QAR'
                                            : refundDetailRes!.refundcharge
                                                    .toString() +
                                                ' QAR'),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    commonColumnField(
                                        color: ColorsUtils.black,
                                        title: 'Terminal Id'.tr,
                                        value:
                                            '${refundDetailRes!.postransaction!.terminal!.terminalId ?? "NA"}'),
                                    commonColumnField(
                                        color: ColorsUtils.accent,
                                        title: 'Terminal Name:'.tr,
                                        value:
                                            '${refundDetailRes!.postransaction!.terminal!.name ?? "NA"}'),
                                    commonColumnField(
                                        color: ColorsUtils.black,
                                        title: 'Device ID'.tr,
                                        value:
                                            '${refundDetailRes!.postransaction!.terminal!.posdevice!.deviceId ?? 'NA'}'),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            refundDetailRes!.entityId == null
                                                ? SizedBox()
                                                : Get.to(
                                                    PosTransactionDetailScreen(
                                                    id: refundDetailRes!
                                                        .entityId!.id
                                                        .toString(),
                                                  ));
                                          },
                                          child: commonColumnField(
                                              color: ColorsUtils.black,
                                              title: 'Transaction ID'.tr,
                                              value: refundDetailRes!
                                                          .actualTxn ==
                                                      null
                                                  ? "NA"
                                                  : '${refundDetailRes!.actualTxn!.invoicenumber ?? "NA"}'),
                                        ),
                                        refundDetailRes!.actualTxn == null
                                            ? SizedBox()
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          color:
                                                              ColorsUtils.black,
                                                          width: 1)),
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 2),
                                                    child: Icon(
                                                        Icons
                                                            .arrow_forward_ios_rounded,
                                                        size: 12),
                                                  ),
                                                ),
                                              )
                                      ],
                                    ),
                                    commonColumnField(
                                        color: ColorsUtils.accent,
                                        title: 'Transaction Amount'.tr,
                                        value: refundDetailRes!.entityId == null
                                            ? '0'
                                            : '${refundDetailRes!.entityId!.amount ?? "0"} QAR'),
                                    // commonColumnField(
                                    //     color: ColorsUtils.black,
                                    //     title: 'Transaction response code'.tr,
                                    //     value: refundDetailRes!.txnBankStatus ==
                                    //             null
                                    //         ? "NA"
                                    //         : '${refundDetailRes!.txnBankStatus!.first.code ?? "NA"}'),
                                    commonColumnField(
                                        color: ColorsUtils.black,
                                        title:
                                            'Transaction response message'.tr,
                                        value:
                                            '${refundDetailRes!.postransaction!.transResponseMessage ?? "NA"}'),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        commonColumnField(
                                            color: ColorsUtils.black,
                                            title: 'Payment Method'.tr,
                                            value:
                                                '${refundDetailRes!.cardtype ?? "NA"}'),
                                        Spacer(),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Image.asset(
                                              refundDetailRes!.cardtype ==
                                                      'MASTERCARD'
                                                  ? Images.masterCard
                                                  : refundDetailRes!.cardtype ==
                                                          'VISA'
                                                      ? Images.visaCard
                                                      : refundDetailRes!
                                                                  .cardtype ==
                                                              'GOOGLE PAY'
                                                          ? Images.googlePay
                                                          : refundDetailRes!
                                                                      .cardtype ==
                                                                  'APPLE PAY'
                                                              ? Images.applePay
                                                              : refundDetailRes!
                                                                          .cardtype ==
                                                                      'AMERICAN EXPRESS'
                                                                  ? Images.amex
                                                                  : refundDetailRes!
                                                                              .cardtype ==
                                                                          'JCB'
                                                                      ? Images
                                                                          .jcb
                                                                      : refundDetailRes!.cardtype ==
                                                                              'SADAD PAY'
                                                                          ? Images
                                                                              .sadadWalletPay
                                                                          : refundDetailRes!.cardtype == 'SADAD'
                                                                              ? Images.sadadWalletPay
                                                                              : Images.onlinePayment,

                                              // : icon == 'AMERICAN EXPRESS'
                                              //                                 ? Images.amex
                                              //                                 : icon == 'UPI'
                                              //                                     ? Images.upi
                                              //                                     : icon == 'JCB'
                                              //                                         ? Images.jcb
                                              //                                         : icon == 'SADAD PAY'
                                              //                                             ? Images.sadadWalletPay
                                              //                                             : Images.onlinePayment,
                                              width: 30,
                                              height: 30),
                                        )
                                      ],
                                    ),
                                    commonColumnField(
                                        color: ColorsUtils.accent,
                                        title: 'Transaction mode'.tr,
                                        value: refundDetailRes!
                                                    .transactionmode ==
                                                null
                                            ? 'NA'
                                            : '${refundDetailRes!.transactionmode!.name ?? 'NA'}'),
                                    commonColumnField(
                                        color: ColorsUtils.black,
                                        title: 'Card Entry Type'.tr,
                                        value:
                                            '${refundDetailRes!.postransaction!.cardType ?? "NA"}'),
                                    commonColumnField(
                                        color: ColorsUtils.black,
                                        title: 'RRN',
                                        value:
                                            '${refundDetailRes!.postransaction!.rrn ?? "NA"}'),
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
                                  color: ColorsUtils.accent,
                                  title: 'Dispute ID'.tr,
                                  value:
                                      '${refundDetailRes!.disputeId ?? "NA"}'),
                            ),
                          ),
                          height30()
                        ],
                      ),
                    ),
                  ),
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

    posTransactionViewModel.refundDetail(id: widget.id, userId: userId);
  }
}
