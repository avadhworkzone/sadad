// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/terminal/terminalCountResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/terminal/terminalListResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/pos/terminals/editTerminalName.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:sadad_merchat_app/viewModel/pos/terminal/terminalViewModel.dart';

import 'terminalDetailScreen.dart';
import 'terminalFilterScreen.dart';

class PosTerminalSearchScreen extends StatefulWidget {
  const PosTerminalSearchScreen({Key? key}) : super(key: key);

  @override
  State<PosTerminalSearchScreen> createState() =>
      _PosTerminalSearchScreenState();
}

class _PosTerminalSearchScreenState extends State<PosTerminalSearchScreen> {
  int differenceDays = 0;
  bool isTabVisible = false;
  String _range = '';
  ScrollController? _scrollController;
  String startDate = '';
  String filter = '';
  String countFilter = '';
  GlobalKey _key = GlobalKey();
  String endDate = '';
  bool isPageFirst = false;
  bool isFirstTime = true;
  bool isExpand = false;
  String dropDownValue = 'Transaction ID';
  bool _customTileExpanded = false;
  var items = [
    'Transaction ID',
    'Terminal Id',
    'Transaction Amount',
    'Card Number',
    'RRN',
  ];
  TerminalViewModel terminalViewModel = Get.find();
  EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences();
  List<String> selectedTimeZone = ['All'];
  int selectedTab = 0;
  List<TerminalListResponseModel>? terminalListRes;
  TerminalCountResponseModel? terminalCountResponseModel;
  String? searchKey;
  TextEditingController search = TextEditingController();
  ConnectivityViewModel connectivityViewModel = Get.find();
  @override
  void initState() {
    connectivityViewModel.startMonitoring();
    // terminalViewModel.setTerminalInit();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      terminalViewModel.terminalListApiResponse =
          ApiResponse.loading('Loading');
      initData();
    });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (connectivityViewModel.isOnline != null) {
      if (connectivityViewModel.isOnline!) {
        return Scaffold(
          body: GetBuilder<TerminalViewModel>(
            builder: (controller) {
              if (controller.terminalListApiResponse.status == Status.LOADING ||
                  controller.terminalCountApiResponse.status ==
                      Status.LOADING) {
                return const Center(child: Loader());
              }
              if (controller.terminalListApiResponse.status == Status.ERROR ||
                  controller.terminalCountApiResponse.status == Status.ERROR) {
                return const SessionExpire();
                // return const Center(child: Text('Error'));
              }

              terminalListRes = terminalViewModel.terminalListApiResponse.data;
              terminalCountResponseModel =
                  terminalViewModel.terminalCountApiResponse.data;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    height60(),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      //crossAxisAlignment: CrossAxisAlignment.start,
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
                                isFirstTime = false;
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
                                  hintText: 'ex. Transaction Id, amount'.tr,
                                  hintStyle: ThemeUtils.blackRegular.copyWith(
                                      color: ColorsUtils.grey,
                                      fontSize: FontUtils.small)),
                            ),
                          ),
                        ),
                        // search.text.isEmpty ?
                        // const SizedBox() :
                        width10(),
                        // search.text.isEmpty
                        //     ? SizedBox()
                        //     :
                        InkWell(
                            onTap: () async {
                              await Get.to(() => const TerminalFilterScreen());
                              initData(isLoading: true);
                            },
                            child: Image.asset(Images.filter,
                                height: 20,
                                width: 20,
                                color: Utility.terminalFilterTransModes
                                            .isNotEmpty ||
                                        Utility.terminalFilterTransStatus
                                            .isNotEmpty ||
                                        Utility.terminalFilterDeviceStatus
                                            .isNotEmpty ||
                                        Utility.terminalFilterPaymentMethod
                                            .isNotEmpty
                                    ? ColorsUtils.accent
                                    : ColorsUtils.black)),
                      ],
                    ),
                    // search.text.isEmpty
                    //     ? Expanded(
                    //         child: Center(
                    //             child: Text(isFirstTime == false
                    //                 ? 'No data found'.tr
                    //                 : '')))
                    //     :
                    Expanded(
                        child: Column(
                      children: [
                        height20(),
                        searchKey != null && searchKey != ""
                            ? Align(
                                alignment: Alignment.centerRight,
                                child: customSmallSemiText(
                                    title:
                                        // '${terminalCountResponseModel!.count ?? '0'} Terminals',
                                        '${getCount(terminalListRes)} ${'Terminal'.tr}'
                                            .tr,
                                    color: ColorsUtils.black))
                            : Align(
                                alignment: Alignment.centerRight,
                                child: customSmallSemiText(
                                    title:
                                        // '${terminalCountResponseModel!.count ?? '0'} Terminals',
                                        '${getAllCount(terminalListRes)} ${'Terminal'.tr}'
                                            .tr,
                                    color: ColorsUtils.black)),
                        height10(),
                        terminalListRes!.isEmpty &&
                                !terminalViewModel.isPaginationLoading
                            ? Center(child: Text('No data found'.tr))
                            : Expanded(
                                child: ListView.builder(
                                  controller: _scrollController,
                                  key: _key,
                                  padding: EdgeInsets.zero,
                                  itemCount: terminalListRes!.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    if (searchKey != null && searchKey != "") {
                                      if (terminalListRes![index]
                                              .terminalId
                                              .toString()
                                              .toLowerCase()
                                              .contains(
                                                  searchKey!.toLowerCase()) ||
                                          terminalListRes![index]
                                              .name
                                              .toString()
                                              .toLowerCase()
                                              .contains(
                                                  searchKey!.toLowerCase()) ||
                                          terminalListRes![index]
                                              .zone
                                              .toString()
                                              .toLowerCase()
                                              .contains(
                                                  searchKey!.toLowerCase()) ||
                                          terminalListRes![index]
                                              .deviceSerialNo
                                              .toString()
                                              .toLowerCase()
                                              .contains(
                                                  searchKey!.toLowerCase())) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          child: InkWell(
                                            onTap: () {
                                              Get.to(() => TerminalDetailScreen(
                                                    id: terminalListRes![index]
                                                        .terminalId,
                                                  ));
                                            },
                                            child: Container(
                                              width: Get.width,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: ColorsUtils.border,
                                                      width: 1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(15),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          height:
                                                              Get.height * 0.1,
                                                          width:
                                                              Get.width * 0.2,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              image: DecorationImage(
                                                                  image: AssetImage(
                                                                      Images
                                                                          .device))),
                                                        ),
                                                        width10(),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Expanded(
                                                                    child: customSmallMedBoldText(
                                                                        color: ColorsUtils
                                                                            .black,
                                                                        title:
                                                                            '${'Terminal ID:'.tr} ${terminalListRes![index].terminalId ?? "NA"}'),
                                                                  ),
                                                                  InkWell(
                                                                      onTap:
                                                                          () async {
                                                                        bottomSheetSelectBalance(
                                                                            context,
                                                                            index);
                                                                      },
                                                                      child: Icon(
                                                                          Icons
                                                                              .more_vert))
                                                                ],
                                                              ),
                                                              height5(),
                                                              // customSmallSemiText(
                                                              //     title:
                                                              //         '${terminalListRes![index].name ?? "NA"}',
                                                              //     color: ColorsUtils.black),
                                                              customSmallSemiText(
                                                                  title:
                                                                      '${terminalListRes![index].deviceSerialNo ?? "NA"}',
                                                                  color:
                                                                      ColorsUtils
                                                                          .black),
                                                              height10(),
                                                              customSmallSemiText(
                                                                  title:
                                                                      '${terminalListRes![index].posdevice!.devicetype ?? "NA"}',
                                                                  color:
                                                                      ColorsUtils
                                                                          .black),
                                                              height10(),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                    // Directionality(
                                                    //   textDirection: TextDirection.ltr,
                                                    //   child: customSmallSemiText(
                                                    //       title: intl.DateFormat(
                                                    //               'dd MMM yyyy, HH:mm:ss')
                                                    //           .format(DateTime.parse(
                                                    //               terminalListRes![
                                                    //                       index]
                                                    //                   .activated)),
                                                    //       color: ColorsUtils.grey),
                                                    // ),
                                                    // height10(),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: terminalListRes![
                                                                              index]
                                                                          .isActive ==
                                                                      1
                                                                  ? ColorsUtils
                                                                      .green
                                                                  : ColorsUtils
                                                                      .accent),
                                                          child: Center(
                                                            child: Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 2),
                                                              child: customVerySmallSemiText(
                                                                  color:
                                                                      ColorsUtils
                                                                          .white,
                                                                  title: terminalListRes![index]
                                                                              .isActive ==
                                                                          1
                                                                      ? 'Active'
                                                                          .tr
                                                                      : 'InActive'
                                                                          .tr),
                                                            ),
                                                          ),
                                                        ),
                                                        // InkWell(
                                                        //   onTap: () {
                                                        //     Get.to(() =>
                                                        //         PosTransactionListScreen(
                                                        //           terminalFilter:
                                                        //               '${terminalListRes![index].terminalId}',
                                                        //         ));
                                                        //   },
                                                        //   child: Container(
                                                        //     decoration: BoxDecoration(
                                                        //       color: ColorsUtils.yellow,
                                                        //       borderRadius:
                                                        //           BorderRadius.circular(
                                                        //               12),
                                                        //     ),
                                                        //     child: Padding(
                                                        //       padding: const EdgeInsets
                                                        //               .symmetric(
                                                        //           vertical: 2,
                                                        //           horizontal: 10),
                                                        //       child: customSmallBoldText(
                                                        //           title: 'Transactions',
                                                        //           color: ColorsUtils
                                                        //               .white),
                                                        //     ),
                                                        //   ),
                                                        // ),
                                                        customSmallSemiText(
                                                          title:
                                                              '${terminalListRes![index].isOnline == true ? 'Online' : 'Offline'}',
                                                          // 'avd',
                                                          color: terminalListRes![
                                                                          index]
                                                                      .isOnline ==
                                                                  true
                                                              ? ColorsUtils
                                                                  .green
                                                              : ColorsUtils.red,
                                                        )
                                                        // commonColumnField(
                                                        //     title: 'Device status'.tr,
                                                        //     color:
                                                        //         terminalListRes![index]
                                                        //                     .isOnline ==
                                                        //                 true
                                                        //             ? ColorsUtils.green
                                                        //             : ColorsUtils.red,
                                                        //     // value: 'Offline'
                                                        //     value:
                                                        //         '${terminalListRes![index].isOnline == true ? 'Online' : 'Offline'}'),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                        //     Padding(
                                        //   padding:
                                        //       const EdgeInsets.symmetric(
                                        //           vertical: 8),
                                        //   child: InkWell(
                                        //     onTap: () {
                                        //       Get.to(() =>
                                        //           TerminalDetailScreen(
                                        //             id: terminalListRes![
                                        //                     index]
                                        //                 .terminalId,
                                        //           ));
                                        //     },
                                        //     child: Container(
                                        //       width: Get.width,
                                        //       decoration: BoxDecoration(
                                        //           border: Border.all(
                                        //               color: ColorsUtils
                                        //                   .border,
                                        //               width: 1),
                                        //           borderRadius:
                                        //               BorderRadius
                                        //                   .circular(12)),
                                        //       child: Padding(
                                        //         padding:
                                        //             const EdgeInsets.all(
                                        //                 15),
                                        //         child: Column(
                                        //           crossAxisAlignment:
                                        //               CrossAxisAlignment
                                        //                   .start,
                                        //           children: [
                                        //             Row(
                                        //               children: [
                                        //                 customSmallMedBoldText(
                                        //                     color:
                                        //                         ColorsUtils
                                        //                             .black,
                                        //                     title:
                                        //                         '${'Terminal ID:'.tr} ${terminalListRes![index].terminalId ?? "NA"}'),
                                        //                 Spacer(),
                                        //                 Icon(Icons
                                        //                     .more_vert)
                                        //               ],
                                        //             ),
                                        //             height5(),
                                        //             customSmallSemiText(
                                        //                 title:
                                        //                     '${terminalListRes![index].name ?? "NA"}',
                                        //                 color: ColorsUtils
                                        //                     .black),
                                        //             height10(),
                                        //             Directionality(
                                        //               textDirection:
                                        //                   TextDirection
                                        //                       .ltr,
                                        //               child: customSmallSemiText(
                                        //                   title: intl.DateFormat(
                                        //                           'dd MMM yyyy, HH:mm:ss')
                                        //                       .format(DateTime.parse(
                                        //                           terminalListRes![index]
                                        //                               .created)),
                                        //                   color:
                                        //                       ColorsUtils
                                        //                           .grey),
                                        //             ),
                                        //             height10(),
                                        //             Row(
                                        //               children: [
                                        //                 Container(
                                        //                   decoration: BoxDecoration(
                                        //                       borderRadius:
                                        //                           BorderRadius.circular(
                                        //                               10),
                                        //                       color: terminalListRes![index].isActive ==
                                        //                               true
                                        //                           ? ColorsUtils
                                        //                               .green
                                        //                           : ColorsUtils
                                        //                               .accent),
                                        //                   child: Center(
                                        //                     child:
                                        //                         Padding(
                                        //                       padding: const EdgeInsets
                                        //                               .symmetric(
                                        //                           horizontal:
                                        //                               8,
                                        //                           vertical:
                                        //                               2),
                                        //                       child: customVerySmallSemiText(
                                        //                           color: ColorsUtils
                                        //                               .white,
                                        //                           title: terminalListRes![index].isActive ==
                                        //                                   true
                                        //                               ? 'Active'.tr
                                        //                               : 'InActive'.tr),
                                        //                     ),
                                        //                   ),
                                        //                 ),
                                        //                 Spacer(),
                                        //                 customSmallSemiText(
                                        //                   title:
                                        //                       '${terminalListRes![index].terminaltype}',
                                        //                   // 'avd',
                                        //                   color:
                                        //                       ColorsUtils
                                        //                           .black,
                                        //                 )
                                        //               ],
                                        //             )
                                        //           ],
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   ),
                                        // );
                                      } else {
                                        return SizedBox();
                                      }
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: InkWell(
                                        onTap: () {
                                          Get.to(() => TerminalDetailScreen(
                                                id: terminalListRes![index]
                                                    .terminalId,
                                              ));
                                        },
                                        child: Container(
                                          width: Get.width,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: ColorsUtils.border,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: Get.height * 0.1,
                                                      width: Get.width * 0.2,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          image: DecorationImage(
                                                              image: AssetImage(
                                                                  Images
                                                                      .device))),
                                                    ),
                                                    width10(),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Expanded(
                                                                child: customSmallMedBoldText(
                                                                    color: ColorsUtils
                                                                        .black,
                                                                    title:
                                                                        '${'Terminal ID:'.tr} ${terminalListRes![index].terminalId ?? "NA"}'),
                                                              ),
                                                              InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    bottomSheetSelectBalance(
                                                                        context,
                                                                        index);
                                                                  },
                                                                  child: Icon(Icons
                                                                      .more_vert))
                                                            ],
                                                          ),
                                                          height5(),
                                                          // customSmallSemiText(
                                                          //     title:
                                                          //         '${terminalListRes![index].name ?? "NA"}',
                                                          //     color: ColorsUtils.black),
                                                          customSmallSemiText(
                                                              title:
                                                                  '${terminalListRes![index].deviceSerialNo ?? "NA"}',
                                                              color: ColorsUtils
                                                                  .black),
                                                          height10(),
                                                          customSmallSemiText(
                                                              title:
                                                                  '${terminalListRes![index].posdevice!.devicetype ?? "NA"}',
                                                              color: ColorsUtils
                                                                  .black),
                                                          height10(),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                // Directionality(
                                                //   textDirection: TextDirection.ltr,
                                                //   child: customSmallSemiText(
                                                //       title: intl.DateFormat(
                                                //               'dd MMM yyyy, HH:mm:ss')
                                                //           .format(DateTime.parse(
                                                //               terminalListRes![
                                                //                       index]
                                                //                   .activated)),
                                                //       color: ColorsUtils.grey),
                                                // ),
                                                // height10(),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: terminalListRes![
                                                                          index]
                                                                      .isActive ==
                                                                  1
                                                              ? ColorsUtils
                                                                  .green
                                                              : ColorsUtils
                                                                  .accent),
                                                      child: Center(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 2),
                                                          child: customVerySmallSemiText(
                                                              color: ColorsUtils
                                                                  .white,
                                                              title: terminalListRes![
                                                                              index]
                                                                          .isActive ==
                                                                      1
                                                                  ? 'Active'.tr
                                                                  : 'InActive'
                                                                      .tr),
                                                        ),
                                                      ),
                                                    ),
                                                    // InkWell(
                                                    //   onTap: () {
                                                    //     Get.to(() =>
                                                    //         PosTransactionListScreen(
                                                    //           terminalFilter:
                                                    //               '${terminalListRes![index].terminalId}',
                                                    //         ));
                                                    //   },
                                                    //   child: Container(
                                                    //     decoration: BoxDecoration(
                                                    //       color: ColorsUtils.yellow,
                                                    //       borderRadius:
                                                    //           BorderRadius.circular(
                                                    //               12),
                                                    //     ),
                                                    //     child: Padding(
                                                    //       padding: const EdgeInsets
                                                    //               .symmetric(
                                                    //           vertical: 2,
                                                    //           horizontal: 10),
                                                    //       child: customSmallBoldText(
                                                    //           title: 'Transactions',
                                                    //           color: ColorsUtils
                                                    //               .white),
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                    customSmallSemiText(
                                                      title:
                                                          '${terminalListRes![index].isOnline == true ? 'Online' : 'Offline'}',
                                                      // 'avd',
                                                      color: terminalListRes![
                                                                      index]
                                                                  .isOnline ==
                                                              true
                                                          ? ColorsUtils.green
                                                          : ColorsUtils.red,
                                                    )
                                                    // commonColumnField(
                                                    //     title: 'Device status'.tr,
                                                    //     color:
                                                    //         terminalListRes![index]
                                                    //                     .isOnline ==
                                                    //                 true
                                                    //             ? ColorsUtils.green
                                                    //             : ColorsUtils.red,
                                                    //     // value: 'Offline'
                                                    //     value:
                                                    //         '${terminalListRes![index].isOnline == true ? 'Online' : 'Offline'}'),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                        if (controller.isPaginationLoading && isPageFirst)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 0),
                            child: Center(child: Loader()),
                          ),
                        if (controller.isPaginationLoading && !isPageFirst)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 0),
                            child: Center(child: Loader()),
                          ),
                      ],
                    ))
                  ],
                ),
              );
            },
          ),
        );
      } else {
        return InternetNotFound(
          onTap: () async {
            connectivityViewModel.startMonitoring();

            if (connectivityViewModel.isOnline != null) {
              if (connectivityViewModel.isOnline!) {
                terminalViewModel.setTerminalInit();
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
              terminalViewModel.setTerminalInit();
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

  int getCount(List<TerminalListResponseModel>? result) {
    int count = 0;
    result!.forEach((e) {
      if ((e.terminalId as String)
          .toLowerCase()
          .contains(searchKey!.toLowerCase())) {
        count++;
      }
    });
    return count;
  }

  int getAllCount(List<TerminalListResponseModel>? result) {
    int count = 0;
    result!.forEach((e) {
      count++;
      // if ((e.terminalId as String)
      //     .toLowerCase()
      //     .contains(searchKey!.toLowerCase())) {
      //   count++;
      // }
    });
    return count;
  }

  void initData({bool isLoading = false}) async {
    print(
        'Utility.terminalFilterDeviceStatus ======>${Utility.terminalFilterDeviceStatus}');
    filter = Utility.terminalFilterTransStatus +
        Utility.terminalFilterTransModes +
        Utility.terminalFilterDeviceStatus +
        Utility.terminalFilterPaymentMethod;
    countFilter = (Utility.terminalCountFilterTransStatus.isNotEmpty ||
                Utility.terminalCountFilterTransModes.isNotEmpty ||
                Utility.terminalCountFilterPaymentMethod.isNotEmpty
            ? "?filter"
            : "") +
        Utility.terminalCountFilterTransStatus +
        Utility.terminalCountFilterTransModes +
        Utility.terminalCountFilterPaymentMethod;
    terminalViewModel.clearResponseList();
    scrollData();

    await terminalViewModel.terminalList(filter: filter, isLoading: isLoading);
    await terminalViewModel.terminalCount(filter: countFilter);
    if (isPageFirst == false) {
      isPageFirst = true;
    }
  }

  void scrollData() async {
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController!.position.maxScrollExtent ==
                _scrollController!.offset &&
            !terminalViewModel.isPaginationLoading) {
          terminalViewModel.terminalList(filter: filter);
        }
      });
  }

  Future<void> bottomSheetSelectBalance(BuildContext context, int index) {
    return showModalBottomSheet<void>(
      isScrollControlled: true,
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
                  height10(),
                  const Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 70,
                      height: 5,
                      child: Divider(color: ColorsUtils.border, thickness: 4),
                    ),
                  ),
                  height30(),
                  InkWell(
                    onTap: () async {
                      Get.back();
                      await Get.to(() => EditTerminalName(
                            terminalName: terminalListRes![index].name,
                            id: terminalListRes![index].id.toString(),
                          ));
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        terminalViewModel.setTerminalInit();
                        initData();
                      });
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          Images.edit,
                          height: 20,
                        ),
                        width20(),
                        customSmallMedBoldText(title: 'Edit terminal name'.tr)
                      ],
                    ),
                  ),
                  height30(),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
