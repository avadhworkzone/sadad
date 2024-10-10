// ignore_for_file: unnecessary_string_interpolations, prefer_interpolation_to_compose_strings

import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/report/reportListResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/downloadFile.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/pos/report/posReportFilterScreen.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:sadad_merchat_app/viewModel/pos/report/posReportListViewModel.dart';
import 'package:http/http.dart' as http;

class PosReportDetailScreen extends StatefulWidget {
  String? startDate;
  String? endDate;
  String? selectedType;
  PosReportDetailScreen(
      {Key? key, this.startDate, this.endDate, this.selectedType})
      : super(key: key);

  @override
  State<PosReportDetailScreen> createState() => _PosReportDetailScreenState();
}

class _PosReportDetailScreenState extends State<PosReportDetailScreen> {
  PosReportDetailViewModel reportDetailViewModel = Get.find();
  PosReportTransactionListResponseModel? reportDetailResponseModel;
  ScrollController? _scrollController;
  int isRadioSelected = 0;
  bool sendEmail = false;
  String email = '';
  int type = 0;
  bool isPageFirst = false;
  EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences();
  ConnectivityViewModel connectivityViewModel = Get.find();

  @override
  void initState() {
    connectivityViewModel.startMonitoring();
    reportDetailViewModel.setReportInit();
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (connectivityViewModel.isOnline != null) {
      if (connectivityViewModel.isOnline!) {
        return type == 1
            ? Scaffold(body: GetBuilder<PosReportDetailViewModel>(
                builder: (controller) {
                  if (controller.posTransactionReportApiResponse.status ==
                      Status.LOADING) {
                    print('Loading');
                    return const Center(child: Loader());
                  }

                  if (controller.posTransactionReportApiResponse.status ==
                      Status.ERROR) {
                    return const SessionExpire();
                    // return const Text('Error');
                  }
                  reportDetailResponseModel = reportDetailViewModel
                      .posTransactionReportApiResponse.data;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      height60(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
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
                            Image.asset(
                              Images.search,
                              height: 20,
                            ),
                            width20(),
                            InkWell(
                              onTap: () async {
                                await Get.to(() => PosReportFilterScreen());
                                initData();
                              },
                              child: Image.asset(
                                Images.filter,
                                height: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      height10(),
                      Container(
                          height: 1,
                          width: Get.width,
                          color: ColorsUtils.border),
                      SizedBox(
                        height: Get.height * 0.1,
                        width: Get.width,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            width20(),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  smallBoldText(text: 'From'.tr),
                                  Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: smallSemiBoldText(
                                        text:
                                            '${intl.DateFormat('dd MMM yy').format(DateTime.parse(widget.startDate!))}'),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  smallBoldText(text: 'To'.tr),
                                  Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: smallSemiBoldText(
                                        text:
                                            '${intl.DateFormat('dd MMM yy').format(DateTime.parse(widget.endDate!))}'),
                                  ),
                                ],
                              ),
                            ),
                            width50(),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  controller.tranResponse.isEmpty
                                      ? Get.showSnackbar(GetSnackBar(
                                          message: 'No Data Found'.tr,
                                        ))
                                      : exportBottomSheet();
                                },
                                child: Container(
                                  color: ColorsUtils.accent,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          Images.download,
                                          height: 20,
                                        ),
                                        Text(
                                          'Download'.tr,
                                          style: ThemeUtils.blackSemiBold
                                              .copyWith(
                                                  fontSize: FontUtils.small,
                                                  color: ColorsUtils.white),
                                        )
                                      ]),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                          height: 1,
                          width: Get.width,
                          color: ColorsUtils.border),
                      height20(),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          physics: BouncingScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Transactions details'.tr,
                                  style: ThemeUtils.blackBold.copyWith(
                                      fontSize: FontUtils.mediumSmall),
                                ),
                                height10(),
                                smallSemiBoldText(
                                    text:
                                        '${reportDetailResponseModel!.count} ${'Items'.tr}'),
                                controller.tranResponse.isEmpty
                                    ? Center(
                                        child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 50),
                                        child: Text(
                                          'No Data Found'.tr,
                                        ),
                                      ))
                                    : ListView.builder(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 20),
                                        itemCount:
                                            controller.tranResponse.length,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  border: Border.all(
                                                      color: ColorsUtils.border,
                                                      width: 1)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(15),
                                                child: Column(
                                                  children: [
                                                    commonRow(
                                                        title:
                                                            'Transaction ID'.tr,
                                                        value:
                                                            '${controller.tranResponse[index].transactionId ?? "NA"}'),
                                                    // '${type == 1 ? controller.tranResponse[index].transactionId ?? "NA" : type == 3 ? controller.invResponse[index].invoiceNumber ?? "NA" : 'NA'}'),
                                                    commonRow(
                                                        title:
                                                            'Transaction Type'
                                                                .tr,
                                                        value:
                                                            '${controller.tranResponse[index].transactionType ?? "NA"}'),
                                                    commonRow(
                                                        title:
                                                            'Transaction Amount'
                                                                .tr,
                                                        value:
                                                            '${controller.tranResponse[index].transactionAmount ?? "NA"} QAR'),
                                                    commonRow(
                                                        title:
                                                            'Transaction Method'
                                                                .tr,
                                                        value:
                                                            '${controller.tranResponse[index].paymentMethods ?? 'NA'}'),
                                                    commonRow(
                                                        title:
                                                            'Transaction Status'
                                                                .tr,
                                                        value:
                                                            '${controller.tranResponse[index].transactionStatus ?? 'NA'}'),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                if (controller.isPaginationLoading &&
                                    isPageFirst)
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 0),
                                    child: Center(child: Loader()),
                                  ),
                                if (controller.isPaginationLoading &&
                                    !isPageFirst)
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 0),
                                    child: Center(child: Loader()),
                                  ),
                                height20(),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                },
              ))
            : Scaffold(
                body: Center(
                  child: Text('Coming soon'.tr),
                ),
              );
      } else {
        return InternetNotFound(
          onTap: () async {
            connectivityViewModel.startMonitoring();

            if (connectivityViewModel.isOnline != null) {
              if (connectivityViewModel.isOnline!) {
                reportDetailViewModel.setReportInit();

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
              reportDetailViewModel.setReportInit();

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

  Widget commonRow({String? title, String? value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        smallBoldText(text: title!),
        smallSemiBoldText(text: value!)
      ]),
    );
  }

  Text smallSemiBoldText({String? text}) {
    return Text(text!,
        style:
            ThemeUtils.blackSemiBold.copyWith(fontSize: FontUtils.verySmall));
  }

  Text smallBoldText({String? text}) {
    return Text(text!,
        style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.verySmall));
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
                    'Select Format'.tr,
                    style: ThemeUtils.blackSemiBold.copyWith(
                      fontSize: FontUtils.medium,
                    ),
                  ),
                  Column(
                    children: [
                      LabeledRadio(
                        label: 'PDF',
                        value: 1,
                        groupValue: isRadioSelected,
                        onChanged: (newValue) {
                          setState(() {
                            isRadioSelected = newValue;
                          });
                        },
                      ),
                      LabeledRadio(
                        label: 'CSV',
                        value: 2,
                        groupValue: isRadioSelected,
                        onChanged: (newValue) {
                          setState(() {
                            print('hi');
                            isRadioSelected = newValue;
                          });
                        },
                      ),
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
                      connectivityViewModel.startMonitoring();
                      if (connectivityViewModel.isOnline != null) {
                        if (connectivityViewModel.isOnline!) {
                          if (sendEmail == true) {
                            String token = await encryptedSharedPreferences
                                .getString('token');
                            final url = Uri.parse(
                              '${Utility.baseUrl}reporthistories/${widget.selectedType}?filter[where][created][between][0]=${intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(widget.startDate!))}&filter[where][created][between][1]=${intl.DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.endDate!))} 23:59:59&filter[order]=created%20DESC&${isRadioSelected == 1 ? 'isPdf' : isRadioSelected == 2 ? 'isCsv' : 'isExcel'}=true&isEmail=true',
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
                            await downloadFile(
                              isEmail: sendEmail,
                              isRadioSelected: isRadioSelected,
                              url:
                                  '${Utility.baseUrl}reporthistories/${widget.selectedType}?filter[where][created][between][0]=${intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(widget.startDate!))}&filter[where][created][between][1]=${intl.DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.endDate!))} 23:59:59&filter[order]=created%20DESC&${isRadioSelected == 1 ? 'isPdf' : isRadioSelected == 2 ? 'isCsv' : 'isExcel'}=true',
                              context: context,
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

  void initData() async {
    email = await encryptedSharedPreferences.getString('email');
    widget.selectedType == 'posTransactionDetailReport'
        ? type = 1
        : widget.selectedType == 'settlementReports'
            ? type = 2
            : widget.selectedType == 'posTerminalSummaryReport'
                ? type = 3
                : widget.selectedType == 'posDeviceSummaryReport'
                    ? type = 4
                    : type = 0;
    setState(() {});

    scrollData();
    reportDetailViewModel.clearResponseList();
    await apiCalling();

    if (isPageFirst == false) {
      isPageFirst = true;
    }
  }

  Future<void> apiCalling() async {
    //transactionReport

    await reportDetailViewModel.transactionReport(
        type: widget.selectedType,
        filter:
            '&filter[where][created][between][0]=${intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(widget.startDate!))}&filter[where][created][between][1]=${intl.DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.endDate!))} 23:59:59' +
                Utility.posReportPaymentMethodFilter +
                Utility.posReportTransactionStatusFilter +
                Utility.posReportDisputesStatusFilter +
                Utility.posReportRefundStatusFilter +
                Utility.posReportDeviceTypeFilter +
                Utility.posReportDeviceStatusFilter +
                Utility.posReportTransactionModesFilter +
                Utility.posReportTransactionTypeFilter +
                Utility.posReportCardEntryTypeFilter);
    // if (widget.selectedType == 'transactionDetailsReport') {
    //   print('transaction report Api');
    //
    //   await reportDetailViewModel.transactionReport(
    //       type: widget.selectedType,
    //       filter:
    //           '&filter[where][created][between][0]=${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(widget.startDate!))}&filter[where][created][between][1]=${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(widget.endDate!))}');
    // }
    // //invoiceReport
    // else if (widget.selectedType == 'invoiceReports') {
    //   print('invoice report Api');
    //   await reportDetailViewModel.invoiceReport(
    //       type: widget.selectedType,
    //       filter:
    //           '&filter[where][created][between][0]=${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(widget.startDate!))}&filter[where][created][between][1]=${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(widget.endDate!))}');
    // }
  }

  void scrollData() {
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController!.position.maxScrollExtent ==
                _scrollController!.offset &&
            !reportDetailViewModel.isPaginationLoading) {
          //transactionReport

          reportDetailViewModel.transactionReport(
              type: widget.selectedType,
              filter:
                  '&filter[where][created][between][0]=${intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(widget.startDate!))}&filter[where][created][between][1]=${intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(widget.endDate!))}');
          // if (widget.selectedType == 'transactionDetailsReport') {
          //   print('transaction report Api');
          //
          //   reportDetailViewModel.transactionReport(
          //       type: widget.selectedType,
          //       filter:
          //           '&filter[where][created][between][0]=${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(widget.startDate!))}&filter[where][created][between][1]=${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(widget.endDate!))}');
          // }
          // //invoiceReport
          // else if (widget.selectedType == 'invoiceReports') {
          //   print('invoice report Api');
          //   reportDetailViewModel.invoiceReport(
          //       type: widget.selectedType,
          //       filter:
          //           '&filter[where][created][between][0]=${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(widget.startDate!))}&filter[where][created][between][1]=${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(widget.endDate!))}');
          // }
        }
      });
  }
}
