import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/BatchSummary/TerminalBatchSummeryResModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/staticData.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/downloadFile.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/pos/batchSummary/batchSummaryDetailScreen.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:sadad_merchat_app/viewModel/pos/batch%20Summary/batchSummeryViewModel.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:http/http.dart' as http;

class BatchSummaryScreen extends StatefulWidget {
  const BatchSummaryScreen({Key? key}) : super(key: key);

  @override
  State<BatchSummaryScreen> createState() => _BatchSummaryScreenState();
}

class _BatchSummaryScreenState extends State<BatchSummaryScreen> {
  List<String> selectedTimeZone = ['Today'];
  final now = DateTime.now();
  GlobalKey _key = GlobalKey();

  String filterDate = '';
  String _range = '';
  String _reportDate = '';
  String customRange = '';
  String endDate = '';
  String startDate = '';
  String customEndDate = '';
  String customStartDate = '';
  int differenceDays = 0;
  int selectedMode = 0;
  bool isPageFirst = true;

  String email = '';
  BatchSummeryViewModel batchSummeryViewModel = Get.find();
  ConnectivityViewModel connectivityViewModel = Get.find();
  int isRadioSelected = 3;
  bool sendEmail = false;
  List<TerminalBatchSummaryResModel>? batchSummaryRes;
  ScrollController? _scrollController;
  @override
  void initState() {
    _reportDate =
        '${intl.DateFormat("dd MMM yyyy").format(DateTime.now())} - ${intl.DateFormat("dd MMM yyyy").format(DateTime.now())}';

    connectivityViewModel.startMonitoring();
    // TODO: implement initState
    batchSummeryViewModel.setInit();
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [topView(context), bottomView()],
      ),
    );
  }

  Expanded bottomView() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Expanded(
              child: GetBuilder<BatchSummeryViewModel>(
                builder: (controller) {
                  if (controller.batchSummeryListApiResponse.status ==
                          Status.LOADING ||
                      controller.batchSummeryListApiResponse.status ==
                          Status.INITIAL) {
                    return const Center(child: Loader());
                  }
                  if (controller.batchSummeryListApiResponse.status ==
                      Status.ERROR) {
                    return const SessionExpire();
                    //return Text('something wrong');
                  }

                  batchSummaryRes = controller.batchSummeryListApiResponse.data;

                  return batchSummaryRes == null ||
                          batchSummaryRes == [] ||
                          batchSummaryRes!.isEmpty
                      ? noDataFound()
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          controller: _scrollController,
                          itemCount: batchSummaryRes!.length,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            int salesCnt = 0;
                            double salesAmt = 0.0;
                            int refundCnt = 0;
                            double refundAmt = 0.0;
                            int preAuthCnt = 0;
                            double preAuthAmt = 0.0;
                            Map<String, dynamic> salesCount = {};
                            Map<String, dynamic> salesAmount = {};
                            Map<String, dynamic> refundCount = {};
                            Map<String, dynamic> refundAmount = {};
                            Map<String, dynamic> preAuthCount = {};
                            Map<String, dynamic> preAuthAmount = {};
                            batchSummaryRes![index]
                                .paymentMethodData!
                                .forEach((element) {
                              print("element ==== $element");
                              if (element.sales != null)
                                element.sales!.forEach((element) {
                                  print("sales===$element");
                                  print(
                                      "sales count === ${Map<String, dynamic>.from(element).values.first['count']}");
                                  salesCnt += int.parse(
                                      Map<String, dynamic>.from(element)
                                          .values
                                          .first['count']
                                          .toString());
                                  print("cnt == $salesCnt");
                                  salesAmt += Map<String, dynamic>.from(element)
                                      .values
                                      .first['amount'];
                                  print("amt == $salesAmt");
                                });
                              if (element.refunds != null)
                                element.refunds!.forEach((element) {
                                  print("refunds===$element");
                                  print(
                                      "refunds count === ${Map<String, dynamic>.from(element).values.first['count']}");
                                  refundCnt += int.parse(
                                      Map<String, dynamic>.from(element)
                                          .values
                                          .first['count']
                                          .toString());
                                  print("refunds cnt == $refundCnt");
                                  refundAmt +=
                                      Map<String, dynamic>.from(element)
                                          .values
                                          .first['amount'];
                                  print("refunds amt == $refundAmt");
                                });
                              if (element.preauth != null)
                                element.preauth!.forEach((element) {
                                  print("preauth===$element");
                                  print(
                                      "preauth count === ${Map<String, dynamic>.from(element).values.first['count']}");
                                  preAuthCnt += int.parse(
                                      Map<String, dynamic>.from(element)
                                          .values
                                          .first['count']
                                          .toString());
                                  print("preauth cnt == $preAuthCnt");
                                  preAuthAmt +=
                                      Map<String, dynamic>.from(element)
                                          .values
                                          .first['amount'];
                                  print("preauth amt == $preAuthAmt");
                                });
                              salesCount['$index'] = salesCnt;
                              print("sales count===$salesCount");
                              salesAmount['$index'] = salesAmt;
                              print("sales amount===$salesAmount");
                              refundCount['$index'] = refundCnt;
                              print("refund count===$refundCount");
                              refundAmount['$index'] = refundAmt;
                              print("refund amount===$refundAmount");
                              preAuthCount['$index'] = preAuthCnt;
                              print("preAuth count===$preAuthCount");
                              preAuthAmount['$index'] = preAuthAmt;
                              print("preAuth amount===$preAuthAmount");
                            });

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: InkWell(
                                onTap: () async {
                                  await Get.to(() => BatchSummaryDetailScreen(
                                        activatedDate:
                                            batchSummaryRes![index].activated ??
                                                '',
                                        customEndDate: selectedTimeZone.first
                                                .contains('Custom')
                                            ? customEndDate
                                            : "",
                                        customStartDate: selectedTimeZone.first
                                                .contains('Custom')
                                            ? customStartDate
                                            : "",
                                        selectedTimeZone:
                                            selectedTimeZone.first,
                                        serialNo: batchSummaryRes![index]
                                                .deviceSerialNo ??
                                            '',
                                        terminalId: batchSummaryRes![index]
                                                .terminalId ??
                                            '',
                                        terminalName: batchSummaryRes![index]
                                                .terminalName ??
                                            '',
                                      ));
                                  batchSummeryViewModel.setInit();
                                  initData();
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color:
                                              ColorsUtils.grey.withOpacity(0.3),
                                          width: 1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Expanded(
                                                          child: customSmallMedBoldText(
                                                              color: ColorsUtils
                                                                  .black,
                                                              title:
                                                                  '${batchSummaryRes![index].terminalName ?? "NA"}'),
                                                        ),
                                                      ],
                                                    ),
                                                    height5(),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Expanded(
                                                            child: customSmallBoldText(
                                                                color:
                                                                    Colors.grey,
                                                                title:
                                                                    '${'Terminal ID:'.tr} ${batchSummaryRes![index].terminalId ?? 'NA'}')),
                                                        // Icon(
                                                        //   Icons.more_vert,
                                                        //   size: 25,
                                                        // )
                                                      ],
                                                    ),
                                                    height5(),
                                                    customVerySmallNorText(
                                                        color: ColorsUtils.grey,
                                                        title:
                                                            '${batchSummaryRes![index].deviceSerialNo ?? 'NA'}'),
                                                    height5(),
                                                    customVerySmallNorText(
                                                        color: ColorsUtils.grey,
                                                        title:
                                                            '${batchSummaryRes![index].location.toString().capitalize ?? 'NA'}'),
                                                    height5(),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: Get.height * 0.1,
                                                width: Get.width * 0.2,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    image: DecorationImage(
                                                      image: AssetImage(
                                                          Images.deviceBlank),
                                                    )),
                                              ),
                                            ],
                                          ),
                                          dividerData(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  customVerySmallBoldText(
                                                      title:
                                                          'Total Amount : '.tr),
                                                  currencyText(
                                                      salesAmount['$index'] +
                                                          refundAmount[
                                                              '$index'] +
                                                          preAuthAmount[
                                                              '$index'],
                                                      ThemeUtils.blackBold
                                                          .copyWith(
                                                              fontSize:
                                                                  FontUtils
                                                                      .small),
                                                      ThemeUtils.blackRegular
                                                          .copyWith(
                                                              fontSize: 8)),
                                                ],
                                              ),
                                              Container(
                                                height: 20,
                                                width: 1,
                                                color: ColorsUtils.grey
                                                    .withOpacity(0.3),
                                              ),
                                              customVerySmallBoldText(
                                                  title:
                                                      '${'Total Count -'.tr} ${salesCount['$index'] + refundCount['$index'] + preAuthCount['$index']}'),
                                            ],
                                          )
                                        ],
                                      ),
                                    )),
                              ),
                            );
                          },
                        );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Column topView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        height60(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(Icons.arrow_back_ios)),
              customMediumLargeBoldText(title: "Batch Summery".tr),
              InkWell(
                onTap: () {
                  batchSummaryRes == null || batchSummaryRes!.isEmpty
                      ?
                      // Get.showSnackbar(GetSnackBar(
                      //         message: 'No Data Found'.tr,
                      //       ))
                      Get.snackbar(
                          '',
                          'No Data Found'.tr,
                        )
                      : exportBottomSheet(context);
                  // exportBottomSheet(context);
                },
                child: Image.asset(
                  Images.download,
                  color: ColorsUtils.primary,
                  scale: 3,
                ),
              )
            ],
          ),
        ),
        height25(),
        timeZone(),
        height25(),
        Center(
          child: customSmallNorText(
              title: selectedTimeZone.contains('Today')
                  ? '${intl.DateFormat("dd MMM’ yy, 00:00:00").format(DateTime.now())} - ${intl.DateFormat("dd MMM’ yy, 23:59:59").format(DateTime.now())}'
                  : customRange != ''
                      ? customRange
                      : _range,
              color: ColorsUtils.grey),
        ),
        height10(),
      ],
    );
  }

  Widget timeZone() {
    return SizedBox(
      height: 25,
      width: Get.width,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: StaticData().batchSummaryTimeZone.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: index == 0 && Get.locale!.languageCode == 'en'
                ? const EdgeInsets.only(left: 20, right: 5)
                : index == StaticData().batchSummaryTimeZone.length - 1 &&
                        Get.locale!.languageCode == 'en'
                    ? const EdgeInsets.only(right: 20, left: 5)
                    : const EdgeInsets.symmetric(horizontal: 5),
            child: InkWell(
              onTap: () async {
                selectedTimeZone.clear();
                selectedTimeZone.add(StaticData().batchSummaryTimeZone[index]);
                if (selectedTimeZone.contains('Custom')) {
                  await datePicker(context);
                  setState(() {});
                } else {
                  customRange = '';
                  _range = selectedTimeZone.contains('Today')
                      ? '${intl.DateFormat("dd MMM’ yy, 00:00:00").format(DateTime.now())} - ${intl.DateFormat("dd MMM’ yy, 23:59:59").format(DateTime.now())}'
                      : selectedTimeZone.contains('Yesterday')
                          //? '${intl.DateFormat("dd MMM’ yy, 00:00:00").format(DateTime(now.year, now.month, now.day - 1))} - ${intl.DateFormat("dd MMM’ yy, 23:59:59").format(DateTime.now())}'
                          ? '${intl.DateFormat("dd MMM’ yy, 00:00:00").format(DateTime(now.year, now.month, now.day - 1))} - ${intl.DateFormat("dd MMM’ yy, 23:59:59").format(DateTime(now.year, now.month, now.day - 1))}'
                          : selectedTimeZone.contains('Week')
                              ? '${intl.DateFormat("dd MMM’ yy, 00:00:00").format(DateTime(now.year, now.month, now.day - 6))} - ${intl.DateFormat("dd MMM’ yy, 23:59:59").format(DateTime.now())}'
                              : selectedTimeZone.contains('Month')
                                  ? '${intl.DateFormat("dd MMM’ yy, 00:00:00").format(DateTime(now.year, now.month - 1, now.day))} - ${intl.DateFormat("dd MMM’ yy, 23:59:59").format(DateTime.now())}'
                                  : selectedTimeZone.contains('Year')
                                      ? '${intl.DateFormat("dd MMM’ yy, 00:00:00").format(DateTime(now.year - 1, now.month, now.day))} - - ${intl.DateFormat("dd MMM’ yy, 23:59:59").format(DateTime.now())}'
                                      : '';

                  _reportDate = selectedTimeZone.contains('Today')
                      ? '${intl.DateFormat("dd MMM yyyy").format(DateTime.now())} - ${intl.DateFormat("dd MMM yyyy").format(DateTime.now())}'
                      : selectedTimeZone.contains('Yesterday')
                          //? '${intl.DateFormat("dd MMM’ yy, 00:00:00").format(DateTime(now.year, now.month, now.day - 1))} - ${intl.DateFormat("dd MMM’ yy, 23:59:59").format(DateTime.now())}'
                          ? '${intl.DateFormat("dd MMM yyyy").format(DateTime(now.year, now.month, now.day - 1))} - ${intl.DateFormat("dd MMM yyyy").format(DateTime(now.year, now.month, now.day - 1))}'
                          : selectedTimeZone.contains('Week')
                              ? '${intl.DateFormat("dd MMM yyyy").format(DateTime(now.year, now.month, now.day - 6))} - ${intl.DateFormat("dd MMM yyyy").format(DateTime.now())}'
                              : selectedTimeZone.contains('Month')
                                  ? '${intl.DateFormat("dd MMM yyyy").format(DateTime(now.year, now.month - 1, now.day))} - ${intl.DateFormat("dd MMM yyyy").format(DateTime.now())}'
                                  : selectedTimeZone.contains('Year')
                                      ? '${intl.DateFormat("dd MMM yyyy").format(DateTime(now.year - 1, now.month, now.day))} - - ${intl.DateFormat("dd MMM yyyy").format(DateTime.now())}'
                                      : '';
                  print('_reportDate::::::::   $_reportDate');
                  setState(() {});
                }
                print('$selectedTimeZone');
                batchSummeryViewModel.setInit();
                initData();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: selectedTimeZone
                            .contains(StaticData().batchSummaryTimeZone[index])
                        ? ColorsUtils.primary
                        : ColorsUtils.tabUnselect),
                child: Center(
                  child: Text(
                    index == 4
                        ? customRange == ''
                            ? StaticData().batchSummaryTimeZone[index].tr
                            : customRange
                        : StaticData().batchSummaryTimeZone[index].tr,
                    style: ThemeUtils.maroonBold.copyWith(
                        fontSize: FontUtils.verySmall,
                        color: selectedTimeZone.contains(
                                StaticData().batchSummaryTimeZone[index])
                            ? ColorsUtils.white
                            : ColorsUtils.tabUnselectLabel),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> datePicker(BuildContext context) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          String customRangePicker = '';

          return StatefulBuilder(
            builder: (context, setDialogState) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        decoration: BoxDecoration(
                            color: ColorsUtils.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: ColorsUtils.border)),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                'Select Dates'.tr,
                                style: ThemeUtils.blackBold.copyWith(
                                    color: ColorsUtils.accent,
                                    fontSize: FontUtils.medium),
                              ),
                              height20(),
                              SfDateRangePicker(
                                //minDate: DateTime(),
                                onSelectionChanged:
                                    (dateRangePickerSelectionChangedArgs) {
                                  if (dateRangePickerSelectionChangedArgs
                                              .value.endDate ==
                                          null ||
                                      dateRangePickerSelectionChangedArgs
                                              .value.endDate ==
                                          '') {
                                    customEndDate = '';
                                    customRangePicker = '';
                                  } else {
                                    if (dateRangePickerSelectionChangedArgs
                                        .value is PickerDateRange) {
                                      customRangePicker =
                                          '${intl.DateFormat('dd MMM’ yy, 00:00:00').format(dateRangePickerSelectionChangedArgs.value.startDate)} -'
                                          ' ${intl.DateFormat('dd MMM’ yy, 23:59:59').format(dateRangePickerSelectionChangedArgs.value.endDate)}';
                                      setState(() {});
                                    }
                                    final difference =
                                        dateRangePickerSelectionChangedArgs
                                            .value.endDate
                                            .difference(
                                                dateRangePickerSelectionChangedArgs
                                                    .value.startDate)
                                            .inDays;
                                    differenceDays =
                                        int.parse(difference.toString());
                                    print('days is :::$difference');
                                  }
                                  if (differenceDays >= 364) {
                                    Get.snackbar('warning'.tr,
                                        'Please select range in 12 month'.tr);
                                    customStartDate = '';
                                    customEndDate = '';
                                  } else {
                                    customStartDate = intl.DateFormat(
                                            'yyyy-MM-dd 00:00:00')
                                        .format(DateTime.parse(
                                            '${dateRangePickerSelectionChangedArgs.value.startDate}'));

                                    dateRangePickerSelectionChangedArgs
                                                    .value.endDate ==
                                                null ||
                                            dateRangePickerSelectionChangedArgs
                                                    .value.endDate ==
                                                ''
                                        ? ''
                                        : customEndDate = intl.DateFormat(
                                                'yyyy-MM-dd 23:59:59')
                                            .format(DateTime.parse(
                                                '${dateRangePickerSelectionChangedArgs.value.endDate}'));
                                  }

                                  setDialogState(() {});
                                },
                                selectionMode:
                                    DateRangePickerSelectionMode.range,
                                minDate: DateTime(DateTime.now().year - 1,
                                    DateTime.now().month, DateTime.now().day),
                                maxDate: DateTime.now(),
                                initialSelectedRange: PickerDateRange(
                                    customStartDate == ''
                                        ? DateTime.now()
                                            .subtract(const Duration(days: 7))
                                        : DateTime.parse(customStartDate),
                                    customEndDate == ''
                                        ? DateTime.now()
                                        : DateTime.parse(customEndDate)),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border:
                                        Border.all(color: ColorsUtils.border)),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Selected Dates: '.tr,
                                        style: ThemeUtils.blackBold.copyWith(
                                            fontSize: FontUtils.verySmall),
                                      ),
                                      Text(
                                        customRangePicker,
                                        style: ThemeUtils.blackBold.copyWith(
                                            fontSize: FontUtils.verySmall),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              height20(),
                              Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        print(
                                            "custom range---$customRangePicker");
                                        customRange = customRangePicker;

                                        setState(() {});
                                        if (customStartDate == '' ||
                                            customEndDate == '') {
                                          Get.snackbar('error'.tr,
                                              'Please select correct date'.tr);
                                        } else {
                                          batchSummeryViewModel.setInit();
                                          Get.back();
                                        }
                                      },
                                      child: buildContainerWithoutImage(
                                          color: ColorsUtils.accent,
                                          text: 'Select'.tr),
                                    ),
                                  ),
                                  width10(),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        Get.back();
                                        if (customRangePicker == '') {
                                          customRange = '';
                                          selectedTimeZone.clear();
                                          selectedTimeZone.add('Today');
                                          setState(() {});
                                        }
                                      },
                                      child: buildContainerWithoutImage(
                                          color: ColorsUtils.accent,
                                          text: 'Cancel'.tr),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  void exportBottomSheet(BuildContext hideDialogContext) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
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
                  Text(
                    'Download Options'.tr,
                    style: ThemeUtils.blackBold.copyWith(
                      fontSize: FontUtils.medLarge,
                    ),
                  ),
                  height30(),
                  Text(
                    'Format'.tr,
                    style: ThemeUtils.blackSemiBold.copyWith(
                      fontSize: FontUtils.medium,
                    ),
                  ),
                  Column(
                    children: [
                      // LabeledRadio(
                      //   label: 'PDF',
                      //   value: 1,
                      //   groupValue: isRadioSelected,
                      //   onChanged: (newValue) {
                      //     setState(() {
                      //       isRadioSelected = newValue;
                      //     });
                      //   },
                      // ),
                      // LabeledRadio(
                      //   label: 'CSV',
                      //   value: 2,
                      //   groupValue: isRadioSelected,
                      //   onChanged: (newValue) {
                      //     setState(() {
                      //       isRadioSelected = newValue;
                      //     });
                      //   },
                      // ),
                      LabeledRadio(
                        label: 'XLS',
                        value: 3,
                        groupValue: isRadioSelected,
                        onChanged: (newValue) {
                          print("New Valueee === $newValue");
                          setState(() {
                            isRadioSelected = newValue;
                          });
                        },
                      ),
                    ],
                  ),
                  height20(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          sendEmail = !sendEmail;
                          setState(() {});
                        },
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: ColorsUtils.black, width: 1),
                              borderRadius: BorderRadius.circular(5)),
                          child: sendEmail == true
                              ? Center(
                                  child: Image.asset(Images.check,
                                      height: 10, width: 10))
                              : SizedBox(),
                        ),
                      ),
                      width20(),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Send Email to'.tr,
                              style: ThemeUtils.blackBold.copyWith(
                                fontSize: FontUtils.verySmall,
                              ),
                            ),
                            Text(
                              email,
                              style: ThemeUtils.blackRegular.copyWith(
                                fontSize: FontUtils.verySmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  height30(),
                  InkWell(
                    onTap: () async {
                      filterDate = selectedTimeZone.first.contains('Custom')
                          ? '&filter[date]=custom&filter[between]=["$customStartDate","$customEndDate"]&filter[is_active]=true'
                          : '&filter[date]=${selectedTimeZone.first.toLowerCase()}&filter[is_active]=true';
                      connectivityViewModel.startMonitoring();
                      if (connectivityViewModel.isOnline != null) {
                        if (connectivityViewModel.isOnline!) {
                          Get.back();
                          if (sendEmail == true) {
                            String token = await encryptedSharedPreferences
                                .getString('token');
                            final url = Uri.parse(
                              '${Utility.baseUrl}reporthistories/terminalBatch?$filterDate&filter[order]=created%20DESC&${isRadioSelected == 1 ? 'isPdf' : isRadioSelected == 2 ? 'isCsv' : 'isExcel'}=true&filter[isEmail]=true',
                              // '${Utility.baseUrl}${widget.isRadioSelected == 1 ? 'reporthistories/settlementReports' : 'reporthistories/transactionDetailsReport'}?filter[where][created][between][0]=${intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(widget.startDate!))}&filter[where][created][between][1]=${intl.DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.endDate!))} 23:59:59${widget.isRadioSelected == 1 ? Utility.activityReportSettlementWithdrawFilterType + Utility.activityReportSettlementPayoutFilterStatus + Utility.activityReportSettlementPayoutFilterBank + Utility.activityReportSettlementWithdrawFilterStatus + Utility.activityReportGetSubUSer : Utility.activityTransactionReportTransactionTypeFilter + Utility.activityTransactionReportTransactionSourceFilter + Utility.activityTransactionReportTransactionStatusFilter + Utility.activityTransactionReportPaymentMethodFilter + Utility.activityTransactionReportTransactionModeFilter + Utility.activityTransactionReportIntegrationTypeFilter}&filter[order]=created%20DESC&${isRadioSelected == 1 ? 'isPdf' : isRadioSelected == 2 ? 'isCsv' : 'isExcel'}=true&isEmail=true',
                            );
                            print("Send Email URL === $url");
                            final request = http.Request("GET", url);
                            request.headers.addAll(<String, String>{
                              'Authorization': token,
                              'Content-Type': 'application/json'
                            });
                            request.body = '';
                            final res = await request.send();
                            print("SendEmail Res == ${res.statusCode}");
                            if (res.statusCode == 200) {
                              Get.snackbar(
                                  'Success'.tr, 'send successFully'.tr);
                            } else {
                              print('error ::${res.request}');
                              Get.snackbar('error', '${res.request}');
                            }
                          } else {
                            print(
                                "Terminal Batch Report ${selectedTimeZone.contains('Custom') ? '${intl.DateFormat("dd MMM yyyy").format(DateTime.parse(customStartDate))} - ${intl.DateFormat("dd MMM yyyy").format(DateTime.parse(customEndDate))}' : _reportDate != '' ? _reportDate : '${DateTime.now().microsecondsSinceEpoch}'} ${DateTime.now().microsecondsSinceEpoch}");
                            await downloadFile(
                              isEmail: sendEmail,
                              name:
                                  'Terminal Batch Report ${selectedTimeZone.contains('Custom') ? '${intl.DateFormat("dd MMM yyyy").format(DateTime.parse(customStartDate))} - ${intl.DateFormat("dd MMM yyyy").format(DateTime.parse(customEndDate))}' : _reportDate != '' ? _reportDate : _reportDate} ${DateTime.now().microsecondsSinceEpoch}',
                              isRadioSelected: isRadioSelected,
                              url:
                                  '${Utility.baseUrl}reporthistories/terminalBatch?$filterDate&filter[order]=created%20DESC&${isRadioSelected == 1 ? 'isPdf' : isRadioSelected == 2 ? 'isCsv' : 'isExcel'}=true',
                              context: hideDialogContext,
                            );
                          }
                        } else {
                          Get.snackbar('error', 'Please check connection');
                        }
                      } else {
                        Get.snackbar('error', 'Please check connection');
                      }
                    },
                    child: commonButtonBox(
                        color: ColorsUtils.accent,
                        text: 'DownLoad'.tr,
                        img: Images.download),
                  ),
                  height30(),
                ],
              ),
            );
          });
        },
        backgroundColor: ColorsUtils.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))));
  }

  initData() async {
    batchSummeryViewModel.clearResponseList();
    // _range =
    //     '${intl.DateFormat("dd MMM’ yy, 00:00:00").format(DateTime.now())} - ${intl.DateFormat("dd MMM’ yy, 23:59:59").format(DateTime.now())}';
    await apiCall();
    print('filter Date is $filterDate');
    // scrollApiData();

    if (isPageFirst == true) {
      isPageFirst = false;
      setState(() {});
    }
  }

  // scrollApiData() {
  //   print('SCROLL CONTROLLER CALL==========');
  //
  //   _scrollController = ScrollController()
  //     ..addListener(() {
  //       if (_scrollController!.position.maxScrollExtent ==
  //               _scrollController!.offset &&
  //           !batchSummeryViewModel.isPaginationLoading) {
  //         filterDate = selectedTimeZone.first.contains('Custom')
  //             ? '&filter[date]=custom&filter[between]=["$customStartDate","$customEndDate"]'
  //             : '&filter[date]=${selectedTimeZone.first.toLowerCase()}';
  //         print('hiiii');
  //         batchSummeryViewModel.batchSummeryList(
  //             filter: filterDate + '&filter[is_active]=true', isLoading: false);
  //       }
  //     });
  // }

  apiCall() async {
    ///api calling.......

    print('page1 ');
    filterDate = selectedTimeZone.first.contains('Custom')
        ? (customStartDate == '' && customEndDate == '')
            ? '?filter[date]=today'
            : '?filter[date]=custom&filter[between]=["$customStartDate","$customEndDate"]'
        : '?filter[date]=${selectedTimeZone.first.toLowerCase()}';
    await batchSummeryViewModel.batchSummeryList(
        filter: filterDate + '&filter[is_active]=true', isLoading: true);
    setState(() {});
  }
}
