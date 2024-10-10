// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/DashBoard/availableBalanceResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/settlement/settlementWithdrawalListResponse.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/settlement/settlemetPayoutListResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/staticData.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/analytics_service.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/settlement/filterSettlementScreen.dart';
import 'package:sadad_merchat_app/view/settlement/settlementPayoutDetailScreen.dart';
import 'package:sadad_merchat_app/view/settlement/settlementReportScreen.dart';
import 'package:sadad_merchat_app/view/settlement/settlementWithdrawalScreen.dart';
import 'package:sadad_merchat_app/view/settlement/withdrawalDetailScreen.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:sadad_merchat_app/viewModel/dashboard/dashBoardViewModel.dart';
import 'package:sadad_merchat_app/viewModel/settlement/settlementViewModel.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:http/http.dart' as http;

class SettlementScreen extends StatefulWidget {
  const SettlementScreen({Key? key}) : super(key: key);

  @override
  State<SettlementScreen> createState() => _SettlementScreenState();
}

class _SettlementScreenState extends State<SettlementScreen>
    with TickerProviderStateMixin {
  String filterValue = 'All';
  String today = intl.DateFormat('dd MMM').format(DateTime.now());
  List<String> selectedTimeZone = ['All'];
  late TabController tabController;
  GlobalKey _key = GlobalKey();
  bool isPageFirst = true;
  String token = '';
  DashBoardViewModel dashBoardViewModel = Get.find();
  List<SettlementWithdrawalListResponseModel>? withdrawalRes;
  List<SettlementPayoutListResponseModel>? payoutRes;
  int selectedTab = 0;
  AnimationController? animationController;
  Animation<double>? animation;
  ScrollController? _scrollController;
  double? tabPosition = 0.0;
  int differenceDays = 0;
  bool isTabVisible = false;
  String startDate = '';
  String endDate = '';
  String _range = '';
  String filterDate = '';
  ConnectivityViewModel connectivityViewModel = Get.find();

  SettlementWithdrawalListViewModel settlementWithdrawalListViewModel =
      Get.find();

  @override
  void initState() {
    connectivityViewModel.startMonitoring();

    AnalyticsService.sendAppCurrentScreen('Settlement Screen');

    tabController = TabController(length: 2, vsync: this);
    settlementWithdrawalListViewModel.setInit();
    Utility.settlementWithdrawFilterStatus = '';
    Utility.settlementWithdrawFilterType = '';
    Utility.settlementPayoutFilterStatus = '';
    Utility.settlementPayoutFilterBank = '';
    Utility.holdSettlementWithdrawFilterStatus = '';
    Utility.holdSettlementWithdrawFilterType = '';
    Utility.holdSettlementPayoutFilterStatus = '';
    Utility.holdSettlementPayoutFilterBank = '';
    availBal();
    initData();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    animationController?.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (connectivityViewModel.isOnline != null) {
      if (connectivityViewModel.isOnline!) {
        return Scaffold(
            appBar: appBarData(),
            body: SingleChildScrollView(
              controller: _scrollController,
              physics: tabPosition == 0.0
                  ? NeverScrollableScrollPhysics()
                  : ClampingScrollPhysics(),
              child: Column(
                children: [
                  GetBuilder<DashBoardViewModel>(
                    builder: (controller) {
                      if (controller.availableBalanceApiResponse.status ==
                              Status.LOADING ||
                          controller.availableBalanceApiResponse.status ==
                              Status.INITIAL) {
                        return const Center(child: Loader());
                      }
                      if (controller.availableBalanceApiResponse.status ==
                          Status.ERROR) {
                        return const SessionExpire();
                        // return Text('something wrong');
                      }
                      AvailableBalanceResponseModel avaBalResponse =
                          controller.availableBalanceApiResponse.data;
                      return Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 40),
                                color: ColorsUtils.lightPink,
                                height: Get.height * 0.18,
                              ),
                              Positioned(
                                bottom: 0,
                                left: 20,
                                right: 20,
                                child: GestureDetector(
                                  onTap: () async {
                                    Utility.settlementWithdrawPeriodAlready =
                                        false;
                                    Utility.settlementWithdrawPeriod = '';
                                    await Get.to(
                                        () => SettlementWithdrawalScreen());
                                    initData();
                                    availBal();
                                  },
                                  child: Container(
                                    width: Get.width,
                                    // height: Get.height * 0.22,
                                    decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          begin: Alignment(-0.7, -1),
                                          end: Alignment(0.3, 1),
                                          stops: [0.1, 0.4, 0.9],
                                          colors: [
                                            ColorsUtils.orange,
                                            ColorsUtils.darkOrange,
                                            ColorsUtils.darkMaroon,
                                          ],
                                        ),
                                        image: DecorationImage(
                                            colorFilter: ColorFilter.mode(
                                                ColorsUtils.black
                                                    .withOpacity(0.25),
                                                BlendMode.srcATop),
                                            image: const AssetImage(
                                                Images.carViewMaroon),
                                            fit: BoxFit.cover),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                  child: Text(
                                                "Total Available Balance".tr,
                                                style: ThemeUtils.whiteRegular
                                                    .copyWith(
                                                        fontSize:
                                                            FontUtils.small),
                                              )),
                                              Text(
                                                textDirection:
                                                    TextDirection.ltr,
                                                today,
                                                style: ThemeUtils.whiteRegular
                                                    .copyWith(
                                                        fontSize: FontUtils
                                                            .verySmall),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          currencyText(
                                              avaBalResponse
                                                  .totalavailablefunds!
                                                  .toDouble(),
                                              ThemeUtils.whiteBold.copyWith(
                                                  fontSize: FontUtils.large),
                                              ThemeUtils.whiteRegular.copyWith(
                                                  fontSize: FontUtils.small)),
                                          height30(),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () async {
                                                  Utility.settlementWithdrawPeriodAlready =
                                                      false;
                                                  Utility.settlementWithdrawPeriod =
                                                      '';
                                                  await Get.to(() =>
                                                      SettlementWithdrawalScreen());
                                                  initData();
                                                  availBal();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    primary: ColorsUtils.white,
                                                    textStyle: ThemeUtils
                                                        .maroonSemiBold
                                                        .copyWith(
                                                            fontSize: FontUtils
                                                                .verySmall),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12))),
                                                child: Text(
                                                  "settlement".tr,
                                                  style: ThemeUtils
                                                      .maroonSemiBold
                                                      .copyWith(
                                                          fontSize: FontUtils
                                                              .verySmall),
                                                ),
                                              ),
                                              const Expanded(child: SizedBox()),
                                              InkWell(
                                                  child: Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color:
                                                                  Colors.white),
                                                      child: const Padding(
                                                        padding:
                                                            EdgeInsets.all(6),
                                                        child: Icon(
                                                          Icons
                                                              .arrow_forward_ios_rounded,
                                                          color:
                                                              Color(0xff8E1B3E),
                                                          size: 15,
                                                        ),
                                                      )))
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Container(
                              decoration: BoxDecoration(
                                color: ColorsUtils.createInvoiceContainer,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: ColorsUtils.border),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: InkWell(
                                  onTap: () async {
                                    await Get.to(
                                        () => SettlementReportScreen());
                                    initData();
                                  },
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        Images.report,
                                        height: 36,
                                      ),
                                      width20(),
                                      customMediumBoldText(
                                          title: 'Settlement Reports'.tr),
                                      const Spacer(),
                                      const CircleAvatar(
                                        radius: 12,
                                        backgroundColor: ColorsUtils.white,
                                        child: Icon(
                                            Icons.arrow_forward_ios_sharp,
                                            size: 12,
                                            color: ColorsUtils.black),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          height10(),
                          const Divider(),
                          height10(),
                        ],
                      );
                    },
                  ),
                  timeZone(),
                  height20(),
                  tabBar(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          // Container(
                          //   decoration: BoxDecoration(
                          //       color: ColorsUtils.white,
                          //       borderRadius: BorderRadius.circular(10),
                          //       border: Border.all(
                          //           color: ColorsUtils.border, width: 1)),
                          //   child: Padding(
                          //     padding: const EdgeInsets.symmetric(
                          //         vertical: 5, horizontal: 10),
                          //     child: InkWell(
                          //       onTap: () async {
                          //         bottomSelection(context);
                          //         print('sss $filterValue');
                          //
                          //         setState(() {});
                          //       },
                          //       child: Row(
                          //         mainAxisSize: MainAxisSize.min,
                          //         children: [
                          //           customSmallSemiText(
                          //               title: filterValue,
                          //               color: ColorsUtils.black),
                          //           width40(),
                          //           const Icon(
                          //             Icons.keyboard_arrow_down,
                          //             size: 20,
                          //           )
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // ),

                          Spacer(),
                          Container(
                            width: 1,
                            height: 30,
                            color: ColorsUtils.border,
                          ),
                          width20(),
                          InkWell(
                            onTap: () async {
                              await Get.to(() => FilterSettlementScreen(
                                    tab: selectedTab,
                                  ));
                              isPageFirst = true;
                              isTabVisible = false;
                              // tabPosition = _scrollController!.offset;
                              initData();
                            },
                            child: Image.asset(Images.filter,
                                height: 20,
                                color: Utility.settlementWithdrawFilterStatus !=
                                            '' ||
                                        Utility.settlementWithdrawFilterType !=
                                            '' ||
                                        Utility.settlementPayoutFilterStatus !=
                                            '' ||
                                        Utility.settlementPayoutFilterBank != ''
                                    ? ColorsUtils.accent
                                    : ColorsUtils.black),
                          )
                        ],
                      ),
                    ),
                  ),
                  GetBuilder<SettlementWithdrawalListViewModel>(
                    builder: (controller) {
                      if (selectedTab == 0) {
                        if (controller.settlementWithdrawalListApiResponse
                                    .status ==
                                Status.LOADING ||
                            controller.settlementWithdrawalListApiResponse
                                    .status ==
                                Status.INITIAL) {
                          return const Center(child: Loader());
                        }
                      } else {
                        if (controller.settlementPayoutListApiResponse.status ==
                                Status.LOADING ||
                            controller.settlementPayoutListApiResponse.status ==
                                Status.INITIAL) {
                          return const Center(child: Loader());
                        }
                      }

                      if (controller.settlementPayoutListApiResponse.status ==
                              Status.ERROR ||
                          controller
                                  .settlementWithdrawalListApiResponse.status ==
                              Status.ERROR) {
                        return const SessionExpire();
                        // return Text('something wrong');
                      }
                      if (selectedTab == 0) {
                        withdrawalRes =
                            controller.settlementWithdrawalListApiResponse.data;
                      } else {
                        payoutRes =
                            controller.settlementPayoutListApiResponse.data;
                      }

                      return (selectedTab == 0
                                  ? withdrawalRes!.isEmpty ||
                                      withdrawalRes == null
                                  : payoutRes!.isEmpty || payoutRes == null) &&
                              !settlementWithdrawalListViewModel
                                  .isPaginationLoading
                          ? noDataFound()
                          : Column(
                              key: _key,
                              children: [
                                listOfData(),
                                if (settlementWithdrawalListViewModel
                                        .isPaginationLoading &&
                                    !isPageFirst)
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                    child: Center(child: Loader()),
                                  ),
                              ],
                            );
                    },
                  )
                ],
              ),
            ));
      } else {
        return InternetNotFound(
          onTap: () async {
            connectivityViewModel.startMonitoring();

            if (connectivityViewModel.isOnline != null) {
              if (connectivityViewModel.isOnline!) {
                AnalyticsService.sendAppCurrentScreen('Settlement Screen');

                tabController = TabController(length: 2, vsync: this);
                settlementWithdrawalListViewModel.setInit();
                Utility.settlementWithdrawFilterStatus = '';
                Utility.settlementWithdrawFilterType = '';
                Utility.settlementPayoutFilterStatus = '';
                Utility.settlementPayoutFilterBank = '';
                Utility.holdSettlementWithdrawFilterStatus = '';
                Utility.holdSettlementWithdrawFilterType = '';
                Utility.holdSettlementPayoutFilterStatus = '';
                Utility.holdSettlementPayoutFilterBank = '';
                setState(() {});
                availBal();
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
              AnalyticsService.sendAppCurrentScreen('Settlement Screen');

              tabController = TabController(length: 2, vsync: this);
              settlementWithdrawalListViewModel.setInit();
              Utility.settlementWithdrawFilterStatus = '';
              Utility.settlementWithdrawFilterType = '';
              Utility.settlementPayoutFilterStatus = '';
              Utility.settlementPayoutFilterBank = '';
              Utility.holdSettlementWithdrawFilterStatus = '';
              Utility.holdSettlementWithdrawFilterType = '';
              Utility.holdSettlementPayoutFilterStatus = '';
              Utility.holdSettlementPayoutFilterBank = '';
              setState(() {});
              availBal();
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

  Center noDataFound() {
    return Center(
        child: Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Text('No data found'.tr),
    ));
  }

  Widget listOfData() {
    return (selectedTab == 0 ? withdrawalRes!.isEmpty : payoutRes!.isEmpty)
        ? noDataFound()
        : ListView.builder(
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount:
                selectedTab == 0 ? withdrawalRes!.length : payoutRes!.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      selectedTab == 1
                          ? Get.to(() => SettlementPayoutDetailScreen(
                                id: payoutRes![index].id.toString(),
                              ))
                          : Get.to(() => SettlementWithdrawalDetailScreen(
                                id: withdrawalRes![index].id.toString(),
                              ));
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
                              border: Border.all(
                                  color: ColorsUtils.border, width: 1),
                            ),
                            child: Image.network(
                              '${Utility.baseUrl}containers/api-banks/download/${selectedTab == 0 ? withdrawalRes![index].userbank!.bank!.logo : payoutRes![index].withdrawalrequest!.userbank!.bank!.logo}',
                              headers: {HttpHeaders.authorizationHeader: token},
                              fit: BoxFit.contain,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  customSmallBoldText(
                                      title: selectedTab == 0
                                          ? withdrawalRes![index]
                                                  .userbank!
                                                  .bank!
                                                  .name ??
                                              "NA"
                                          : payoutRes![index]
                                                  .withdrawalrequest!
                                                  .userbank!
                                                  .bank!
                                                  .name ??
                                              "NA"),
                                  // Icon(Icons.more_vert)
                                ],
                              ),
                              height5(),
                              Row(
                                children: [
                                  customSmallSemiText(
                                      title:
                                          'ID: ${selectedTab == 0 ? withdrawalRes![index].withdrawnumber ?? "NA" : payoutRes![index].withdrawalrequest!.withdrawnumber ?? "NA"}'),
                                  Spacer(),
                                  (selectedTab == 0 &&
                                          withdrawalRes![index]
                                                  .withdrawaltype
                                                  .toString()
                                                  .toLowerCase() ==
                                              'manual' &&
                                          withdrawalRes![index]
                                                  .withdrawalrequeststatus!
                                                  .name ==
                                              'REQUESTED')
                                      ? InkWell(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return StatefulBuilder(
                                                  builder: (context, setState) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          'Are you sure you want to cancel this withdraw Request ?'
                                                              .tr,
                                                          style: TextStyle(
                                                              fontSize: 14)),
                                                      actions: [
                                                        ElevatedButton(
                                                            onPressed: () {
                                                              Get.back();
                                                            },
                                                            child: Text(
                                                                'Cancel'.tr)),
                                                        ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              cancelWithdrawAPiCall(
                                                                  withdrawalRes![
                                                                          index]
                                                                      .id
                                                                      .toString());
                                                            },
                                                            child:
                                                                Text('Ok'.tr)),
                                                      ],
                                                    );
                                                    // return Dialog(
                                                    //   elevation: 0,
                                                    //
                                                    //   // backgroundColor: Colors.transparent,
                                                    //   insetPadding:
                                                    //       EdgeInsets.symmetric(
                                                    //           horizontal: 20),
                                                    //   shape:
                                                    //       RoundedRectangleBorder(
                                                    //           borderRadius:
                                                    //               BorderRadius
                                                    //                   .circular(
                                                    //                       20.0)),
                                                    //   child: Column(
                                                    //     mainAxisSize:
                                                    //         MainAxisSize.min,
                                                    //     children: [
                                                    //       Container(
                                                    //         decoration:
                                                    //             BoxDecoration(
                                                    //                 borderRadius:
                                                    //                     BorderRadius.circular(
                                                    //                         20),
                                                    //                 // border: Border.all(
                                                    //                 //   color: ColorsUtils.accent,
                                                    //                 //   width: 2,
                                                    //                 // ),
                                                    //                 color: ColorsUtils
                                                    //                     .lightPink),
                                                    //         child: Padding(
                                                    //           padding:
                                                    //               const EdgeInsets
                                                    //                   .all(20),
                                                    //           child: Column(
                                                    //             children: [
                                                    //               customSmallBoldText(
                                                    //                   title:
                                                    //                       'are you sure you want to cancel this withdraw request ?')
                                                    //             ],
                                                    //           ),
                                                    //         ),
                                                    //       )
                                                    //     ],
                                                    //   ),
                                                    // );
                                                  },
                                                );
                                              },
                                            );
                                          },
                                          child: Icon(
                                            Icons.close,
                                            color: ColorsUtils.accent,
                                          ),
                                        )
                                      : SizedBox()
                                ],
                              ),
                              height10(),
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: customSmallSemiText(
                                    title:
                                        '${intl.DateFormat('dd MMM yyyy, HH:mm:ss').format(DateTime.parse(selectedTab == 1 ? payoutRes![index].created.toString() : withdrawalRes![index].created.toString()))}',
                                    color: ColorsUtils.grey),
                              ),
                              height10(),
                              Row(
                                // mainAxisAlignment:
                                //     MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: selectedTab == 0
                                            ? (withdrawalRes![index]
                                                            .withdrawalrequeststatus!
                                                            .name ==
                                                        'REJECTED' ||
                                                    withdrawalRes![index]
                                                            .withdrawalrequeststatus!
                                                            .name ==
                                                        'CANCELLED')
                                                ? ColorsUtils.reds
                                                : withdrawalRes![index]
                                                            .withdrawalrequeststatus!
                                                            .name ==
                                                        'REQUESTED'
                                                    ? ColorsUtils.yellow
                                                    : ColorsUtils.green
                                            : (payoutRes![index]
                                                            .payoutstatus!
                                                            .name ==
                                                        'REJECTED' ||
                                                    payoutRes![index]
                                                            .payoutstatus!
                                                            .name ==
                                                        'CANCELLED')
                                                ? ColorsUtils.reds
                                                : payoutRes![index]
                                                            .payoutstatus!
                                                            .name ==
                                                        'REQUESTED'
                                                    ? ColorsUtils.yellow
                                                    : ColorsUtils.green,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 2),
                                      child: customSmallSemiText(
                                          color: ColorsUtils.white,
                                          title:
                                              '${selectedTab == 0 ? (withdrawalRes![index].withdrawalrequeststatus!.name == 'APPROVED' ? 'ACCEPTED' : withdrawalRes![index].withdrawalrequeststatus!.name == 'IN PROGRESS' ? 'ACCEPTED' : withdrawalRes![index].withdrawalrequeststatus!.name) : payoutRes![index].payoutstatus!.name}'),
                                    ),
                                  ),
                                  Spacer(),
                                  // Image.asset(
                                  //   Images.onlinePayment,
                                  //   width: 25,
                                  // ),
                                  Container(
                                    // width: Get.width * 0.375,
                                    child: customMediumBoldText(
                                        title:
                                            '${selectedTab == 0 ? withdrawalRes![index].amount : payoutRes![index].payoutAmount ?? "0"} QAR',
                                        color: ColorsUtils.accent),
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

  Future<void> cancelWithdrawAPiCall(String? id) async {
    String token = await encryptedSharedPreferences.getString('token');
    final url = Uri.parse(
      '${Utility.baseUrl}withdrawalrequests/$id',
    );
    var body = {"withdrawalrequeststatusId": 6};
    Map<String, String> header = {'Authorization': token};
    print(url);
    print('req::${jsonEncode(body)}');
    var result = await http.patch(
      url,
      body: body,
      headers: header,
    );

    print('token is:$token }  \n response is :${result.body} ');
    if (result.statusCode == 401) {
      SessionExpire();
    }

    if (result.statusCode == 200) {
      print('hiiiii');
      Get.back();
      Get.snackbar('success', 'Withdrawal request has been cancelled!!');
      availBal();
      initData();
    } else {
      Get.back();

      Get.snackbar(
          'error'.tr, '${jsonDecode(result.body)['error']['message']}');
    }
  }

  AppBar appBarData() {
    return AppBar(
      leadingWidth: Get.width * 0.2,
      backgroundColor:
          isTabVisible == true ? Colors.white : ColorsUtils.lightPink,
      // leading: Image.asset(
      //   Images.qrCode,
      //   scale: 2.8,
      // ),
      actions: [
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 10),
        //   child: const Icon(
        //     Icons.more_vert,
        //     color: ColorsUtils.black,
        //   ),
        // )
      ],
      centerTitle: true,
      title: customMediumLargeBoldText(title: 'Settlement'),
      bottom: isTabVisible == true
          ? PreferredSize(
              preferredSize: Size(Get.width, Get.height * 0.125),
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AnimatedBuilder(
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: animation!,
                        child: Column(
                          children: [timeZone(), height10(), tabBar()],
                        ),
                      );
                    },
                    animation: animationController!,
                  )))
          : const PreferredSize(child: SizedBox(), preferredSize: Size(0, 0)),
    );
  }

  Container tabBar() {
    return Container(
      width: Get.width,
      decoration: const BoxDecoration(
        color: ColorsUtils.accent,
      ),
      child: TabBar(
        controller: tabController,
        indicatorColor: ColorsUtils.white,
        onTap: (value) async {
          selectedTab = value;
          isPageFirst = true;
          _scrollController!.animateTo(0.0,
              duration: Duration(microseconds: 200), curve: Curves.ease);
          tabPosition = 0.0;
          setState(() {
            isTabVisible = false;
          });
          initData();
        },
        padding: const EdgeInsets.symmetric(horizontal: 10),
        isScrollable: true,
        labelStyle: ThemeUtils.blackSemiBold
            .copyWith(color: ColorsUtils.white, fontSize: FontUtils.small),
        unselectedLabelColor: ColorsUtils.white,
        labelColor: ColorsUtils.white,
        labelPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
        tabs: [
          Tab(
            text: 'Withdrawals'.tr,
          ),
          Tab(text: 'Payouts'.tr),
        ],
      ),
    );
  }

  bottomSelection(BuildContext context) {
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
                        filterValue = 'All';
                        setState(() {});
                        print(filterValue);
                        Get.back();
                      },
                      child: customSmallMedBoldText(title: 'All Withdrawals')),
                  height20(),
                  InkWell(
                      onTap: () {
                        filterValue = 'Online';
                        setState(() {});
                        print(filterValue);

                        Get.back();
                      },
                      child: customSmallMedBoldText(
                          title: 'Online Payment Withdrawals')),
                  height20(),
                  InkWell(
                      onTap: () {
                        filterValue = 'POS';
                        setState(() {});
                        print(filterValue);

                        Get.back();
                      },
                      child: customSmallMedBoldText(title: 'POS Withdrawals')),
                  height40(),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget timeZone() {
    return SizedBox(
      height: 25,
      width: Get.width,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: StaticData().timeZone.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: index == 0 && Get.locale!.languageCode == 'en'
                ? const EdgeInsets.only(left: 20, right: 5)
                : index == StaticData().timeZone.length - 1 &&
                        Get.locale!.languageCode == 'en'
                    ? const EdgeInsets.only(right: 20, left: 5)
                    : const EdgeInsets.symmetric(horizontal: 5),
            child: InkWell(
              onTap: () async {
                selectedTimeZone.clear();
                startDate = '';
                endDate = '';

                selectedTimeZone.add(StaticData().timeZone[index]);
                if (selectedTimeZone.contains('Custom')) {
                  startDate = '';
                  endDate = '';

                  selectedTimeZone.clear();
                  await datePicker(context);
                  if (startDate != '' && endDate != '') {
                    selectedTimeZone.add('Custom');
                    filterDate =
                        '&filter[where][created][between][0]=$startDate&filter[where][created][between][1]=$endDate';
                    print('filter date=$filterDate');
                    initData();
                  }
                } else {
                  startDate = '';
                  endDate = '';
                  final now = DateTime.now();
                  endDate = selectedTimeZone.first == 'Yesterday'
                      ? intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime(
                          now.year, now.month, now.day - 1, 23, 59, 59))
                      : intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(
                          DateTime(now.year, now.month, now.day, 23, 59, 59));
                  selectedTimeZone.first == 'Today'
                      ? startDate = intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(
                          DateTime(now.year, now.month, now.day, 00, 00, 00))
                      : selectedTimeZone.first == 'Yesterday'
                          ? startDate = intl.DateFormat('yyyy-MM-dd HH:mm:ss')
                              .format(DateTime(
                                  now.year, now.month, now.day - 1, 00, 00, 00))
                          : selectedTimeZone.first == 'Week'
                              ? startDate =
                                  intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(
                                      DateTime(now.year, now.month, now.day - 6,
                                          00, 00, 00))
                              : selectedTimeZone.first == 'Month'
                                  ? startDate =
                                      intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(
                                          DateTime(now.year, now.month - 1, now.day, 00, 00, 00))
                                  : selectedTimeZone.first == 'Year'
                                      ? startDate = intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime(now.year, now.month, now.day - 365, 00, 00, 00))
                                      : '';

                  filterDate = selectedTimeZone.first == 'All'
                      ? ""
                      : '&filter[where][created][between][0]=$startDate&filter[where][created][between][1]=$endDate';
                  print('filterDate::$filterDate');
                  _range = '';
                  initData();
                }
                setState(() {});
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color:
                        selectedTimeZone.contains(StaticData().timeZone[index])
                            ? ColorsUtils.primary
                            : ColorsUtils.white),
                child: Center(
                  child: Text(
                    index == 6
                        ? _range == ''
                            ? StaticData().timeZone[index].tr
                            : '$_range'
                        : StaticData().timeZone[index].tr,
                    style: ThemeUtils.maroonSemiBold.copyWith(
                        fontSize: FontUtils.verySmall,
                        color: selectedTimeZone
                                .contains(StaticData().timeZone[index])
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
          _range = '';
          startDate = '';
          endDate = '';
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
                                onSelectionChanged:
                                    (dateRangePickerSelectionChangedArgs) {
                                  if (dateRangePickerSelectionChangedArgs.value
                                      is PickerDateRange) {
                                    _range =
                                        '${intl.DateFormat('dd/MM/yyyy').format(dateRangePickerSelectionChangedArgs.value.startDate)} -'
                                        ' ${intl.DateFormat('dd/MM/yyyy').format(dateRangePickerSelectionChangedArgs.value.endDate ?? dateRangePickerSelectionChangedArgs.value.startDate)}';
                                  }
                                  if (dateRangePickerSelectionChangedArgs
                                              .value.endDate ==
                                          null ||
                                      dateRangePickerSelectionChangedArgs
                                              .value.endDate ==
                                          '') {
                                    '';
                                  } else {
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
                                    DateTime.now()
                                        .subtract(const Duration(days: 7)),
                                    DateTime.now()),
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
                                        'SelectedDates: '.tr,
                                        style: ThemeUtils.blackBold.copyWith(
                                            fontSize: FontUtils.verySmall),
                                      ),
                                      Text(
                                        _range,
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
                                        Get.back();
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
                                        startDate = '';
                                        endDate = '';
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

  initData() async {
    token = await encryptedSharedPreferences.getString('token');

    print('hiiii');
    String id = await encryptedSharedPreferences.getString('id');

    settlementWithdrawalListViewModel.clearResponseList();

    await apiCall(id);
    print('filter Date is $filterDate');
    scrollApiData(id);
    // _scrollController!.removeListener(() {});
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Future.delayed(const Duration(seconds: 1), () {
        print('go to pos');
        getPosition();
      });
    });

    if (isPageFirst == true) {
      isPageFirst = false;
    }
  }

  // void animationScrollData() async {
  //   Utility.settlementWithdrawFilterStatus = '';
  //   Utility.settlementWithdrawFilterType = '';
  //   animationController =
  //       AnimationController(vsync: this, duration: const Duration(seconds: 2));
  //   animation = Tween(begin: 0.0, end: 1.0).animate(animationController!);
  //
  //   _scrollController = ScrollController()
  //     ..addListener(() {
  //       print(
  //           'curr pos ${_scrollController!.position.pixels} pos $tabPosition');
  //       if (_scrollController!.position.pixels >= (tabPosition! - 30)) {
  //         if (!isTabVisible) {
  //           setState(() {
  //             isTabVisible = true;
  //             animationController!.forward();
  //           });
  //         }
  //       } else {
  //         if (isTabVisible) {
  //           setState(() {
  //             isTabVisible = false;
  //             animationController!.reverse();
  //           });
  //         }
  //         // print(isTabVisible);
  //       }
  //     });
  // }

  scrollApiData(String id) {
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    animation = Tween(begin: 0.0, end: 1.0).animate(animationController!);

    _scrollController = ScrollController()
      ..addListener(() {
        // print(
        //     'curr pos ${_scrollController!.position.pixels} pos $tabPosition');

        if (_scrollController!.position.maxScrollExtent ==
                _scrollController!.offset &&
            !settlementWithdrawalListViewModel.isPaginationLoading) {
          selectedTab == 0
              ? settlementWithdrawalListViewModel.settlementWithdrawalList(
                  filter: filterDate +
                      Utility.settlementWithdrawFilterType +
                      Utility.settlementWithdrawFilterStatus,
                  id: id,
                  isLoading: false)
              : settlementWithdrawalListViewModel.settlementPayoutList(
                  filter: filterDate +
                      Utility.settlementPayoutFilterBank +
                      (Utility.settlementPayoutFilterStatus == ''
                          ? "&filter[where][payoutstatusId][inq][0]=3&filter[where][payoutstatusId][inq][1]=4"
                          : Utility.settlementPayoutFilterStatus),
                  id: id,
                  isLoading: false);
        }
        if (_scrollController!.position.pixels >= (tabPosition! - 30) &&
            (tabPosition ?? 0.0) > 0.0) {
          if (!isTabVisible) {
            setState(() {
              isTabVisible = true;
              animationController!.forward();
            });
          }
          print(
              "isTabVisible:=>1$isTabVisible tabPosition:$tabPosition scroll pos:${_scrollController!.position.pixels}");
        } else {
          if (isTabVisible) {
            setState(() {
              isTabVisible = false;
              animationController!.reverse();
            });
          }
          print(
              "isTabVisible:=>2$isTabVisible tabPosition:$tabPosition scroll pos:${_scrollController!.position.pixels}");
        }
      });
  }

  void getPosition() {
    try {
      if (_key.currentContext == null) {
        print('null state');
        return;
      }
      RenderBox? box = _key.currentContext!.findRenderObject() as RenderBox?;
      Offset position =
          box!.localToGlobal(Offset.zero); //this is global position
      double y = position.dy;
      print("key  y position: " + y.toString());
      tabPosition = y;

      setState(() {
        isTabVisible = false;
      });
    } on Exception catch (e) {
      print('error $e');
      // TODO
    }
  }

  apiCall(String id) async {
    ///api calling.......

    if (selectedTab == 0) {
      print('page1 ');
      await settlementWithdrawalListViewModel.settlementWithdrawalList(
          filter: filterDate +
              Utility.settlementWithdrawFilterType +
              Utility.settlementWithdrawFilterStatus,
          id: id,
          isLoading: true);
    } else {
      print('page2');
      print('filter date $filterDate');
      await settlementWithdrawalListViewModel.settlementPayoutList(
          filter: filterDate +
              Utility.settlementPayoutFilterBank +
              (Utility.settlementPayoutFilterStatus == ''
                  ? "&filter[where][payoutstatusId][inq][0]=3&filter[where][payoutstatusId][inq][1]=4"
                  : Utility.settlementPayoutFilterStatus),
          id: id,
          isLoading: true);
    }
  }

  void availBal() async {
    String id = await encryptedSharedPreferences.getString('id');
    await dashBoardViewModel.availableBalance(id);
  }
}
