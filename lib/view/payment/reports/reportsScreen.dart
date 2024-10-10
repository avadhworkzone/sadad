// ignore_for_file: curly_braces_in_flow_control_structures, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/payment/reports/invoiceReportDetailScreen.dart';
import 'package:sadad_merchat_app/view/payment/reports/storeOrderReportScreen.dart';
import 'package:sadad_merchat_app/view/payment/reports/subscriptionReportScreen.dart';
import 'package:sadad_merchat_app/view/payment/reports/transactionReposrtScreen.dart';

import '../../../main.dart';
import 'package:http/http.dart' as http;

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  String? selectedType;
  String? selectFromDate;
  String? selectToDate;
  int isRadioSelected = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          height40(),
          Row(
            children: [
              InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(Icons.arrow_back_ios)),
              width20(),
              const Spacer(),
              Text('Reports'.tr,
                  style: ThemeUtils.blackBold.copyWith(
                    fontSize: FontUtils.medLarge,
                  )),
              const Spacer(),
              width20()
            ],
          ),
          height40(),
          Image.asset(Images.reportImage,
              width: Get.width, height: Get.height * 0.3),
          height40(),
          Text(
            'View and Download\nOnline Payment Reports'.tr,
            textAlign: TextAlign.center,
            style: ThemeUtils.blackBold.copyWith(
              fontSize: FontUtils.medLarge,
            ),
          ),
          height30(),
          InkWell(
            onTap: () async {
              await bottomSheetforStoreProduct(context);
              setState(() {});
            },
            child: Container(
              height: Get.height * 0.07,
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: ColorsUtils.border, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isRadioSelected == 0
                          ? 'Select your Report'.tr
                          : isRadioSelected == 1
                              ? 'Transaction Details'.tr
                              : isRadioSelected == 2
                                  ? 'Invoice Payments Details'.tr
                                  // : isRadioSelected == 3
                                  //     ? 'Subscription Payments Details'.tr
                                  : isRadioSelected == 3
                                      ? 'Store Orders Details'.tr
                                      : '',
                      style: ThemeUtils.blackSemiBold.copyWith(
                        fontSize: FontUtils.small,
                        color: ColorsUtils.grey,
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      size: 25,
                    )
                  ],
                ),
              ),
            ),
          ),
          height20(),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () async {
                    print('hi');
                    await _selectFromDate(context);
                  },
                  child: Container(
                    height: Get.height * 0.07,
                    width: Get.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: ColorsUtils.border, width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            textDirection: TextDirection.ltr,
                            selectFromDate == null
                                ? 'Form'.tr
                                : intl.DateFormat('dd-MM-yyyy')
                                    .format(fromDate),
                            style: ThemeUtils.blackSemiBold.copyWith(
                              fontSize: FontUtils.small,
                              color: ColorsUtils.grey,
                            ),
                          ),
                          Image.asset(
                            Images.calender,
                            height: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              width20(),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    await _toDate(context);
                  },
                  child: Container(
                    height: Get.height * 0.07,
                    width: Get.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: ColorsUtils.border, width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            textDirection: TextDirection.ltr,
                            selectToDate == null
                                ? 'To'.tr
                                : intl.DateFormat('dd-MM-yyyy').format(toDate),
                            style: ThemeUtils.blackSemiBold.copyWith(
                              fontSize: FontUtils.small,
                              color: ColorsUtils.grey,
                            ),
                          ),
                          Image.asset(
                            Images.calender,
                            height: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          height40(),
          InkWell(
            onTap: () async {
              if (isRadioSelected == 0 || selectedType == null) {
                Get.snackbar('', 'Please Select Report Type'.tr);
              } else if (selectFromDate == null || selectToDate == null) {
                Get.snackbar('', 'Please Select Dates'.tr);
              } else {
                final difference = DateTime.parse(selectToDate!)
                    .difference(DateTime.parse(selectFromDate!))
                    .inDays;
                if (difference >= 365) {
                  Get.snackbar(
                      'error', 'Please select date range under 1 year');
                } else {
                  Utility.transactionFilterStatus = '';
                  Utility.transactionFilterPaymentMethod = '';
                  Utility.transactionFilterTransactionModes = '';
                  Utility.transactionFilterTransactionSources = '';
                  Utility.holdTransactionFilterTransactionType = '';
                  Utility.transactionFilterTransactionType = '';
                  Utility.holdTransactionFilterStatus = '';
                  Utility.holdTransactionFilterPaymentMethod = '';
                  Utility.holdTransactionFilterTransactionModes = '';
                  Utility.holdTransactionFilterTransactionSources = '';
                  Utility.activityReportGetSubUSer = '';
                  Utility.activityReportHoldGetSubUSerId = '';
                  Utility.holdOnlineInvoiceFilterStatus = '';
                  Utility.onlineInvoiceFilterStatus = '';
                  Utility.activityReportHoldGetSubUSer = '';
                  Utility.transactionFilterIntegrationType = '';
                  Utility.holdTransactionFilterIntegrationType = '';
                  Utility.orderDeliverStatus = '';
                  print('select ebd date:$selectToDate');
                  String token =
                      await encryptedSharedPreferences.getString('token');
                  //reporthistories/invoiceReports
                  final url = Uri.parse(
                    '${Utility.baseUrl}reporthistories/${isRadioSelected == 1 ? 'transactionDetailsReport' : isRadioSelected == 2 ? 'invoiceReports' : 'orderReports'}?filter[skip]=0&filter[limit]=10&filter[order]=created DESC&filter[where][created][between][0]=${intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse('${selectFromDate}'))}&filter[where][created][between][1]=${intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse('${selectToDate}'))}',
                  );
                  Map<String, String> header = {
                    'Authorization': token,
                    'Content-Type': 'application/json'
                  };
                  var result = await http.get(
                    url,
                    headers: header,
                  );

                  print(
                      'token is:$token } \n url $url  \n response is :${result.body} ');
                  if (result.statusCode >= 200 && result.statusCode <= 299) {
                    isRadioSelected == 1
                        ? Get.to(() => TransactionReportScreen(
                            endDate: selectToDate,
                            startDate: selectFromDate,
                            selectedType: selectedType))
                        : isRadioSelected == 2
                            ? Get.to(() => InvoiceReportScreen(
                                endDate: selectToDate,
                                startDate: selectFromDate,
                                selectedType: selectedType))
                            // : isRadioSelected == 3
                            //     ? Get.to(() => SubscriptionReportScreen())
                            : Get.to(() => StoreOrderDetailScreen(
                                endDate: selectToDate,
                                startDate: selectFromDate,
                                selectedType: selectedType));
                  } else {
                    Get.snackbar('error',
                        '${jsonDecode(result.body)['error']['message']}');
                  }
                }
              }
            },
            child: buildContainerWithoutImage(
                color: ColorsUtils.accent, text: 'View result'.tr),
          )
        ],
      ),
    ));
  }

  Future<dynamic> reportTypeDialog(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        isRadioSelected = 0;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'Select your Report'.tr,
                      style: ThemeUtils.blackBold.copyWith(
                          color: ColorsUtils.accent,
                          fontSize: FontUtils.medium),
                    ),
                  ),
                  LabeledRadio(
                    value: 1,
                    groupValue: isRadioSelected,
                    label: 'Transaction Details'.tr,
                    onChanged: (value) {
                      isRadioSelected = value;
                      selectedType = 'transactionDetailsReport';
                      setDialogState(() {});
                    },
                  ),
                  LabeledRadio(
                    value: 2,
                    groupValue: isRadioSelected,
                    label: 'Settlement Details'.tr,
                    onChanged: (value) {
                      selectedType = 'settlementReports';
                      isRadioSelected = value;
                      setDialogState(() {});
                    },
                  ),
                  LabeledRadio(
                    value: 3,
                    groupValue: isRadioSelected,
                    label: 'Invoice Payments Details'.tr,
                    onChanged: (value) {
                      selectedType = 'invoiceReports';
                      isRadioSelected = value;
                      setDialogState(() {});
                    },
                  ),
                  // LabeledRadio(
                  //   value: 4,
                  //   groupValue: isRadioSelected,
                  //   label: 'Subscription Payments Details'.tr,
                  //   onChanged: (value) {
                  //     selectedType = 'subscriptionDetailsReports';
                  //     isRadioSelected = value;
                  //     setDialogState(() {});
                  //   },
                  // ),
                  LabeledRadio(
                    value: 4,
                    groupValue: isRadioSelected,
                    label: 'Store Orders Details'.tr,
                    onChanged: (value) {
                      selectedType = 'orderReports';
                      isRadioSelected = value;
                      setDialogState(() {});
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: buildContainerWithoutImage(
                                color: ColorsUtils.accent, text: 'Select'.tr),
                          ),
                        ),
                        width20(),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              selectedType == null;
                              isRadioSelected = 0;
                              Get.back();
                            },
                            child: buildContainerWithoutImage(
                                color: ColorsUtils.accent, text: 'Cancel'.tr),
                          ),
                        ),
                      ],
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

  bottomSheetforStoreProduct(BuildContext context) {
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
                  InkWell(
                      onTap: () {
                        isRadioSelected = 1;
                        selectedType = 'transactionDetailsReport';
                        setState(() {});
                        Get.back();
                      },
                      child: customSmallMedBoldText(
                          title: 'Transaction Details'.tr)),
                  height20(),
                  InkWell(
                      onTap: () {
                        isRadioSelected = 2;
                        selectedType = 'invoiceReports';
                        setState(() {});
                        Get.back();
                      },
                      child: customSmallMedBoldText(
                          title: 'Invoice Payments Details'.tr)),
                  // height20(),
                  // InkWell(
                  //     onTap: () {
                  //       isRadioSelected = 3;
                  //       selectedType = 'subscriptionDetailsReports';
                  //
                  //       setState(() {});
                  //       Get.back();
                  //     },
                  //     child: customSmallMedBoldText(
                  //         title: 'Subscription Payment Details'.tr)),
                  height20(),
                  InkWell(
                      onTap: () {
                        isRadioSelected = 3;
                        selectedType = 'orderReports';

                        setState(() {});
                        Get.back();
                      },
                      child: customSmallMedBoldText(
                          title: 'Store Orders Details'.tr)),
                  height40(),
                ],
              ),
            );
          },
        );
      },
    );
  }

  _selectFromDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: fromDate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (selected != null && selected != fromDate)
      setState(() {
        fromDate = selected;
        selectFromDate = fromDate.toString();
        print(fromDate);
      });
  }

  _toDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: fromDate,
      firstDate: fromDate,
      lastDate: DateTime.now(),
    );
    if (selected != null && selected != toDate)
      setState(() {
        toDate = selected;
        selectToDate = toDate.toString();
        print(toDate);
      });
  }

  Text smallBoldText({String? text}) {
    return Text(text!,
        style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.verySmall));
  }
}
