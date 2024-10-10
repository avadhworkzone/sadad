import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as intl;
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/Activity/activityAllTransactionReportResponse.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/downloadFile.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/Activity/activityPosRendtalDetailScreen.dart';
import 'package:sadad_merchat_app/view/Activity/activityTransactionDetailScreen.dart';
import 'package:sadad_merchat_app/view/Activity/activityWithdrawalDetailScreen.dart';
import 'package:sadad_merchat_app/view/Activity/report/activityReportFilterTransactionScreen.dart';
import 'package:sadad_merchat_app/viewModel/Activity/activityReport.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';

class ActivityReportTransactionSearchScreen extends StatefulWidget {
  final String? startDate;
  final String? endDate;
  const ActivityReportTransactionSearchScreen(
      {Key? key, this.startDate, this.endDate})
      : super(key: key);

  @override
  State<ActivityReportTransactionSearchScreen> createState() =>
      _ActivityReportTransactionSearchScreenState();
}

class _ActivityReportTransactionSearchScreenState
    extends State<ActivityReportTransactionSearchScreen> {
  ScrollController? _scrollController;
  ConnectivityViewModel connectivityViewModel = Get.find();
  ActivityAllTransactionReportResponse transactionReportResponse =
      ActivityAllTransactionReportResponse();
  String? searchKey;
  TextEditingController search = TextEditingController();
  String filterDate = '';
  String searchFilter = '';
  String token = '';
  bool isPageFirst = true;
  String email = '';
  int isRadioSelected = 0;
  bool sendEmail = false;
  ActivityReportViewModel activityReportViewModel = Get.find();
  List<DataTransaction> transactionResponse = [];
  @override
  void initState() {
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
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      onChanged: (value) async {
                        searchKey = value;
                        // if (value.isNotEmpty) {
                        searchFilter =
                            '&filter[where][invoicenumber][like]=$value';
                        // }
                        setState(() {});

                        activityReportViewModel.setInit();
                        initData();
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
                          hintText: 'ex. Transaction Id',
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
                              () => ActivityReportTransactionFilterScreen());
                          activityReportViewModel.setInit();
                          initData();
                        },
                        child: Image.asset(Images.filter,
                            height: 20,
                            color: (Utility.activityTransactionReportTransactionTypeFilter != '' ||
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
                                : ColorsUtils.black),
                      ),
              ],
            ),
          ),
          height10(),
          Container(height: 1, width: Get.width, color: ColorsUtils.border),
          search.text.isEmpty
              ? SizedBox()
              : SizedBox(
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
                            transactionReportResponse.data == null ||
                                    transactionReportResponse.data!.isEmpty
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
                      ),
                    ],
                  ),
                ),
          Container(height: 1, width: Get.width, color: ColorsUtils.border),
          height20(),
          search.text.isEmpty || transactionReportResponse.data == []
              ? Expanded(child: Center(child: Text('No data found'.tr)))
              : Expanded(
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
                        // return Center(child: Text('Error'));
                        return SessionExpire();
                      }

                      transactionReportResponse.data =
                          controller.transactionResponse;
                      print(
                          'yes it is null====>${transactionReportResponse.data}');

                      if (transactionReportResponse.data == null ||
                          transactionReportResponse.data == []) {
                        print(
                            'yes it is null====>${transactionReportResponse.data}');
                        return Center(child: Text('No data found'.tr));
                      }
                      return transactionReportResponse.data!.isEmpty
                          ? Center(child: Text('No data found'.tr))
                          : ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: transactionReportResponse.data!.length,
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
                                                padding:
                                                    const EdgeInsets.all(10.0),
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
                                                        color:
                                                            ColorsUtils.accent,
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
                                                      decoration: BoxDecoration(
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
                                                              ? ColorsUtils.reds
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
                                                                (transactionReportResponse.data![index].inOut ==
                                                                            null ||
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
                                                              title: (transactionReportResponse
                                                                              .data![
                                                                                  index]
                                                                              .inOut ==
                                                                          null ||
                                                                      transactionReportResponse
                                                                              .data![index]
                                                                              .inOut ==
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
                            );
                    },
                  ),
                )
        ],
      ),
    );
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
          activityReportViewModel.allTransactionList(
            filter: filterDate +
                searchFilter +
                Utility.activityTransactionReportTransactionTypeFilter +
                Utility.activityTransactionReportTransactionSourceFilter +
                Utility.activityTransactionReportTransactionStatusFilter +
                Utility.activityTransactionReportPaymentMethodFilter +
                Utility.activityTransactionReportTransactionModeFilter +
                Utility.activityTransactionReportIntegrationTypeFilter,
            isLoading: false,
          );
        }
      });
  }

  void apiCall(String id) async {
    ///api calling.......

    print('page1 ');

    await activityReportViewModel.allTransactionList(
      filter: filterDate +
          searchFilter +
          Utility.activityTransactionReportTransactionTypeFilter +
          Utility.activityTransactionReportTransactionSourceFilter +
          Utility.activityTransactionReportTransactionStatusFilter +
          Utility.activityTransactionReportPaymentMethodFilter +
          Utility.activityTransactionReportTransactionModeFilter +
          Utility.activityTransactionReportIntegrationTypeFilter,
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
                              '${Utility.baseUrl}reporthistories/transactionDetailsReport?filter[where][created][between][0]=${intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(widget.startDate!))}$searchFilter&filter[where][created][between][1]=${intl.DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.endDate!))} 23:59:59${Utility.activityTransactionReportTransactionTypeFilter + Utility.activityTransactionReportTransactionSourceFilter + Utility.activityTransactionReportTransactionStatusFilter + Utility.activityTransactionReportPaymentMethodFilter + Utility.activityTransactionReportTransactionModeFilter + Utility.activityTransactionReportIntegrationTypeFilter}&filter[order]=created%20DESC&${isRadioSelected == 1 ? 'isPdf' : isRadioSelected == 2 ? 'isCsv' : 'isExcel'}=true&isEmail=true',
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
                                  '${Utility.baseUrl}reporthistories/transactionDetailsReport?filter[where][created][between][0]=${intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(widget.startDate!))}$searchFilter${Utility.activityTransactionReportTransactionTypeFilter + Utility.activityTransactionReportTransactionSourceFilter + Utility.activityTransactionReportTransactionStatusFilter + Utility.activityTransactionReportPaymentMethodFilter + Utility.activityTransactionReportTransactionModeFilter + Utility.activityTransactionReportIntegrationTypeFilter}&filter[where][created][between][1]=${intl.DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.endDate!))} 23:59:59&filter[order]=created%20DESC&${isRadioSelected == 1 ? 'isPdf' : isRadioSelected == 2 ? 'isCsv' : 'isExcel'}=true',
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
