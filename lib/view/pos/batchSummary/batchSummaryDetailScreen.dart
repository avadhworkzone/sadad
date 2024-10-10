// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/controller/controller.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/BatchSummary/TerminalBatchSummeryResModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/staticData.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/downloadFile.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:sadad_merchat_app/viewModel/pos/batch%20Summary/batchSummeryViewModel.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:http/http.dart' as http;

enum PaymentMethodType { sales, refunds, preauth }

class BatchSummaryDetailScreen extends StatefulWidget {
  const BatchSummaryDetailScreen(
      {Key? key,
      required this.terminalId,
      required this.terminalName,
      required this.serialNo,
      required this.selectedTimeZone,
      required this.customEndDate,
      required this.customStartDate,
      required this.activatedDate})
      : super(key: key);
  final String terminalId;
  final String terminalName;
  final String serialNo;
  final String selectedTimeZone;
  final String customEndDate;
  final String customStartDate;
  final String activatedDate;

  @override
  State<BatchSummaryDetailScreen> createState() =>
      _BatchSummaryDetailScreenState();
}

class _BatchSummaryDetailScreenState extends State<BatchSummaryDetailScreen> {
  BatchSummeryViewModel batchSummeryViewModel = Get.find();
  DashboardController dashboardController = Get.find();
  List<String> selectedTimeZone = [];
  List<TerminalBatchSummaryResModel>? batchSummaryRes;
  final now = DateTime.now();
  String filterDate = '';
  String filter = '';
  String _range = '';
  String _reportRange = '';
  String customRange = '';
  String endDate = '';
  String startDate = '';
  String startTime = '00:00:00';
  String startAmTime = '12:00 AM';
  String endTime = '23:59:00';
  String endAmTime = '11:59 PM';
  int differenceDays = 0;
  int selectedMode = 0;
  DateTime? singleDate;
  bool timePick = false;
  bool customTimePick = false;
  Map<String, dynamic> mapData = {};
  int isRadioSelected = 3;
  bool sendEmail = false;
  String email = '';
  double totalAmtSales = 0.0;
  double totalAmtRefunds = 0.0;
  double totalAmtPreAuth = 0.0;
  int totalCntSales = 0;
  int totalCntRefunds = 0;
  int totalCntPreAuth = 0;
  ConnectivityViewModel connectivityViewModel = Get.find();
  DateTime activatedDate = DateTime(2015);

  @override
  void initState() {
    print("Activatedd ==== ${widget.activatedDate}");
    activatedDate = DateTime.parse(widget.activatedDate != ''
        ? widget.activatedDate
        : '2015-01-01 00:00:00');
    print("activated Date -- ${activatedDate}");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      selectedTimeZone.clear();
      selectedTimeZone.add(widget.selectedTimeZone);
      print("widget.customStartDate === ${widget.customStartDate}");
      print("widget.customEndDate === ${widget.customEndDate}");
      if (selectedTimeZone.contains('Today')) {
        singleDate = DateTime.now();
        _range =
            '${intl.DateFormat("dd MMM’ yy 00:00:00").format(DateTime.now())} - ${intl.DateFormat("dd MMM’ yy 23:59:59").format(DateTime.now())}';
        _reportRange =
            '${intl.DateFormat("dd MMM yyyy").format(DateTime.now())} - ${intl.DateFormat("dd MMM yyyy").format(DateTime.now())}';
      } else if (selectedTimeZone.contains('Yesterday')) {
        singleDate = DateTime(now.year, now.month, now.day - 1);
        _range =
            //'${intl.DateFormat("dd MMM’ yy 00:00:00").format(DateTime(now.year, now.month, now.day - 1))} - ${intl.DateFormat("dd MMM’ yy 23:59:59").format(DateTime.now())}';
            '${intl.DateFormat("dd MMM’ yy, 00:00:00").format(DateTime(now.year, now.month, now.day - 1))} - ${intl.DateFormat("dd MMM’ yy, 23:59:59").format(DateTime(now.year, now.month, now.day - 1))}';
        _reportRange =
            '${intl.DateFormat("dd MMM yyyy").format(DateTime(now.year, now.month, now.day - 1))} - ${intl.DateFormat("dd MMM yyyy").format(DateTime(now.year, now.month, now.day - 1))}';
      } else if (selectedTimeZone.contains('Week')) {
        singleDate = DateTime(now.year, now.month, now.day - 6);
        _range =
            '${intl.DateFormat("dd MMM’ yy 00:00:00").format(DateTime(now.year, now.month, now.day - 6))} - ${intl.DateFormat("dd MMM’ yy 23:59:59").format(DateTime.now())}';
        _reportRange =
            '${intl.DateFormat("dd MMM yyyy").format(DateTime(now.year, now.month, now.day - 6))} - ${intl.DateFormat("dd MMM yyyy").format(DateTime.now())}';
      } else if (selectedTimeZone.contains('Month')) {
        singleDate = DateTime(now.year, now.month - 1, now.day);
        _range =
            '${intl.DateFormat("dd MMM’ yy 00:00:00").format(DateTime(now.year, now.month - 1, now.day))} - ${intl.DateFormat("dd MMM’ yy 23:59:59").format(DateTime.now())}';
        _reportRange =
            '${intl.DateFormat("dd MMM yyyy").format(DateTime(now.year, now.month - 1, now.day))} - ${intl.DateFormat("dd MMM yyyy").format(DateTime.now())}';
      } else if (selectedTimeZone.contains('Year')) {
        _range =
            '${intl.DateFormat("dd MMM’ yy 00:00:00").format(DateTime(now.year - 1, now.month, now.day))} - - ${intl.DateFormat("dd MMM’ yy 23:59:59").format(DateTime.now())}';
        _reportRange =
            '${intl.DateFormat("dd MMM yyyy").format(DateTime(now.year - 1, now.month, now.day))} - - ${intl.DateFormat("dd MMM yyyy").format(DateTime.now())}';
      } else {
        _range = '';
        _reportRange = '';
      }
      // _range =
      //     '${intl.DateFormat("dd MMM’ yy 00:00:00").format(DateTime.now())} - ${intl.DateFormat("dd MMM’ yy 23:59:59").format(DateTime.now())}';

      if (widget.customStartDate != '' && widget.customEndDate != '') {
        customRange =
            '${intl.DateFormat('dd MMM’ yy 00:00:00').format(DateTime.parse(widget.customStartDate))} -'
            ' ${intl.DateFormat('dd MMM’ yy 23:59:59').format(DateTime.parse(widget.customEndDate))}';
        startDate = intl.DateFormat('yyyy-MM-dd HH:mm:ss')
            .format(DateTime.parse(widget.customStartDate));
        endDate = intl.DateFormat('yyyy-MM-dd 23:59:59')
            .format(DateTime.parse(widget.customEndDate));
        filterDate =
            '&filter[date]=custom&filter[between]=["$startDate","$endDate"]';
      }

      print("customRange ----- $customRange");
      print("selectedTimeZone ----- ${selectedTimeZone.first}");
      batchSummeryViewModel.setInit();
      initData();
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: bottomNavBar(),
        body: Column(
          children: [height60(), topView(), bottomView()],
        ));
  }

  // void bottomBarCalculation() {
  //   setState(() {});
  // }

  Column bottomNavBar() {
    totalAmtSales = 0.0;
    totalAmtRefunds = 0.0;
    totalAmtPreAuth = 0.0;
    totalCntSales = 0;
    totalCntRefunds = 0;
    totalCntPreAuth = 0;
    mapData.forEach((key, value) {
      totalAmtSales += double.parse(
          value[PaymentMethodType.sales.name]['amount'].toString());
      totalAmtRefunds += double.parse(
          value[PaymentMethodType.refunds.name]['amount'].toString());
      totalAmtPreAuth += double.parse(
          value[PaymentMethodType.preauth.name]['amount'].toString());
      totalCntSales +=
          int.parse(value[PaymentMethodType.sales.name]['count'].toString());
      totalCntRefunds +=
          int.parse(value[PaymentMethodType.refunds.name]['count'].toString());
      totalCntPreAuth +=
          int.parse(value[PaymentMethodType.preauth.name]['count'].toString());
    });
    // Future.delayed(Duration(seconds: 1), () {
    //   setState(() {});
    // });
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Padding(
        //   padding: const EdgeInsets.only(bottom: 30, right: 10, left: 10),
        //   child: Row(
        //     children: [
        //       Expanded(
        //         child: Container(
        //           padding: EdgeInsets.all(5),
        //           decoration: BoxDecoration(
        //               color: ColorsUtils.primary,
        //               borderRadius: BorderRadius.circular(10)),
        //           child: Column(
        //             children: [
        //               customSmallNorText(
        //                   color: ColorsUtils.white, title: 'Sales'),
        //               height5(),
        //               Row(
        //                 children: [
        //                   customVerySmallNorText(
        //                       color: ColorsUtils.white, title: 'Total : '),
        //                   selectedMode == 0
        //                       ? Expanded(
        //                           child: currencyText(
        //                               //totalAmtSales ?? 0.0,
        //                               1101210.12,
        //                               ThemeUtils.whiteSemiBold,
        //                               ThemeUtils.whiteRegular
        //                                   .copyWith(fontSize: 8)),
        //                         )
        //                       : Expanded(
        //                           child: Center(
        //                             child: Text(
        //                               '${totalCntSales ?? 0}',
        //                               overflow: TextOverflow.ellipsis,
        //                               style: ThemeUtils.whiteSemiBold
        //                                   .copyWith(height: 0.9),
        //                             ),
        //                           ),
        //                         ),
        //                 ],
        //               )
        //             ],
        //           ),
        //         ),
        //       ),
        //       width5(),
        //       Expanded(
        //         child: Container(
        //           padding: EdgeInsets.all(5),
        //           decoration: BoxDecoration(
        //               color: ColorsUtils.primary,
        //               borderRadius: BorderRadius.circular(10)),
        //           child: Column(
        //             children: [
        //               customSmallNorText(
        //                   color: ColorsUtils.white, title: 'Refunds'),
        //               height5(),
        //               Row(
        //                 children: [
        //                   customVerySmallNorText(
        //                       color: ColorsUtils.white, title: 'Total : '),
        //                   selectedMode == 0
        //                       ? Expanded(
        //                           child: currencyText(
        //                               totalAmtRefunds ?? 0.0,
        //                               //4565634631514545456454.325,
        //                               ThemeUtils.whiteSemiBold,
        //                               ThemeUtils.whiteRegular
        //                                   .copyWith(fontSize: 8)),
        //                         )
        //                       : Expanded(
        //                           child: Center(
        //                             child: Text(
        //                               '${totalCntRefunds ?? 0}',
        //                               overflow: TextOverflow.ellipsis,
        //                               style: ThemeUtils.whiteSemiBold
        //                                   .copyWith(height: 0.9),
        //                             ),
        //                           ),
        //                         ),
        //                 ],
        //               )
        //             ],
        //           ),
        //         ),
        //       ),
        //       width5(),
        //       Expanded(
        //         child: Container(
        //           padding: EdgeInsets.all(5),
        //           decoration: BoxDecoration(
        //               color: ColorsUtils.primary,
        //               borderRadius: BorderRadius.circular(10)),
        //           child: Column(
        //             children: [
        //               customSmallNorText(
        //                   color: ColorsUtils.white, title: 'PreAuth'),
        //               height5(),
        //               Row(
        //                 children: [
        //                   customVerySmallNorText(
        //                       color: ColorsUtils.white, title: 'Total : '),
        //                   selectedMode == 0
        //                       ? Expanded(
        //                           child: currencyText(
        //                               totalAmtPreAuth ?? 0.0,
        //                               //4565634631514545456454.325,
        //                               ThemeUtils.whiteSemiBold,
        //                               ThemeUtils.whiteRegular
        //                                   .copyWith(fontSize: 8)),
        //                         )
        //                       : Expanded(
        //                           child: Center(
        //                             child: Text(
        //                               '${totalCntPreAuth ?? 0}',
        //                               overflow: TextOverflow.ellipsis,
        //                               style: ThemeUtils.whiteSemiBold
        //                                   .copyWith(height: 0.9),
        //                             ),
        //                           ),
        //                         ),
        //                 ],
        //               )
        //             ],
        //           ),
        //         ),
        //       )
        //     ],
        //   ),
        // )
        Padding(
          padding: const EdgeInsets.only(bottom: 30, right: 10, left: 10),
          child: Container(
            decoration: BoxDecoration(
              color: ColorsUtils.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  customSmallNorText(
                      color: ColorsUtils.white, title: 'Total'.tr),
                  width2(),
                  selectedMode == 0
                      ? totalCurrencyText(totalAmount: totalAmtSales)
                      : Expanded(
                          child: Center(
                            child: Text(
                              '${totalCntSales ?? 0}',
                              overflow: TextOverflow.ellipsis,
                              style: ThemeUtils.whiteSemiBold
                                  .copyWith(height: 0.9),
                            ),
                          ),
                        ),
                  width2(),
                  Container(
                    height: 30,
                    width: 1,
                    decoration: BoxDecoration(color: ColorsUtils.white),
                  ),
                  width2(),
                  selectedMode == 0
                      ? totalCurrencyText(totalAmount: totalAmtRefunds)
                      // Flexible(
                      //         child: currencyText(
                      //             totalAmtRefunds ?? 0.0,
                      //             ThemeUtils.whiteSemiBold,
                      //             ThemeUtils.whiteRegular.copyWith(fontSize: 8)),
                      //       )
                      : Expanded(
                          child: Center(
                            child: Text(
                              '${totalCntRefunds ?? 0}',
                              overflow: TextOverflow.ellipsis,
                              style: ThemeUtils.whiteSemiBold
                                  .copyWith(height: 0.9),
                            ),
                          ),
                        ),
                  width2(),
                  Container(
                    height: 30,
                    width: 1,
                    decoration: BoxDecoration(color: ColorsUtils.white),
                  ),
                  width2(),
                  selectedMode == 0
                      ? totalCurrencyText(totalAmount: totalAmtPreAuth)
                      // Flexible(
                      //         child: currencyText(
                      //             totalAmtPreAuth ?? 0.0,
                      //             ThemeUtils.whiteSemiBold,
                      //             ThemeUtils.whiteRegular.copyWith(fontSize: 8)),
                      //       )
                      : Expanded(
                          child: Center(
                            child: Text(
                              '${totalCntPreAuth ?? 0}',
                              overflow: TextOverflow.ellipsis,
                              style: ThemeUtils.whiteSemiBold
                                  .copyWith(height: 0.9),
                            ),
                          ),
                        ),
                  width2(),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Flexible totalCurrencyText({required double totalAmount}) {
    return Flexible(
        child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            oCcy.format(totalAmount ?? 0.0),
            overflow: TextOverflow.ellipsis,
            style: ThemeUtils.whiteSemiBold.copyWith(height: 0.9),
          ),
        ),
        width5(),
        Container(
          // margin: const EdgeInsets.only(left: 4),
          child: Text(
            "QAR",
            style: ThemeUtils.whiteRegular.copyWith(height: 0.9, fontSize: 8),
          ),
        ),
      ],
    ));
  }

  Column topView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              Flexible(
                child: Center(
                  child: customMediumLargeBoldText(
                      title: "Batch Summery Detail".tr),
                ),
              ),
              InkWell(
                onTap: () {
                  if (batchSummaryRes!.first.paymentMethodData != null) {
                    batchSummaryRes!.first.paymentMethodData!.isEmpty ||
                            mapData.isEmpty
                        ? Get.snackbar(
                            'Note'.tr,
                            'No Data Found'.tr,
                          )
                        // Get.showSnackbar(GetSnackBar(
                        //         message: 'No Data Found'.tr,
                        //       ))
                        : exportBottomSheet();
                  }
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
        height20(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child:
                        customMediumBoldText(title: '${widget.terminalName}'),
                  ),
                  height10(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: customSmallNorText(
                        title: '${'Terminal ID:'.tr} ${widget.terminalId}'),
                  ),
                  height10(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: customSmallNorText(
                        title:
                            '${'Device Serial Number :'.tr} ${widget.serialNo}'),
                  ),
                ],
              ),
            ),
          ],
        ),
        height10(),
        Container(
          height: 1,
          width: Get.width,
          decoration: BoxDecoration(color: ColorsUtils.border),
        ),
        height10(),
      ],
    );
  }

  bottomView() {
    return Expanded(
      child: Column(
        children: [
          ///terminal details
          timePick == true
              ? SizedBox()
              : Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                          child: GestureDetector(
                        onTap: () {
                          if (selectedTimeZone.contains('Today')) {
                            setState(() {
                              timePick = !timePick;
                            });
                          }
                        },
                        child: customSmallNorText(
                            title: customRange != '' ? customRange : _range,
                            color: ColorsUtils.grey),
                      )),
                      width10(),
                      selectedTimeZone.contains('Custom')
                          ? SizedBox()
                          : selectedTimeZone.contains('Today') &&
                                  batchSummaryRes != null
                              ? InkWell(
                                  onTap: () async {
                                    setState(() {
                                      timePick = !timePick;
                                    });
                                  },
                                  child: Icon(
                                    Icons.access_time_outlined,
                                    color: ColorsUtils.primary,
                                  ),
                                )
                              : SizedBox()
                    ],
                  ),
                ),
          height10(),

          ///bottom date selection
          timePick != true
              ? SizedBox()
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: ColorsUtils.grey.withOpacity(0.3),
                              width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 20),
                          child: Column(
                            children: [
                              height10(),
                              Align(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                    onTap: () {
                                      timePick = false;
                                      setState(() {});
                                    },
                                    child: Icon(
                                      Icons.close,
                                      size: 20,
                                      color: ColorsUtils.grey,
                                    )),
                              ),
                              height10(),
                              InkWell(
                                onTap: () async {
                                  await _selectSingleDate(context);
                                },
                                child: Container(
                                  height: Get.height * 0.07,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        color: ColorsUtils.border, width: 1),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            textDirection: TextDirection.ltr,
                                            _range,
                                            style: ThemeUtils.blackSemiBold
                                                .copyWith(
                                              fontSize: FontUtils.verySmall,
                                              color: ColorsUtils.grey,
                                            ),
                                          ),
                                        ),
                                        Image.asset(
                                          Images.calender,
                                          color: ColorsUtils.primary,
                                          height: 20,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              height20(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ///from
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        TimeOfDay? pickedTime =
                                            await showTimePicker(
                                          initialTime: TimeOfDay.now(),
                                          builder: (context, Widget? child) {
                                            return MediaQuery(
                                              data: MediaQuery.of(context)
                                                  .copyWith(
                                                      alwaysUse24HourFormat:
                                                          false),
                                              child: child!,
                                            );
                                          },
                                          context:
                                              context, //context of current state
                                        );

                                        if (pickedTime != null) {
                                          MaterialLocalizations localizations =
                                              MaterialLocalizations.of(context);

                                          startAmTime = localizations
                                              .formatTimeOfDay(pickedTime,
                                                  alwaysUse24HourFormat: false);
                                          print(pickedTime.format(context));
                                          DateTime parsedTime =
                                              intl.DateFormat.jm()
                                                  .parse(startAmTime);
                                          String formattedTime =
                                              intl.DateFormat('HH:mm:ss')
                                                  .format(parsedTime);
                                          String formattedAmTime =
                                              intl.DateFormat('h:mm a')
                                                  .format(parsedTime);
                                          print(formattedTime);
                                          print(
                                              "Parsed Time === $formattedTime");
                                          startTime = formattedTime;
                                          //startAmTime = formattedAmTime;
                                          print("start Am Time===$startAmTime");
                                          print("start Time===$startTime");
                                          setState(() {});
                                        } else {
                                          print("Time is not selected");
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: ColorsUtils.grey
                                                  .withOpacity(0.3),
                                              width: 1),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            children: [
                                              customSmallNorText(
                                                  color: ColorsUtils.grey,
                                                  title: 'From'.tr),
                                              height5(),
                                              customSmallBoldText(
                                                  title: startAmTime != ''
                                                      ? startAmTime
                                                      : '00:00',
                                                  color: ColorsUtils.primary),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  width10(),

                                  ///to
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        TimeOfDay? pickedTime =
                                            await showTimePicker(
                                          initialTime: TimeOfDay.now(),
                                          builder: (context, Widget? child) {
                                            return MediaQuery(
                                              data: MediaQuery.of(context)
                                                  .copyWith(
                                                      alwaysUse24HourFormat:
                                                          false),
                                              child: child!,
                                            );
                                          },
                                          context:
                                              context, //context of current state
                                        );

                                        if (pickedTime != null) {
                                          MaterialLocalizations localizations =
                                              MaterialLocalizations.of(context);

                                          endAmTime = localizations
                                              .formatTimeOfDay(pickedTime,
                                                  alwaysUse24HourFormat: false);
                                          print(pickedTime.format(context));
                                          // DateTime parsedTime =
                                          //     intl.DateFormat.jm().parse(
                                          //         pickedTime
                                          //             .format(context)
                                          //             .toString());
                                          DateTime parsedTime =
                                              intl.DateFormat.jm()
                                                  .parse(endAmTime);
                                          String formattedTime =
                                              intl.DateFormat('HH:mm:ss')
                                                  .format(parsedTime);
                                          print(formattedTime);
                                          String formattedAmTime =
                                              intl.DateFormat('h:mm a')
                                                  .format(parsedTime);
                                          endTime = formattedTime;
                                          //endAmTime = formattedAmTime;
                                          setState(() {});
                                        } else {
                                          print("Time is not selected");
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: ColorsUtils.grey
                                                  .withOpacity(0.3),
                                              width: 1),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            children: [
                                              customSmallNorText(
                                                  color: ColorsUtils.grey,
                                                  title: 'To'.tr),
                                              height5(),
                                              customSmallBoldText(
                                                  title: endAmTime != ''
                                                      ? endAmTime
                                                      : '00:00',
                                                  color: ColorsUtils.primary),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  width10(),

                                  ///apply
                                  InkWell(
                                    onTap: () {
                                      if (startTime == '' || endTime == '') {
                                        Get.snackbar(
                                            'error', 'select both Time');
                                      } else {
                                        if (double.parse(
                                                startTime.replaceAll(':', '')) >
                                            double.parse(
                                                endTime.replaceAll(':', ''))) {
                                          Get.snackbar('error',
                                              'Please check correct timezone');
                                        } else {
                                          filterDate =
                                              '&filter[date]=custom&filter[between]=["${intl.DateFormat("yyyy-MM-dd $startTime").format(singleDate ?? DateTime.now())}","${intl.DateFormat("yyyy-MM-dd $endTime").format(singleDate ?? DateTime.now())}"]';

                                          // filter =
                                          //     '&filter[date]=custom&filter[between]=["${intl.DateFormat("yyyy-MM-dd $startTime").format(singleDate ?? DateTime.now())}","${intl.DateFormat("yyyy-MM-dd $endTime").format(singleDate ?? DateTime.now())}"]';
                                          setState(() {});
                                          print('filter date==>$filter');

                                          ///start date
                                          startDate =
                                              '${intl.DateFormat("dd MMM’ yy $startTime").format(singleDate ?? DateTime.now())}';
                                          String reportStartDate =
                                              '${intl.DateFormat("dd MMM yyyy $startTime").format(singleDate ?? DateTime.now())}';
                                          print(startDate);

                                          ///end date
                                          endDate =
                                              '${intl.DateFormat("dd MMM’ yy $endTime").format(singleDate ?? DateTime.now())}';
                                          String reportEndDate =
                                              '${intl.DateFormat("dd MMM yyyy $endTime").format(singleDate ?? DateTime.now())}';
                                          print(endDate);

                                          _range = '$startDate - $endDate';
                                          _reportRange =
                                              '$reportStartDate - $reportEndDate';
                                          timePick = false;
                                          customTimePick = true;
                                          initData();
                                        }
                                        setState(() {});
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: ColorsUtils.primary,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: ColorsUtils.grey
                                                .withOpacity(0.3),
                                            width: 1),
                                      ),
                                      child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: customMediumBoldText(
                                              title: 'Apply'.tr,
                                              color: ColorsUtils.white)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          height10(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  selectedMode = 0;
                  setState(() {});
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: ColorsUtils.grey.withOpacity(0.3), width: 1),
                      borderRadius: BorderRadius.circular(8),
                      color: selectedMode == 0
                          ? ColorsUtils.primary
                          : ColorsUtils.white),
                  child: Center(
                      child: customSmallSemiText(
                          title: 'Amount'.tr,
                          color: selectedMode == 0
                              ? ColorsUtils.white
                              : ColorsUtils.black)),
                ),
              ),
              width20(),
              InkWell(
                onTap: () {
                  selectedMode = 1;
                  setState(() {});
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: ColorsUtils.grey.withOpacity(0.3), width: 1),
                      borderRadius: BorderRadius.circular(8),
                      color: selectedMode == 1
                          ? ColorsUtils.primary
                          : ColorsUtils.white),
                  child: Center(
                      child: customSmallSemiText(
                          title: 'Count'.tr,
                          color: selectedMode == 1
                              ? ColorsUtils.white
                              : ColorsUtils.black)),
                ),
              ),
            ],
          ),
          height20(),
          Expanded(
            child: GetBuilder<BatchSummeryViewModel>(
              builder: (controller) {
                if (controller.batchSummeryDetailListApiResponse.status ==
                        Status.LOADING ||
                    controller.batchSummeryDetailListApiResponse.status ==
                        Status.INITIAL) {
                  return const Center(child: Loader());
                }

                if (controller.batchSummeryDetailListApiResponse.status ==
                    Status.ERROR) {
                  return const SessionExpire();
                  //return Text('something wrong');
                }
                batchSummaryRes =
                    controller.batchSummeryDetailListApiResponse.data;

                return batchSummaryRes!.first.paymentMethodData == null
                    ? noDataFound()
                    : batchSummaryRes!.first.paymentMethodData!.isEmpty ||
                            mapData.isEmpty
                        ? noDataFound()
                        : ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: mapData.keys.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color:
                                            ColorsUtils.grey.withOpacity(0.3),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset(
                                          StaticData().cardImage[mapData.keys
                                                  .toList()[index]] ??
                                              Images.mobilePay,
                                          height: 30,
                                          width: 30,
                                        ),
                                        Expanded(
                                          child: commonFormatForTransactionColumn(
                                              key: 'Sales'.tr,
                                              value: selectedMode == 0
                                                  ? mapData[mapData.keys.toList()[index]]
                                                          [PaymentMethodType
                                                              .sales
                                                              .name]['amount']
                                                      .toStringAsFixed(2)
                                                  : mapData[mapData.keys.toList()[index]]
                                                          [PaymentMethodType
                                                              .sales
                                                              .name]['count']
                                                      .toString()),
                                        ),
                                        Expanded(
                                          child: commonFormatForTransactionColumn(
                                              key: 'Refunds'.tr,
                                              value: selectedMode == 0
                                                  ? mapData[mapData.keys.toList()[index]]
                                                          [PaymentMethodType
                                                              .refunds
                                                              .name]['amount']
                                                      .toStringAsFixed(2)
                                                  : mapData[mapData.keys.toList()[index]]
                                                          [PaymentMethodType
                                                              .refunds
                                                              .name]['count']
                                                      .toString()),
                                        ),
                                        Expanded(
                                          child: commonFormatForTransactionColumn(
                                              key: 'PreAuth'.tr,
                                              value: selectedMode == 0
                                                  ? mapData[mapData.keys.toList()[index]]
                                                          [PaymentMethodType
                                                              .preauth
                                                              .name]['amount']
                                                      .toStringAsFixed(2)
                                                  : mapData[mapData.keys.toList()[index]]
                                                          [PaymentMethodType
                                                              .preauth
                                                              .name]['count']
                                                      .toString()),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
              },
            ),
          ),
        ],
      ),
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
                timePick = false;
                customTimePick = false;
                timePick = false;
                endTime = '23:59:00';
                startTime = '00:00:00';
                startAmTime = '12:00 AM';
                endAmTime = '11:59 PM';
                customRange = '';
                selectedTimeZone.clear();
                selectedTimeZone.add(StaticData().batchSummaryTimeZone[index]);
                print("Selected TimeZone === $selectedTimeZone");
                if (selectedTimeZone.contains('Custom')) {
                  startDate = '';
                  endDate = '';
                  await datePicker(context);
                } else {
                  if (selectedTimeZone.contains('Today')) {
                    singleDate = DateTime.now();
                    _range =
                        '${intl.DateFormat("dd MMM’ yy 00:00:00").format(DateTime.now())} - ${intl.DateFormat("dd MMM’ yy 23:59:59").format(DateTime.now())}';
                    _reportRange =
                        '${intl.DateFormat("dd MMM yyyy").format(DateTime.now())} - ${intl.DateFormat("dd MMM yyyy").format(DateTime.now())}';
                  } else if (selectedTimeZone.contains('Yesterday')) {
                    singleDate = DateTime(now.year, now.month, now.day - 1);
                    _range =
                        //'${intl.DateFormat("dd MMM’ yy 00:00:00").format(DateTime(now.year, now.month, now.day - 1))} - ${intl.DateFormat("dd MMM’ yy 23:59:59").format(DateTime.now())}';
                        '${intl.DateFormat("dd MMM’ yy, 00:00:00").format(DateTime(now.year, now.month, now.day - 1))} - ${intl.DateFormat("dd MMM’ yy, 23:59:59").format(DateTime(now.year, now.month, now.day - 1))}';
                    _reportRange =
                        '${intl.DateFormat("dd MMM yyyy").format(DateTime(now.year, now.month, now.day - 1))} - ${intl.DateFormat("dd MMM yyyy").format(DateTime(now.year, now.month, now.day - 1))}';
                  } else if (selectedTimeZone.contains('Week')) {
                    singleDate = DateTime(now.year, now.month, now.day - 6);
                    _range =
                        '${intl.DateFormat("dd MMM’ yy 00:00:00").format(DateTime(now.year, now.month, now.day - 6))} - ${intl.DateFormat("dd MMM’ yy 23:59:59").format(DateTime.now())}';
                    _reportRange =
                        '${intl.DateFormat("dd MMM yyyy").format(DateTime(now.year, now.month, now.day - 6))} - ${intl.DateFormat("dd MMM yyyy").format(DateTime.now())}';
                  } else if (selectedTimeZone.contains('Month')) {
                    singleDate = DateTime(now.year, now.month - 1, now.day);
                    _range =
                        '${intl.DateFormat("dd MMM’ yy 00:00:00").format(DateTime(now.year, now.month - 1, now.day))} - ${intl.DateFormat("dd MMM’ yy 23:59:59").format(DateTime.now())}';
                    _reportRange =
                        '${intl.DateFormat("dd MMM yyyy").format(DateTime(now.year, now.month - 1, now.day))} - ${intl.DateFormat("dd MMM yyyy").format(DateTime.now())}';
                  } else if (selectedTimeZone.contains('Year')) {
                    _range =
                        '${intl.DateFormat("dd MMM’ yy 00:00:00").format(DateTime(now.year - 1, now.month, now.day))} - - ${intl.DateFormat("dd MMM’ yy 23:59:59").format(DateTime.now())}';
                    _reportRange =
                        '${intl.DateFormat("dd MMM yyyy").format(DateTime(now.year - 1, now.month, now.day))} - - ${intl.DateFormat("dd MMM yyyy").format(DateTime.now())}';
                  } else {
                    _range = '';
                    _reportRange = '';
                  }

                  print('_range   $_range');
                  setState(() {});
                }
                initData();
                print('$selectedTimeZone');
                setState(() {});
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
                                // minDate: DateTime(activatedDate.year,
                                //     activatedDate.month, activatedDate.day),
                                minDate: DateTime(DateTime.now().year - 1,
                                    DateTime.now().month, DateTime.now().day),

                                onSelectionChanged:
                                    (dateRangePickerSelectionChangedArgs) {
                                  if (dateRangePickerSelectionChangedArgs
                                              .value.endDate ==
                                          null ||
                                      dateRangePickerSelectionChangedArgs
                                              .value.endDate ==
                                          '') {
                                    endDate = '';
                                    customRange = '';
                                  } else {
                                    if (dateRangePickerSelectionChangedArgs
                                        .value is PickerDateRange) {
                                      customRange =
                                          '${intl.DateFormat('dd MMM’ yy 00:00:00').format(dateRangePickerSelectionChangedArgs.value.startDate)} -'
                                          ' ${intl.DateFormat('dd MMM’ yy 23:59:59').format(dateRangePickerSelectionChangedArgs.value.endDate)}';
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
                                    startDate = '';
                                    endDate = '';
                                    customRange = '';
                                  } else {
                                    startDate = intl.DateFormat(
                                            'yyyy-MM-dd HH:mm:ss')
                                        .format(DateTime.parse(
                                            '${dateRangePickerSelectionChangedArgs.value.startDate}'));

                                    dateRangePickerSelectionChangedArgs
                                                    .value.endDate ==
                                                null ||
                                            dateRangePickerSelectionChangedArgs
                                                    .value.endDate ==
                                                ''
                                        ? ''
                                        : endDate = intl.DateFormat(
                                                'yyyy-MM-dd 23:59:59')
                                            .format(DateTime.parse(
                                                '${dateRangePickerSelectionChangedArgs.value.endDate}'));
                                  }

                                  setDialogState(() {});
                                },
                                selectionMode:
                                    DateRangePickerSelectionMode.range,
                                maxDate: DateTime.now(),
                                initialSelectedRange: PickerDateRange(
                                    startDate == ''
                                        ? DateTime.now()
                                            .subtract(const Duration(days: 7))
                                        : DateTime.parse(startDate),
                                    endDate == ''
                                        ? DateTime.now()
                                        : DateTime.parse(endDate)),
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
                                        customRange,
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
                                        filterDate =
                                            '&filter[date]=custom&filter[between]=["$startDate","$endDate"]';
                                        setState(() {});
                                        if (startDate == '' || endDate == '') {
                                          Get.snackbar('error'.tr,
                                              'Please select correct date'.tr);
                                        } else {
                                          batchSummeryViewModel.setInit();
                                          initData();
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
                                        if (customRange == '') {
                                          selectedTimeZone.clear();
                                          selectedTimeZone.add('Today');
                                          setState(() {});
                                        }
                                        // startDate = '';
                                        // endDate = '';
                                        // setState(() {});
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

  Column commonFormatForTransactionColumn({String? key, String? value}) {
    return Column(
      children: [
        customVerySmallNorText(title: key, color: ColorsUtils.grey),
        //customMediumSemiText(title: value)
        customSmallSemiText(title: value)
      ],
    );
  }

  void exportBottomSheet() {
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
                      //       print('hi');
                      //       isRadioSelected = newValue;
                      //     });
                      //   },
                      // ),
                      LabeledRadio(
                        label: 'XLS',
                        value: 3,
                        groupValue: isRadioSelected,
                        onChanged: (newValue) {
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
                      filter = selectedTimeZone.first.contains('Custom') ||
                              customTimePick == true
                          ? '?filter[terminalId]=${widget.terminalId}$filterDate'
                          : '?filter[terminalId]=${widget.terminalId}&filter[date]=${selectedTimeZone.first.toLowerCase()}';
                      connectivityViewModel.startMonitoring();
                      if (connectivityViewModel.isOnline != null) {
                        print("isOnline condition true==== ");
                        if (connectivityViewModel.isOnline!) {
                          if (sendEmail == true) {
                            String token = await encryptedSharedPreferences
                                .getString('token');

                            final url = Uri.parse(
                              '${Utility.baseUrl}reporthistories/terminalBatch$filter&filter[order]=created%20DESC&${isRadioSelected == 1 ? 'isPdf' : isRadioSelected == 2 ? 'isCsv' : 'isExcel'}=true&isEmail=true',
                              // '${Utility.baseUrl}${widget.isRadioSelected == 1 ? 'reporthistories/settlementReports' : 'reporthistories/transactionDetailsReport'}?filter[where][created][between][0]=${intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(widget.startDate!))}&filter[where][created][between][1]=${intl.DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.endDate!))} 23:59:59${widget.isRadioSelected == 1 ? Utility.activityReportSettlementWithdrawFilterType + Utility.activityReportSettlementPayoutFilterStatus + Utility.activityReportSettlementPayoutFilterBank + Utility.activityReportSettlementWithdrawFilterStatus + Utility.activityReportGetSubUSer : Utility.activityTransactionReportTransactionTypeFilter + Utility.activityTransactionReportTransactionSourceFilter + Utility.activityTransactionReportTransactionStatusFilter + Utility.activityTransactionReportPaymentMethodFilter + Utility.activityTransactionReportTransactionModeFilter + Utility.activityTransactionReportIntegrationTypeFilter}&filter[order]=created%20DESC&${isRadioSelected == 1 ? 'isPdf' : isRadioSelected == 2 ? 'isCsv' : 'isExcel'}=true&isEmail=true',
                            );
                            final request = http.Request("GET", url);
                            request.headers.addAll(<String, String>{
                              'Authorization': token,
                              'Content-Type': 'application/json'
                            });
                            request.body = '';
                            final res = await request.send();
                            if (res.statusCode == 200) {
                              Get.snackbar(
                                  'Success'.tr, 'send successFully'.tr);
                            } else {
                              print('error ::${res.request}');
                              Get.snackbar('error', '${res.request}');
                            }
                          } else {
                            print(
                                "Terminal Batch Report ${selectedTimeZone.contains('Custom') ? '${intl.DateFormat("dd MMM yyyy").format(DateTime.parse(startDate))} - ${intl.DateFormat("dd MMM yyyy").format(DateTime.parse(endDate))}' : _reportRange != '' ? _reportRange : _range}");
                            await downloadFile(
                              name:
                                  '${widget.terminalId} Terminal Batch Report ${selectedTimeZone.contains('Custom') ? '${intl.DateFormat("dd MMM yyyy").format(DateTime.parse(startDate))} - ${intl.DateFormat("dd MMM yyyy").format(DateTime.parse(endDate))}' : _reportRange != '' ? _reportRange : _range}  ${DateTime.now().microsecondsSinceEpoch}',
                              isEmail: sendEmail,
                              isRadioSelected: isRadioSelected,
                              url:
                                  '${Utility.baseUrl}reporthistories/terminalBatch$filter&filter[order]=created%20DESC&${isRadioSelected == 1 ? 'isPdf' : isRadioSelected == 2 ? 'isCsv' : 'isExcel'}=true',
                              context: context,
                            );
                          }
                        } else {
                          Get.snackbar('error', 'Please check connection');
                        }
                      } else {
                        print("isOnline condition false==== ");
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

  _selectSingleDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: singleDate ?? DateTime.now(),
      firstDate:
          // DateTime(activatedDate.year, activatedDate.month, activatedDate.day),
          DateTime(2015, 01, 01),
      lastDate: DateTime.now(),
    );
    if (selected != null && selected != singleDate)
      setState(() {
        //${intl.DateFormat("dd MMM’ yy 00:00:00").format(DateTime.now())} - ${intl.DateFormat("dd MMM’ yy 23:59:59").format(DateTime.now())}
        singleDate = selected;
        filterDate =
            '&filter[date]=custom&filter[between]=["${intl.DateFormat("yyyy-MM-dd 00:00:00").format(singleDate ?? DateTime.now())}","${intl.DateFormat("yyyy-MM-dd 23:59:59").format(singleDate ?? DateTime.now())}"]';
        startDate = intl.DateFormat('yyyy-MM-dd 00:00:00')
            .format(DateTime.parse('${selected}'));
        endDate = intl.DateFormat('yyyy-MM-dd 23:59:59')
            .format(DateTime.parse('${selected}'));
        String formattedStartDate = intl.DateFormat('dd MMM’ yy 00:00:00')
            .format(DateTime.parse('${selected}'));
        String formattedEndDate = intl.DateFormat('dd MMM’ yy 23:59:59')
            .format(DateTime.parse('${selected}'));
        String reportStartDate = intl.DateFormat('dd MMM yyyy')
            .format(DateTime.parse('${selected}'));
        String reportEndDate = intl.DateFormat('dd MMM yyyy')
            .format(DateTime.parse('${selected}'));
        _range = '$formattedStartDate - $formattedEndDate';
        _reportRange = '$reportStartDate - $reportEndDate';
        timePick = false;
        customTimePick = true;
        // ignore: avoid_print
        print(singleDate);
      });
    initData();
  }

  initData() async {
    batchSummeryViewModel.clearResponseList();

    await apiCall();
    print('filter Date is $filterDate');
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
  //             filter: filterDate, isLoading: false);
  //       }
  //     });
  // }

  apiCall() async {
    ///api calling.......
    print('api call filter Date is $filterDate');
    print('page1');
    String filter = '';
    filter = selectedTimeZone.first.contains('Custom') || customTimePick == true
        ? '?filter[terminalId]=${widget.terminalId}$filterDate'
        : '?filter[terminalId]=${widget.terminalId}&filter[date]=${selectedTimeZone.first.toLowerCase()}';
    await batchSummeryViewModel.batchSummeryDetailList(
        filter: filter, isLoading: true);
    if (batchSummeryViewModel.batchSummeryDetailListApiResponse.status ==
        Status.COMPLETE) {
      batchSummaryRes =
          batchSummeryViewModel.batchSummeryDetailListApiResponse.data;
      //print("is Data === $isData");
      // if (batchSummaryRes!.first.paymentMethodData != null) {
      //   if (batchSummaryRes!.first.paymentMethodData!.isEmpty ||
      //       mapData.isEmpty) {
      //     setState(() {
      //       isData = false;
      //     });
      //     print("is Data is Empty === $isData");
      //   } else {
      //     setState(() {
      //       isData = true;
      //     });
      //     print("is Data is Not Empty=== $isData");
      //   }
      // }
      mapData = {};
      // Map<String, dynamic> refaundMapData = {};
      // Map<String, dynamic> preAuthMapData = {};

      if (batchSummaryRes!.first.paymentMethodData != null) {
        batchSummaryRes!.first.paymentMethodData!.forEach((e1) {
          if (e1.sales is List) {
            (e1.sales as List).forEach((e2) {
              print('SALES MAP :=>$e2');
              if (!mapData.containsKey(e2.keys.first)) {
                mapData.addAll({
                  e2.keys.first: {PaymentMethodType.sales.name: e2.values.first}
                });
              }
            });
            // print(
            //     'SALES MAP :=>${(element.sales as List).map((e) => e.keys.toList()).toList()}');
          }
          if (e1.refunds is List) {
            (e1.refunds as List).forEach((e2) {
              print('REFAUND MAP :=>$e2');
              if (mapData.containsKey(e2.keys.first)) {
                mapData[e2.keys.first]
                    .addAll({PaymentMethodType.refunds.name: e2.values.first});
              } else {
                mapData.addAll({
                  e2.keys.first: {
                    PaymentMethodType.refunds.name: e2.values.first
                  }
                });
              }
            });
          }
          if (e1.preauth is List) {
            (e1.preauth as List).forEach((e2) {
              print('preauth MAP :=>$e2');
              if (mapData.containsKey(e2.keys.first)) {
                mapData[e2.keys.first]
                    .addAll({PaymentMethodType.preauth.name: e2.values.first});
              } else {
                mapData.addAll({
                  e2.keys.first: {
                    PaymentMethodType.preauth.name: e2.values.first
                  }
                });
              }
            });
          }
        });
      }
    }
    setState(() {});
  }
}
