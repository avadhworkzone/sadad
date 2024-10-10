// ignore_for_file: unrelated_type_equality_checks, must_be_immutable

import 'package:country_calling_code_picker/picker.dart' as CountryPicker;
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/transaction/transactionDetailModel.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/downloadFile.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/dashboard/invoices/invoicedetail.dart';
import 'package:sadad_merchat_app/view/payment/transaction/refundDetailScreen.dart';
import 'package:sadad_merchat_app/view/payment/transaction/refundTransactionScreen.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import '../../../base/constants.dart';
import '../../../model/apis/api_response.dart';
import '../../../viewModel/Payment/transaction/transactionViewModel.dart';

class ActivityTransactionDetailScreen extends StatefulWidget {
  String? id;
  ActivityTransactionDetailScreen({Key? key, this.id}) : super(key: key);
  @override
  State<ActivityTransactionDetailScreen> createState() =>
      _ActivityTransactionDetailScreenState();
}

class _ActivityTransactionDetailScreenState
    extends State<ActivityTransactionDetailScreen> {
  EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences();
  TransactionViewModel transactionViewModel = Get.find();
  List<TransactionDetailResponseModel>? transactionDetailResponse;
  //List<TransactionDetailResponseModel>? transactionDetailResponseList;
  String userid = 'NA';
  String name = 'NA';
  String mobileNo = 'NA';
  String email = 'NA';
  ConnectivityViewModel connectivityViewModel = Get.find();
  CountryPicker.Country? _selectedCountry;
  @override
  void initState() {
    connectivityViewModel.startMonitoring();

    initData();
    super.initState();
  }

  initCountry(String code) async {
    final country = await CountryPicker.getCountryByCountryCode(context, code);
    setState(() {
      _selectedCountry = country;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (connectivityViewModel.isOnline != null) {
      if (connectivityViewModel.isOnline!) {
        return Scaffold(
            backgroundColor: ColorsUtils.lightBg,
            body: GetBuilder<TransactionViewModel>(
              builder: (controller) {
                if (controller.transactionDetailApiResponse.status ==
                    Status.LOADING) {
                  print('Loading');
                  return const Center(child: Loader());
                }
                if (controller.transactionDetailApiResponse.status ==
                    Status.ERROR) {
                  return const SessionExpire();
                  //return const Text('Error');
                }
                if (controller.transactionDetailApiResponse.status ==
                    Status.COMPLETE) {
                  transactionDetailResponse =
                      transactionViewModel.transactionDetailApiResponse.data;
                  if (transactionDetailResponse == null ||
                      transactionDetailResponse!.isEmpty) {
                  } else {
                    clientNameEmailMobile();
                  }
                }

                return transactionDetailResponse == null ||
                        transactionDetailResponse!.isEmpty
                    ? Center(
                        child: Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: Text('No data found'.tr),
                      ))
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            height40(),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: const Icon(
                                    Icons.arrow_back_ios,
                                  ),
                                ),
                                const Spacer(),
                                (transactionDetailResponse!
                                                .first.transactionstatus!.id ==
                                            1 ||
                                        transactionDetailResponse!
                                                .first.transactionstatus!.id ==
                                            5)
                                    ? SizedBox()
                                    : InkWell(
                                        onTap: () {
                                          bottomSheetforDownloadAndRefund(
                                              context);
                                        },
                                        child: const Icon(
                                          Icons.more_vert,
                                        ),
                                      ),
                              ],
                            ),
                            height10(),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Transaction Details'.tr,
                                      style: ThemeUtils.blackBold.copyWith(
                                        fontSize: FontUtils.medLarge,
                                      ),
                                    ),
                                    height20(),
                                    transactionDetail(),
                                    height10(),
                                    refundAndPaymentMethod(),
                                    height10(),
                                    transactionSource(),
                                    height10(),
                                    customerDetail(),
                                    // height10(),
                                    // transactionResponse(),
                                    // height10(),
                                    // refundAndDispute(),
                                    height30(),
                                    (transactionDetailResponse!.first
                                                    .transactionstatus!.id ==
                                                1 ||
                                            transactionDetailResponse!.first
                                                    .transactionstatus!.id ==
                                                5)
                                        ? SizedBox()
                                        : InkWell(
                                            onTap: () {
                                              downloadFile(
                                                  context: context,
                                                  isRadioSelected: 1,
                                                  isEmail: false,
                                                  url:
                                                      '${Utility.baseUrl}transactions/downloadReceipt?transactionId=${transactionDetailResponse!.first.invoicenumber}&isPOS=false');
                                            },
                                            child: commonButtonBox(
                                                color: ColorsUtils.accent,
                                                img: Images.download,
                                                text: 'Download Receipt'),
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

  void clientNameEmailMobile() {
    if (transactionDetailResponse!.first.receiverId == null) {
      checkSenderId();
    } else if (transactionDetailResponse!.first.senderId == null) {
      checkReceiverId();
    } else {
      checkSenderId();
      checkReceiverId();
    }
  }

  checkSenderId() {
    if (transactionDetailResponse!.first.senderId!.id.toString() == userid) {
      if (transactionDetailResponse!.first.transactionentityId == 1 &&
          transactionDetailResponse!.first.invoice != null) {
        name = transactionDetailResponse!.first.invoice!.clientname ?? "NA";
        email = transactionDetailResponse!.first.invoice!.emailaddress ?? "NA";
        mobileNo = transactionDetailResponse!.first.invoice!.cellno ?? "NA";
      } else {
        ///name
        name = transactionDetailResponse!.first.receiverId == 0 ||
                transactionDetailResponse!.first.receiverId == null
            // ? transactionDetailResponse!.guestuser == null
            ? transactionDetailResponse!.first.entityId == null
                ? 'Guest User'
                : transactionDetailResponse!.first.entityId!.clientname ??
                    "Guest User"
            // : 'Guest User'
            // : '${transactionDetailResponse!.entityId!.clientname}'
            : transactionDetailResponse!.first.receiverId!.name ?? "Guest User";

        ///email
        email = transactionDetailResponse!.first.receiverId == 0 ||
                transactionDetailResponse!.first.receiverId == null
            ? transactionDetailResponse!.first.guestuser == null
                ? transactionDetailResponse!.first.entityId == null
                    ? 'NA'
                    : transactionDetailResponse!.first.entityId!.emailaddress ??
                        "NA"
                : transactionDetailResponse!.first.guestuser!.email ?? "NA"
            : transactionDetailResponse!.first.receiverId!.email ?? "NA";

        ///mobile
        mobileNo = transactionDetailResponse!.first.receiverId == 0 ||
                transactionDetailResponse!.first.receiverId == null
            ? transactionDetailResponse!.first.guestuser == null
                ? transactionDetailResponse!.first.entityId == null
                    ? 'NA'
                    : transactionDetailResponse!.first.entityId!.cellno ?? "NA"
                : transactionDetailResponse!
                        .first.guestuser!.actualCellnumber ??
                    "NA"
            : transactionDetailResponse!.first.receiverId!.cellnumber ?? "NA";
        // print('b');
      }
    }
  }

  checkReceiverId() {
    if (transactionDetailResponse!.first.receiverId!.id.toString() == userid) {
      ///name
      name = transactionDetailResponse!.first.senderId == 0 ||
              transactionDetailResponse!.first.senderId == null
          // ? transactionDetailResponse!.guestuser == null
          ? transactionDetailResponse!.first.entityId == null
              ? 'Guest User'
              : transactionDetailResponse!.first.entityId!.clientname ?? "NA"
          // : 'Guest User'
          // : '${transactionDetailResponse!.entityId!.clientname}'
          : transactionDetailResponse!.first.senderId!.name ?? "NA";

      ///email
      email = transactionDetailResponse!.first.senderId == 0 ||
              transactionDetailResponse!.first.senderId == null
          ? transactionDetailResponse!.first.guestuser == null
              ? transactionDetailResponse!.first.entityId == null
                  ? 'NA'
                  : transactionDetailResponse!.first.entityId!.emailaddress ??
                      "NA"
              : transactionDetailResponse!.first.guestuser!.email ?? "NA"
          : transactionDetailResponse!.first.senderId!.email ?? 'NA';

      ///mobile
      mobileNo = transactionDetailResponse!.first.senderId == 0 ||
              transactionDetailResponse!.first.senderId == null
          ? transactionDetailResponse!.first.guestuser == null
              ? transactionDetailResponse!.first.entityId == null
                  ? 'NA'
                  : transactionDetailResponse!.first.entityId!.cellno ?? "NA"
              : transactionDetailResponse!.first.guestuser!.actualCellnumber ??
                  "NA"
          : transactionDetailResponse!.first.senderId!.cellnumber ?? "NA";
    }
  }

  Container transactionDetail() {
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
                smallText(title: 'Transaction ID.'.tr),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: Utility.isDisputeDetailTransaction == true
                        ? transactionDetailResponse!
                                    .first.dispute!.disputestatusId ==
                                1
                            ? ColorsUtils.green
                            : transactionDetailResponse!
                                        .first.dispute!.disputestatusId ==
                                    2
                                ? ColorsUtils.yellow
                                : transactionDetailResponse!
                                            .first.dispute!.disputestatusId ==
                                        3
                                    ? ColorsUtils.accent
                                    : ColorsUtils.accent
                        : transactionDetailResponse!
                                    .first.transactionstatus!.id ==
                                1
                            ? ColorsUtils.yellow
                            : transactionDetailResponse!
                                        .first.transactionstatus!.id ==
                                    2
                                ? ColorsUtils.reds
                                : transactionDetailResponse!
                                            .first.transactionstatus!.id ==
                                        3
                                    ? ColorsUtils.green
                                    : transactionDetailResponse!
                                                .first.transactionstatus!.id ==
                                            4
                                        ? ColorsUtils.tersBlue
                                        : transactionDetailResponse!.first
                                                    .transactionstatus!.id ==
                                                5
                                            ? ColorsUtils.yellow
                                            : transactionDetailResponse!
                                                        .first
                                                        .transactionstatus!
                                                        .id ==
                                                    6
                                                ? ColorsUtils.blueBerryPie
                                                : ColorsUtils.accent,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                    child: Text(
                      Utility.isDisputeDetailTransaction == true
                          ? transactionDetailResponse!
                                      .first.dispute!.disputestatusId ==
                                  1
                              ? 'OPEN'.tr
                              : transactionDetailResponse!
                                          .first.dispute!.disputestatusId ==
                                      2
                                  ? 'UNDER REVIEW'.tr
                                  : 'CLOSED'.tr
                          : '${transactionDetailResponse!.first.transactionstatus!.name}',
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
                title: '${transactionDetailResponse!.first.invoicenumber}'),
            height15(),
            // smallGreyText(
            //     title: DateFormat('dd MMM yyyy, HH:mm:ss').format(
            //         DateTime.parse(
            //             transactionDetailResponse!.created.toString()))),
            smallGreyText(
              title: transactionDetailResponse!.first.receiverId == null
                  ? '${DateFormat('dd MMM yy, HH:mm:ss').format(DateTime.parse(transactionDetailResponse!.first.senderId!.created.toString()))}'
                  : '${transactionDetailResponse!.first.receiverId!.id.toString() == userid ? DateFormat('dd MMM yy, HH:mm:ss').format(DateTime.parse(transactionDetailResponse!.first.senderId!.created.toString())) ?? "NA" : DateFormat('dd MMM yy, HH:mm:ss').format(DateTime.parse(transactionDetailResponse!.first.receiverId!.created.toString())) ?? "NA"}',
            ),
          ],
        ),
      ),
    );
  }

  Container refundAndPaymentMethod() {
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
            // commonColumnField(
            //     color: ColorsUtils.accent,
            //     title: 'Refund amount',
            //     value: '${transactionDetailResponse!.refundamount ?? "0"} QAR'),
            commonColumnField(
                color: ColorsUtils.accent,
                title: 'Transaction Type'.tr,
                value: transactionDetailResponse!.first.transactionentityId == 1
                    ? 'Invoice'.tr
                    : transactionDetailResponse!.first.transactionentityId == 2
                        ? 'Subscription'.tr
                        : transactionDetailResponse!
                                    .first.transactionentityId ==
                                3
                            ? 'Add Funds'.tr
                            : transactionDetailResponse!
                                        .first.transactionentityId ==
                                    4
                                ? 'Withdrawal'.tr
                                : transactionDetailResponse!
                                            .first.transactionentityId ==
                                        5
                                    ? 'Transfer'.tr
                                    : transactionDetailResponse!
                                                .first.transactionentityId ==
                                            6
                                        ? 'Store link'.tr
                                        : transactionDetailResponse!.first
                                                    .transactionentityId ==
                                                7
                                            ? 'PG API'.tr
                                            : transactionDetailResponse!.first
                                                        .transactionentityId ==
                                                    8
                                                ? 'Transfer'.tr
                                                : transactionDetailResponse!
                                                            .first
                                                            .transactionentityId ==
                                                        9
                                                    ? 'PG API'.tr
                                                    : transactionDetailResponse!
                                                                .first
                                                                .transactionentityId ==
                                                            10
                                                        ? 'AJAX Transaction'.tr
                                                        : transactionDetailResponse!
                                                                    .first
                                                                    .transactionentityId ==
                                                                11
                                                            ? 'Subscription'.tr
                                                            : transactionDetailResponse!
                                                                        .first
                                                                        .transactionentityId ==
                                                                    12
                                                                ? 'Mawaid'.tr
                                                                : transactionDetailResponse!
                                                                            .first
                                                                            .transactionentityId ==
                                                                        13
                                                                    ? 'Reward'.tr
                                                                    : transactionDetailResponse!.first.transactionentityId == 14
                                                                        ? 'Reward Add Funds'.tr
                                                                        : transactionDetailResponse!.first.transactionentityId == 15
                                                                            ? 'Partner Reward'.tr
                                                                            : transactionDetailResponse!.first.transactionentityId == 16
                                                                                ? 'Manual Service Charge'.tr
                                                                                : transactionDetailResponse!.first.transactionentityId == 17
                                                                                    ? 'POS Transaction'.tr
                                                                                    : 'Other'.tr),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: commonColumnField(
                      color: ColorsUtils.black,
                      title: 'Payment Method'.tr,
                      value: transactionDetailResponse!.first.cardtype == null
                          ? 'NA'
                          : '${transactionDetailResponse!.first.cardtype ?? ""}'),
                ),
                Expanded(
                  flex: 1,
                  child: Image.asset(
                    transactionDetailResponse!.first.cardtype == 'VISA'
                        ? Images.visaCard
                        : transactionDetailResponse!.first.cardtype ==
                                'SADAD PAY'
                            ? Images.sadadWalletPay
                            : transactionDetailResponse!.first.cardtype ==
                                    'MASTERCARD'
                                ? Images.masterCard
                                : transactionDetailResponse!.first.cardtype ==
                                        'GOOGLE PAY'
                                    ? Images.googlePay
                                    : transactionDetailResponse!
                                                .first.cardtype ==
                                            'APPLE PAY'
                                        ? Images.applePay
                                        : transactionDetailResponse!
                                                    .first.cardtype ==
                                                'JCB'
                                            ? Images.jcb
                                            : transactionDetailResponse!
                                                        .first.cardtype ==
                                                    'AMEX'
                                                ? Images.amex
                                                : transactionDetailResponse!
                                                            .first.cardtype ==
                                                        'UPI'
                                                    ? Images.upi
                                                    : Images.sadadWalletPay,
                    height: 40,
                  ),
                )
              ],
            ),

            commonColumnField(
                color: ColorsUtils.black,
                title: 'Card number'.tr,
                value: transactionDetailResponse!.first.bankresponse == null
                    ? 'NA'
                    : '${transactionDetailResponse!.first.bankresponse!.cardNumber ?? "NA"}'),
            commonColumnField(
                color: ColorsUtils.black,
                title: 'Sadad Charges'.tr,
                value:
                    '${transactionDetailResponse!.first.servicecharge ?? "NA"} QAR'),
          ],
        ),
      ),
    );
  }

  Widget transactionSource() {
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                commonColumnField(
                    color: ColorsUtils.black,
                    title: 'Transaction Source'.tr,
                    value: transactionDetailResponse!
                                .first.transactionentityId ==
                            1
                        ? 'Invoice'.tr
                        : transactionDetailResponse!.first.transactionentityId ==
                                2
                            ? 'Subscription'.tr
                            : transactionDetailResponse!
                                        .first.transactionentityId ==
                                    3
                                ? 'Add Funds'.tr
                                : transactionDetailResponse!
                                            .first.transactionentityId ==
                                        4
                                    ? 'Withdrawal'.tr
                                    : transactionDetailResponse!
                                                .first.transactionentityId ==
                                            5
                                        ? 'Wallet Transfer'.tr
                                        : transactionDetailResponse!.first
                                                    .transactionentityId ==
                                                6
                                            ? 'Store link'.tr
                                            : transactionDetailResponse!.first
                                                        .transactionentityId ==
                                                    7
                                                ? 'PG API'.tr
                                                : transactionDetailResponse!
                                                            .first
                                                            .transactionentityId ==
                                                        8
                                                    ? 'Wallet Transfer'.tr
                                                    : transactionDetailResponse!
                                                                .first
                                                                .transactionentityId ==
                                                            9
                                                        ? 'PG API'.tr
                                                        : transactionDetailResponse!
                                                                    .first
                                                                    .transactionentityId ==
                                                                10
                                                            ? 'AJAX Transaction'.tr
                                                            : transactionDetailResponse!.first.transactionentityId == 11
                                                                ? 'Subscription'.tr
                                                                : transactionDetailResponse!.first.transactionentityId == 12
                                                                    ? 'Mawaid'.tr
                                                                    : transactionDetailResponse!.first.transactionentityId == 13
                                                                        ? 'Reward'.tr
                                                                        : transactionDetailResponse!.first.transactionentityId == 14
                                                                            ? 'Reward Add Funds'.tr
                                                                            : transactionDetailResponse!.first.transactionentityId == 15
                                                                                ? 'Partner Reward'.tr
                                                                                : transactionDetailResponse!.first.transactionentityId == 16
                                                                                    ? 'Manual Service Charge'.tr
                                                                                    : transactionDetailResponse!.first.transactionentityId == 17
                                                                                        ? 'POS Transaction'.tr
                                                                                        : 'Other'.tr),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Image.asset(Images.invoice, height: 20, width: 20),
                ),
              ],
            ),
            transactionDetailResponse!.first.entityId == null
                ? SizedBox()
                : InkWell(
                    onTap: () {
                      Get.to(() => InvoiceDetailScreen(
                            invoiceId: transactionDetailResponse!
                                .first.entityId!.id
                                .toString(),
                          ));
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        commonColumnField(
                            color: ColorsUtils.black,
                            title: 'Source ID'.tr,
                            value:
                                '${transactionDetailResponse!.first.entityId!.invoiceno ?? "NA"}'),
                        width20(),
                        transactionDetailResponse!.first.entityId!.invoiceno ==
                                null
                            ? SizedBox()
                            : Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      color: ColorsUtils.white,
                                      shape: BoxShape.circle,
                                      border:
                                          Border.all(color: ColorsUtils.black)),
                                  child: const Icon(Icons.arrow_forward_ios,
                                      size: 10),
                                ),
                              )
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Widget customerDetail() {
    initCountry(transactionDetailResponse!.first.bincardstatusvalue == null
        ? "US"
        : transactionDetailResponse!
            .first.bincardstatusvalue!.country!.alpha2!);
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                commonColumnField(
                    color: ColorsUtils.black,
                    title: 'Customer IP'.tr,
                    value: transactionDetailResponse!.first.txniptrackervalue ==
                            null
                        ? 'NA'
                        : transactionDetailResponse!
                            .first.txniptrackervalue!.ipAddress),
                // '${transactionDetailResponse!.txniptrackervalue['ip_address'].toString()}'),
                const Spacer(),
                transactionDetailResponse!.first.bincardstatusvalue == null
                    ? SizedBox()
                    : Row(
                        children: [
                          _selectedCountry == null
                              ? SizedBox()
                              : Image.asset(
                                  _selectedCountry!.flag,
                                  package: CountryPicker.countryCodePackageName,
                                  width: 30,
                                ),
                          // Image.network(
                          //   transactionDetailResponse!
                          //       .txniptrackervalue!.flag!.png,
                          //   height: 30,
                          //   width: 30,
                          // ),
                          width10(),
                          Text(
                            transactionDetailResponse!
                                .first.bincardstatusvalue!.country!.name!,
                            style: ThemeUtils.blackSemiBold
                                .copyWith(fontSize: FontUtils.mediumSmall),
                          ),
                        ],
                      )
              ],
            )
          ],
        ),
      ),
    );
  }

  // Widget transactionResponse() {
  //   return Container(
  //     width: Get.width,
  //     decoration: BoxDecoration(
  //         color: ColorsUtils.white,
  //         borderRadius: BorderRadius.circular(15),
  //         border: Border.all(color: ColorsUtils.border, width: 1)),
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           commonColumnField(
  //               color: ColorsUtils.black,
  //               title: 'Transaction response code'.tr,
  //               value: transactionDetailResponse!.bankresponse == null
  //                   ? "NA"
  //                   : '${transactionDetailResponse!.bankresponse!.responseCode ?? "NA"}'),
  //           commonColumnField(
  //               color: ColorsUtils.black,
  //               title: 'Transaction response message'.tr,
  //               value: transactionDetailResponse!.bankresponse == null
  //                   ? "NA"
  //                   : '${transactionDetailResponse!.bankresponse!.explanation}'),
  //           commonColumnField(
  //               color: ColorsUtils.black,
  //               title: 'Auth number'.tr,
  //               value: transactionDetailResponse!.bankresponse == null
  //                   ? "NA"
  //                   : '${transactionDetailResponse!.bankresponse!.authNumber}'),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget refundAndDispute() {
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
            transactionDetailResponse!.first.transactionentityId != 5
                ? InkWell(
                    onTap: () {
                      transactionDetailResponse!.first.refundTxn!.isEmpty ||
                              transactionDetailResponse!.first.refundTxn == null
                          ? SizedBox()
                          : Get.to(() => RefundDetailScreen(
                                id: transactionDetailResponse!
                                    .first.refundTxn!.first.id
                                    .toString(),
                              ));
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        commonColumnField(
                            color: ColorsUtils.black,
                            title: 'Refund ID.'.tr,
                            value:
                                '${transactionDetailResponse!.first.refundTxn!.isEmpty || transactionDetailResponse!.first.refundTxn == null ? 'NA' : transactionDetailResponse!.first.refundTxn!.first.invoicenumber ?? "NA"}'),
                        width20(),
                        transactionDetailResponse!.first.refundTxn!.isEmpty ||
                                transactionDetailResponse!.first.refundTxn ==
                                    null
                            ? SizedBox()
                            : Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      color: ColorsUtils.white,
                                      shape: BoxShape.circle,
                                      border:
                                          Border.all(color: ColorsUtils.black)),
                                  child: const Icon(Icons.arrow_forward_ios,
                                      size: 10),
                                ),
                              )
                      ],
                    ),
                  )
                : SizedBox(),
            SizedBox(
              width: Get.width,
              child: commonColumnField(
                  color: ColorsUtils.black,
                  title: 'Dispute ID'.tr,
                  value: transactionDetailResponse!.first.dispute == null
                      ? 'NA'
                      : '${transactionDetailResponse!.first.dispute!.disputeId ?? ""}'),
            ),
          ],
        ),
      ),
    );
  }

  void bottomSheetforDownloadAndRefund(BuildContext context) {
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
                  height20(),
                  InkWell(
                    onTap: () {
                      // Navigator.pop(context);
                      downloadFile(
                              context: context,
                              isRadioSelected: 1,
                              isEmail: false,
                              url:
                                  '${Utility.baseUrl}transactions/downloadReceipt?transactionId=${transactionDetailResponse!.first.invoicenumber}&isPOS=false')
                          .then((value) => Navigator.pop(context));
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          Images.download,
                          width: 25,
                          height: 25,
                          color: ColorsUtils.black,
                        ),
                        width20(),
                        Text(
                          'Download Receipt'.tr,
                          style: ThemeUtils.blackSemiBold
                              .copyWith(fontSize: FontUtils.mediumSmall),
                        )
                      ],
                    ),
                  ),
                  transactionDetailResponse!.first.transactionstatus!.id == 3 &&
                          transactionDetailResponse!.first.receiverId!.id
                                  .toString() ==
                              userid
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Divider(),
                        )
                      : SizedBox(),
                  transactionDetailResponse!.first.transactionstatus!.id == 3 &&
                          transactionDetailResponse!.first.receiverId!.id
                                  .toString() ==
                              userid
                      ? InkWell(
                          onTap: () async {
                            Get.back();
                            if ((transactionDetailResponse!.first.isRefund ==
                                    false &&
                                (transactionDetailResponse!
                                        .first.priorRefundRequestedAmount <=
                                    0))) {
                              Map<String, dynamic> transactionDetail = {
                                'id': transactionDetailResponse!
                                    .first.invoicenumber,
                                'type':
                                    transactionDetailResponse!.first.cardtype,
                                'amount':
                                    transactionDetailResponse!.first.amount,
                                'isCredit': transactionDetailResponse!
                                    .first.transactionmode!.id,
                                'PriorAmount': transactionDetailResponse!
                                    .first.priorRefundRequestedAmount
                              };
                              Get.back();
                              Get.to(() => RefundTransactionScreen(
                                    transactionDetail: transactionDetail,
                                  ));
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(
                                    builder: (context, setState) {
                                      return Dialog(
                                        elevation: 0,

                                        // backgroundColor: Colors.transparent,
                                        insetPadding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  // border: Border.all(
                                                  //   color: ColorsUtils.accent,
                                                  //   width: 2,
                                                  // ),
                                                  color: ColorsUtils.white),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(20),
                                                child: Column(
                                                  children: [
                                                    //selectedRefundedStatus.first == 'Refunded'
                                                    //               ? ',{"transactionstatusId":"4"}'
                                                    //               : selectedRefundedStatus.first == 'Requested'
                                                    //                   ? ',{"transactionstatusId":"5"}'
                                                    //                   : selectedRefundedStatus.first == 'Rejected'
                                                    //                       ? ',{"transactionstatusId":"7"}'
                                                    //                       : '';
                                                    RichText(
                                                      text: TextSpan(
                                                          style: TextStyle(
                                                            color: ColorsUtils
                                                                .black,
                                                          ),
                                                          text:
                                                              'Sorry, you have your already raised Refund transaction.\n\nYour refund status is ',
                                                          children: [
                                                            TextSpan(
                                                                style: TextStyle(
                                                                    color: ColorsUtils
                                                                        .accent,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                text:
                                                                    '${transactionDetailResponse!.first.refundId == null ? 'NA' : transactionDetailResponse!.first.refundId!.first.transactionstatusId == 4 ? 'Refunded' : transactionDetailResponse!.first.refundId!.first.transactionstatusId == 5 ? 'Pending' : 'Rejected'}')
                                                          ]),
                                                    ),
                                                    height20(),
                                                    Row(
                                                      children: [
                                                        customSmallSemiText(
                                                            title:
                                                                'Your refund ID is : '),
                                                        customSmallBoldText(
                                                            title:
                                                                '${(transactionDetailResponse!.first.refundId == null ? 'NA' : transactionDetailResponse!.first.refundId!.first.invoicenumber ?? "NA")}',
                                                            color: ColorsUtils
                                                                .accent)
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            }
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                Images.refund,
                                width: 25,
                                height: 25,
                                color: ColorsUtils.black,
                              ),
                              width20(),
                              Text(
                                'Refund'.tr,
                                style: ThemeUtils.blackSemiBold
                                    .copyWith(fontSize: FontUtils.mediumSmall),
                              )
                            ],
                          ),
                        )
                      : SizedBox(),
                  height40()
                ],
              ),
            );
          },
        );
      },
    );
  }

  initData() async {
    userid = await encryptedSharedPreferences.getString('id');
    await transactionViewModel.activityTransactionDetail(userid, widget.id!);
    setState(() {});
  }
}
