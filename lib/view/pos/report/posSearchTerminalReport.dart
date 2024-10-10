import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/terminal/terminalCountResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/terminal/terminalListResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/downloadFile.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/pos/terminals/terminalDetailScreen.dart';
import 'package:sadad_merchat_app/view/pos/terminals/terminalFilterScreen.dart';
import 'package:sadad_merchat_app/viewModel/pos/terminal/terminalViewModel.dart';
import 'package:http/http.dart' as http;

class PosSearchTerminalReport extends StatefulWidget {
  String? startDate;
  String? endDate;
  String? selectedType;
  PosSearchTerminalReport(
      {Key? key, this.endDate, this.selectedType, this.startDate})
      : super(key: key);

  @override
  State<PosSearchTerminalReport> createState() =>
      _PosSearchTerminalReportState();
}

class _PosSearchTerminalReportState extends State<PosSearchTerminalReport> {
  bool sendEmail = false;
  int isRadioSelected = 0;
  String email = '';
  int differenceDays = 0;
  bool isTabVisible = false;
  ScrollController? _scrollController;
  String filter = '';
  String countFilter = '';
  GlobalKey _key = GlobalKey();
  bool isPageFirst = false;
  TerminalViewModel terminalViewModel = Get.find();
  EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences();
  List<TerminalListResponseModel>? terminalListRes;
  TerminalCountResponseModel? terminalCountResponseModel;
  String? searchKey;
  TextEditingController search = TextEditingController();

  @override
  void initState() {
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
    return Scaffold(
      body: GetBuilder<TerminalViewModel>(
        builder: (controller) {
          if (controller.terminalListApiResponse.status == Status.LOADING ||
              controller.terminalCountApiResponse.status == Status.LOADING) {
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
          return Column(
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
                              hintText:
                                  'ex. customer name,phone,invoice no,amount,id......'
                                      .tr,
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
              ),
              search.text.isEmpty
                  ? Expanded(child: Center(child: Text('No data found'.tr)))
                  : Expanded(
                      child: Column(
                        children: [
                          height20(),
                          Container(
                              height: 1,
                              width: Get.width,
                              color: ColorsUtils.border),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                          height40(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: customSmallSemiText(
                                    title:
                                        '${terminalCountResponseModel!.count ?? '0'} Pos Terminals',
                                    color: ColorsUtils.black)),
                          ),
                          height20(),
                          terminalListRes!.isEmpty &&
                                  !terminalViewModel.isPaginationLoading
                              ? Center(child: Text('No data found'.tr))
                              : Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: ListView.builder(
                                      controller: _scrollController,
                                      key: _key,
                                      padding: EdgeInsets.zero,
                                      itemCount: terminalListRes!.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        if (searchKey != null &&
                                            searchKey != "") {
                                          if (terminalListRes![index]
                                              .terminalId
                                              .toString()
                                              .toLowerCase()
                                              .contains(
                                                  searchKey!.toLowerCase())) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: InkWell(
                                                onTap: () {
                                                  Get.to(() =>
                                                      TerminalDetailScreen(
                                                        id: terminalListRes![
                                                                index]
                                                            .terminalId,
                                                      ));
                                                },
                                                child: Container(
                                                  width: Get.width,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: ColorsUtils
                                                              .border,
                                                          width: 1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        customSmallMedBoldText(
                                                            color: ColorsUtils
                                                                .black,
                                                            title:
                                                                '${'Terminal ID:'.tr} ${terminalListRes![index].terminalId ?? "NA"}'),
                                                        height5(),
                                                        customSmallSemiText(
                                                            title:
                                                                '${terminalListRes![index].name ?? "NA"}',
                                                            color: ColorsUtils
                                                                .black),
                                                        height10(),
                                                        Directionality(
                                                          textDirection:
                                                              TextDirection.ltr,
                                                          child: customSmallSemiText(
                                                              title: intl.DateFormat(
                                                                      'dd MMM yyyy, HH:mm:ss')
                                                                  .format(DateTime.parse(
                                                                      terminalListRes![
                                                                              index]
                                                                          .created)),
                                                              color: ColorsUtils
                                                                  .grey),
                                                        ),
                                                        height10(),
                                                        Row(
                                                          children: [
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  color: terminalListRes![index]
                                                                              .isActive ==
                                                                          true
                                                                      ? ColorsUtils
                                                                          .green
                                                                      : ColorsUtils
                                                                          .accent),
                                                              child: Center(
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          8,
                                                                      vertical:
                                                                          2),
                                                                  child: customVerySmallSemiText(
                                                                      color: ColorsUtils
                                                                          .white,
                                                                      title: terminalListRes![index].isActive ==
                                                                              true
                                                                          ? 'Active'
                                                                              .tr
                                                                          : 'InActive'
                                                                              .tr),
                                                                ),
                                                              ),
                                                            ),
                                                            Spacer(),
                                                            customSmallSemiText(
                                                              title:
                                                                  '${terminalListRes![index].terminaltype}',
                                                              // 'avd',
                                                              color: ColorsUtils
                                                                  .black,
                                                            )
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
                                        return SizedBox();
                                      },
                                    ),
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
                    )
            ],
          );
        },
      ),
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
                      if (isRadioSelected == 0) {
                        Get.snackbar('error', 'Please select Format!'.tr);
                      } else {
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
                            Get.snackbar('Success'.tr, 'send successFully'.tr);
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
    filter =
        '${Utility.terminalFilterTransStatus}${Utility.terminalFilterDeviceStatus}${Utility.terminalFilterTransModes}${Utility.terminalFilterPaymentMethod}&filter[date]=custom&filter[between]=["${intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(widget.startDate!))}", "${intl.DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.endDate!))} 23:59:59"]';
    countFilter =
        '?filter[date]=custom&filter[between]=["${intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(widget.startDate!))}", "${intl.DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.endDate!))} 23:59:59"]${Utility.terminalCountFilterTransStatus}${Utility.terminalCountFilterTransModes}${Utility.terminalCountFilterPaymentMethod}';
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
}
