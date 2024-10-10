// ignore_for_file: unrelated_type_equality_checks, must_be_immutable

import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/payment/transaction/transactionDetailScreen.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import '../../../model/apimodels/responseModel/productScreen/transaction/refundTransactionResponseModel.dart';
import '../../../model/apis/api_response.dart';
import '../../../viewModel/Payment/transaction/transactionViewModel.dart';

class RefundDetailScreen extends StatefulWidget {
  String? id;
  RefundDetailScreen({Key? key, this.id}) : super(key: key);
  @override
  State<RefundDetailScreen> createState() => _RefundDetailScreenState();
}

class _RefundDetailScreenState extends State<RefundDetailScreen> {
  EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences();
  TransactionViewModel transactionViewModel = Get.find();
  TransactionRefundDetailResponseModel? refundTransactionDetailResponse;
  String userid = 'NA';
  String name = 'NA';
  String mobileNo = 'NA';
  String email = 'NA';
  ConnectivityViewModel connectivityViewModel = Get.find();

  @override
  void initState() {
    connectivityViewModel.startMonitoring();

    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (connectivityViewModel.isOnline != null) {
      if (connectivityViewModel.isOnline!) {
        return Scaffold(
            backgroundColor: ColorsUtils.lightBg,
            body: GetBuilder<TransactionViewModel>(
              builder: (controller) {
                if (controller.transactionRefundDetailApiResponse.status ==
                    Status.LOADING) {
                  print('Loading');
                  return const Center(child: Loader());
                }

                if (controller.transactionRefundDetailApiResponse.status ==
                    Status.ERROR) {
                  return const SessionExpire();
                  // return const Text('Error');
                }
                refundTransactionDetailResponse = transactionViewModel
                    .transactionRefundDetailApiResponse.data;
                clientNameEmailMobile();

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      height40(),
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(
                          Icons.arrow_back_ios,
                        ),
                      ),
                      height30(),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Refund Details'.tr,
                                style: ThemeUtils.blackBold.copyWith(
                                  fontSize: FontUtils.medLarge,
                                ),
                              ),
                              height20(),
                              refundDetail(),
                              height10(),
                              transactionAndRefundDetail(),
                              height10(),
                              transactionDetail(),
                              height10(),
                              paymentDetail(),
                              height10(),
                              customerDetail(),
                              height10(),
                              disputeDetail(),
                              height30(),
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

  Container refundDetail() {
    return Container(
      decoration: BoxDecoration(
          color: ColorsUtils.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: ColorsUtils.border, width: 1)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                smallText(title: 'Refund ID.'.tr),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: refundTransactionDetailResponse!.transactionstatusId
                                .toString() ==
                            '1'
                        ? ColorsUtils.yellow
                        : refundTransactionDetailResponse!.transactionstatusId
                                    .toString() ==
                                '2'
                            ? ColorsUtils.reds
                            : refundTransactionDetailResponse!
                                        .transactionstatusId
                                        .toString() ==
                                    '3'
                                ? ColorsUtils.green
                                : refundTransactionDetailResponse!
                                            .transactionstatusId
                                            .toString() ==
                                        '4'
                                    ? ColorsUtils.green
                                    : refundTransactionDetailResponse!
                                                .transactionstatusId
                                                .toString() ==
                                            '5'
                                        ? ColorsUtils.yellow
                                        : refundTransactionDetailResponse!
                                                    .transactionstatusId
                                                    .toString() ==
                                                '6'
                                            ? ColorsUtils.blueBerryPie
                                            : ColorsUtils.accent,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                    child: Text(
                      refundTransactionDetailResponse!.transactionstatusId
                                  .toString() ==
                              '1'
                          ? 'Inprogress'.tr
                          : refundTransactionDetailResponse!.transactionstatusId
                                      .toString() ==
                                  '2'
                              ? 'Failed'.tr
                              : refundTransactionDetailResponse!
                                          .transactionstatusId
                                          .toString() ==
                                      '3'
                                  ? 'Success'.tr
                                  : refundTransactionDetailResponse!
                                              .transactionstatusId
                                              .toString() ==
                                          '4'
                                      ? 'Refund'.tr
                                      : refundTransactionDetailResponse!
                                                  .transactionstatusId
                                                  .toString() ==
                                              '5'
                                          ? 'Requested'.tr
                                          : refundTransactionDetailResponse!
                                                      .transactionstatusId
                                                      .toString() ==
                                                  '6'
                                              ? 'Onhold'.tr
                                              : 'Rejected'.tr,
                      style: ThemeUtils.blackRegular.copyWith(
                          fontSize: FontUtils.verySmall,
                          color: ColorsUtils.white),
                    ),
                  ),
                ),
              ],
            ),
            height10(),
            boldText(
                title: '${refundTransactionDetailResponse!.invoicenumber}'),
            height15(),
            smallGreyText(
                title:
                    '${DateFormat('dd MMM yyyy, HH:ss:mm').format(DateTime.parse(refundTransactionDetailResponse!.created.toString()))}'),
          ],
        ),
      ),
    );
  }

  Container transactionAndRefundDetail() {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
          color: ColorsUtils.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: ColorsUtils.border, width: 1)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            commonColumnField(
              color: ColorsUtils.accent,
              title: 'Transaction Type'.tr,
              value: refundTransactionDetailResponse!.transactionstatusId
                          .toString() ==
                      '1'
                  ? 'Inprogress'.tr
                  : refundTransactionDetailResponse!.transactionstatusId
                              .toString() ==
                          '2'
                      ? 'Failed'.tr
                      : refundTransactionDetailResponse!.transactionstatusId
                                  .toString() ==
                              '3'
                          ? 'Success'.tr
                          : refundTransactionDetailResponse!.transactionstatusId
                                      .toString() ==
                                  '4'
                              ? 'Refund'.tr
                              : refundTransactionDetailResponse!
                                          .transactionstatusId
                                          .toString() ==
                                      '5'
                                  ? 'Pending'.tr
                                  : refundTransactionDetailResponse!
                                              .transactionstatusId
                                              .toString() ==
                                          '6'
                                      ? 'Onhold'.tr
                                      : 'Rejected'.tr,
            ),
            commonColumnField(
                color: ColorsUtils.accent,
                title: 'Refund amount'.tr,
                value: '${refundTransactionDetailResponse!.amount} QAR'),
            commonColumnField(
                color: ColorsUtils.black,
                title: 'Refund type'.tr,
                value:
                    '${refundTransactionDetailResponse!.isPartialRefund == true ? 'Partial'.tr : 'Full'.tr ?? "NA"}'),
            commonColumnField(
                color: ColorsUtils.black,
                title: 'Remaining amount'.tr,
                value: refundTransactionDetailResponse!.entityId == null
                    ? '0 QAR'
                    : '${double.parse(refundTransactionDetailResponse!.entityId!.amount.toString()) - double.parse(refundTransactionDetailResponse!.amount.toString())} QAR'),
            commonColumnField(
                color: ColorsUtils.black,
                title: 'Sadad charges'.tr,
                value:
                    '${refundTransactionDetailResponse!.refundcharge ?? "0"} QAR'),
            commonColumnField(
                color: ColorsUtils.black,
                title: 'Refund reason'.tr,
                value:
                    '${refundTransactionDetailResponse!.transactionNote ?? "NA"}'),
            !(([3, 4, 5].contains(refundTransactionDetailResponse!
                        .transactionmode?.id)) &&
                    refundTransactionDetailResponse!.cardtype == 'SADAD PAY' &&
                    refundTransactionDetailResponse!.transactionentityId == 5)
                ? commonColumnField(
                    color: ColorsUtils.black,
                    title: 'Card Holder Name'.tr,
                    value:
                        '${refundTransactionDetailResponse!.cardholdername ?? "NA"}')
                : SizedBox(),
            !(([3, 4, 5].contains(refundTransactionDetailResponse!
                        .transactionmode?.id)) &&
                    refundTransactionDetailResponse!.cardtype == 'SADAD PAY' &&
                    refundTransactionDetailResponse!.transactionentityId == 5)
                ? commonColumnField(
                    color: ColorsUtils.black,
                    title: 'Transaction response code'.tr,
                    value: refundTransactionDetailResponse!.bankresponse == null
                        ? "NA"
                        : '${refundTransactionDetailResponse!.bankresponse!.responseCode ?? "NA"}')
                : SizedBox(),
            !(([3, 4, 5].contains(refundTransactionDetailResponse!
                        .transactionmode?.id)) &&
                    refundTransactionDetailResponse!.cardtype == 'SADAD PAY' &&
                    refundTransactionDetailResponse!.transactionentityId == 5)
                ? commonColumnField(
                    color: ColorsUtils.black,
                    title: 'Transaction response message'.tr,
                    value: refundTransactionDetailResponse!.bankresponse == null
                        ? "NA"
                        : '${refundTransactionDetailResponse!.bankresponse!.explanation}')
                : SizedBox()
          ],
        ),
      ),
    );
  }

  Widget transactionDetail() {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
          color: ColorsUtils.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: ColorsUtils.border, width: 1)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                Get.to(() => TransactionDetailScreen(
                      id: refundTransactionDetailResponse!.entityId!.id
                          .toString(),
                    ));
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  commonColumnField(
                      color: ColorsUtils.black,
                      title: 'Transaction ID.'.tr,
                      value: refundTransactionDetailResponse!.entityId == null
                          ? "NA"
                          : '${refundTransactionDetailResponse!.entityId!.invoicenumber ?? "NA"}'),
                  width10(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                          color: ColorsUtils.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: ColorsUtils.black)),
                      child: const Icon(Icons.arrow_forward_ios, size: 10),
                    ),
                  )
                ],
              ),
            ),
            commonColumnField(
                color: ColorsUtils.black,
                title: 'Transaction amount'.tr,
                value: refundTransactionDetailResponse!.entityId == null
                    ? "NA"
                    : '${refundTransactionDetailResponse!.entityId!.amount ?? "0"} QAR'),
            refundTransactionDetailResponse!.bankRefundResponse == null
                ? SizedBox()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      commonColumnField(
                          color: ColorsUtils.black,
                          title: 'Transaction response code'.tr,
                          value: refundTransactionDetailResponse!
                                      .bankRefundResponse ==
                                  null
                              ? 'NA'
                              : '${refundTransactionDetailResponse!.bankRefundResponse!.responseCode ?? "NA"}'),
                      commonColumnField(
                          color: ColorsUtils.black,
                          title: 'Transaction response message'.tr,
                          value: refundTransactionDetailResponse!
                                      .bankRefundResponse ==
                                  null
                              ? 'NA'
                              : '${refundTransactionDetailResponse!.bankRefundResponse!.explanation ?? "NA"}'),
                      commonColumnField(
                          color: ColorsUtils.black,
                          title: 'Auth Number'.tr,
                          value: refundTransactionDetailResponse!
                                      .bankRefundResponse ==
                                  null
                              ? 'NA'
                              : 'NA'),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Container paymentDetail() {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
          color: ColorsUtils.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: ColorsUtils.border, width: 1)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: commonColumnField(
                      color: ColorsUtils.black,
                      title: 'Payment Method'.tr,
                      value:
                          '${refundTransactionDetailResponse!.transactionmode!.name.toString().capitalize}'),
                ),
                Expanded(
                  flex: 1,
                  child: Image.asset(
                    refundTransactionDetailResponse!.cardtype == 'VISA'
                        ? Images.visaCard
                        : refundTransactionDetailResponse!.cardtype ==
                                'SADAD PAY'
                            ? Images.sadadWalletPay
                            : refundTransactionDetailResponse!.cardtype ==
                                    'MASTERCARD'
                                ? Images.masterCard
                                : refundTransactionDetailResponse!.cardtype ==
                                        'GOOGLE PAY'
                                    ? Images.googlePay
                                    : refundTransactionDetailResponse!
                                                .cardtype ==
                                            'APPLE PAY'
                                        ? Images.applePay
                                        : Images.sadadWalletPay,
                    height: 40,
                  ),
                )
              ],
            ),
            refundTransactionDetailResponse!.bankRefundResponse == null
                ? SizedBox()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      commonColumnField(
                          color: ColorsUtils.black,
                          title: 'Card number'.tr,
                          value: refundTransactionDetailResponse!
                                      .bankRefundResponse ==
                                  null
                              ? "NA"
                              : '${refundTransactionDetailResponse!.bankRefundResponse!.cardNumber ?? "NA"}'),
                      commonColumnField(
                          color: ColorsUtils.black,
                          title: 'Card holder name'.tr,
                          value:
                              '${refundTransactionDetailResponse!.cardholdername ?? 'NA'}'),
                      commonColumnField(
                          color: ColorsUtils.black,
                          title: 'RRN',
                          value: refundTransactionDetailResponse!
                                      .bankRefundResponse ==
                                  null
                              ? "NA"
                              : '${refundTransactionDetailResponse!.bankRefundResponse!.rRN ?? ""}'),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Container customerDetail() {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
          color: ColorsUtils.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: ColorsUtils.border, width: 1)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            commonColumnField(
                color: ColorsUtils.black,
                title: 'Customer name'.tr,
                value: name),
            commonColumnField(
                color: ColorsUtils.black,
                title: 'Customer Mobile no.'.tr,
                value: mobileNo),
            commonColumnField(
                color: ColorsUtils.black,
                title: 'Customer Email ID'.tr,
                value: email),
          ],
        ),
      ),
    );
  }

  Container disputeDetail() {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
          color: ColorsUtils.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: ColorsUtils.border, width: 1)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            commonColumnField(
                color: ColorsUtils.black,
                title: 'Dispute ID'.tr,
                value: '${refundTransactionDetailResponse!.disputeId ?? 'NA'}'),
          ],
        ),
      ),
    );
  }

  void clientNameEmailMobile() {
    if (refundTransactionDetailResponse!.receiverId == null) {
      checkSendId();
    } else if (refundTransactionDetailResponse!.senderId == null) {
      checkReceiverId();
    } else {
      checkSendId();
      checkReceiverId();
    }
    // if (refundTransactionDetailResponse!.receiverId!.id.toString() == userid) {
    //   ///name
    //   name = refundTransactionDetailResponse!.senderId == 0 ||
    //           refundTransactionDetailResponse!.senderId == null
    //       ? refundTransactionDetailResponse!.guestuser == null
    //           ? "NA"
    //           : 'Guest User'
    //       : refundTransactionDetailResponse!.senderId!.name ?? "NA";
    //
    //   ///email
    //   email = refundTransactionDetailResponse!.senderId == 0 ||
    //           refundTransactionDetailResponse!.senderId == null
    //       ? refundTransactionDetailResponse!.guestuser == null
    //           ? "NA"
    //           : refundTransactionDetailResponse!.guestuser!.email ?? "NA"
    //       : refundTransactionDetailResponse!.senderId!.email ?? 'NA';
    //
    //   ///mobile
    //   mobileNo = refundTransactionDetailResponse!.senderId == 0 ||
    //           refundTransactionDetailResponse!.senderId == null
    //       ? refundTransactionDetailResponse!.guestuser == null
    //           ? "NA"
    //           : refundTransactionDetailResponse!.guestuser!.cellnumber ?? "NA"
    //       : refundTransactionDetailResponse!.senderId!.cellnumber ?? "NA";
    // } else if (refundTransactionDetailResponse!.senderId!.id.toString() ==
    //     userid) {
    //   print('sender ');
    //   ///name
    //   name = refundTransactionDetailResponse!.receiverId == 0 ||
    //           refundTransactionDetailResponse!.receiverId == null
    //       ? refundTransactionDetailResponse!.guestuser == null
    //           ? "NA"
    //           : 'Guest User'
    //       : refundTransactionDetailResponse!.receiverId!.name ?? "NA";
    //
    //   ///email
    //   email = refundTransactionDetailResponse!.receiverId == 0 ||
    //           refundTransactionDetailResponse!.receiverId == null
    //       ? refundTransactionDetailResponse!.guestuser == null
    //           ? "NA"
    //           : refundTransactionDetailResponse!.guestuser!.email ?? "NA"
    //       : refundTransactionDetailResponse!.receiverId!.email ?? "NA";
    //
    //   ///mobile
    //   mobileNo = refundTransactionDetailResponse!.receiverId == 0 ||
    //           refundTransactionDetailResponse!.receiverId == null
    //       ? refundTransactionDetailResponse!.guestuser == null
    //           ? "NA"
    //           : refundTransactionDetailResponse!.guestuser!.cellnumber ?? "NA"
    //       : refundTransactionDetailResponse!.receiverId!.cellnumber ?? "NA";
    //   print('b');
    // }
  }

  void checkSendId() {
    if (refundTransactionDetailResponse!.senderId!.id.toString() == userid) {
      print('sender ....');

      ///name
      name = refundTransactionDetailResponse!.receiverId == 0 ||
              refundTransactionDetailResponse!.receiverId == null
          ? refundTransactionDetailResponse!.guestuser == null
              ? "NA"
              : refundTransactionDetailResponse!.invoice == null
                  ? 'Guest User'
                  : refundTransactionDetailResponse!.invoice!.clientname ?? "NA"
          : refundTransactionDetailResponse!.receiverId!.name ?? "NA";

      ///email
      email = refundTransactionDetailResponse!.receiverId == 0 ||
              refundTransactionDetailResponse!.receiverId == null
          ? refundTransactionDetailResponse!.guestuser == null
              ? refundTransactionDetailResponse!.invoice == null
                  ? 'NA'
                  : refundTransactionDetailResponse!.invoice!.emailaddress ??
                      "NA"
              : refundTransactionDetailResponse!.guestuser!.email ?? "NA"
          : refundTransactionDetailResponse!.receiverId!.email ?? "NA";

      ///mobile
      // mobileNo = refundTransactionDetailResponse!.receiverId == 0 ||
      //         refundTransactionDetailResponse!.receiverId == null
      //     ? refundTransactionDetailResponse!.guestuser == null
      //         ? "NA"
      //         : refundTransactionDetailResponse!.guestuser!.cellnumber ?? "NA"
      //     : refundTransactionDetailResponse!.receiverId!.cellnumber ?? "NA";

      mobileNo = refundTransactionDetailResponse!.invoice == null
          ? refundTransactionDetailResponse!.receiverId == 0 ||
                  refundTransactionDetailResponse!.receiverId == null
              ? refundTransactionDetailResponse!.guestuser == null
                  ? 'NA'
                  : refundTransactionDetailResponse!
                          .guestuser!.actualCellnumber ??
                      "NA"
              : refundTransactionDetailResponse!.receiverId!.cellnumber ?? "NA"
          : refundTransactionDetailResponse!.invoice!.cellno ?? "NA";
      print('b');
    }
  }

  void checkReceiverId() {
    if (refundTransactionDetailResponse!.receiverId!.id.toString() == userid) {
      ///name
      name = refundTransactionDetailResponse!.senderId == 0 ||
              refundTransactionDetailResponse!.senderId == null
          ? refundTransactionDetailResponse!.guestuser == null
              ? "NA"
              : refundTransactionDetailResponse!.invoice == null
                  ? 'Guest User'
                  : refundTransactionDetailResponse!.invoice!.clientname ?? "NA"
          : refundTransactionDetailResponse!.senderId!.name ?? "NA";

      ///email
      email = refundTransactionDetailResponse!.senderId == 0 ||
              refundTransactionDetailResponse!.senderId == null
          ? refundTransactionDetailResponse!.guestuser == null
              ? refundTransactionDetailResponse!.invoice == null
                  ? 'NA'
                  : refundTransactionDetailResponse!.invoice!.emailaddress ??
                      "NA"
              : refundTransactionDetailResponse!.guestuser!.email ?? "NA"
          : refundTransactionDetailResponse!.senderId!.email ?? 'NA';

      ///mobile
      // mobileNo = refundTransactionDetailResponse!.senderId == 0 ||
      //         refundTransactionDetailResponse!.senderId == null
      //     ? refundTransactionDetailResponse!.guestuser == null
      //         ? "NA"
      //         : refundTransactionDetailResponse!.guestuser!.cellnumber ?? "NA"
      //     : refundTransactionDetailResponse!.senderId!.cellnumber ?? "NA";

      mobileNo = refundTransactionDetailResponse!.invoice == null
          ? refundTransactionDetailResponse!.senderId == 0 ||
                  refundTransactionDetailResponse!.senderId == null
              ? refundTransactionDetailResponse!.guestuser == null
                  ? 'NA'
                  : refundTransactionDetailResponse!
                          .guestuser!.actualCellnumber ??
                      "NA"
              : refundTransactionDetailResponse!.senderId!.cellnumber ?? "NA"
          : refundTransactionDetailResponse!.invoice!.cellno ?? "NA";
    }
  }

  initData() async {
    await transactionViewModel.refundTransactionDetail(widget.id!);
    userid = await encryptedSharedPreferences.getString('id');
  }
}
