// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/report/terminalListResponse.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/terminal/terminalCountResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/terminal/terminalListResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/downloadFile.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/pos/report/posSearchTerminalReport.dart';
import 'package:sadad_merchat_app/view/pos/terminals/terminalDetailScreen.dart';
import 'package:sadad_merchat_app/view/pos/terminals/terminalFilterScreen.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:sadad_merchat_app/viewModel/pos/report/posReportListViewModel.dart';
import 'package:sadad_merchat_app/viewModel/pos/terminal/terminalViewModel.dart';
import 'package:http/http.dart' as http;

class PosTerminalReportDetailScreen extends StatefulWidget {
  String? startDate;
  String? endDate;
  String? selectedType;
  PosTerminalReportDetailScreen(
      {Key? key, this.endDate, this.selectedType, this.startDate})
      : super(key: key);

  @override
  State<PosTerminalReportDetailScreen> createState() =>
      _PosTerminalReportDetailScreenState();
}

class _PosTerminalReportDetailScreenState
    extends State<PosTerminalReportDetailScreen> {
  bool sendEmail = false;
  int isRadioSelected = 0;
  String email = '';
  int differenceDays = 0;
  bool isTabVisible = false;
  bool isSearchClick = false;
  String? searchKey;
  TextEditingController search = TextEditingController();
  ScrollController? _scrollController;
  String filter = '';
  String countFilter = '';
  GlobalKey _key = GlobalKey();
  bool isPageFirst = false;
  PosReportDetailViewModel terminalViewModel = Get.find();
  EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences();
  List<TerminalData>? terminalListRes;
  TerminalCountResponseModel? terminalCountResponseModel;
  ConnectivityViewModel connectivityViewModel = Get.find();

  @override
  void initState() {
    connectivityViewModel.startMonitoring();
    terminalViewModel.setReportInit();
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
          body: GetBuilder<PosReportDetailViewModel>(
            builder: (controller) {
              if (controller.posTerminalListReportApiResponse.status ==
                      Status.LOADING ||
                  controller.posTerminalListReportApiResponse.status ==
                      Status.INITIAL) {
                return const Center(child: Loader());
              }
              if (controller.posTerminalListReportApiResponse.status ==
                      Status.ERROR ||
                  controller.posTerminalListReportApiResponse.status ==
                      Status.ERROR) {
                return const SessionExpire();
                //return const Center(child: Text('Error'));
              }
              terminalListRes = terminalViewModel.terminalResponse;
              // terminalCountResponseModel =
              //     terminalViewModel.posTerminalListReportApiResponse.data['count'];
              return Column(
                children: [
                  height60(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        InkWell(
                            onTap: () {
                              if (isSearchClick == true) {
                                isSearchClick = false;
                                initData();
                                search.clear();
                                setState(() {});
                              } else {
                                Get.back();
                              }
                            },
                            child: const Icon(Icons.arrow_back_ios)),
                        //isSearchClick ? SizedBox() : Spacer(),
                        isSearchClick == true
                            ? Expanded(
                                child: SizedBox(
                                  height: 40,
                                  child: TextField(
                                    onChanged: (value) async {
                                      searchKey = value;
                                      setState(() {});
                                      initData();
                                    },
                                    controller: search,
                                    decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.all(0.0),
                                        isDense: true,
                                        prefixIcon: InkWell(
                                          onTap: () {
                                            setState(() {
                                              isSearchClick = !isSearchClick;
                                            });
                                            // search.clear();
                                            // searchKey = '';
                                            // initData();
                                          },
                                          child: Image.asset(
                                            Images.search,
                                            scale: 3,
                                          ),
                                        ),
                                        suffixIcon: search.text.isEmpty
                                            ? const SizedBox()
                                            : InkWell(
                                                onTap: () {
                                                  search.clear();
                                                  searchKey = '';
                                                  setState(() {});
                                                  initData();
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
                                        hintText: 'ex. TerminalId',
                                        hintStyle: ThemeUtils.blackRegular
                                            .copyWith(
                                                color: ColorsUtils.grey,
                                                fontSize: FontUtils.small)),
                                  ),
                                ),
                              )
                            : Expanded(
                                child: Text('POS Terminals Summary',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: ThemeUtils.blackBold.copyWith(
                                      fontSize: FontUtils.medLarge,
                                    )),
                              ),
                        // const Spacer(),
                        isSearchClick == true
                            ? SizedBox()
                            : InkWell(
                                onTap: () {
                                  // Get.to(() => PosSearchTerminalReport(
                                  //       selectedType: widget.selectedType,
                                  //       startDate: widget.startDate,
                                  //       endDate: widget.endDate,
                                  //     ));

                                  setState(() {
                                    isSearchClick = !isSearchClick;
                                  });
                                },
                                child: Image.asset(
                                  Images.search,
                                  height: 20,
                                  width: 20,
                                ),
                              ),
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
                  ),
                  height20(),
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
                              customSmallBoldText(title: 'From'.tr),
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: customSmallSemiText(
                                    title:
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
                              customSmallBoldText(title: 'To'.tr),
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: customSmallSemiText(
                                    title:
                                        '${intl.DateFormat('dd MMM yy').format(DateTime.parse(widget.endDate!))}'),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              terminalListRes!.isEmpty
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
                                      style: ThemeUtils.blackSemiBold.copyWith(
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
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 20),
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
                                                        BorderRadius.circular(
                                                            10),
                                                    image: DecorationImage(
                                                        image: AssetImage(terminalListRes![
                                                                        index]
                                                                    .deviceType ==
                                                                null
                                                            ? Images.device
                                                            : terminalListRes![
                                                                            index]
                                                                        .deviceType ==
                                                                    "WPOS-3"
                                                                ? Images.device
                                                                : Images
                                                                    .WPOSQTBlank))),
                                              ),
                                              width10(),
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
                                                                  '${terminalListRes![index].terminalName ?? "NA"}'),
                                                        )
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
                                                                    '${'Terminal ID:'.tr} ${terminalListRes![index].terminalId ?? "NA"}')),
                                                        // Icon(
                                                        //   Icons.more_vert,
                                                        //   size: 25,
                                                        // )
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
                                                            ColorsUtils.black),
                                                    height10(),
                                                    customSmallSemiText(
                                                        title:
                                                            '${terminalListRes![index].deviceType != null ? terminalListRes![index].deviceType ?? "NA" : "NA"}',
                                                        color:
                                                            ColorsUtils.black),
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
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: terminalListRes![
                                                                    index]
                                                                .terminalStatus ==
                                                            null
                                                        ? ColorsUtils.accent
                                                        : terminalListRes![
                                                                        index]
                                                                    .terminalStatus ==
                                                                'active'
                                                            ? ColorsUtils.green
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
                                                            ColorsUtils.white,
                                                        title: terminalListRes![
                                                                        index]
                                                                    .terminalStatus ==
                                                                null
                                                            ? 'InActive'.tr
                                                            : '${terminalListRes![index].terminalStatus ?? 'InActive'}'
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
                                                    '${terminalListRes![index].deviceStatus == 1 ? 'Online' : 'Offline'}',
                                                // 'avd',
                                                color: terminalListRes![index]
                                                            .deviceStatus ==
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
                terminalViewModel.setReportInit();

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
              terminalViewModel.setReportInit();

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
                            Map<String, String> header = {
                              'Authorization': token,
                              'Content-Type': 'application/json'
                            };
                            var result = await http.get(
                              url,
                              headers: header,
                            );
                            print(
                                'token is:$token \n req is : ${result.request}  \n response is :${result.body} ');
                            if (result.statusCode == 200) {
                              Get.snackbar(
                                  'Success'.tr, 'send successFully'.tr);
                            } else {
                              // const SessionExpire();
                              Get.snackbar('error', 'something Wrong');
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
                          Get.snackbar('error', 'Please check your connection');
                        }
                      } else {
                        Get.snackbar('error', 'Please check your connection');
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

  void initData({bool isLoading = false}) async {
    print("search keyy == $searchKey");
    print("deviceFilterDeviceType == ${Utility.deviceFilterDeviceType}");
    email = await encryptedSharedPreferences.getString('email');
//filter[skip]=0&filter[limit]=10&filter[order]=created DESC&filter[where][created][between][0]=2023-03-01 00:00:00&filter[where][created][between][1]=2023-03-12 23:59:5
    filter = Utility.terminalFilterTransStatus +
        Utility.terminalFilterDeviceStatus +
        Utility.terminalFilterTransModes +
        Utility.terminalFilterPaymentMethod +
        Utility.deviceFilterDeviceType +
        // Utility.terminalFilterStartActivationDate +
        // Utility.terminalFilterEndActivationDate +
        ((searchKey != null && searchKey != '')
            ? '&filter[where][terminalId][like]=$searchKey'
            : '') +
        (Utility.terminalFilterStartActivationDate.isNotEmpty &&
                Utility.terminalFilterStartActivationDate != ''
            ? Utility.terminalFilterStartActivationDate
            : '&filter[where][activated][between][0]=${intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(widget.startDate!))}') +
        (Utility.terminalFilterEndActivationDate.isNotEmpty &&
                Utility.terminalFilterEndActivationDate != ''
            ? Utility.terminalFilterEndActivationDate
            : '&filter[where][activated][between][1]=${intl.DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.endDate!))} 23:59:59');
    countFilter =
        '?filter[date]=custom&filter[between]=["${intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(widget.startDate!))}", "${intl.DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.endDate!))} 23:59:59"]' +
            ((searchKey != null && searchKey != '')
                ? '&filter[where][terminalId][like]=$searchKey'
                : '') +
            // (Utility.terminalCountFilterTransStatus.isNotEmpty ||
            //         Utility.terminalCountFilterTransModes.isNotEmpty ||
            //         Utility.terminalCountFilterPaymentMethod.isNotEmpty
            //     ? "?filter"
            //     : "")
            // +
            Utility.terminalCountFilterTransStatus +
            Utility.terminalCountFilterTransModes +
            Utility.terminalCountFilterPaymentMethod;
    terminalViewModel.clearResponseList();
    scrollData();

    await terminalViewModel.terminalReport(
      filter: filter,
    );
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
          terminalViewModel.terminalReport(filter: filter);
        }
      });
  }
}
