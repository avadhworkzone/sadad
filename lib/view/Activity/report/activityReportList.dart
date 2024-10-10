import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as intl;
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/Activity/activityAllTransactionReportResponse.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/Activity/activityWithdrawalFilterGetSubUserResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/Activity/activityWithdrawalReport.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/Activity/transferListResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/downloadFile.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/Activity/activityPosRendtalDetailScreen.dart';
import 'package:sadad_merchat_app/view/Activity/activityTransactionDetailScreen.dart';
import 'package:sadad_merchat_app/view/Activity/report/activityReportFilterScreen.dart';
import 'package:sadad_merchat_app/view/Activity/report/activityReportFilterTransactionScreen.dart';
import 'package:sadad_merchat_app/view/Activity/report/activityReportFilterTransferScreen.dart';
import 'package:sadad_merchat_app/view/Activity/report/activityReportTransactionSearchScreen.dart';
import 'package:sadad_merchat_app/view/Activity/report/activityReportTransferSearchScreen.dart';
import 'package:sadad_merchat_app/view/Activity/report/activityReportWithdrawalaSearchScreen.dart';
import 'package:sadad_merchat_app/view/Activity/withdrawal/activityWithdrawalDetailScreen.dart';
import 'package:sadad_merchat_app/viewModel/Activity/activityReport.dart';
import 'package:sadad_merchat_app/viewModel/Activity/transferViewModel.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';

class ActivityReportListScreen extends StatefulWidget {
  final String? startDate;
  final int? isRadioSelected;
  final String? endDate;
  ActivityReportListScreen(
      {Key? key, this.startDate, this.endDate, this.isRadioSelected})
      : super(key: key);

  @override
  State<ActivityReportListScreen> createState() =>
      _ActivityReportListScreenState();
}

class _ActivityReportListScreenState extends State<ActivityReportListScreen> {
  ScrollController? _scrollController;
  List<GetSubUserNamesResponseModel>? getSubUserList;
  ActivityAllTransactionReportResponse transactionReportResponse =
      ActivityAllTransactionReportResponse();
  TransferViewModel transferViewModel = Get.find();
  List<ActivityTransferListResponse>? activityTransferListRes;
  List<DataTransaction>? lastRes;
  String filterDate = '';
  String token = '';
  bool isPageFirst = true;
  String email = '';
  ConnectivityViewModel connectivityViewModel = Get.find();
  int isRadioSelected = 0;
  bool sendEmail = false;
  String userId = '';

  ActivityReportViewModel activityReportViewModel = Get.find();
  List<Data>? withdrawalRes;
  List<DataTransaction> transactionResponse = [];
  @override
  void initState() {
    transferViewModel.transferListApiResponse = ApiResponse.initial('Initial');

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      activityReportViewModel.setInit();
      connectivityViewModel.startMonitoring();
      initData();
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        height40(),
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
              InkWell(
                onTap: () async {
                  widget.isRadioSelected == 1
                      ? await Get.to(() => ActivityWithdrawalSearchScreen(
                            isRadioSelected: widget.isRadioSelected,
                            endDate: widget.endDate,
                            startDate: widget.startDate,
                          ))
                      : widget.isRadioSelected == 2
                          ? await Get.to(
                              () => ActivityReportTransactionSearchScreen(
                                    endDate: widget.endDate,
                                    startDate: widget.startDate,
                                  ))
                          : await Get.to(
                              () => ActivityReportTransferSearchScreen(
                                    endDate: widget.endDate,
                                    startDate: widget.startDate,
                                  ));
                  activityReportViewModel.setInit();
                  initData();
                },
                child: Image.asset(
                  Images.search,
                  height: 20,
                ),
              ),
              width20(),
              InkWell(
                onTap: () async {
                  if (widget.isRadioSelected == 1) {
                    await Get.to(() => ActivityReportFilterWithdrawalScreen());
                    activityReportViewModel.setInit();
                    initData();
                  } else if (widget.isRadioSelected == 2) {
                    await Get.to(() => ActivityReportTransactionFilterScreen());
                    activityReportViewModel.setInit();
                    initData();
                  } else {
                    await Get.to(() => ActivityReportTransferFilterScreen());
                    activityReportViewModel.setInit();
                    initData();
                  }
                },
                child: Image.asset(Images.filter,
                    height: 20,
                    color: widget.isRadioSelected == 1
                        ? (Utility.activityReportGetSubUSer != '' ||
                                Utility.activityReportSettlementWithdrawFilterStatus !=
                                    '' ||
                                Utility.activityReportSettlementWithdrawFilterType !=
                                    '' ||
                                Utility.activityReportSettlementPayoutFilterStatus !=
                                    '' ||
                                Utility.activityReportSettlementPayoutFilterBank !=
                                    '')
                            ? ColorsUtils.accent
                            : ColorsUtils.black
                        : widget.isRadioSelected == 2
                            ? (Utility.activityTransactionReportTransactionTypeFilter != '' ||
                                    Utility.activityTransactionReportTransactionSourceFilter !=
                                        '' ||
                                    Utility.activityTransactionReportTransactionStatusFilter !=
                                        '' ||
                                    Utility.activityTransactionReportPaymentMethodFilter !=
                                        '' ||
                                    Utility.activityTransactionReportTransactionModeFilter !=
                                        '' ||
                                    Utility.activityTransactionReportIntegrationTypeFilter !=
                                        '')
                                ? ColorsUtils.accent
                                : ColorsUtils.black
                            : (Utility.activityTransferReportTransferTypeFilter !=
                                    ''
                                ? ColorsUtils.accent
                                : ColorsUtils.black)),
              ),
            ],
          ),
        ),
        height10(),
        Container(height: 1, width: Get.width, color: ColorsUtils.border),
        SizedBox(
          height: Get.height * 0.08,
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
                    if (widget.isRadioSelected == 1) {
                      withdrawalRes == null || withdrawalRes!.isEmpty
                          ? Get.showSnackbar(GetSnackBar(
                              message: 'No Data Found'.tr,
                            ))
                          : exportBottomSheet();
                    } else if (widget.isRadioSelected == 2) {
                      transactionReportResponse.data == null ||
                              transactionReportResponse.data!.isEmpty
                          ? Get.showSnackbar(GetSnackBar(
                              message: 'No Data Found'.tr,
                            ))
                          : exportBottomSheet();
                    } else {
                      lastRes == null || lastRes!.isEmpty
                          ? Get.showSnackbar(GetSnackBar(
                              message: 'No Data Found'.tr,
                            ))
                          : exportBottomSheet();
                    }
                  },
                  child: Container(
                    color: ColorsUtils.accent,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            Images.download,
                            height: 20,
                          ),
                          Text(
                            'Download'.tr,
                            style: ThemeUtils.blackSemiBold.copyWith(
                                fontSize: FontUtils.small,
                                color: ColorsUtils.white),
                          )
                        ]),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(height: 1, width: Get.width, color: ColorsUtils.border),
        height20(),
        widget.isRadioSelected == 1

            ///radio 1
            ? Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: GetBuilder<ActivityReportViewModel>(
                    builder: (controller) {
                      if (controller
                                  .settlementWithdrawalListApiResponse.status ==
                              Status.LOADING ||
                          controller
                                  .settlementWithdrawalListApiResponse.status ==
                              Status.INITIAL) {
                        return const Center(child: Loader());
                      }

                      if (controller
                              .settlementWithdrawalListApiResponse.status ==
                          Status.ERROR) {
                        return const SessionExpire();
                        //return Text('something wrong');
                      }

                      if (controller
                              .settlementWithdrawalListApiResponse.status ==
                          Status.COMPLETE) {
                        // print(
                        //     'res===${jsonEncode(controller.settlementWithdrawalListApiResponse.data)}');
                        withdrawalRes =
                            controller.settlementWithdrawalListApiResponse.data;
                      }

                      return withdrawalRes!.isEmpty &&
                              !activityReportViewModel.isPaginationLoading
                          ? Center(
                              child: Padding(
                              padding: const EdgeInsets.only(top: 50),
                              child: Text('No data found'.tr),
                            ))
                          : Column(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                            '${controller.countWithdrawalReport} ${'withdrawals'.tr}'))),
                                listOfDataWithdrawal(),
                                if (activityReportViewModel
                                        .isPaginationLoading &&
                                    isPageFirst)
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                    child: Center(child: Loader()),
                                  ),
                                if (activityReportViewModel
                                        .isPaginationLoading &&
                                    !isPageFirst)
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                    child: Center(child: Loader()),
                                  ),
                              ],
                            );
                    },
                  ),
                ),
              )

            ///radio 2
            : widget.isRadioSelected == 2
                ? Expanded(
                    child: GetBuilder<ActivityReportViewModel>(
                      builder: (controller) {
                        if (controller.activityAllTransactionListApiResponse
                                    .status ==
                                Status.LOADING ||
                            controller.activityAllTransactionListApiResponse
                                    .status ==
                                Status.INITIAL) {
                          return Loader();
                        }
                        if (controller
                                .activityAllTransactionListApiResponse.status ==
                            Status.ERROR) {
                          //return Center(child: Text('Error'));
                          return SessionExpire();
                        }

                        transactionReportResponse.data =
                            controller.transactionResponse;
                        if (transactionReportResponse.data == null ||
                            transactionReportResponse.data == []) {
                          return Center(child: Text('No data found'));
                        }
                        return Column(
                          children: [
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                        '${controller.countTransactionReport} ${'Transactions'.tr}'))),
                            Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount:
                                    transactionReportResponse.data!.length,
                                shrinkWrap: true,
                                controller: _scrollController,
                                // physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      // Container(
                                      //   width: Get.width,
                                      //   decoration: BoxDecoration(
                                      //     color: ColorsUtils.tabUnselect,
                                      //   ),
                                      //   child: Padding(
                                      //     padding: const EdgeInsets.all(8.0),
                                      //     child: customVerySmallSemiText(
                                      //         title:
                                      //             '${balanceListRes.data![index].date}'),
                                      //   ),
                                      // ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        child: InkWell(
                                          onTap: () {
                                            print(
                                                '===>${transactionReportResponse.data![index].transactionSource}');
                                            // Sadad Service Charge SADAD Paid Services
                                            if (transactionReportResponse
                                                        .data![index]
                                                        .transactionSource !=
                                                    'Sadad Service Charge' ||
                                                transactionReportResponse
                                                        .data![index]
                                                        .transactionSource !=
                                                    'SADAD Paid Services') {
                                              if (transactionReportResponse
                                                          .data![index]
                                                          .transactionSource ==
                                                      'Settlement Withdrawal' ||
                                                  transactionReportResponse
                                                          .data![index]
                                                          .transactionSource ==
                                                      'Withdrawal') {
                                                Get.to(() =>
                                                    ActivityWithdrawalDetailScreen(
                                                      id: transactionReportResponse
                                                          .data![index]
                                                          .transactionId
                                                          .toString(),
                                                    ));
                                              } else if (transactionReportResponse
                                                      .data![index]
                                                      .transactionSource ==
                                                  'POS Rental') {
                                                Get.to(() =>
                                                    ActivityPosRentalTransactionScreen(
                                                      id: transactionReportResponse
                                                          .data![index]
                                                          .transactionId
                                                          .toString(),
                                                    ));
                                              } else {
                                                Get.to(() =>
                                                    ActivityTransactionDetailScreen(
                                                      id: transactionReportResponse
                                                          .data![index]
                                                          .transactionId
                                                          .toString(),
                                                    ));
                                              }
                                            }
                                          },
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: ColorsUtils.tabUnselect
                                                      .withOpacity(0.5),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Image.asset(
                                                      Images.invoice,
                                                      width: Get.width * 0.06),
                                                ),
                                              ),
                                              width10(),
                                              Expanded(
                                                  child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      customSmallBoldText(
                                                          title:
                                                              '${transactionReportResponse.data![index].transactionSource ?? "NA"}'),
                                                      Spacer(),
                                                      customSmallBoldText(
                                                          color: ColorsUtils
                                                              .accent,
                                                          title:
                                                              '${transactionReportResponse.data![index].transactionAmount} QAR')
                                                    ],
                                                  ),
                                                  height5(),
                                                  customVerySmallNorText(
                                                      title:
                                                          '${transactionReportResponse.data![index].transactionType ?? 'NA'}'),
                                                  height5(),
                                                  Row(
                                                    children: [
                                                      customVerySmallNorText(
                                                          title:
                                                              'ID: ${transactionReportResponse.data![index].transactionId ?? "NA"}',
                                                          color:
                                                              ColorsUtils.grey),
                                                      Spacer(),
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          border: Border.all(
                                                            color: (transactionReportResponse
                                                                            .data![
                                                                                index]
                                                                            .inOut ==
                                                                        null ||
                                                                    transactionReportResponse
                                                                            .data![
                                                                                index]
                                                                            .inOut ==
                                                                        0)
                                                                ? ColorsUtils
                                                                    .reds
                                                                : ColorsUtils
                                                                    .green,
                                                          ),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            CircleAvatar(
                                                              backgroundColor: (transactionReportResponse
                                                                              .data![
                                                                                  index]
                                                                              .inOut ==
                                                                          null ||
                                                                      transactionReportResponse
                                                                              .data![
                                                                                  index]
                                                                              .inOut ==
                                                                          0)
                                                                  ? ColorsUtils
                                                                      .reds
                                                                  : ColorsUtils
                                                                      .green,
                                                              radius: 10,
                                                              child: Icon(
                                                                  (transactionReportResponse.data![index].inOut == null ||
                                                                          transactionReportResponse.data![index].inOut ==
                                                                              0)
                                                                      ? Icons
                                                                          .arrow_back_outlined
                                                                      : Icons
                                                                          .arrow_forward_outlined,
                                                                  size: 15,
                                                                  color:
                                                                      ColorsUtils
                                                                          .white),
                                                            ),
                                                            width10(),
                                                            customVerySmallNorText(
                                                                color: (transactionReportResponse.data![index].inOut == null ||
                                                                        transactionReportResponse.data![index].inOut ==
                                                                            0)
                                                                    ? ColorsUtils
                                                                        .reds
                                                                    : ColorsUtils
                                                                        .green,
                                                                title: (transactionReportResponse.data![index].inOut ==
                                                                            null ||
                                                                        transactionReportResponse.data![index].inOut ==
                                                                            0)
                                                                    ? 'Payment Out'
                                                                    : 'Payment In'),
                                                            width10(),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              )),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Divider()
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  )
                :

                ///radio 3
                Expanded(
                    child: GetBuilder<TransferViewModel>(
                      builder: (controller) {
                        if (controller.transferReportListApiResponse.status ==
                                Status.LOADING ||
                            controller.transferReportListApiResponse.status ==
                                Status.INITIAL) {
                          return Loader();
                        }
                        if (controller.transferReportListApiResponse.status ==
                            Status.ERROR) {
                          //return Text('Error');
                          return SessionExpire();
                        }
                        lastRes = controller.transferReportListApiResponse.data;
                        return Column(
                          children: [
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                        '${controller.countTransferReport} ${'Transfers'.tr}'))),
                            Expanded(
                              child: ListView.builder(
                                controller: _scrollController,
                                padding: EdgeInsets.zero,
                                itemCount: lastRes!.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  // dataShow(index);
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: InkWell(
                                      onTap: () {
                                        if (lastRes![index].transactionId !=
                                            null) {
                                          Get.to(() =>
                                              ActivityTransactionDetailScreen(
                                                id: lastRes![index]
                                                    .transactionId
                                                    .toString(),
                                              ));
                                        }
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 35,
                                                backgroundColor:
                                                    ColorsUtils.lightYellow,
                                                child: Icon(Icons.person,
                                                    color: ColorsUtils.yellow,
                                                    size: 32),
                                              ),
                                              width20(),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: customSmallMedBoldText(
                                                              title:
                                                                  '${lastRes![index].customerName ?? "NA"}'),
                                                        ),
                                                        customSmallMedSemiText(
                                                            color: (lastRes![index]
                                                                            .inOut ==
                                                                        null ||
                                                                    lastRes![index]
                                                                            .inOut ==
                                                                        1)
                                                                ? ColorsUtils
                                                                    .green
                                                                : ColorsUtils
                                                                    .red,
                                                            title:
                                                                '${lastRes![index].transactionAmount ?? "0"} QAR')
                                                      ],
                                                    ),
                                                    height10(),
                                                    customSmallNorText(
                                                        title:
                                                            // '26 Mar 2022, 11:19:39',
                                                            '${intl.DateFormat('dd MMM yy, HH:mm:ss').format(DateTime.parse(lastRes![index].transactionDateTime.toString()))}',
                                                        color: ColorsUtils.grey)
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
      ],
    ));
  }

  void initData() async {
    token = await encryptedSharedPreferences.getString('token');

    email = await encryptedSharedPreferences.getString('email');

    String id = await encryptedSharedPreferences.getString('id');
    filterDate =
        '&filter[where][created][between][0]=${widget.startDate}&filter[where][created][between][1]=${widget.endDate}';
    activityReportViewModel.clearResponseList();

    apiCall(id);
    setState(() {});
    if (isPageFirst == true) {
      isPageFirst = false;
    }
    scrollApiData(id);
  }

  void scrollApiData(String id) {
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController!.position.maxScrollExtent ==
                _scrollController!.offset &&
            !activityReportViewModel.isPaginationLoading) {
          widget.isRadioSelected == 1
              ? activityReportViewModel.withdrawalList(
                  isLoading: false,
                  filter: filterDate +
                      Utility.activityReportSettlementWithdrawFilterType +
                      Utility.activityReportSettlementPayoutFilterStatus +
                      Utility.activityReportSettlementPayoutFilterBank +
                      Utility.activityReportSettlementWithdrawFilterStatus +
                      Utility.activityReportGetSubUSer,
                  filterType: 'settlementReports')
              : widget.isRadioSelected == 2
                  ? activityReportViewModel.allTransactionList(
                      filter: filterDate +
                          Utility
                              .activityTransactionReportTransactionTypeFilter +
                          Utility
                              .activityTransactionReportTransactionSourceFilter +
                          Utility
                              .activityTransactionReportTransactionStatusFilter +
                          Utility.activityTransactionReportPaymentMethodFilter +
                          Utility
                              .activityTransactionReportTransactionModeFilter +
                          Utility
                              .activityTransactionReportIntegrationTypeFilter,
                      isLoading: false,
                    )
                  : transferViewModel.transferReportList(
                      filter: filterDate +
                          Utility.activityTransferReportTransferTypeFilter);
        }
      });
  }

  void apiCall(String id) async {
    ///api calling.......

    print('page1 ');

    if (widget.isRadioSelected == 1) {
      await activityReportViewModel.withdrawalList(
          filter: filterDate +
              Utility.activityReportSettlementWithdrawFilterType +
              Utility.activityReportSettlementPayoutFilterStatus +
              Utility.activityReportSettlementPayoutFilterBank +
              Utility.activityReportSettlementWithdrawFilterStatus +
              Utility.activityReportGetSubUSer,
          filterType: 'settlementReports');
    } else if (widget.isRadioSelected == 2) {
      await activityReportViewModel.allTransactionList(
        filter: filterDate +
            Utility.activityTransactionReportTransactionTypeFilter +
            Utility.activityTransactionReportTransactionSourceFilter +
            Utility.activityTransactionReportTransactionStatusFilter +
            Utility.activityTransactionReportPaymentMethodFilter +
            Utility.activityTransactionReportTransactionModeFilter +
            Utility.activityTransactionReportIntegrationTypeFilter,
      );
    } else {
      userId = await encryptedSharedPreferences.getString('id');

      transferViewModel.setTransactionInit();
      await transferViewModel.transferReportList(
          filter:
              filterDate + Utility.activityTransferReportTransferTypeFilter);
    }
  }

  ListView listOfDataWithdrawal() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: withdrawalRes!.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            InkWell(
              onTap: () {
                Get.to(() => ActivityWithdrawalDetailScreen(
                      id: withdrawalRes![index].id.toString(),
                    ));

                // Get.to(() => SettlementWithdrawalDetailScreen(
                //       // id: withdrawalRes!.data![index].id.toString(),
                //     ));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: ColorsUtils.border, width: 1),
                      ),
                      child: Image.network(
                        '${Utility.baseUrl}containers/api-banks/download/${withdrawalRes![index].logo}',
                        headers: {HttpHeaders.authorizationHeader: token},
                        fit: BoxFit.contain,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                    width10(),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            customSmallBoldText(
                                title: withdrawalRes![index].bankName ?? "NA"),
                            // Icon(Icons.more_vert)
                          ],
                        ),
                        height10(),
                        customSmallSemiText(
                            title:
                                'ID: ${withdrawalRes![index].withdrawalRequestId ?? "NA"}'),
                        height10(),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: customSmallSemiText(
                              title:
                                  '${intl.DateFormat('dd MMM yyyy, HH:mm:ss').format(DateTime.parse(withdrawalRes![index].withdrawalRequestDateTime.toString()))}',
                              color: ColorsUtils.grey),
                        ),
                        height10(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: (withdrawalRes![index]
                                                  .withdrawalRequestStatus! ==
                                              'REJECTED' ||
                                          withdrawalRes![index]
                                                  .withdrawalRequestStatus! ==
                                              'CANCELLED')
                                      ? ColorsUtils.reds
                                      : withdrawalRes![index]
                                                  .withdrawalRequestStatus! ==
                                              'REQUESTED'
                                          ? ColorsUtils.yellow
                                          : ColorsUtils.green,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 2),
                                child: customSmallSemiText(
                                    color: ColorsUtils.white,
                                    title:
                                        '${withdrawalRes![index].withdrawalRequestStatus!}'),
                              ),
                            ),
                            // Image.asset(
                            //   Images.onlinePayment,
                            //   width: 25,
                            // ),
                            SizedBox(
                              // width: Get.width * 0.375,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: customMediumBoldText(
                                    title:
                                        '${withdrawalRes![index].requestAmount ?? '0'} QAR',
                                    color: ColorsUtils.accent),
                              ),
                            )
                          ],
                        )
                      ],
                    ))
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Divider(),
            )
          ],
        );
      },
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
                              '${Utility.baseUrl}${widget.isRadioSelected == 1 ? 'reporthistories/settlementReports' : 'reporthistories/transactionDetailsReport'}?filter[where][created][between][0]=${intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(widget.startDate!))}&filter[where][created][between][1]=${intl.DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.endDate!))} 23:59:59${widget.isRadioSelected == 1 ? widget.isRadioSelected == 2 ? Utility.activityReportSettlementWithdrawFilterType + Utility.activityReportSettlementPayoutFilterStatus + Utility.activityReportSettlementPayoutFilterBank + Utility.activityReportSettlementWithdrawFilterStatus + Utility.activityReportGetSubUSer : Utility.activityTransactionReportTransactionTypeFilter + Utility.activityTransactionReportTransactionSourceFilter + Utility.activityTransactionReportTransactionStatusFilter + Utility.activityTransactionReportPaymentMethodFilter + Utility.activityTransactionReportTransactionModeFilter + Utility.activityTransactionReportIntegrationTypeFilter : Utility.activityTransferReportTransferTypeFilter}&filter[order]=created%20DESC${widget.isRadioSelected == 3 ? '&filter[where][transactionentityId][inq][0]=5&filter[where][transactionentityId][inq][1]=8' : ""}&${isRadioSelected == 1 ? 'isPdf' : isRadioSelected == 2 ? 'isCsv' : 'isExcel'}=true&isEmail=true',
                            );
                            final request = http.Request("GET", url);
                            request.headers.addAll(<String, String>{
                              'Authorization': token,
                              'Content-Type': 'application/json'
                            });
                            print("URL===$url");
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
                              name:
                                  'Online Payment Report ${'${intl.DateFormat("dd MMM yyyy").format(DateTime.parse(widget.startDate!))} - ${intl.DateFormat("dd MMM yyyy").format(DateTime.parse(widget.endDate!))}'} ${DateTime.now().microsecondsSinceEpoch}',
                              url:
                                  '${Utility.baseUrl}${widget.isRadioSelected == 1 ? 'reporthistories/settlementReports' : 'reporthistories/transactionDetailsReport'}?filter[where][created][between][0]=${intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(widget.startDate!))}&filter[where][created][between][1]=${intl.DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.endDate!))} 23:59:59${widget.isRadioSelected == 1 ? widget.isRadioSelected == 2 ? Utility.activityReportSettlementWithdrawFilterType + Utility.activityReportSettlementPayoutFilterStatus + Utility.activityReportSettlementPayoutFilterBank + Utility.activityReportSettlementWithdrawFilterStatus + Utility.activityReportGetSubUSer : Utility.activityTransactionReportTransactionTypeFilter + Utility.activityTransactionReportTransactionSourceFilter + Utility.activityTransactionReportTransactionStatusFilter + Utility.activityTransactionReportPaymentMethodFilter + Utility.activityTransactionReportTransactionModeFilter + Utility.activityTransactionReportIntegrationTypeFilter : Utility.activityTransferReportTransferTypeFilter}&filter[order]=created%20DESC${widget.isRadioSelected == 3 ? '&filter[where][transactionentityId][inq][0]=5&filter[where][transactionentityId][inq][1]=8' : ""}&${isRadioSelected == 1 ? 'isPdf' : isRadioSelected == 2 ? 'isCsv' : 'isExcel'}=true',
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
}
