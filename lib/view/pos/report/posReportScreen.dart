// ignore_for_file: curly_braces_in_flow_control_structures, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/pos/report/posDeviceReportScreen.dart';
import 'package:sadad_merchat_app/view/pos/report/posReportTerminalDetail.dart';
import 'package:sadad_merchat_app/view/pos/report/posTransactionDetailScreen.dart';
import 'package:http/http.dart' as http;

class PosReportScreen extends StatefulWidget {
  const PosReportScreen({Key? key}) : super(key: key);

  @override
  State<PosReportScreen> createState() => _PosReportScreenState();
}

class _PosReportScreenState extends State<PosReportScreen> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  String? selectedType;
  String? selectFromDate;
  String? selectToDate;
  int isRadioSelected = 0;
  DateTime activatedDate = DateTime.now();

  getInitData() async {
    String date =
        await encryptedSharedPreferences.getString('posActivatedDate');
    print('date is====$date');
    // print(
    //     'date is====${DateTime(activatedDate.year, activatedDate.month, activatedDate.day)}');
    if (date.isNotEmpty) {
      activatedDate = DateTime.parse(date);
    }
    setState(() {});
  }

  @override
  void initState() {
    getInitData();
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
          height60(),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              'View and Download POS Reports'.tr,
              textAlign: TextAlign.center,
              style: ThemeUtils.blackBold.copyWith(
                fontSize: FontUtils.medLarge,
              ),
            ),
          ),
          height30(),
          InkWell(
            onTap: () async {
              // await reportTypeDialog(context);
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
                              ? 'POS Transaction Details'.tr
                              : isRadioSelected == 2
                                  ? 'POS Terminals Summary'.tr
                                  : isRadioSelected == 3
                                      ? 'POS Devices Summary'.tr
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
                print('diffff $difference');
                print('select end Data::;$selectToDate');

                ///pos terminal
                Utility.terminalFilterPaymentMethod = '';
                Utility.terminalFilterTransModes = '';
                Utility.terminalFilterTransStatus = '';
                Utility.terminalFilterDeviceStatus = '';
                Utility.terminalCountFilterPaymentMethod = '';
                Utility.terminalCountFilterTransModes = '';
                Utility.terminalCountFilterTransStatus = '';

                ///pos device
                Utility.holdDeviceFilterDeviceType = '';

                ///pos transaction
                ///
                Utility.posPaymentTransactionStatusFilter = '';
                Utility.posPaymentCardEntryTypeFilter = '';
                Utility.posPaymentTransactionTypeFilter = '';
                Utility.posPaymentPaymentMethodFilter = '';
                Utility.posPaymentTransactionModesFilter = '';
                Utility.holdPosPaymentTransactionStatusFilter = '';
                Utility.holdPosPaymentTransactionModesFilter = '';
                Utility.holdPosPaymentTransactionTypeFilter = [];
                Utility.holdPosPaymentCardEntryTypeFilter = '';
                Utility.posPaymentTerminalSelectionFilter = [];
                Utility.holdPosPaymentTerminalSelectionFilter = [];
                Utility.posPaymentTransactionTypeTerminalFilter = [];
                Utility.holdPosPaymentTransactionTypeTerminalFilter = [];
                Utility.posDisputeTransactionStatusFilter = '';
                Utility.holdPosDisputeTransactionStatusFilter = '';
                Utility.holdDeviceFilterDeviceStatus = '';
                Utility.deviceFilterDeviceStatus = '';
                Utility.deviceFilterDeviceType = '';
                Utility.posRefundTransactionStatusFilter = '';
                Utility.holdPosRefundTransactionStatusFilter = '';

                ///
                Utility.posDisputeTransactionStatusFilter = '';
                Utility.posDisputeTransactionTypeFilter = '';
                Utility.posRefundTransactionModesFilter = '';
                Utility.posRefundCardEntryTypeFilter = '';
                Utility.posRefundPaymentMethodFilter = '';
                Utility.posRentalPaymentStatusFilter = '';
                Utility.holdPosDisputeTransactionStatusFilter = '';
                Utility.posDisputeTransactionStatusFilter = '';

                // if (selectedType == 'posTransactionDetailReport') {
                if (difference >= 365) {
                  Get.snackbar(
                      'error', 'Please select date range under 1 year');
                } else {
                  String token =
                      await encryptedSharedPreferences.getString('token');
                  //reporthistories/invoiceReports
                  final url = Uri.parse(
                    '${Utility.baseUrl}reporthistories/${selectedType}?filter[skip]=0&filter[limit]=10&filter[order]=created DESC&filter[where][created][between][0]=${intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(selectFromDate.toString()))}&filter[where][created][between][1]=${intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(selectToDate.toString()))}',
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
                    selectedType == 'posTransactionDetailReport'
                        ? Get.to(() => PosReportTransactionDetailScreen(
                              endDate: selectToDate,
                              startDate: selectFromDate,
                              selectedType: selectedType,
                            ))
                        : selectedType == 'posDeviceSummaryReport'
                            ? Get.to(() => PosDeviceReportScreen(
                                  endDate: selectToDate,
                                  startDate: selectFromDate,
                                  selectedType: selectedType,
                                ))
                            : Get.to(() => PosTerminalReportDetailScreen(
                                  endDate: selectToDate,
                                  startDate: selectFromDate,
                                  selectedType: selectedType,
                                ));
                  } else {
                    Get.snackbar('error',
                        '${jsonDecode(result.body)['error']['message']}');
                  }
                }
                // } else {
                //   selectedType == 'posTransactionDetailReport'
                //       ? Get.to(() => PosReportTransactionDetailScreen(
                //             endDate: selectToDate,
                //             startDate: selectFromDate,
                //             selectedType: selectedType,
                //           ))
                //       : selectedType == 'posDeviceSummaryReport'
                //           ? Get.to(() => PosDeviceReportScreen(
                //                 endDate: selectToDate,
                //                 startDate: selectFromDate,
                //                 selectedType: selectedType,
                //               ))
                //           : Get.to(() => PosTerminalReportDetailScreen(
                //                 endDate: selectToDate,
                //                 startDate: selectFromDate,
                //                 selectedType: selectedType,
                //               ));
                // }
                // if (difference >= 365) {
                //   Get.snackbar(
                //       'error', 'Please select date range under 1 year');
                // } else {

                // }
              }
            },
            child: buildContainerWithoutImage(
                color: ColorsUtils.accent, text: 'View result'.tr),
          )
        ],
      ),
    ));
  }

  _selectFromDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: fromDate,
      //firstDate: DateTime(1950),
      firstDate:isRadioSelected==2? DateTime(activatedDate.year,
          activatedDate.month, activatedDate.day):DateTime(DateTime.now().year-1,DateTime.now().month,DateTime.now().day),
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
                        selectedType = 'posTransactionDetailReport';
                        setState(() {});
                        Get.back();
                      },
                      child: customSmallMedBoldText(
                          title: 'POS Transaction Details'.tr)),
                  height20(),
                  InkWell(
                      onTap: () {
                        isRadioSelected = 2;
                        selectedType = 'posTerminalSummaryReport';

                        setState(() {});
                        Get.back();
                      },
                      child: customSmallMedBoldText(
                          title: 'POS Terminals Summary'.tr)),
                  //height20(),
                  // InkWell(
                  //     onTap: () {
                  //       isRadioSelected = 3;
                  //       selectedType = 'posDeviceSummaryReport';
                  //
                  //       setState(() {});
                  //       Get.back();
                  //     },
                  //     child: customSmallMedBoldText(
                  //         title: 'POS Devices Summary'.tr)),
                  height40(),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Text smallBoldText({String? text}) {
    return Text(text!,
        style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.verySmall));
  }
}
