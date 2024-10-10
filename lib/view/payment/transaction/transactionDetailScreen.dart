// ignore_for_file: unrelated_type_equality_checks, must_be_immutable

import 'package:country_calling_code_picker/picker.dart' as CountryPicker;
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
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

class TransactionDetailScreen extends StatefulWidget {
  String? id;
  bool? isFromReport = false;

  TransactionDetailScreen({Key? key, this.id, this.isFromReport})
      : super(key: key);

  @override
  State<TransactionDetailScreen> createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences();
  TransactionViewModel transactionViewModel = Get.find();
  TransactionDetailResponseModel? transactionDetailResponse;
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
                  // return const Text('Error');
                }
                transactionDetailResponse =
                    transactionViewModel.transactionDetailApiResponse.data;

                // print(
                //     '=====${transactionDetailResponse!.transactionstatus!.id != 1}');
                clientNameEmailMobile();
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
                          (transactionDetailResponse!.transactionstatus!.id ==
                                      1 ||
                                  transactionDetailResponse!
                                          .transactionstatus!.id ==
                                      5)
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
                              transactionSource(),
                              height10(),
                              customerDetail(),
                              height10(),
                              transactionResponse(),
                              height10(),
                              refundAndDispute(),
                              height30(),
                              (transactionDetailResponse!
                                              .transactionstatus!.id ==
                                          1 ||
                                      transactionDetailResponse!
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
                                                '${Utility.baseUrl}transactions/downloadReceipt?transactionId=${transactionDetailResponse!.invoicenumber}&isPOS=false');
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
    if (transactionDetailResponse!.receiverId == null) {
      checkSenderId();
    } else if (transactionDetailResponse!.senderId == null) {
      checkReceiverId();
    } else {
      checkSenderId();
      checkReceiverId();
    }
  }

  checkSenderId() {
    if (transactionDetailResponse!.senderId!.id.toString() == userid) {
      ///name
      name = transactionDetailResponse!.entityId != null
          // ? transactionDetailResponse!.guestuser == null
          ? transactionDetailResponse!.entityId == null
              ? 'Guest User'
              : transactionDetailResponse!.entityId!.clientname ?? "Guest User"
          // : 'Guest User'
          // : '${transactionDetailResponse!.entityId!.clientname}'
          : transactionDetailResponse!.receiverId == 0 ||
                  transactionDetailResponse!.receiverId == null
              ? 'Guest User'
              : transactionDetailResponse!.receiverId!.name ?? "Guest User";

      ///email
      email = transactionDetailResponse!.entityId != null
          ? transactionDetailResponse!.guestuser == null
              ? transactionDetailResponse!.entityId == null
                  ? 'NA'
                  : transactionDetailResponse!.entityId!.emailaddress ?? "NA"
              : transactionDetailResponse!.guestuser!.email ?? "NA"
          : transactionDetailResponse!.receiverId == 0 ||
                  transactionDetailResponse!.receiverId == null
              ? 'NA'
              : transactionDetailResponse!.receiverId!.email ?? "NA";

      ///mobile
      mobileNo = transactionDetailResponse!.entityId?.cellno == null
          ? transactionDetailResponse!.receiverId == 0 ||
                  transactionDetailResponse!.receiverId == null
              ? transactionDetailResponse!.guestuser == null
                  ? 'NA'
                  : transactionDetailResponse!.guestuser!.actualCellnumber ??
                      "NA"
              : transactionDetailResponse!.receiverId!.cellnumber ?? "NA"
          : transactionDetailResponse!.entityId!.cellno ?? "NA";

      // mobileNo = transactionDetailResponse!.receiverId == 0 || transactionDetailResponse!.receiverId == null
      //     ? transactionDetailResponse!.guestuser == null
      //     ? transactionDetailResponse!.entityId == null
      //     ? 'NA'
      //     : transactionDetailResponse!.entityId!.cellno ?? "NA"
      //     : transactionDetailResponse!.guestuser!.actualCellnumber ?? "NA"
      //     : transactionDetailResponse!.receiverId!.cellnumber ?? "NA";
      // print('b');
    }
  }

  checkReceiverId() {
    if (transactionDetailResponse!.receiverId!.id.toString() == userid) {
      ///name
      name = transactionDetailResponse!.entityId != null
          // ? transactionDetailResponse!.guestuser == null
          ? transactionDetailResponse!.entityId == null
              ? 'Guest User'
              : transactionDetailResponse!.entityId!.clientname ?? "Guest User"
          // : 'Guest User'
          // : '${transactionDetailResponse!.entityId!.clientname}'
          : transactionDetailResponse!.senderId == 0 ||
                  transactionDetailResponse!.senderId == null
              ? 'Guest User'
              : transactionDetailResponse!.senderId!.name ?? "Guest User";

      ///email
      email = transactionDetailResponse!.entityId != null
          ? transactionDetailResponse!.guestuser == null
              ? transactionDetailResponse!.entityId == null
                  ? 'NA'
                  : transactionDetailResponse!.entityId!.emailaddress ?? "NA"
              : transactionDetailResponse!.guestuser!.email ?? "NA"
          : transactionDetailResponse!.senderId == 0 ||
                  transactionDetailResponse!.senderId == null
              ? 'NA'
              : transactionDetailResponse!.senderId!.email ?? "NA";
      // ///name
      // name = transactionDetailResponse!.senderId == 0 ||
      //         transactionDetailResponse!.senderId == null
      //     // ? transactionDetailResponse!.guestuser == null
      //     ? transactionDetailResponse!.entityId == null
      //         ? 'Guest User'
      //         : transactionDetailResponse!.entityId!.clientname ?? "NA"
      //     // : 'Guest User'
      //     // : '${transactionDetailResponse!.entityId!.clientname}'
      //     : transactionDetailResponse!.senderId!.name ?? "NA";
      //
      // ///email
      // email = transactionDetailResponse!.senderId == 0 ||
      //         transactionDetailResponse!.senderId == null
      //     ? transactionDetailResponse!.guestuser == null
      //         ? transactionDetailResponse!.entityId == null
      //             ? 'NA'
      //             : transactionDetailResponse!.entityId!.emailaddress ?? "NA"
      //         : transactionDetailResponse!.guestuser!.email ?? "NA"
      //     : transactionDetailResponse!.senderId!.email ?? 'NA';

      ///mobile
      // mobileNo = transactionDetailResponse!.senderId == 0 ||
      //         transactionDetailResponse!.senderId == null
      //     ? transactionDetailResponse!.guestuser == null
      //         ? transactionDetailResponse!.entityId == null
      //             ? 'NA'
      //             : transactionDetailResponse!.entityId!.cellno ?? "NA"
      //         : transactionDetailResponse!.guestuser!.cellnumber ?? "NA"
      //     : transactionDetailResponse!.senderId!.cellnumber ?? "NA";

      mobileNo = transactionDetailResponse!.entityId?.cellno == null
          ? transactionDetailResponse!.senderId == 0 ||
                  transactionDetailResponse!.senderId == null
              ? transactionDetailResponse!.guestuser == null
                  ? 'NA'
                  : transactionDetailResponse!.guestuser!.actualCellnumber ??
                      "NA"
              : transactionDetailResponse!.senderId!.cellnumber ?? "NA"
          : transactionDetailResponse!.entityId!.cellno ?? "NA";
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
                        ? transactionDetailResponse!.dispute!.disputestatusId ==
                                1
                            ? ColorsUtils.green
                            : transactionDetailResponse!
                                        .dispute!.disputestatusId ==
                                    2
                                ? ColorsUtils.yellow
                                : transactionDetailResponse!
                                            .dispute!.disputestatusId ==
                                        3
                                    ? ColorsUtils.accent
                                    : ColorsUtils.accent
                        : transactionDetailResponse!.transactionstatus!.id == 1
                            ? ColorsUtils.yellow
                            : transactionDetailResponse!
                                        .transactionstatus!.id ==
                                    2
                                ? ColorsUtils.reds
                                : transactionDetailResponse!
                                            .transactionstatus!.id ==
                                        3
                                    ? ColorsUtils.green
                                    : transactionDetailResponse!
                                                .transactionstatus!.id ==
                                            4
                                        ? ColorsUtils.tersBlue
                                        : transactionDetailResponse!
                                                    .transactionstatus!.id ==
                                                5
                                            ? ColorsUtils.yellow
                                            : transactionDetailResponse!
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
                                      .dispute!.disputestatusId ==
                                  1
                              ? 'OPEN'.tr
                              : transactionDetailResponse!
                                          .dispute!.disputestatusId ==
                                      2
                                  ? 'UNDER REVIEW'.tr
                                  : 'CLOSED'.tr
                          : '${transactionDetailResponse!.transactionstatus!.name}'
                              .tr,
                      style: ThemeUtils.blackRegular.copyWith(
                          fontSize: FontUtils.verySmall,
                          color: ColorsUtils.white),
                    ),
                  ),
                ),
              ],
            ),
            height10(),
            boldText(title: '${transactionDetailResponse!.invoicenumber}'),
            height15(),
            smallGreyText(
                title: intl.DateFormat('dd MMM yyyy, HH:mm:ss').format(
                    DateTime.parse(
                        transactionDetailResponse!.created.toString()))),
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
                value: transactionDetailResponse!.transactionentity == null
                    ? transactionDetailResponse!.isDisputed == true
                        ? 'Dispute'.tr
                        : 'NA'
                    : transactionDetailResponse!.isDisputed == true
                        ? 'Dispute'.tr
                        : transactionDetailResponse!.transactionentity?.name ==
                                'TRANSFER'
                            ? '${transactionDetailResponse!.transactionentity?.name ?? 'NA'}'
                            : 'Purchase'.tr),

            transactionDetailResponse!.cardtype == null
                ? SizedBox()
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                        child: commonColumnField(
                            color: ColorsUtils.black,
                            title: 'Payment Method'.tr,
                            value: transactionDetailResponse!.cardtype == null
                                ? 'NA'
                                : '${transactionDetailResponse!.cardtype.toString().capitalize ?? ""}'),
                      ),
                      Expanded(
                        flex: 1,
                        child: transactionDetailResponse!.cardtype != null
                            ? Image.asset(
                                transactionDetailResponse!.cardtype == 'VISA'
                                    ? Images.visaCard
                                    : transactionDetailResponse!.cardtype ==
                                            'SADAD PAY'
                                        ? Images.sadadWalletPay
                                        : transactionDetailResponse!.cardtype ==
                                                'MASTERCARD'
                                            ? Images.masterCard
                                            : transactionDetailResponse!
                                                        .cardtype ==
                                                    'GOOGLE PAY'
                                                ? Images.googlePay
                                                : transactionDetailResponse!
                                                            .cardtype ==
                                                        'APPLE PAY'
                                                    ? Images.applePay
                                                    : transactionDetailResponse!
                                                                .cardtype ==
                                                            'JCB'
                                                        ? Images.jcb
                                                        : transactionDetailResponse!
                                                                    .cardtype ==
                                                                'AMEX'
                                                            ? Images.amex
                                                            : transactionDetailResponse!
                                                                        .cardtype ==
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

            transactionDetailResponse!.transactionmodeId != 3
                //transactionDetailResponse!.bankresponse != null
                ? commonColumnField(
                    color: ColorsUtils.black,
                    title: 'Card number'.tr,
                    value: transactionDetailResponse!.bankresponse == null
                        ? 'NA'
                        : '${transactionDetailResponse!.bankresponse!.cardNumber == '' ? "NA" : transactionDetailResponse!.bankresponse!.cardNumber}')
                : SizedBox(),
            transactionDetailResponse!.transactionentityId == 7
                ? commonColumnField(
                    color: ColorsUtils.black,
                    title: 'Merchant Reference Number'.tr,
                    value: '${transactionDetailResponse!.websiteRefNo ?? "NA"}')
                : SizedBox(),
            commonColumnField(
                color: ColorsUtils.black,
                title: 'Sadad Charges'.tr,
                value:
                    '${transactionDetailResponse!.servicecharge ?? "NA"} QAR'),

            transactionDetailResponse!.transactionmodeId != null
                ? transactionDetailResponse!.transactionmodeId == 1
                    ? commonColumnField(
                        color: ColorsUtils.black,
                        title: 'Card Holder Name'.tr,
                        value:
                            '${transactionDetailResponse!.cardholdername ?? "NA"}')
                    : SizedBox()
                : SizedBox()
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
                    // case 1: value = "Invoice"; break;
                    //       case 2: value = "Subscription"; break;
                    //       case 3: value = "Add Funds"; break;
                    //       case 4: value = "Withdrawal"; break;
                    //       case 5: value = "Transfer"; break;
                    //       case 6: value = "Store link"; break;
                    //       case 7: value = "PG API"; break;
                    //       case 8: value = "Transfer"; break;
                    //       case 9: value = "PG API"; break;
                    //       case 10: value = "AJAX Transaction (Not in used)"; break;
                    //       case 11: value = "Subscription"; break;
                    //       case 12: value = "Mawaid"; break;
                    //       case 13: value = "Reward"; break;
                    //       case 14: value = "Reward Add Funds"; break;
                    //       case 15: value = "Partner Reward"; break;
                    //       case 16: value = "Manual Service Charge"; break;
                    //       case 17: value = "POS Transaction"; break;
                    //       default: value = "Other"; break;
                    value: transactionDetailResponse!.transactionentityId == 1
                        ? 'Invoice'.tr
                        : transactionDetailResponse!.transactionentityId == 2
                            ? 'Subscription'.tr
                            : transactionDetailResponse!.transactionentityId ==
                                    3
                                ? 'Add Funds'.tr
                                : transactionDetailResponse!
                                            .transactionentityId ==
                                        4
                                    ? 'Withdrawal'.tr
                                    : transactionDetailResponse!
                                                .transactionentityId ==
                                            5
                                        ? 'Wallet Transfer'.tr
                                        : transactionDetailResponse!
                                                    .transactionentityId ==
                                                6
                                            ? 'Store link'.tr
                                            : transactionDetailResponse!
                                                        .transactionentityId ==
                                                    7
                                                ? 'PG API'.tr
                                                : transactionDetailResponse!
                                                            .transactionentityId ==
                                                        8
                                                    ? 'QR Transfer'.tr
                                                    : transactionDetailResponse!
                                                                .transactionentityId ==
                                                            9
                                                        ? 'PG API'.tr
                                                        : transactionDetailResponse!
                                                                    .transactionentityId ==
                                                                10
                                                            ? 'AJAX Transaction'
                                                                .tr
                                                            : transactionDetailResponse!
                                                                        .transactionentityId ==
                                                                    11
                                                                ? 'Subscription'
                                                                    .tr
                                                                : transactionDetailResponse!
                                                                            .transactionentityId ==
                                                                        12
                                                                    ? 'Mawaid'
                                                                        .tr
                                                                    : transactionDetailResponse!.transactionentityId ==
                                                                            13
                                                                        ? 'Reward'
                                                                            .tr
                                                                        : transactionDetailResponse!.transactionentityId ==
                                                                                14
                                                                            ? 'Reward Add Funds'.tr
                                                                            : transactionDetailResponse!.transactionentityId == 15
                                                                                ? 'Partner Reward'.tr
                                                                                : transactionDetailResponse!.transactionentityId == 16
                                                                                    ? 'Manual Service Charge'.tr
                                                                                    : transactionDetailResponse!.transactionentityId == 17
                                                                                        ? 'POS Transaction'.tr
                                                                                        : 'Other'.tr),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Image.asset(Images.invoice, height: 20, width: 20),
                ),
              ],
            ),
            transactionDetailResponse!.transactionentityId == 1 &&
                    transactionDetailResponse!.entityId != null
                ? InkWell(
                    onTap: () {
                      Get.to(() => InvoiceDetailScreen(
                            invoiceId: transactionDetailResponse!.entityId!.id
                                .toString(),
                          ));
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        commonColumnField(
                            color: ColorsUtils.black,
                            title: 'Invoice ID'.tr,
                            value:
                                '${transactionDetailResponse!.entityId!.invoiceno ?? "NA"}'),
                        width20(),
                        transactionDetailResponse!.entityId!.invoiceno == null
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
            // transactionDetailResponse!.transactionentityId == 6 &&
            //         transactionDetailResponse!.entityId != null
            //     ? InkWell(
            //         onTap: () {
            //           Get.to(() => OrderDetailScreen(
            //               id: transactionDetailResponse!.entityId!.id
            //                   .toString()));
            //         },
            //         child: Row(
            //           crossAxisAlignment: CrossAxisAlignment.end,
            //           children: [
            //             commonColumnField(
            //                 color: ColorsUtils.black,
            //                 title: 'Order ID'.tr,
            //                 value:
            //                     '${transactionDetailResponse!.entityId!.orderno ?? "NA"}'),
            //             width20(),
            //             transactionDetailResponse!.entityId!.orderno == null
            //                 ? SizedBox()
            //                 : Padding(
            //                     padding: const EdgeInsets.only(bottom: 10),
            //                     child: Container(
            //                       height: 20,
            //                       width: 20,
            //                       decoration: BoxDecoration(
            //                           color: ColorsUtils.white,
            //                           shape: BoxShape.circle,
            //                           border:
            //                               Border.all(color: ColorsUtils.black)),
            //                       child: const Icon(Icons.arrow_forward_ios,
            //                           size: 10),
            //                     ),
            //                   )
            //           ],
            //         ),
            //       )
            //     : SizedBox(),
            // transactionDetailResponse!.transactionentityId == 6
            //     ? InkWell(
            //         onTap: () {
            //           Get.to(() => InvoiceDetailScreen(
            //                 invoiceId: transactionDetailResponse!.entityId!.id
            //                     .toString(),
            //               ));
            //         },
            //         child: Row(
            //           crossAxisAlignment: CrossAxisAlignment.end,
            //           children: [
            //             commonColumnField(
            //                 color: ColorsUtils.black,
            //                 title: 'Invoice ID'.tr,
            //                 value:
            //                     '${transactionDetailResponse!.entityId!.invoiceno ?? "NA"}'),
            //             width20(),
            //             transactionDetailResponse!.entityId!.invoiceno == null
            //                 ? SizedBox()
            //                 : Padding(
            //                     padding: const EdgeInsets.only(bottom: 10),
            //                     child: Container(
            //                       height: 20,
            //                       width: 20,
            //                       decoration: BoxDecoration(
            //                           color: ColorsUtils.white,
            //                           shape: BoxShape.circle,
            //                           border:
            //                               Border.all(color: ColorsUtils.black)),
            //                       child: const Icon(Icons.arrow_forward_ios,
            //                           size: 10),
            //                     ),
            //                   )
            //           ],
            //         ),
            //       )
            //     : SizedBox()
          ],
        ),
      ),
    );
  }

  Widget customerDetail() {
    initCountry(transactionDetailResponse!.bincardstatusvalue == null
        ? "US"
        : transactionDetailResponse!.bincardstatusvalue!.country!.alpha2!);
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
            SizedBox(
              width: Get.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  smallText(title: 'Customer IP'.tr),
                  height5(),
                  Text(
                    transactionDetailResponse!.txniptrackervalue == null
                        ? 'NA'
                        : transactionDetailResponse!
                            .txniptrackervalue!.ipAddress,
                    style: ThemeUtils.blackBold.copyWith(
                        fontSize: FontUtils.mediumSmall,
                        color: ColorsUtils.black),
                  ),
                ],
              ),
            ),
            height10(),
            transactionDetailResponse!.transactionmodeId == 1
                ? smallText(title: 'Bin Country')
                : SizedBox(),
            transactionDetailResponse!.transactionmodeId == 1
                ? height5()
                : SizedBox(),
            transactionDetailResponse!.transactionmodeId == 1
                ? Row(
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
                                .bincardstatusvalue!.country!.name ??
                            'NA',
                        style: ThemeUtils.blackSemiBold
                            .copyWith(fontSize: FontUtils.mediumSmall),
                      ),
                    ],
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }

  Widget transactionResponse() {
    // print(
    //     "transactionDetailResponse!.transactionentity === ${transactionDetailResponse!.transactionentity!.id}");
    // print(
    //     "transactionDetailResponse!.transactionModeId === ${transactionDetailResponse!.transactionmode!.id}");
    // print("Condition ===${!(([
    //       3,
    //       4,
    //       5
    //     ].contains(transactionDetailResponse!.transactionmode?.id)) && transactionDetailResponse!.cardtype == 'SADAD PAY' && transactionDetailResponse!.transactionentityId == 5)}");
    return
        // transactionDetailResponse!.bankresponse == null
        //   ? SizedBox()
        //   :
        transactionDetailResponse!.transactionmode!.id == 3 &&
                transactionDetailResponse!.transactionentityId == 5
            ? SizedBox()
            : Container(
                width: Get.width,
                decoration: BoxDecoration(
                    color: ColorsUtils.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: ColorsUtils.border, width: 1)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      transactionDetailResponse!.transactionmodeId == 1
                          ? commonColumnField(
                              color: ColorsUtils.black,
                              title: 'RRN'.tr,
                              value: transactionDetailResponse!.bankresponse ==
                                      null
                                  ? "NA"
                                  : '${transactionDetailResponse!.bankresponse?.rRN ?? "NA"}')
                          : SizedBox(),
                      transactionDetailResponse!.transactionentity?.id == 9
                          ? commonColumnField(
                              color: ColorsUtils.black,
                              title: 'Integration Type'.tr,
                              value: transactionDetailResponse!
                                          .transactionentity ==
                                      null
                                  ? "NA"
                                  : '${transactionDetailResponse!.transactionentity?.name ?? "NA"}')
                          : SizedBox(),
                      transactionDetailResponse!.transactionentity?.id == 7
                          ? commonColumnField(
                              color: ColorsUtils.black,
                              title: 'Integration Type'.tr,
                              value: transactionDetailResponse!
                                          .transactionentity ==
                                      null
                                  ? "NA"
                                  : '${transactionDetailResponse!.transactionentity?.name ?? "NA"}')
                          : SizedBox(),
                      !(([3, 4, 5].contains(transactionDetailResponse!
                                  .transactionmode?.id)) &&
                              transactionDetailResponse!.cardtype ==
                                  'SADAD PAY' &&
                              transactionDetailResponse!.transactionentityId ==
                                  5)
                          ? commonColumnField(
                              color: ColorsUtils.black,
                              title: 'Transaction response code'.tr,
                              value: transactionDetailResponse!.bankresponse ==
                                      null
                                  ? "NA"
                                  : '${transactionDetailResponse!.bankresponse!.responseCode ?? "NA"}')
                          : SizedBox.shrink(),
                      !(([3, 4, 5].contains(transactionDetailResponse!
                                  .transactionmode?.id)) &&
                              transactionDetailResponse!.cardtype ==
                                  'SADAD PAY' &&
                              transactionDetailResponse!.transactionentityId ==
                                  5)
                          ? commonColumnField(
                              color: ColorsUtils.black,
                              title: 'Transaction response message'.tr,
                              value: transactionDetailResponse!.bankresponse ==
                                      null
                                  ? "NA"
                                  : '${transactionDetailResponse!.bankresponse!.explanation}')
                          : SizedBox(),
                      transactionDetailResponse!.transactionmodeId != 3
                          ? commonColumnField(
                              color: ColorsUtils.black,
                              title: 'Auth number'.tr,
                              value: transactionDetailResponse!.bankresponse ==
                                      null
                                  ? "NA"
                                  : transactionDetailResponse!
                                              .bankresponse!.authNumber ==
                                          ''
                                      ? "NA"
                                      : '${transactionDetailResponse!.bankresponse!.authNumber ?? "NA"}')
                          : SizedBox()
                    ],
                  ),
                ),
              );
  }

  Widget refundAndDispute() {
    // print(
    //     "transactionDetailResponse!.transactionentity === ${transactionDetailResponse!.transactionentity!.id}");
    // print(
    //     "transactionDetailResponse!.transactionModeId === ${transactionDetailResponse!.transactionmode!.id}");
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
                transactionDetailResponse!.refundTxn!.isEmpty
                    ? SizedBox()
                    : Get.to(() => RefundDetailScreen(
                          id: transactionDetailResponse!.refundTxn!.first.id
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
                          '${transactionDetailResponse!.refundTxn!.isEmpty ? 'NA' : transactionDetailResponse!.refundTxn!.first.invoicenumber ?? "NA"}'),
                  width20(),
                  transactionDetailResponse!.refundTxn!.isEmpty
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
            transactionDetailResponse!.transactionentityId == 6
                ?
                // InkWell(
                //         onTap: () {
                //           transactionDetailResponse!.order == null
                //               ? SizedBox()
                //               : Get.to(() => OrderDetailScreen(
                //                     id: transactionDetailResponse!.order!.id
                //                         .toString(),
                //                   ));
                //         },
                //         child:
                //         Row(
                //           crossAxisAlignment: CrossAxisAlignment.end,
                //           children: [
                //             commonColumnField(
                //                 color: ColorsUtils.black,
                //                 title: 'Order ID.'.tr,
                //                 value:
                //                     '${transactionDetailResponse!.entityId == null ? 'NA' : transactionDetailResponse!.entityId!.orderno ?? "NA"}'),
                //             width20(),
                //             transactionDetailResponse!.entityId == null ||
                //                     transactionDetailResponse!.entityId!.orderno ==
                //                         null
                //                 ? SizedBox()
                //                 : Padding(
                //                     padding: const EdgeInsets.only(bottom: 10),
                //                     child: Container(
                //                       height: 20,
                //                       width: 20,
                //                       decoration: BoxDecoration(
                //                           color: ColorsUtils.white,
                //                           shape: BoxShape.circle,
                //                           border:
                //                               Border.all(color: ColorsUtils.black)),
                //                       child: const Icon(Icons.arrow_forward_ios,
                //                           size: 10),
                //                     ),
                //                   )
                //           ],
                //         ),
                //       )
                InkWell(
                    onTap: () {
                      if (transactionDetailResponse!.entityId != null)
                        Get.to(() => OrderDetailScreen(
                            id: transactionDetailResponse!.entityId!.id
                                .toString()));
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        commonColumnField(
                            color: ColorsUtils.black,
                            title: 'Order ID'.tr,
                            value:
                                '${transactionDetailResponse!.entityId == null ? 'NA' : transactionDetailResponse!.entityId!.orderno ?? "NA"}'),
                        width20(),
                        transactionDetailResponse!.entityId == null
                            ? SizedBox()
                            : transactionDetailResponse!.entityId!.orderno ==
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
                                          border: Border.all(
                                              color: ColorsUtils.black)),
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
                  value: transactionDetailResponse!.dispute == null
                      ? 'NA'
                      : '${transactionDetailResponse!.dispute!.disputeId ?? ""}'),
            ),
            transactionDetailResponse!.transactionentityId == 2
                ? SizedBox(
                    width: Get.width,
                    child: commonColumnField(
                        color: ColorsUtils.black,
                        title: 'Subscription ID'.tr,
                        value: transactionDetailResponse!
                                    .subscriptionInvoiceId ==
                                null
                            ? 'NA'
                            : '${transactionDetailResponse!.subscriptionInvoiceId ?? ""}'),
                  )
                : SizedBox()
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
                                  '${Utility.baseUrl}transactions/downloadReceipt?transactionId=${transactionDetailResponse!.invoicenumber}&isPOS=false')
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
                  transactionDetailResponse!.transactionstatus!.id == 3
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Divider(),
                        )
                      : SizedBox(),
                  transactionDetailResponse!.transactionstatus!.id == 3
                      ? InkWell(
                          onTap: () async {
                            Get.back();
                            if ((transactionDetailResponse!.isRefund == false &&
                                (transactionDetailResponse!
                                        .priorRefundRequestedAmount <=
                                    0))) {
                              Map<String, dynamic> transactionDetail = {
                                'id': transactionDetailResponse!.invoicenumber,
                                'type': transactionDetailResponse!.cardtype,
                                'amount': transactionDetailResponse!.amount,
                                'isCredit': transactionDetailResponse!
                                    .transactionmode!.id,
                                'PriorAmount': transactionDetailResponse!
                                    .priorRefundRequestedAmount
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
                                                                    '${transactionDetailResponse!.refundTxn == null ? 'NA' : transactionDetailResponse!.refundTxn!.first.transactionstatusId == 4 ? 'Refunded' : transactionDetailResponse!.refundTxn!.first.transactionstatusId == 5 ? 'Pending' : 'Rejected'}')
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
                                                                '${(transactionDetailResponse!.refundTxn == null ? 'NA' : transactionDetailResponse!.refundTxn!.first.invoicenumber ?? "NA")}',
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
    await transactionViewModel.transactionDetail(widget.id!);
    userid = await encryptedSharedPreferences.getString('id');
  }
}
