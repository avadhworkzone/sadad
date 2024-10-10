// ignore_for_file: unrelated_type_equality_checks, must_be_immutable

import 'package:country_calling_code_picker/picker.dart' as CountryPicker;
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/reports/onlineTransactionReportResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/transaction/transactionDetailModel.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/downloadFile.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/dashboard/invoices/invoicedetail.dart';
import 'package:sadad_merchat_app/view/payment/products/orderDetailScreen.dart';
import 'package:sadad_merchat_app/view/payment/transaction/refundDetailScreen.dart';
import 'package:sadad_merchat_app/view/payment/transaction/refundTransactionScreen.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import '../../../base/constants.dart';
import '../../../model/apis/api_response.dart';
import '../../../viewModel/Payment/transaction/transactionViewModel.dart';

class TransactionReportDetailScreen extends StatefulWidget {
  bool? isFromReport = false;
  String? id;
  final OnlineTransReportData transactionDetailResponse;

  TransactionReportDetailScreen(
      {Key? key,
      this.id,
      required this.transactionDetailResponse,
      this.isFromReport})
      : super(key: key);

  @override
  State<TransactionReportDetailScreen> createState() =>
      _TransactionReportDetailScreenState();
}

class _TransactionReportDetailScreenState
    extends State<TransactionReportDetailScreen> {
  EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences();
  TransactionViewModel transactionViewModel = Get.find();
  //TransactionDetailResponseModel? transactionDetailResponse;
  OnlineTransReportData? transactionDetailResponse;
  String userid = 'NA';
  String name = 'NA';
  String mobileNo = 'NA';
  String email = 'NA';
  ConnectivityViewModel connectivityViewModel = Get.find();
  CountryPicker.Country? _selectedCountry;

  @override
  void initState() {
    connectivityViewModel.startMonitoring();

    //initData();
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
                // if (controller.transactionDetailApiResponse.status ==
                //     Status.LOADING) {
                //   print('Loading');
                //   return const Center(child: Loader());
                // }
                // if (controller.transactionDetailApiResponse.status ==
                //     Status.ERROR) {
                //   return const SessionExpire();
                // }
                // transactionDetailResponse =
                //     transactionViewModel.transactionDetailApiResponse.data;
                transactionDetailResponse = widget.transactionDetailResponse;

                // clientNameEmailMobile();
                return Padding(
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
                          (transactionDetailResponse!.transactionStatus ==
                                      'INPROGRESS' ||
                                  transactionDetailResponse!
                                          .transactionStatus ==
                                      'PENDING')
                              ? SizedBox()
                              : widget.isFromReport == false
                                  ? InkWell(
                                      onTap: () {
                                        bottomSheetforDownloadAndRefund(
                                            context);
                                      },
                                      child: const Icon(
                                        Icons.more_vert,
                                      ),
                                    )
                                  : SizedBox(),
                        ],
                      ),
                      height30(),
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
                              //transactionSource(),
                              //height10(),
                              customerDetail(),
                              height10(),
                              transactionResponse(),
                              height10(),
                              refund(),
                              height10(),
                              dispute(),
                              height10(),
                              if (transactionDetailResponse!
                                      .transactionSource ==
                                  'Invoice')
                                invoice(),
                              height30(),
                              (transactionDetailResponse!.transactionStatus ==
                                          'INPROGRESS' ||
                                      transactionDetailResponse!
                                              .transactionStatus ==
                                          'PENDING')
                                  ? SizedBox()
                                  : InkWell(
                                      onTap: () {
                                        downloadFile(
                                            context: context,
                                            isRadioSelected: 1,
                                            isEmail: false,
                                            url:
                                                '${Utility.baseUrl}transactions/downloadReceipt?transactionId=${transactionDetailResponse!.transactionId}&isPOS=false');
                                      },
                                      child: commonButtonBox(
                                          color: ColorsUtils.accent,
                                          img: Images.download,
                                          text: 'Download Receipt'.tr),
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

                //initData();
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

              //initData();
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

  // void clientNameEmailMobile() {
  //   if (transactionDetailResponse!.receiverId == null) {
  //     checkSenderId();
  //   } else if (transactionDetailResponse!.senderId == null) {
  //     checkReceiverId();
  //   } else {
  //     checkSenderId();
  //     checkReceiverId();
  //   }
  // }

  // checkSenderId() {
  //   if (transactionDetailResponse!.senderId!.id.toString() == userid) {
  //     ///name
  //     name = transactionDetailResponse!.entityId != null
  //         // ? transactionDetailResponse!.guestuser == null
  //         ? transactionDetailResponse!.entityId == null
  //             ? 'Guest User'
  //             : transactionDetailResponse!.entityId!.clientname ?? "Guest User"
  //         // : 'Guest User'
  //         // : '${transactionDetailResponse!.entityId!.clientname}'
  //         : transactionDetailResponse!.receiverId == 0 ||
  //                 transactionDetailResponse!.receiverId == null
  //             ? 'Guest User'
  //             : transactionDetailResponse!.receiverId!.name ?? "Guest User";
  //
  //     ///email
  //     email = transactionDetailResponse!.entityId != null
  //         ? transactionDetailResponse!.guestuser == null
  //             ? transactionDetailResponse!.entityId == null
  //                 ? 'NA'
  //                 : transactionDetailResponse!.entityId!.emailaddress ?? "NA"
  //             : transactionDetailResponse!.guestuser!.email ?? "NA"
  //         : transactionDetailResponse!.receiverId == 0 ||
  //                 transactionDetailResponse!.receiverId == null
  //             ? 'NA'
  //             : transactionDetailResponse!.receiverId!.email ?? "NA";
  //
  //     ///mobile
  //     mobileNo = transactionDetailResponse!.entityId?.cellno == null
  //         ? transactionDetailResponse!.receiverId == 0 ||
  //                 transactionDetailResponse!.receiverId == null
  //             ? transactionDetailResponse!.guestuser == null
  //                 ? 'NA'
  //                 : transactionDetailResponse!.guestuser!.actualCellnumber ??
  //                     "NA"
  //             : transactionDetailResponse!.receiverId!.cellnumber ?? "NA"
  //         : transactionDetailResponse!.entityId!.cellno ?? "NA";
  //
  //     // mobileNo = transactionDetailResponse!.receiverId == 0 || transactionDetailResponse!.receiverId == null
  //     //     ? transactionDetailResponse!.guestuser == null
  //     //     ? transactionDetailResponse!.entityId == null
  //     //     ? 'NA'
  //     //     : transactionDetailResponse!.entityId!.cellno ?? "NA"
  //     //     : transactionDetailResponse!.guestuser!.actualCellnumber ?? "NA"
  //     //     : transactionDetailResponse!.receiverId!.cellnumber ?? "NA";
  //     // print('b');
  //   }
  // }
  //
  // checkReceiverId() {
  //   if (transactionDetailResponse!.receiverId!.id.toString() == userid) {
  //     ///name
  //     name = transactionDetailResponse!.entityId != null
  //         // ? transactionDetailResponse!.guestuser == null
  //         ? transactionDetailResponse!.entityId == null
  //             ? 'Guest User'
  //             : transactionDetailResponse!.entityId!.clientname ?? "Guest User"
  //         // : 'Guest User'
  //         // : '${transactionDetailResponse!.entityId!.clientname}'
  //         : transactionDetailResponse!.senderId == 0 ||
  //                 transactionDetailResponse!.senderId == null
  //             ? 'Guest User'
  //             : transactionDetailResponse!.senderId!.name ?? "Guest User";
  //
  //     ///email
  //     email = transactionDetailResponse!.entityId != null
  //         ? transactionDetailResponse!.guestuser == null
  //             ? transactionDetailResponse!.entityId == null
  //                 ? 'NA'
  //                 : transactionDetailResponse!.entityId!.emailaddress ?? "NA"
  //             : transactionDetailResponse!.guestuser!.email ?? "NA"
  //         : transactionDetailResponse!.senderId == 0 ||
  //                 transactionDetailResponse!.senderId == null
  //             ? 'NA'
  //             : transactionDetailResponse!.senderId!.email ?? "NA";
  //     // ///name
  //     // name = transactionDetailResponse!.senderId == 0 ||
  //     //         transactionDetailResponse!.senderId == null
  //     //     // ? transactionDetailResponse!.guestuser == null
  //     //     ? transactionDetailResponse!.entityId == null
  //     //         ? 'Guest User'
  //     //         : transactionDetailResponse!.entityId!.clientname ?? "NA"
  //     //     // : 'Guest User'
  //     //     // : '${transactionDetailResponse!.entityId!.clientname}'
  //     //     : transactionDetailResponse!.senderId!.name ?? "NA";
  //     //
  //     // ///email
  //     // email = transactionDetailResponse!.senderId == 0 ||
  //     //         transactionDetailResponse!.senderId == null
  //     //     ? transactionDetailResponse!.guestuser == null
  //     //         ? transactionDetailResponse!.entityId == null
  //     //             ? 'NA'
  //     //             : transactionDetailResponse!.entityId!.emailaddress ?? "NA"
  //     //         : transactionDetailResponse!.guestuser!.email ?? "NA"
  //     //     : transactionDetailResponse!.senderId!.email ?? 'NA';
  //
  //     ///mobile
  //     // mobileNo = transactionDetailResponse!.senderId == 0 ||
  //     //         transactionDetailResponse!.senderId == null
  //     //     ? transactionDetailResponse!.guestuser == null
  //     //         ? transactionDetailResponse!.entityId == null
  //     //             ? 'NA'
  //     //             : transactionDetailResponse!.entityId!.cellno ?? "NA"
  //     //         : transactionDetailResponse!.guestuser!.cellnumber ?? "NA"
  //     //     : transactionDetailResponse!.senderId!.cellnumber ?? "NA";
  //
  //     mobileNo = transactionDetailResponse!.entityId?.cellno == null
  //         ? transactionDetailResponse!.senderId == 0 ||
  //                 transactionDetailResponse!.senderId == null
  //             ? transactionDetailResponse!.guestuser == null
  //                 ? 'NA'
  //                 : transactionDetailResponse!.guestuser!.actualCellnumber ??
  //                     "NA"
  //             : transactionDetailResponse!.senderId!.cellnumber ?? "NA"
  //         : transactionDetailResponse!.entityId!.cellno ?? "NA";
  //   }
  // }

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
                    color: transactionDetailResponse!.transactionStatus ==
                            'INPROGRESS'
                        ? ColorsUtils.yellow
                        : transactionDetailResponse!.transactionStatus ==
                                'FAILED'
                            ? ColorsUtils.reds
                            : transactionDetailResponse!.transactionStatus ==
                                    'SUCCESS'
                                ? ColorsUtils.green
                                : transactionDetailResponse!
                                            .transactionStatus ==
                                        'REFUND'
                                    ? ColorsUtils.tersBlue
                                    : transactionDetailResponse!
                                                .transactionStatus ==
                                            'PENDING'
                                        ? ColorsUtils.yellow
                                        : transactionDetailResponse!
                                                    .transactionStatus ==
                                                'ONHOLD'
                                            ? ColorsUtils.blueBerryPie
                                            : ColorsUtils.accent,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                    child: Text(
                      '${transactionDetailResponse!.transactionStatus}'.tr,
                      style: ThemeUtils.blackRegular.copyWith(
                          fontSize: FontUtils.verySmall,
                          color: ColorsUtils.white),
                    ),
                  ),
                ),
              ],
            ),
            height10(),
            boldText(title: '${transactionDetailResponse!.transactionId}'),
            height15(),
            smallGreyText(
                title: intl.DateFormat('dd MMM yyyy, HH:mm:ss').format(
                    DateTime.parse(transactionDetailResponse!
                        .transactionDateTime
                        .toString()))),
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
            commonColumnField(
                color: ColorsUtils.accent,
                title: 'Transaction Type'.tr,
                value: transactionDetailResponse!.transactionType == 'Payment'
                    ? 'PURCHASE'
                    : transactionDetailResponse!.transactionType.toUpperCase()),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: commonColumnField(
                      color: ColorsUtils.black,
                      title: 'Payment Method'.tr,
                      value: transactionDetailResponse!.paymentMethods == null
                          ? 'NA'
                          : '${transactionDetailResponse!.paymentMethods.toString().capitalize ?? ""}'),
                ),
                Expanded(
                  flex: 1,
                  child: transactionDetailResponse!.paymentMethods != null
                      ? Image.asset(
                          transactionDetailResponse!.paymentMethods == 'VISA'
                              ? Images.visaCard
                              : transactionDetailResponse!.paymentMethods ==
                                      'SADAD PAY'
                                  ? Images.sadadWalletPay
                                  : transactionDetailResponse!.paymentMethods ==
                                          'MASTERCARD'
                                      ? Images.masterCard
                                      : transactionDetailResponse!
                                                  .paymentMethods ==
                                              'GOOGLE PAY'
                                          ? Images.googlePay
                                          : transactionDetailResponse!
                                                      .paymentMethods ==
                                                  'APPLE PAY'
                                              ? Images.applePay
                                              : transactionDetailResponse!
                                                          .paymentMethods ==
                                                      'JCB'
                                                  ? Images.jcb
                                                  : transactionDetailResponse!
                                                              .paymentMethods ==
                                                          'AMEX'
                                                      ? Images.amex
                                                      : transactionDetailResponse!
                                                                  .paymentMethods ==
                                                              'UPI'
                                                          ? Images.upi
                                                          : Images
                                                              .sadadWalletPay,
                          height: 40,
                        )
                      : Text(''),
                )
              ],
            ),
            commonColumnField(
                color: ColorsUtils.black,
                title: 'Masked Card Number'.tr,
                value: transactionDetailResponse!.maskedCardNumber ?? 'NA'),
            // commonColumnField(
            //     color: ColorsUtils.black,
            //     title: 'Merchant Reference Number'.tr,
            //     value: '${transactionDetailResponse!.websiteRefNo ?? "NA"}'),
            // commonColumnField(
            //     color: ColorsUtils.black,
            //     title: 'Sadad Charges'.tr,
            //     value:
            //         '${transactionDetailResponse!.sadadCharges ?? "NA"} QAR'),
            commonColumnField(
                color: ColorsUtils.black,
                title: 'Currency'.tr,
                value: '${transactionDetailResponse!.currency ?? "NA"}'),
            commonColumnField(
                color: ColorsUtils.black,
                title: 'Card Holder Name'.tr,
                value: '${transactionDetailResponse!.cardHolderName ?? "NA"}')
          ],
        ),
      ),
    );
  }

  // Widget transactionSource() {
  //   return Container(
  //     decoration: BoxDecoration(
  //         color: ColorsUtils.white,
  //         borderRadius: BorderRadius.circular(15),
  //         border: Border.all(color: ColorsUtils.border, width: 1)),
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //
  //               const Spacer(),
  //               Padding(
  //                 padding: const EdgeInsets.only(top: 10),
  //                 child: Image.asset(Images.invoice, height: 20, width: 20),
  //               ),
  //             ],
  //           ),
  //           transactionDetailResponse!.transactionentityId == 1 &&
  //                   transactionDetailResponse!.entityId != null
  //               ? InkWell(
  //                   onTap: () {
  //                     Get.to(() => InvoiceDetailScreen(
  //                           invoiceId: transactionDetailResponse!.entityId!.id
  //                               .toString(),
  //                         ));
  //                   },
  //                   child: Row(
  //                     crossAxisAlignment: CrossAxisAlignment.end,
  //                     children: [
  //                       commonColumnField(
  //                           color: ColorsUtils.black,
  //                           title: 'Invoice ID'.tr,
  //                           value:
  //                               '${transactionDetailResponse!.entityId!.invoiceno ?? "NA"}'),
  //                       width20(),
  //                       transactionDetailResponse!.entityId!.invoiceno == null
  //                           ? SizedBox()
  //                           : Padding(
  //                               padding: const EdgeInsets.only(bottom: 10),
  //                               child: Container(
  //                                 height: 20,
  //                                 width: 20,
  //                                 decoration: BoxDecoration(
  //                                     color: ColorsUtils.white,
  //                                     shape: BoxShape.circle,
  //                                     border:
  //                                         Border.all(color: ColorsUtils.black)),
  //                                 child: const Icon(Icons.arrow_forward_ios,
  //                                     size: 10),
  //                               ),
  //                             )
  //                     ],
  //                   ),
  //                 )
  //               : SizedBox(),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget customerDetail() {
    initCountry(transactionDetailResponse!.alphaCountry == null
        ? "US"
        : transactionDetailResponse!.alphaCountry);
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
                value: transactionDetailResponse!.customerName ?? 'NA'),
            commonColumnField(
                color: ColorsUtils.black,
                title: 'Customer Mobile no.'.tr,
                value: transactionDetailResponse!.customerMobileNumber ?? 'NA'),
            commonColumnField(
                color: ColorsUtils.black,
                title: 'Customer Email ID'.tr,
                value: transactionDetailResponse!.customerEmailId ?? 'NA'),
            SizedBox(
              width: Get.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  smallText(title: 'Customer IP'.tr),
                  height5(),
                  Text(
                    transactionDetailResponse!.originatedIp ?? 'NA',
                    style: ThemeUtils.blackBold.copyWith(
                        fontSize: FontUtils.mediumSmall,
                        color: ColorsUtils.black),
                  ),
                ],
              ),
            ),
            height10(),
            smallText(title: 'Bin Country'.tr),
            height5(),
            Row(
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
                  transactionDetailResponse!.binCountry ?? 'NA',
                  style: ThemeUtils.blackSemiBold
                      .copyWith(fontSize: FontUtils.mediumSmall),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget transactionResponse() {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
          color: ColorsUtils.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: ColorsUtils.border, width: 1)),
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            commonColumnField(
                color: ColorsUtils.black,
                title: 'RRN'.tr,
                value: '${transactionDetailResponse!.rrn ?? "NA"}'),
            transactionDetailResponse!.transactionSource != 'Store link'
                ? commonColumnField(
                    color: ColorsUtils.black,
                    title: 'Integration Source'.tr,
                    value:
                        '${transactionDetailResponse!.integrationSource ?? "NA"}')
                : SizedBox(),
            commonColumnField(
                color: ColorsUtils.black,
                title: 'Transaction Source'.tr,
                value: ['Transfer', 'Wallet Transfer']
                        .contains(transactionDetailResponse!.transactionSource)
                    ? 'Wallet Transfer'.toUpperCase()
                    : transactionDetailResponse!.transactionSource
                            .toUpperCase() ??
                        'NA'),
            commonColumnField(
                color: ColorsUtils.black,
                title: 'Transaction response code'.tr,
                value: '${transactionDetailResponse!.responseCode ?? "NA"}'),
            commonColumnField(
                color: ColorsUtils.black,
                title: 'Transaction response message'.tr,
                value: '${transactionDetailResponse!.responseMessage}'),
            commonColumnField(
                color: ColorsUtils.black,
                title: 'Auth number'.tr,
                value: '${transactionDetailResponse!.authNumber ?? "NA"}'),
            commonColumnField(
                color: ColorsUtils.black,
                title: 'Transaction origin'.tr,
                value: '${transactionDetailResponse!.traxOrigin ?? "NA"}')
          ])),
    );
  }

  Widget refund() {
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
            // transactionDetailResponse!.transactionentityId != 5
            //     ?
            InkWell(
              onTap: () {
                transactionDetailResponse!.refundId == null
                    ? SizedBox()
                    : Get.to(() => RefundDetailScreen(
                          id: transactionDetailResponse!.refundId.toString(),
                        ));
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  commonColumnField(
                      color: ColorsUtils.black,
                      title: 'Refund ID.'.tr,
                      value: '${transactionDetailResponse!.refundId ?? "NA"}'),
                  width20(),
                  transactionDetailResponse!.refundId == null
                      ? SizedBox()
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                                color: ColorsUtils.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: ColorsUtils.black)),
                            child:
                                const Icon(Icons.arrow_forward_ios, size: 10),
                          ),
                        )
                ],
              ),
            ),
            // : SizedBox(),
            commonColumnField(
                color: ColorsUtils.black,
                title: 'Refund Requested date & time'.tr,
                value: transactionDetailResponse!.refundRequestedDateTime ==
                            null ||
                        transactionDetailResponse!.refundRequestedDateTime == ''
                    ? "NA"
                    : intl.DateFormat('dd MMM yyyy, HH:mm:ss').format(
                        DateTime.parse(transactionDetailResponse!
                            .refundRequestedDateTime
                            .toString()))),
            commonColumnField(
                color: ColorsUtils.black,
                title: 'Refund Amount'.tr,
                value:
                    '${transactionDetailResponse!.refundAmount ?? "NA"} QAR'),
            commonColumnField(
                color: ColorsUtils.black,
                title: 'Refund Status'.tr,
                value:
                    '${transactionDetailResponse!.refundStatus == 'REFUND' ? 'REFUNDED' : transactionDetailResponse!.refundStatus == 'PENDING' ? 'REQUESTED' : transactionDetailResponse!.refundStatus == 'REJECTED' ? 'REJECTED' : 'NA'} QAR'),
          ],
        ),
      ),
    );
  }

  Widget dispute() {
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
            SizedBox(
              width: Get.width,
              child: commonColumnField(
                  color: ColorsUtils.black,
                  title: 'Dispute ID'.tr,
                  value: '${transactionDetailResponse!.disputeId ?? "NA"}'),
            ),
            commonColumnField(
                color: ColorsUtils.black,
                title: 'Dispute Created Date & Time'.tr,
                value: transactionDetailResponse!.disputeCreatedDateTime ==
                            null ||
                        transactionDetailResponse!.disputeCreatedDateTime == ''
                    ? "NA"
                    : intl.DateFormat('dd MMM yyyy, HH:mm:ss').format(
                        DateTime.parse(transactionDetailResponse!
                            .disputeCreatedDateTime
                            .toString()))),
            commonColumnField(
                color: ColorsUtils.black,
                title: 'Dispute Amount'.tr,
                value:
                    '${transactionDetailResponse!.disputeAmount ?? "NA"} QAR'),
            commonColumnField(
                color: ColorsUtils.black,
                title: 'Dispute Type'.tr,
                value: '${transactionDetailResponse!.disputeType ?? "NA"}'),
            commonColumnField(
                color: ColorsUtils.black,
                title: 'Dispute Status'.tr,
                value: '${transactionDetailResponse!.disputeStatus ?? "NA"}'),
            commonColumnField(
                color: ColorsUtils.black,
                title: 'Comments'.tr,
                value: '${transactionDetailResponse!.comments ?? "NA"}'),
          ],
        ),
      ),
    );
  }

  Widget invoice() {
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
            SizedBox(
              width: Get.width,
              child: commonColumnField(
                  color: ColorsUtils.black,
                  title: 'Invoice Number'.tr,
                  value: '${transactionDetailResponse!.invoiceNumber ?? "NA"}'),
            ),
            commonColumnField(
                color: ColorsUtils.black,
                title: 'Invoice Created Date'.tr,
                value: transactionDetailResponse!.invoiceCreated == null ||
                        transactionDetailResponse!.invoiceCreated == ''
                    ? "NA"
                    : intl.DateFormat('dd MMM yyyy, HH:mm:ss').format(
                        DateTime.parse(transactionDetailResponse!.invoiceCreated
                            .toString()))),
            commonColumnField(
                color: ColorsUtils.black,
                title: 'Invoice Description'.tr,
                value:
                    '${transactionDetailResponse!.invoiceDescription ?? "NA"}'),
            commonColumnField(
                color: ColorsUtils.black,
                title: 'Username'.tr,
                value: '${transactionDetailResponse!.username ?? "NA"}'),
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
            return SafeArea(
              child: Padding(
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
                          child:
                              Divider(color: ColorsUtils.border, thickness: 4),
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
                                    '${Utility.baseUrl}transactions/downloadReceipt?transactionId=${transactionDetailResponse!.transactionId}&isPOS=false')
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
                    // transactionDetailResponse!.transactionStatus == 'SUCCESS'
                    //     ? const Padding(
                    //         padding: EdgeInsets.symmetric(vertical: 5),
                    //         child: Divider(),
                    //       )
                    //     : SizedBox(),
                    // transactionDetailResponse!.transactionStatus == 'SUCCESS'
                    //     ? InkWell(
                    //         onTap: () async {
                    //           Get.back();
                    //           if ((transactionDetailResponse!. == false &&
                    //               (transactionDetailResponse!
                    //                       .priorRefundRequestedAmount <=
                    //                   0))) {
                    //             Map<String, dynamic> transactionDetail = {
                    //               'id': transactionDetailResponse!.invoicenumber,
                    //               'type': transactionDetailResponse!.cardtype,
                    //               'amount': transactionDetailResponse!.amount,
                    //               'isCredit': transactionDetailResponse!
                    //                   .transactionmode!.id,
                    //               'PriorAmount': transactionDetailResponse!
                    //                   .priorRefundRequestedAmount
                    //             };
                    //             Get.back();
                    //             Get.to(() => RefundTransactionScreen(
                    //                   transactionDetail: transactionDetail,
                    //                 ));
                    //           } else {
                    //             showDialog(
                    //               context: context,
                    //               builder: (context) {
                    //                 return StatefulBuilder(
                    //                   builder: (context, setState) {
                    //                     return Dialog(
                    //                       elevation: 0,
                    //
                    //                       // backgroundColor: Colors.transparent,
                    //                       insetPadding: EdgeInsets.symmetric(
                    //                           horizontal: 20),
                    //                       shape: RoundedRectangleBorder(
                    //                           borderRadius:
                    //                               BorderRadius.circular(20.0)),
                    //                       child: Column(
                    //                         mainAxisSize: MainAxisSize.min,
                    //                         children: [
                    //                           Container(
                    //                             decoration: BoxDecoration(
                    //                                 borderRadius:
                    //                                     BorderRadius.circular(20),
                    //                                 // border: Border.all(
                    //                                 //   color: ColorsUtils.accent,
                    //                                 //   width: 2,
                    //                                 // ),
                    //                                 color: ColorsUtils.white),
                    //                             child: Padding(
                    //                               padding:
                    //                                   const EdgeInsets.all(20),
                    //                               child: Column(
                    //                                 children: [
                    //                                   //selectedRefundedStatus.first == 'Refunded'
                    //                                   //               ? ',{"transactionstatusId":"4"}'
                    //                                   //               : selectedRefundedStatus.first == 'Requested'
                    //                                   //                   ? ',{"transactionstatusId":"5"}'
                    //                                   //                   : selectedRefundedStatus.first == 'Rejected'
                    //                                   //                       ? ',{"transactionstatusId":"7"}'
                    //                                   //                       : '';
                    //                                   RichText(
                    //                                     text: TextSpan(
                    //                                         style: TextStyle(
                    //                                           color: ColorsUtils
                    //                                               .black,
                    //                                         ),
                    //                                         text:
                    //                                             'Sorry, you have your already raised Refund transaction.\n\nYour refund status is ',
                    //                                         children: [
                    //                                           TextSpan(
                    //                                               style: TextStyle(
                    //                                                   color: ColorsUtils
                    //                                                       .accent,
                    //                                                   fontWeight:
                    //                                                       FontWeight
                    //                                                           .bold),
                    //                                               text:
                    //                                                   '${transactionDetailResponse!.refundTxn == null ? 'NA' : transactionDetailResponse!.refundTxn!.first.transactionstatusId == 4 ? 'Refunded' : transactionDetailResponse!.refundTxn!.first.transactionstatusId == 5 ? 'Pending' : 'Rejected'}')
                    //                                         ]),
                    //                                   ),
                    //                                   height20(),
                    //                                   Row(
                    //                                     children: [
                    //                                       customSmallSemiText(
                    //                                           title:
                    //                                               'Your refund ID is : '),
                    //                                       customSmallBoldText(
                    //                                           title:
                    //                                               '${(transactionDetailResponse!.refundTxn == null ? 'NA' : transactionDetailResponse!.refundTxn!.first.invoicenumber ?? "NA")}',
                    //                                           color: ColorsUtils
                    //                                               .accent)
                    //                                     ],
                    //                                   ),
                    //                                 ],
                    //                               ),
                    //                             ),
                    //                           )
                    //                         ],
                    //                       ),
                    //                     );
                    //                   },
                    //                 );
                    //               },
                    //             );
                    //           }
                    //         },
                    //         child: Row(
                    //           children: [
                    //             Image.asset(
                    //               Images.refund,
                    //               width: 25,
                    //               height: 25,
                    //               color: ColorsUtils.black,
                    //             ),
                    //             width20(),
                    //             Text(
                    //               'Refund'.tr,
                    //               style: ThemeUtils.blackSemiBold
                    //                   .copyWith(fontSize: FontUtils.mediumSmall),
                    //             )
                    //           ],
                    //         ),
                    //       )
                    //     : SizedBox(),
                    // height40()
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  initData() async {
    await transactionViewModel.transactionDetail(widget.id!);
    userid = await encryptedSharedPreferences.getString('id');
  }
}
