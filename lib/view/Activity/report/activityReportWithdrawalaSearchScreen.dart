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
import 'package:sadad_merchat_app/model/apimodels/responseModel/Activity/balanceListResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/downloadFile.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/Activity/activityPosRendtalDetailScreen.dart';
import 'package:sadad_merchat_app/view/Activity/activityTransactionDetailScreen.dart';
import 'package:sadad_merchat_app/view/Activity/report/activityReportFilterScreen.dart';
import 'package:sadad_merchat_app/view/Activity/withdrawal/activityWithdrawalDetailScreen.dart';
import 'package:sadad_merchat_app/viewModel/Activity/activityReport.dart';
import 'package:sadad_merchat_app/viewModel/Activity/activityViewModel.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';

class ActivityWithdrawalSearchScreen extends StatefulWidget {
  final String? startDate;
  final int? isRadioSelected;
  final String? endDate;
  ActivityWithdrawalSearchScreen(
      {Key? key, this.startDate, this.endDate, this.isRadioSelected})
      : super(key: key);

  @override
  State<ActivityWithdrawalSearchScreen> createState() =>
      _ActivityReportListScreenState();
}

class _ActivityReportListScreenState
    extends State<ActivityWithdrawalSearchScreen> {
  ConnectivityViewModel connectivityViewModel = Get.find();

  ScrollController? _scrollController;
  ActivityViewModel activityViewModel = Get.find();
  BalanceListResponseModel balanceListRes = BalanceListResponseModel();
  String? searchKey;
  TextEditingController search = TextEditingController();
  List<GetSubUserNamesResponseModel>? getSubUserList;
  String filterDate = '';
  String token = '';
  String searchFilter = '';

  bool isPageFirst = true;
  String email = '';
  int isRadioSelected = 0;
  bool sendEmail = false;
  ActivityReportViewModel activityReportViewModel = Get.find();
  List<Data>? withdrawalRes;
  List<DataTransaction> transactionResponse = [];
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      activityReportViewModel.setInit();
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
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: TextField(
                    onChanged: (value) async {
                      searchKey = value;
                      setState(() {});
                    },
                    controller: search,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(0.0),
                        isDense: true,
                        prefixIcon: Image.asset(
                          Images.search,
                          scale: 3,
                        ),
                        suffixIcon: search.text.isEmpty
                            ? const SizedBox()
                            : InkWell(
                                onTap: () {
                                  search.clear();
                                },
                                child: const Icon(
                                  Icons.cancel_rounded,
                                  color: ColorsUtils.border,
                                  size: 25,
                                ),
                              ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: ColorsUtils.border, width: 1)),
                        hintText: 'ex. Bank name, Id',
                        hintStyle: ThemeUtils.blackRegular.copyWith(
                            color: ColorsUtils.grey,
                            fontSize: FontUtils.small)),
                  ),
                ),
              ),
              search.text.isEmpty ? const SizedBox() : width10(),
              search.text.isEmpty
                  ? const SizedBox()
                  : InkWell(
                      onTap: () async {
                        await Get.to(
                            () => ActivityReportFilterWithdrawalScreen());
                        activityReportViewModel.setInit();
                        initData();
                      },
                      child: Image.asset(
                        Images.filter,
                        height: 20,
                        width: 20,
                        color: Utility
                                    .deviceFilterCountDeviceStatus.isNotEmpty ||
                                Utility.deviceFilterCountDeviceType.isNotEmpty
                            ? ColorsUtils.accent
                            : ColorsUtils.black,
                      )),
            ],
          ),
        ),
        search.text.isEmpty
            ? Expanded(child: Center(child: Text('No data found'.tr)))
            : Expanded(
                child: Column(
                  children: [
                    height10(),
                    Container(
                        height: 1, width: Get.width, color: ColorsUtils.border),
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
                                withdrawalRes == null || withdrawalRes!.isEmpty
                                    ? Get.showSnackbar(GetSnackBar(
                                        message: 'No Data Found'.tr,
                                      ))
                                    : exportBottomSheet();
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
                                        style: ThemeUtils.blackSemiBold
                                            .copyWith(
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
                    Container(
                        height: 1, width: Get.width, color: ColorsUtils.border),
                    height20(),
                    widget.isRadioSelected == 2
                        ? Expanded(
                            child: GetBuilder<ActivityViewModel>(
                              builder: (controller) {
                                if (controller.balanceListApiResponse.status ==
                                        Status.LOADING ||
                                    controller.balanceListApiResponse.status ==
                                        Status.INITIAL) {
                                  return Loader();
                                }
                                if (controller.balanceListApiResponse.status ==
                                    Status.ERROR) {
                                  // return Center(child: Text('Error'));
                                  return SessionExpire();
                                }

                                balanceListRes.data = controller.response;
                                if (balanceListRes.data == null ||
                                    balanceListRes.data == []) {
                                  return Center(child: Text('No data found'));
                                }
                                return ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: balanceListRes.data!.length > 2
                                      ? 3
                                      : balanceListRes.data!.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    if (searchKey != null && searchKey != "") {
                                      if (balanceListRes
                                          .data![index].transactionId
                                          .toString()
                                          .toLowerCase()
                                          .contains(searchKey!.toLowerCase())) {
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                              child: InkWell(
                                                onTap: () {
                                                  print(
                                                      '===>${balanceListRes.data![index].txnSource}');
                                                  // Sadad Service Charge SADAD Paid Services
                                                  if (balanceListRes
                                                              .data![index]
                                                              .txnSource !=
                                                          'Sadad Service Charge' ||
                                                      balanceListRes
                                                              .data![index]
                                                              .txnSource !=
                                                          'SADAD Paid Services') {
                                                    if (balanceListRes
                                                                .data![index]
                                                                .txnSource ==
                                                            'Settlement Withdrawal' ||
                                                        balanceListRes
                                                                .data![index]
                                                                .txnSource ==
                                                            'Withdrawal') {
                                                      Get.to(() =>
                                                          ActivityWithdrawalDetailScreen(
                                                            id: balanceListRes
                                                                .data![index]
                                                                .transactionId
                                                                .toString(),
                                                          ));
                                                    } else if (balanceListRes
                                                            .data![index]
                                                            .txnSource ==
                                                        'POS Rental') {
                                                      Get.to(() =>
                                                          ActivityPosRentalTransactionScreen(
                                                            id: balanceListRes
                                                                .data![index]
                                                                .transactionId
                                                                .toString(),
                                                          ));
                                                    } else {
                                                      Get.to(() =>
                                                          ActivityTransactionDetailScreen(
                                                            id: balanceListRes
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
                                                        color: ColorsUtils
                                                            .tabUnselect
                                                            .withOpacity(0.5),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: Image.asset(
                                                            Images.invoice,
                                                            width: Get.width *
                                                                0.06),
                                                      ),
                                                    ),
                                                    width10(),
                                                    Expanded(
                                                        child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            customSmallBoldText(
                                                                title:
                                                                    '${balanceListRes.data![index].txnSource ?? "NA"}'),
                                                            Spacer(),
                                                            customSmallBoldText(
                                                                color:
                                                                    ColorsUtils
                                                                        .accent,
                                                                title:
                                                                    '${balanceListRes.data![index].txnAmount} QAR')
                                                          ],
                                                        ),
                                                        height5(),
                                                        customVerySmallNorText(
                                                            title:
                                                                '${balanceListRes.data![index].txnType ?? 'NA'}'),
                                                        height5(),
                                                        Row(
                                                          children: [
                                                            customVerySmallNorText(
                                                                title:
                                                                    'ID: ${balanceListRes.data![index].transactionId ?? "NA"}',
                                                                color:
                                                                    ColorsUtils
                                                                        .grey),
                                                            Spacer(),
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                border:
                                                                    Border.all(
                                                                  color: (balanceListRes.data![index].paymentIn ==
                                                                              null ||
                                                                          balanceListRes.data![index].paymentIn ==
                                                                              '0.00')
                                                                      ? ColorsUtils
                                                                          .reds
                                                                      : ColorsUtils
                                                                          .green,
                                                                ),
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  CircleAvatar(
                                                                    backgroundColor: (balanceListRes.data![index].paymentIn ==
                                                                                null ||
                                                                            balanceListRes.data![index].paymentIn ==
                                                                                '0.00')
                                                                        ? ColorsUtils
                                                                            .reds
                                                                        : ColorsUtils
                                                                            .green,
                                                                    radius: 10,
                                                                    child: Icon(
                                                                        (balanceListRes.data![index].paymentIn == null || balanceListRes.data![index].paymentIn == '0.00')
                                                                            ? Icons
                                                                                .arrow_back_outlined
                                                                            : Icons
                                                                                .arrow_forward_outlined,
                                                                        size:
                                                                            15,
                                                                        color: ColorsUtils
                                                                            .white),
                                                                  ),
                                                                  width10(),
                                                                  customVerySmallNorText(
                                                                      color: (balanceListRes.data![index].paymentIn == null ||
                                                                              balanceListRes.data![index].paymentIn ==
                                                                                  '0.00')
                                                                          ? ColorsUtils
                                                                              .reds
                                                                          : ColorsUtils
                                                                              .green,
                                                                      title: (balanceListRes.data![index].paymentIn == '0.00' ||
                                                                              balanceListRes.data![index].paymentIn == null)
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
                                      }
                                    }
                                    return SizedBox();
                                  },
                                );
                              },
                            ),
                          )
                        : Expanded(
                            child: SingleChildScrollView(
                              controller: _scrollController,
                              child: GetBuilder<ActivityReportViewModel>(
                                builder: (controller) {
                                  if (controller
                                              .settlementWithdrawalListApiResponse
                                              .status ==
                                          Status.LOADING ||
                                      controller
                                              .settlementWithdrawalListApiResponse
                                              .status ==
                                          Status.INITIAL) {
                                    return const Center(child: Loader());
                                  }

                                  if (controller
                                          .settlementWithdrawalListApiResponse
                                          .status ==
                                      Status.ERROR) {
                                    return const SessionExpire();
                                    //return Text('something wrong');
                                  }

                                  if (controller
                                          .settlementWithdrawalListApiResponse
                                          .status ==
                                      Status.COMPLETE) {
                                    // print(
                                    //     'res===${jsonEncode(controller.settlementWithdrawalListApiResponse.data)}');
                                    withdrawalRes = controller
                                        .settlementWithdrawalListApiResponse
                                        .data;
                                  }

                                  return withdrawalRes!.isEmpty &&
                                          !activityReportViewModel
                                              .isPaginationLoading
                                      ? Center(
                                          child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 50),
                                          child: Text('No data found'.tr),
                                        ))
                                      : Column(
                                          children: [
                                            listOfDataWithdrawal(),
                                            // Expanded(
                                            //   child: ListView.builder(
                                            //     controller: _scrollController,
                                            //     padding: EdgeInsets.zero,
                                            //     itemCount: transactionResponse.length,
                                            //     shrinkWrap: true,
                                            //     // physics: NeverScrollableScrollPhysics(),
                                            //     itemBuilder: (context, index) {
                                            //       return Column(
                                            //         children: [
                                            //           Container(
                                            //             width: Get.width,
                                            //             decoration: BoxDecoration(
                                            //               color: ColorsUtils.tabUnselect,
                                            //             ),
                                            //             child: Padding(
                                            //               padding: const EdgeInsets.all(10),
                                            //               child: customVerySmallSemiText(
                                            //                   title:
                                            //                       '${transactionResponse[index].transactionDateTime}'),
                                            //             ),
                                            //           ),
                                            //           Padding(
                                            //             padding: const EdgeInsets.symmetric(
                                            //                 horizontal: 20, vertical: 20),
                                            //             child: InkWell(
                                            //               onTap: () {
                                            //                 print(
                                            //                     '===>${transactionResponse[index].transactionSource}');
                                            //                 if (transactionResponse[index]
                                            //                             .transactionSource ==
                                            //                         'Settlement Withdrawal' ||
                                            //                     transactionResponse[index]
                                            //                             .transactionSource ==
                                            //                         'Withdrawal') {
                                            //                   // Get.to(
                                            //                   //         () => ActivityWithdrawalDetailScreen(
                                            //                   //       id: balanceListRes
                                            //                   //           .data![index].transactionId
                                            //                   //           .toString(),
                                            //                   //     ));
                                            //                 } else if (transactionResponse[index]
                                            //                         .transactionSource ==
                                            //                     'POS Rental') {
                                            //                   // Get.to(() =>
                                            //                   //     ActivityPosRentalTransactionScreen(
                                            //                   //       id: balanceListRes
                                            //                   //           .data![index].transactionId
                                            //                   //           .toString(),
                                            //                   //     ));
                                            //                 } else if (transactionResponse[index]
                                            //                         .transactionSource ==
                                            //                     'SADAD Paid Services') {
                                            //                   print('no route');
                                            //                 } else if (transactionResponse[index]
                                            //                         .transactionSource ==
                                            //                     'Merchant Rewards') {
                                            //                   print('no route');
                                            //                 } else {
                                            //                   // Get.to(
                                            //                   //         () => ActivityTransactionDetailScreen(
                                            //                   //       id: balanceListRes
                                            //                   //           .data![index].transactionId
                                            //                   //           .toString(),
                                            //                   //     ));
                                            //                 }
                                            //               },
                                            //               child: Row(
                                            //                 crossAxisAlignment:
                                            //                     CrossAxisAlignment.start,
                                            //                 children: [
                                            //                   Container(
                                            //                     decoration: BoxDecoration(
                                            //                       color: ColorsUtils.tabUnselect
                                            //                           .withOpacity(0.5),
                                            //                       borderRadius:
                                            //                           BorderRadius.circular(15),
                                            //                     ),
                                            //                     child: Padding(
                                            //                       padding:
                                            //                           const EdgeInsets.all(10.0),
                                            //                       child: Image.asset(
                                            //                           Images.invoice,
                                            //                           width: Get.width * 0.06),
                                            //                     ),
                                            //                   ),
                                            //                   width10(),
                                            //                   Expanded(
                                            //                       child: Column(
                                            //                     crossAxisAlignment:
                                            //                         CrossAxisAlignment.start,
                                            //                     mainAxisAlignment:
                                            //                         MainAxisAlignment.start,
                                            //                     children: [
                                            //                       Row(
                                            //                         children: [
                                            //                           customSmallBoldText(
                                            //                               title:
                                            //                                   '${transactionResponse[index].transactionSource ?? "NA"}'),
                                            //                           Spacer(),
                                            //                           customSmallBoldText(
                                            //                               color:
                                            //                                   ColorsUtils.accent,
                                            //                               title:
                                            //                                   '${transactionResponse[index].transactionAmount} QAR')
                                            //                         ],
                                            //                       ),
                                            //                       height5(),
                                            //                       customVerySmallNorText(
                                            //                           title:
                                            //                               '${transactionResponse[index].transactionType ?? 'NA'}'),
                                            //                       height5(),
                                            //                       // Row(
                                            //                       //   children: [
                                            //                       //     customVerySmallNorText(
                                            //                       //         title:
                                            //                       //             'ID: ${transactionResponse[index].transactionId ?? "NA"}',
                                            //                       //         color:
                                            //                       //             ColorsUtils.grey),
                                            //                       //     Spacer(),
                                            //                       //     Container(
                                            //                       //       decoration: BoxDecoration(
                                            //                       //         borderRadius:
                                            //                       //             BorderRadius
                                            //                       //                 .circular(20),
                                            //                       //         border: Border.all(
                                            //                       //           color: (transactionResponse[
                                            //                       //                               index]
                                            //                       //                           .paymentIn ==
                                            //                       //                       null ||
                                            //                       //                   transactionResponse[
                                            //                       //                               index]
                                            //                       //                           .paymentIn ==
                                            //                       //                       '0.00')
                                            //                       //               ? ColorsUtils.reds
                                            //                       //               : ColorsUtils
                                            //                       //                   .green,
                                            //                       //         ),
                                            //                       //       ),
                                            //                       //       child: Row(
                                            //                       //         children: [
                                            //                       //           CircleAvatar(
                                            //                       //             backgroundColor: (transactionResponse[index]
                                            //                       //                             .paymentIn ==
                                            //                       //                         null ||
                                            //                       //                     transactionResponse[index]
                                            //                       //                             .paymentIn ==
                                            //                       //                         '0.00')
                                            //                       //                 ? ColorsUtils
                                            //                       //                     .reds
                                            //                       //                 : ColorsUtils
                                            //                       //                     .green,
                                            //                       //             radius: 10,
                                            //                       //             child: Icon(
                                            //                       //                 (transactionResponse[index].paymentIn ==
                                            //                       //                             null ||
                                            //                       //                         transactionResponse[index].paymentIn ==
                                            //                       //                             '0.00')
                                            //                       //                     ? Icons
                                            //                       //                         .arrow_back_outlined
                                            //                       //                     : Icons
                                            //                       //                         .arrow_forward_outlined,
                                            //                       //                 size: 15,
                                            //                       //                 color:
                                            //                       //                     ColorsUtils
                                            //                       //                         .white),
                                            //                       //           ),
                                            //                       //           width10(),
                                            //                       //           customVerySmallNorText(
                                            //                       //               color: (transactionResponse[index]
                                            //                       //                               .paymentIn ==
                                            //                       //                           null ||
                                            //                       //                       transactionResponse[index]
                                            //                       //                               .paymentIn ==
                                            //                       //                           '0.00')
                                            //                       //                   ? ColorsUtils
                                            //                       //                       .reds
                                            //                       //                   : ColorsUtils
                                            //                       //                       .green,
                                            //                       //               title: (transactionResponse[index]
                                            //                       //                               .paymentIn ==
                                            //                       //                           null ||
                                            //                       //                       transactionResponse[index]
                                            //                       //                               .paymentIn ==
                                            //                       //                           '0.00')
                                            //                       //                   ? 'Payment Out'
                                            //                       //                   : 'Payment In'),
                                            //                       //           width10(),
                                            //                       //         ],
                                            //                       //       ),
                                            //                       //     )
                                            //                       //   ],
                                            //                       // ),
                                            //                     ],
                                            //                   )),
                                            //                 ],
                                            //               ),
                                            //             ),
                                            //           )
                                            //         ],
                                            //       );
                                            //     },
                                            //   ),
                                            // ),
                                            if (activityReportViewModel
                                                    .isPaginationLoading &&
                                                isPageFirst)
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 20),
                                                child: Center(child: Loader()),
                                              ),
                                            if (activityReportViewModel
                                                    .isPaginationLoading &&
                                                !isPageFirst)
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 20),
                                                child: Center(child: Loader()),
                                              ),
                                          ],
                                        );
                                },
                              ),
                            ),
                          )
                  ],
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
              : activityReportViewModel.allTransactionList(
                  filter: filterDate,
                  isLoading: false,
                );
        }
      });
  }

  void apiCall(String id) async {
    ///api calling.......

    print('page1 ');

    if (widget.isRadioSelected == 1) {
      // await activityReportViewModel.getSubUser();
      //
      // if (activityReportViewModel.activityGetSubUserApiResponse.status ==
      //     Status.COMPLETE) {
      //   getSubUserList =
      //       activityReportViewModel.activityGetSubUserApiResponse.data;
      //   setState(() {});
      // }

      await activityReportViewModel.withdrawalList(
          filter: filterDate +
              Utility.activityReportSettlementWithdrawFilterType +
              Utility.activityReportSettlementPayoutFilterStatus +
              Utility.activityReportSettlementPayoutFilterBank +
              Utility.activityReportSettlementWithdrawFilterStatus +
              Utility.activityReportGetSubUSer,
          filterType: 'settlementReports');
    } else {
      await activityViewModel.balanceList(filter: '&filter[date]=year');
      await activityReportViewModel.allTransactionList(
        filter: filterDate,
      );
    }
  }

  ListView listOfDataWithdrawal() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: withdrawalRes!.length,
      itemBuilder: (context, index) {
        if (searchKey != null && searchKey != "") {
          if (withdrawalRes![index]
                  .withdrawalRequestId
                  .toString()
                  .toLowerCase()
                  .contains(searchKey!.toLowerCase()) ||
              withdrawalRes![index]
                  .bankName
                  .toString()
                  .toLowerCase()
                  .contains(searchKey!.toLowerCase())) {
            return Column(
              children: [
                InkWell(
                  onTap: () {
                    Get.to(() => ActivityWithdrawalDetailScreen(
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
                            border:
                                Border.all(color: ColorsUtils.border, width: 1),
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
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
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
                                    title:
                                        withdrawalRes![index].bankName ?? "NA"),
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
          }
        }
        return SizedBox();
      },
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
                              '${Utility.baseUrl}reporthistories/settlementReports?filter[where][created][between][0]=${intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(widget.startDate!))}$searchFilter&filter[where][created][between][1]=${intl.DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.endDate!))} 23:59:59${Utility.activityReportSettlementWithdrawFilterType + Utility.activityReportSettlementPayoutFilterStatus + Utility.activityReportSettlementPayoutFilterBank + Utility.activityReportSettlementWithdrawFilterStatus + Utility.activityReportGetSubUSer}&filter[order]=created%20DESC&${isRadioSelected == 1 ? 'isPdf' : isRadioSelected == 2 ? 'isCsv' : 'isExcel'}=true&isEmail=true',
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
                                  '${Utility.baseUrl}reporthistories/settlementReports?filter[where][created][between][0]=${intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(widget.startDate!))}$searchFilter&filter[where][created][between][1]=${intl.DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.endDate!))} 23:59:59${Utility.activityReportSettlementWithdrawFilterType + Utility.activityReportSettlementPayoutFilterStatus + Utility.activityReportSettlementPayoutFilterBank + Utility.activityReportSettlementWithdrawFilterStatus + Utility.activityReportGetSubUSer}&filter[order]=created%20DESC&${isRadioSelected == 1 ? 'isPdf' : isRadioSelected == 2 ? 'isCsv' : 'isExcel'}=true',
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
