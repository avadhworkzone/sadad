// ignore_for_file: curly_braces_in_flow_control_structures, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/Activity/report/activityReportList.dart';

class ActivityReportScreen extends StatefulWidget {
  const ActivityReportScreen({Key? key}) : super(key: key);

  @override
  State<ActivityReportScreen> createState() => _ActivityReportScreenState();
}

class _ActivityReportScreenState extends State<ActivityReportScreen> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  String? selectedType;
  String? selectFromDate;
  String? selectToDate;
  int isRadioSelected = 0;

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
                              ? 'Withdrawals'
                              : isRadioSelected == 2
                                  ? 'All Transactions'
                                  : 'Transfers',
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
            onTap: () {
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
                  Utility.activityReportSettlementWithdrawFilterStatus = '';
                  Utility.activityReportSettlementWithdrawFilterType = '';
                  Utility.activityReportSettlementPayoutFilterStatus = '';
                  Utility.activityReportSettlementPayoutFilterBank = '';
                  Utility.activityReportHoldSettlementPayoutFilterStatus = '';
                  Utility.activityReportHoldSettlementPayoutFilterBank = '';
                  Utility.activityReportHoldSettlementWithdrawFilterStatus = '';
                  Utility.activityReportHoldSettlementWithdrawFilterType = '';
                  Utility.activityReportHoldGetSubUSer = '';
                  Utility.activityReportGetSubUSer = '';
                  Utility.activityReportHoldGetSubUSerId = '';

                  ///radio 2
                  Utility.activityTransactionReportTransactionTypeFilter = '';
                  Utility.activityTransactionReportTransactionSourceFilter = '';
                  Utility.activityTransactionReportTransactionStatusFilter = '';
                  Utility.activityTransactionReportPaymentMethodFilter = '';
                  Utility.activityTransactionReportTransactionModeFilter = '';
                  Utility.activityTransactionReportIntegrationTypeFilter = '';
                  Utility.holdActivityTransactionReportTransactionTypeFilter =
                      '';
                  Utility.holdActivityTransactionReportTransactionSourceFilter =
                      '';
                  Utility.holdActivityTransactionReportTransactionStatusFilter =
                      '';
                  Utility.holdActivityTransactionReportPaymentMethodFilter = '';
                  Utility.holdActivityTransactionReportTransactionModeFilter =
                      '';
                  Utility.holdActivityTransactionReportIntegrationTypeFilter =
                      '';

                  ///radio 3
                  Utility.activityTransferReportTransferTypeFilter = '';
                  Utility.holdActivityTransferReportTransferTypeFilter = '';
                  Get.to(() => ActivityReportListScreen(
                        startDate: selectFromDate,
                        endDate: selectToDate,
                        isRadioSelected: isRadioSelected,
                      ));
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
                        selectedType = 'settlementDetailsReport';
                        setState(() {});
                        Get.back();
                      },
                      child: customSmallMedBoldText(title: 'Withdrawals')),
                  height20(),
                  InkWell(
                      onTap: () {
                        isRadioSelected = 2;
                        selectedType = 'settlementDetailsReport';
                        setState(() {});
                        Get.back();
                      },
                      child: customSmallMedBoldText(title: 'All Transactions')),
                  height20(),
                  InkWell(
                      onTap: () {
                        isRadioSelected = 3;
                        selectedType = 'settlementDetailsReport';
                        setState(() {});
                        Get.back();
                      },
                      child: customSmallMedBoldText(title: 'Transfers')),
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
        selectFromDate = intl.DateFormat('yyyy-MM-dd 00:00:00')
            .format(DateTime.parse(fromDate.toString()))
            .toString();
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
        selectToDate = intl.DateFormat('yyyy-MM-dd 23:59:59')
            .format(DateTime.parse(toDate.toString()))
            .toString();
        print(toDate);
      });
  }

  Text smallBoldText({String? text}) {
    return Text(text!,
        style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.verySmall));
  }
}
