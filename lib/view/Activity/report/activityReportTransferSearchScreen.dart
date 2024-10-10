import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/Activity/activityAllTransactionReportResponse.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/Activity/transferListResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/downloadFile.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/Activity/activityTransactionDetailScreen.dart';
import 'package:sadad_merchat_app/view/Activity/report/activityReportFilterTransferScreen.dart';
import 'package:sadad_merchat_app/viewModel/Activity/activityReport.dart';
import 'package:sadad_merchat_app/viewModel/Activity/transferViewModel.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as intl;

class ActivityReportTransferSearchScreen extends StatefulWidget {
  final String? startDate;
  final String? endDate;
  const ActivityReportTransferSearchScreen(
      {Key? key, this.startDate, this.endDate})
      : super(key: key);

  @override
  State<ActivityReportTransferSearchScreen> createState() =>
      _ActivityReportTransferSearchScreenState();
}

class _ActivityReportTransferSearchScreenState
    extends State<ActivityReportTransferSearchScreen> {
  String? searchKey;
  ScrollController? _scrollController;
  int isRadioSelected = 0;
  bool sendEmail = false;
  ActivityReportViewModel activityReportViewModel = Get.find();
  String searchFilter = '';
  ConnectivityViewModel connectivityViewModel = Get.find();
  TransferViewModel transferViewModel = Get.find();
  List<ActivityTransferListResponse>? activityTransferListRes;
  List<DataTransaction>? lastRes;
  String filterDate = '';
  String userId = '';
  String token = '';
  bool isPageFirst = true;
  String email = '';
  TextEditingController search = TextEditingController();
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
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: TextField(
                    onChanged: (value) async {
                      searchKey = value;
                      // if (value.isNotEmpty) {
                      searchFilter = '&filter[where][customerName]=$value';
                      activityReportViewModel.clearResponseList();
                      activityReportViewModel.setInit();
                      setState(() {});

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
                        hintText: 'ex. customer Name',
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
                            () => ActivityReportTransferFilterScreen());
                        activityReportViewModel.setInit();
                        initData();
                      },
                      child: Image.asset(Images.filter,
                          height: 20,
                          color:
                              (Utility.activityTransferReportTransferTypeFilter !=
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
                    lastRes == null || lastRes!.isEmpty
                        ? Get.showSnackbar(GetSnackBar(
                            message: 'No Data Found'.tr,
                          ))
                        : exportBottomSheet();
                    // transactionReportResponse.data == null ||
                    //     transactionReportResponse.data!.isEmpty
                    //     ? Get.showSnackbar(GetSnackBar(
                    //   message: 'No Data Found'.tr,
                    // ))
                    //     : exportBottomSheet();
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
        lastRes == []
            ? Expanded(child: Center(child: Text('No data found'.tr)))
            : Expanded(
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
                    return lastRes == null
                        ? Center(child: Text('No data found'.tr))
                        : ListView.builder(
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
                                    if (lastRes![index].transactionId != null) {
                                      Get.to(
                                          () => ActivityTransactionDetailScreen(
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
                                                            ? ColorsUtils.green
                                                            : ColorsUtils.red,
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
          transferViewModel.transferReportList(
              filter: filterDate +
                  Utility.activityTransferReportTransferTypeFilter +
                  searchFilter);
        }
      });
  }

  void apiCall(String id) async {
    ///api calling.......

    userId = await encryptedSharedPreferences.getString('id');

    transferViewModel.setTransactionInit();
    await transferViewModel.transferReportList(
        filter: filterDate +
            Utility.activityTransferReportTransferTypeFilter +
            searchFilter);
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
                              '${Utility.baseUrl}${'reporthistories/transactionDetailsReport'}?filter[where][created][between][0]=${intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(widget.startDate!))}&filter[where][created][between][1]=${intl.DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.endDate!))} 23:59:59${filterDate + Utility.activityTransferReportTransferTypeFilter}&filter[order]=created%20DESC&filter[where][transactionentityId][inq][0]=5&filter[where][transactionentityId][inq][1]=8&${isRadioSelected == 1 ? 'isPdf' : isRadioSelected == 2 ? 'isCsv' : 'isExcel'}=true&isEmail=true',
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
                                  '${Utility.baseUrl}${'reporthistories/transactionDetailsReport'}?filter[where][created][between][0]=${intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(widget.startDate!))}&filter[where][created][between][1]=${intl.DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.endDate!))} 23:59:59${filterDate + searchFilter + Utility.activityTransferReportTransferTypeFilter}&filter[order]=created%20DESC&filter[where][transactionentityId][inq][0]=5&filter[where][transactionentityId][inq][1]=8&${isRadioSelected == 1 ? 'isPdf' : isRadioSelected == 2 ? 'isCsv' : 'isExcel'}=true',
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
