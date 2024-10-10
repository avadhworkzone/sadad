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
import 'package:sadad_merchat_app/view/pos/terminals/posTerminalSearch.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:sadad_merchat_app/viewModel/pos/terminal/terminalViewModel.dart';

import 'terminalDetailScreen.dart';
import 'terminalFilterScreen.dart';

class TerminalScreen extends StatefulWidget {
  const TerminalScreen({Key? key}) : super(key: key);

  @override
  State<TerminalScreen> createState() => _TerminalScreenState();
}

class _TerminalScreenState extends State<TerminalScreen> {
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
  String? searchKey;
  TextEditingController search = TextEditingController();
  TerminalViewModel terminalViewModel = Get.find();
  EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences();
  List<String> selectedTimeZone = ['All'];
  int selectedTab = 0;
  bool isSearchSelected = false;
  List<TerminalListResponseModel>? terminalListRes;
  TerminalCountResponseModel? terminalCountResponseModel;
  ConnectivityViewModel connectivityViewModel = Get.find();

  @override
  void initState() {
    connectivityViewModel.startMonitoring();
    terminalViewModel.setTerminalInit();
    initData();
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
                //return const Center(child: Text('Error'));
              }

              terminalListRes = terminalViewModel.terminalListApiResponse.data;
              terminalCountResponseModel =
                  terminalViewModel.terminalCountApiResponse.data;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    height60(),
                    Row(
                      children: [
                        InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: const Icon(Icons.arrow_back_ios)),
                        //width20(),
                        isSearchSelected == true
                            ? Expanded(
                                child: SizedBox(
                                  height: 40,
                                  child: TextField(
                                    onChanged: (value) async {
                                      searchKey = value;
                                      setState(() {});
                                    },
                                    controller: search,
                                    decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.all(0.0),
                                        isDense: true,
                                        prefixIcon: InkWell(
                                          onTap: () {
                                            setState(() {
                                              isSearchSelected =
                                                  !isSearchSelected;
                                            });
                                          },
                                          child: Image.asset(
                                            Images.search,
                                            scale: 3,
                                          ),
                                        ),
                                        suffixIcon: InkWell(
                                          onTap: () {
                                            setState(() {
                                              searchKey = '';
                                            });
                                            search.clear();
                                          },
                                          child: const Icon(
                                            Icons.cancel_rounded,
                                            color: ColorsUtils.border,
                                            size: 25,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                color: ColorsUtils.border,
                                                width: 1)),
                                        hintText:
                                            'ex. Terminal ID, Device Serial No, Name, Terminal location',
                                        hintStyle: ThemeUtils.blackRegular
                                            .copyWith(
                                                color: ColorsUtils.grey,
                                                fontSize: FontUtils.verySmall)),
                                  ),
                                ),
                              )
                            :
                            // const Spacer(),
                            Expanded(
                                child: Center(
                                  child: Text('Terminals'.tr,
                                      style: ThemeUtils.blackBold.copyWith(
                                        fontSize: FontUtils.medLarge,
                                      )),
                                ),
                              ),
                        // const Spacer(),
                        if (isSearchSelected == false)
                          InkWell(
                              onTap: () {
                                setState(() {
                                  isSearchSelected = true;
                                });
                                //Get.to(() => PosTerminalSearchScreen());
                              },
                              child: Image.asset(
                                Images.search,
                                height: 20,
                                width: 20,
                              )),
                        width20(),
                        InkWell(
                            onTap: () async {
                              await Get.to(() => const TerminalFilterScreen());

                              initData(isLoading: true);
                            },
                            child: Image.asset(Images.filter,
                                height: 20,
                                width: 20,
                                color:
                                    Utility.terminalFilterTransModes.isNotEmpty ||
                                            Utility.terminalFilterTransStatus
                                                .isNotEmpty ||
                                            Utility.terminalFilterDeviceStatus
                                                .isNotEmpty ||
                                            Utility.terminalFilterPaymentMethod
                                                .isNotEmpty ||
                                            Utility.deviceFilterDeviceType
                                                .isNotEmpty ||
                                            Utility
                                                .terminalFilterStartActivationDate
                                                .isNotEmpty ||
                                            Utility
                                                .terminalFilterEndActivationDate
                                                .isNotEmpty
                                        ? ColorsUtils.accent
                                        : ColorsUtils.black)),
                      ],
                    ),
                    height20(),
                    terminalCountResponseModel == null
                        ? SizedBox()
                        : Align(
                            alignment: Alignment.centerRight,
                            child: customSmallSemiText(
                                title: searchKey != null && searchKey != ""
                                    ? '${getCount(terminalListRes) ?? '0'} ${'Terminal'.tr}'
                                    : '${terminalCountResponseModel!.count ?? '0'} ${'Terminal'.tr}',
                                color: ColorsUtils.black)),
                    // Align(
                    //     alignment: Alignment.centerRight,
                    //     child: customSmallSemiText(
                    //         title:
                    //             '${getCount(terminalListRes) ?? '0'} ${'Terminal'.tr}',
                    //         color: ColorsUtils.black)),
                    height20(),
                    (terminalListRes == null || terminalListRes!.isEmpty) &&
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
                                          .contains(searchKey!.toLowerCase()) ||
                                      terminalListRes![index]
                                          .name
                                          .toString()
                                          .toLowerCase()
                                          .contains(searchKey!.toLowerCase()) ||
                                      terminalListRes![index]
                                          .zone
                                          .toString()
                                          .toLowerCase()
                                          .contains(searchKey!.toLowerCase()) ||
                                      terminalListRes![index]
                                          .deviceSerialNo
                                          .toString()
                                          .toLowerCase()
                                          .contains(searchKey!.toLowerCase())) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: InkWell(
                                        onTap: () async {
                                          await Get.to(
                                              () => TerminalDetailScreen(
                                                    id: terminalListRes![index]
                                                        .terminalId,
                                                  ));
                                          terminalViewModel.startPosition = 0;
                                          terminalViewModel.terminalList(
                                              filter: filter);
                                          // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                                          //   terminalViewModel.setTerminalInit();
                                          //   initData(isLoading: false,isBackLoading: false);
                                          // });
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
                                                              image: AssetImage(terminalListRes![index].devicetypeId == null
                                                                  ? Images.deviceBlank
                                                                  : terminalListRes![index].devicetypeId == 1
                                                                      ? Images.deviceBlank
                                                                      : Images.WPOSQTBlank))),
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
                                                              // InkWell(
                                                              //     onTap: () async {
                                                              //       bottomSheetSelectBalance(
                                                              //           context,
                                                              //           index);
                                                              //     },
                                                              //     child: Icon(Icons
                                                              //         .more_vert))
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
                                                                  '${terminalListRes![index].posdevice != null ? terminalListRes![index].posdevice!.devicetype ?? "NA" : "NA"}',
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
                                                                  true
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
                                                                      true
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
                                                          '${terminalListRes![index].isOnline == "1" ? 'Online' : 'Offline'}',
                                                      // 'avd',
                                                      color: terminalListRes![
                                                                      index]
                                                                  .isOnline ==
                                                              "1"
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
                                  } else {
                                    return SizedBox();
                                  }
                                }
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: InkWell(
                                    onTap: () async {
                                      await Get.to(() => TerminalDetailScreen(
                                            id: terminalListRes![index]
                                                .terminalId,
                                          ));
                                      terminalViewModel.startPosition = 0;
                                      terminalViewModel.terminalList(
                                          filter: filter);
                                      // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                                      //   terminalViewModel.setTerminalInit();
                                      //   initData(isLoading: false,isBackLoading: false);
                                      // });
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
                                                          BorderRadius.circular(
                                                              10),
                                                      image: DecorationImage(
                                                          image: AssetImage(terminalListRes![
                                                                          index]
                                                                      .devicetypeId ==
                                                                  null
                                                              ? Images
                                                                  .deviceBlank
                                                              : terminalListRes![
                                                                              index]
                                                                          .devicetypeId ==
                                                                      1
                                                                  ? Images
                                                                      .deviceBlank
                                                                  : Images
                                                                      .WPOSQTBlank))),
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
                                                                color:
                                                                    ColorsUtils
                                                                        .black,
                                                                title:
                                                                    '${terminalListRes![index].name ?? "NA"}'),
                                                          ),
                                                          // InkWell(
                                                          //     onTap: () async {
                                                          //       bottomSheetSelectBalance(
                                                          //           context,
                                                          //           index);
                                                          //     },
                                                          //     child: Icon(Icons
                                                          //         .more_vert))
                                                        ],
                                                      ),
                                                      height5(),

                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Expanded(
                                                            child: customSmallBoldText(
                                                                color:
                                                                    ColorsUtils
                                                                        .grey,
                                                                title:
                                                                    '${'Terminal ID:'.tr} ${terminalListRes![index].terminalId ?? "NA"}'),
                                                          ),
                                                          // InkWell(
                                                          //     onTap: () async {
                                                          //       bottomSheetSelectBalance(
                                                          //           context,
                                                          //           index);
                                                          //     },
                                                          //     child: Icon(Icons
                                                          //         .more_vert))
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
                                                              '${terminalListRes![index].posdevice != null ? terminalListRes![index].posdevice!.devicetype ?? "NA" : "NA"}',
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
                                                          BorderRadius.circular(
                                                              10),
                                                      color: terminalListRes![
                                                                      index]
                                                                  .isActive ==
                                                              true
                                                          ? ColorsUtils.green
                                                          : ColorsUtils.accent),
                                                  child: Center(
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 8,
                                                          vertical: 2),
                                                      child: customVerySmallSemiText(
                                                          color:
                                                              ColorsUtils.white,
                                                          title: terminalListRes![
                                                                          index]
                                                                      .isActive ==
                                                                  true
                                                              ? 'Active'.tr
                                                              : 'InActive'.tr),
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
                                                      '${terminalListRes![index].isOnline == 1 ? 'Online' : 'Offline'}',
                                                  // 'avd',
                                                  color: terminalListRes![index]
                                                              .isOnline ==
                                                          1
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
      } else if ((e.name as String)
          .toLowerCase()
          .contains(searchKey!.toLowerCase())) {
        count++;
      } else if ((e.deviceSerialNo.toString())
          .toLowerCase()
          .contains(searchKey!.toLowerCase())) {
        count++;
      } else if ((e.zone as String)
          .toLowerCase()
          .contains(searchKey!.toLowerCase())) {
        count++;
      }
    });
    return count;
  }

  void initData({bool isLoading = false, bool isBackLoading = true}) async {
    filter = Utility.terminalFilterTransStatus +
        Utility.terminalFilterTransModes +
        Utility.deviceFilterDeviceType +
        Utility.terminalFilterDeviceStatus +
        Utility.terminalFilterStartActivationDate +
        Utility.terminalFilterEndActivationDate +
        Utility.terminalFilterPaymentMethod;
    countFilter = (Utility.terminalCountFilterTransStatus.isNotEmpty ||
                Utility.terminalCountFilterTransModes.isNotEmpty ||
                Utility.deviceFilterCountDeviceType.isNotEmpty ||
                Utility.terminalCountFilterPaymentMethod.isNotEmpty ||
                Utility.terminalCountFilterDeviceStatus.isNotEmpty ||
                Utility.terminalCountFilterStartActivationDate.isNotEmpty ||
                Utility.terminalCountFilterEndActivationDate.isEmpty
            ? "?filter"
            : "") +
        Utility.terminalCountFilterTransStatus +
        Utility.deviceFilterCountDeviceType +
        Utility.terminalCountFilterDeviceStatus +
        Utility.terminalCountFilterTransModes +
        Utility.terminalCountFilterStartActivationDate +
        Utility.terminalCountFilterEndActivationDate +
        Utility.terminalCountFilterPaymentMethod;
    terminalViewModel.clearResponseList();
    scrollData();

    await terminalViewModel.terminalList(
        filter: filter, isLoading: isLoading, isBackLoading: isBackLoading);
    await terminalViewModel.terminalCount(
        filter: countFilter, isLoading: isLoading);
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
